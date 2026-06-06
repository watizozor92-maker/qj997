CustomTransmit = {}
local this = {}

local __CustomTransmitKey = "PLAYER_CUSTOMTRANSMITKEY"

function CustomTransmit.GetPointFromMapMove(mapId)
    --处理自定义坐标
    local mapMoveCfg = ConfigDataManager.getTableFirst("cfg_mapmove", "mapid", mapId)
    if mapMoveCfg == nil then
        return nil
    end
    local mapX = mapMoveCfg["mapx"]
    local mapY = mapMoveCfg["mapy"]

    if not string.isNullOrEmpty(mapX) and not string.isNullOrEmpty(mapY) then
        return tonumber(mapX), tonumber(mapY)
    end

    local poz = mapMoveCfg["poz"]
    local pointMap = string.toIntIntMap(poz, "#", "|")
    if table.isNullOrEmpty(pointMap) then
        return nil
    end
    local num = math.random(0, table.count(pointMap) - 1)
    local index = 0
    for x, y in pairs(pointMap) do
        if num == index then
            return x, y
        end
        index = index + 1
    end
    return nil
end

function CustomTransmit.CustomToTransmit(actor, targetMap, targetLine, currX, currY, x, y, fromMapMove)
    local checkResult = CustomTransmit.checkTransmit(actor, targetMap, targetLine, currX, currY, x, y,fromMapMove, true)
    if checkResult ~= nil then
        return checkResult
    end

    -- --如果坐标来自mapMove表，则再次自定义计算坐标点
    -- if fromMapMove then
    --     local x, y = CustomTransmit.GetPointFromMapMove(targetMap)
    --     if x == nil or y == nil then
    --         return nil
    --     end
    --     local result = {
    --         result = false,
    --         x = x,
    --         y = y
    --     }
    --     jprint("自定义传送新坐标", targetMap, result)
    --     return result
    -- end
end

function CustomTransmit.checkTransmit(actor, targetMap, targetLine, currX, currY, x, y,fromMapMove, isRandomLine)
    -- 检查等级
    if fromMapMove and not gamemap.checkChangeMapLevel(actor, targetMap) then
        return { result = true, reason = "等级不足", ignoreNotice = false }
    end

    -- 内置传送校验跨服地图条件
    local targetMapConfig = ConfigDataManager.getById("cfg_map_info", targetMap)
    if table.isEmpty(targetMapConfig) then
        return { result = true, reason = "地图配置不存在"}
    end


    if tonumber(targetLine) > 1 then
        local has, rate = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.MAPLINE)
        if not has then
            sendluamsg(actor, LuaMessageIdToClient.RES_NO_SPEC_PRIVILEGE, Privilege.PrivilegeType.MAPLINE)
            return { result = true, reason = "没有权限", ignoreNotice = true }
        end
    end

    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo then
        local dupType = dupInfo['type']
        if dupType == DuplicateType.WAR_ALLIANCE then
            return WarAlliance.CheckTransfer(actor, currX, currY, x, y)
        end
    end

    local newLine = targetLine
    local isCheckCondition = true
    if isRandomLine then
        newLine, isCheckCondition = this.getNewMapLine(actor, targetMap, targetLine)
    end
    --if not newLine then
    --    return { result = true, reason = "当前没有可进入的线路" }
    --end
    local resInfo = this.checkCondition(actor, targetMap, newLine)
    if isCheckCondition and resInfo.result then
        return resInfo
    end


    local curMapCfgId = getbaseinfo(actor, "mapid")
    if not gamemap.checkChangeMapCost(actor, curMapCfgId, targetMap, newLine, fromMapMove) then
        return { result = true, reason = "切换地图道具消耗不足", ignoreNotice = true }
    end

    local isGoldMap = ConfigDataManager.getTableValue("cfg_map_info", "goldmap", "id", targetMap)
    if tonumber(isGoldMap) == 1 then
        -- 检查是否具有特权
        local hasPrivilege, _ = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.GOLD_LINE)
        if hasPrivilege then
            local mapIdStr = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.GOLD_LINE_PRIVILEGE)
            local mapIds = string.split(mapIdStr, "#")
            if table.contains(mapIds, tostring(targetMap)) then
                return { result = false, line = newLine }
            end
        end
        -- 没有权限
        sendluamsg(actor, LuaMessageIdToClient.RES_NO_SPEC_PRIVILEGE, Privilege.PrivilegeType.GOLD_LINE)
        return {result = true, reason = "无权限进入此地图"}
    end

    --local type = string.tonumber(ConfigDataManager.getTableValue("cfg_map_info", "type", "id", targetMap))
    --if type == 1 then
    --    local playerCount = getmapplayercount(actor, targetMap, newLine)
    --    local lineLoadStr = ConfigDataManager.getTableValue("cfg_map_line", "lineLoad", "id", targetMap)
    --    local lineLoadTab = string.toIntIntMap(lineLoadStr)
    --    local lineLoad = lineLoadTab[newLine] or 0
    --    if lineLoad <= 0 then
    --        return { result = true, reason = "地图最大人数上限配置错误 地图id：" .. targetMap .. " 线路：" .. newLine .. " 线路人数上限：" .. lineLoadStr }
    --    end
    --    if playerCount >= lineLoad then
    --        return { result = true, reason = "线路人数已满" }
    --    end
    --end



    if targetMapConfig ~= nil and targetMapConfig.serverType == CrossMap.CROSS_MAP_TYPE then
        if CrossMap.canEnter(actor, targetMap) then
            return { result = false, line = newLine }
        end
        return { result = true, reason = "无法进入跨服地图" }
    end


    return { result = false, line = newLine }
end

function CustomTransmit.DoTransmit(actor, msgData)
    --mapCfgId, line, x, y
    local mapCfgId = msgData.mapCfgId
    local line = msgData.line

    if string.isNullOrEmpty(mapCfgId) then
        mapCfgId = getbaseinfo(actor, "mapid")
    end

    if string.isNullOrEmpty(line) then
        line = getbaseinfo(actor, "line")
    end

    local x = msgData.x
    local y = msgData.y
    maptransfer(actor, x, y, mapCfgId, line)
    sendluamsg(actor, LuaMessageIdToClient.RES_CUSTOME_TRANSFER, {})
end

function CustomTransmit.mapMoveTransfer(actor, msgData)
    local id = msgData.id
    local line = msgData.line
    local moveType = msgData.moveType or 0
    local currX = getbaseinfo(actor, "x")
    local currY = getbaseinfo(actor, "y")
    local cfg_mapMove = ConfigDataManager.getTableFirst("cfg_mapMove", "id", id)
    if table.isEmpty(cfg_mapMove) then
        tipinfo(actor, "传送配置错误")
        return
    end
    local range = string.tonumber(cfg_mapMove.range)
    local mapCfgId = string.tonumber(cfg_mapMove.mapid)
    local x, y
    if moveType == 1 then
        x = string.tonumber(cfg_mapMove.mapx)
        y = string.tonumber(cfg_mapMove.mapy)
    else
        local cfg_mapMoveFirst = ConfigDataManager.getTableFirst("cfg_mapMove", "mapid", mapCfgId)
        x = string.tonumber(cfg_mapMoveFirst.mapx)
        y = string.tonumber(cfg_mapMoveFirst.mapy)
    end


    local checkResult = CustomTransmit.checkTransmit(actor, mapCfgId, line, currX, currY, x, y, true, false)
    if checkResult.result then
        tipinfo(actor, checkResult.reason)
        return
    end
    maptransfer(actor, x, y, mapCfgId, line, range, 1)
end

function CustomTransmit.reqCustomTransfer(actor, msgData)
    local mapCfgId = msgData.mapCfgId
    local line = msgData.line
    local x = msgData.x
    local y = msgData.y
    local currX = getbaseinfo(actor, "x")
    local currY = getbaseinfo(actor, "y")

    local checkResult = CustomTransmit.checkTransmit(actor, mapCfgId, line, currX, currY, x, y, true, false)
    if checkResult.result then
        tipinfo(actor, checkResult.reason)
        return
    end
    maptransfer(actor, x, y, mapCfgId, line, 0, 1)
end

function this.checkCondition(actor, mapCfgId, line)
    if tonumber(line) > 1 then
        local has, rate = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.MAPLINE)
        if not has then
            return { result = true, reason = "没有权限", ignoreNotice = true }
        end
    end

    -- 红名传送限制
    if PKSystem.checkTransmit(actor, mapCfgId, line) == false then
        return { result = true, reason = "PK值较高，暂无法进入和平线路", ignoreNotice = true }
    end

    local condition1, condition2 = this.getConditionCfg(mapCfgId, line)
    local result = ConditionManager.Check(actor, condition1) and ConditionManager.Check(actor, condition2)
    if not result then
        return { result = true, reason = "进入条件不满足", ignoreNotice = false }
    end
    return { result = false }
end

function this.getConditionCfg(mapCfgId, line)
    local condition1 = ""
    local condition2 = ""
    local entryCondition = ConfigDataManager.getTableValue("cfg_map_line", "entryCondition", "id", mapCfgId)
    if not string.isNullOrEmpty(entryCondition) then
        local strTable = string.split(entryCondition, "|")
        for _, str in pairs(strTable) do
            local first_char = string.sub(str, 1, 1)
            if tonumber(first_char) == line then
                condition1 = string.sub(str, 3)
            end
        end
    end
    local showCondition = ConfigDataManager.getTableValue("cfg_map_line", "showCondition", "id", mapCfgId)
    if not string.isNullOrEmpty(showCondition) then
        local strTable = string.split(showCondition, "|")
        for _, str in pairs(strTable) do
            local first_char = string.sub(str, 1, 1)
            if tonumber(first_char) == line then
                condition2 = string.sub(str, 3)
            end
        end
    end
    return condition1, condition2
end

function this.getMapLineTab(s)
    local t = {}
    if string.isNullOrEmpty(s) then
        return t
    end
    for part in s:gmatch("[^|]+") do
        local num = part:match("#(%d+)")
        if num then
            table.insert(t, tonumber(num))
        end
    end
    return t
end

function this.getNewMapLine(actor, mapCfgId, targetLine)
    local newLine = targetLine
    local isCheckCondition = true
    local cfgMapLine = ConfigDataManager.getById("cfg_map_line", mapCfgId)
    if table.isEmpty(cfgMapLine) then
        error(actor, "玩家", actor, "cfg_map_line配置不存在 配置id：", mapCfgId)
        return newLine, isCheckCondition
    end
    local type = string.tonumber(ConfigDataManager.getTableValue("cfg_map_info", "type", "id", mapCfgId))
    if type == 1 then
        local lineAllotRuleForbiddenCfg = string.toIntIntMap(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.LINE_ALLOT_RULE_FORBIDDEN_CFG))
        local serverOpenDays = getbaseinfo(actor, "serveropendays")

        -- 常规地图分配线路
        local mode = string.tonumber(cfgMapLine.mode)
        local mapLineTab = this.getMapLineTab(cfgMapLine.mapline)
        -- 线路大于1才随机
        if #mapLineTab > 1 then
            local lineLoadTab = string.toIntIntMap(cfgMapLine.lineload)
            local sidelinePeople = this.getSidelinePeople(cfgMapLine.sidelinepeople, serverOpenDays)

            local mapId = getbaseinfo(actor, "unimapid")
            local currMapCfgId, mapLine = gamemap.parseMapKey(mapId)
            if mode == MapLineMode.RANDOM then
                local lineMap = {}
                for _, line in pairs(mapLineTab) do
                    local isForbiddenRandom = this.isForbiddenRandom(lineAllotRuleForbiddenCfg, mapCfgId, line)
                    local resInfo = this.checkCondition(actor, mapCfgId, line)
                    if not resInfo.result and not isForbiddenRandom then
                        local maps = gettrickmaps(actor, mapCfgId, line)
                        local playerCount = this.getMapPlayerCount(maps)
                        local lineLoad = this.getLineLoad(cfgMapLine.sidelineswitch, line, lineLoadTab, sidelinePeople, maps)
                        if lineLoad <= 0 then
                            error(actor, "玩家", actor, "地图最大人数上限配置错误1 地图id：", mapCfgId, " 线路：", targetLine, " 线路人数上限：", lineLoadTab, " sidelinePeople", sidelinePeople, "serverOpenDays",serverOpenDays)
                        else
                            if mapCfgId == currMapCfgId and line == mapLine then
                                playerCount = playerCount - 1
                            end
                            if lineLoad > playerCount then
                                table.insert(lineMap, line)
                            end
                        end
                    end
                end
                if #lineMap > 0 then
                    local num = math.random(1, #lineMap)
                    newLine = lineMap[num]
                else
                    newLine = targetLine
                end
            elseif mode == MapLineMode.EVEN then
                local lineMap = {}
                for _, line in pairs(mapLineTab) do
                    local isForbiddenRandom = this.isForbiddenRandom(lineAllotRuleForbiddenCfg, mapCfgId, line)
                    local resInfo = this.checkCondition(actor, mapCfgId, line)
                    if not resInfo.result and not isForbiddenRandom then
                        local maps = gettrickmaps(actor, mapCfgId, line)
                        local playerCount = this.getMapPlayerCount(maps)
                        --local playerIds = getmapplayerids(actor)
                        --ZzpTest.print("均衡查看","lineLoadTab",lineLoadStr, "mapCfgId",mapCfgId, "line",line, "playerCount",playerCount)
                        local lineLoad = this.getLineLoad(cfgMapLine.sidelineswitch, line, lineLoadTab, sidelinePeople, maps)
                        if lineLoad <= 0 then
                            error(actor, "玩家", actor, "地图最大人数上限配置错误2 地图id：", mapCfgId, " 线路：", targetLine, " 线路人数上限：", lineLoadTab, " sidelinePeople", sidelinePeople, "serverOpenDays",serverOpenDays)
                        else
                            if mapCfgId == currMapCfgId and line == mapLine then
                                playerCount = playerCount - 1
                            end
                            if lineLoad > playerCount then
                                local lineInfo = {}
                                lineInfo.line = line
                                lineInfo.playerCount = playerCount
                                table.insert(lineMap, lineInfo)
                            end
                        end
                    end
                end
                if #lineMap > 0 then
                    -- 先按人数升序，再按 id 升序
                    table.sort(lineMap, function(a, b)
                        if a.playerCount ~= b.playerCount then
                            return a.playerCount < b.playerCount  -- 人数少的优先
                        else
                            return a.line < b.line                -- 人数相同时，id 小的优先
                        end
                    end)
                    newLine = lineMap[1].line
                else
                    newLine = targetLine
                end
            end
            isCheckCondition = false
        end
    end
    return newLine , isCheckCondition
end

--- 是否禁止随机线路
function this.isForbiddenRandom(lineAllotRuleForbiddenCfg, mapCfgId, line)
    if table.isEmpty(lineAllotRuleForbiddenCfg) then
        return false
    end
    for cfgMapId, cfgLine in pairs(lineAllotRuleForbiddenCfg) do
        if cfgMapId == tonumber(mapCfgId) and cfgLine == tonumber(line) then
            return true
        end
    end
    return false
end

--- 获取地图线路人数
function this.getMapPlayerCount(maps)
    local totalCount = 0
    if table.isEmpty(maps) then
        return totalCount
    end
    for _, mapInfo in pairs(maps) do
        totalCount = totalCount + mapInfo.playercount
    end
    return totalCount
end

--- 获取线路人数上限
function this.getLineLoad(sidelineSwitch, line, lineLoadTab, sidelinePeople, maps)
    local lineLoad = 0
    local sidelineSwitchTab = string.splitInt(sidelineSwitch, "#")
    if table.contains(sidelineSwitchTab, tonumber(line)) then
        -- 开启支线功能 走sidelinePeople字段
        --local num = table.count(maps)
        --lineLoad = sidelinePeople * num
        lineLoad = 90000
    else
        -- 没有支线功能用 lineLoad字段
        lineLoad = lineLoadTab[line] or 0
    end
    return lineLoad
end

function this.getSidelinePeople(sidelinepeople, openServerDay)
    local lineLoad = 0
    local sidelinePeople = string.splitInt(sidelinepeople, "#")
    local peopleOpenServerDayLow = sidelinePeople[1]
    local peopleOpenServerDayHigh = sidelinePeople[2]
    local peopleCountLimit = sidelinePeople[3]
    if peopleOpenServerDayLow <= openServerDay and peopleOpenServerDayHigh >= openServerDay then
        lineLoad = peopleCountLimit
    end
    return lineLoad
end

function CustomTransmit.throwsItem(actor, cfgId, id, rid)
    if not this.checkValid(actor, cfgId) then
        return
    end
    local v = ConfigDataManager.getTableValue("cfg_global", "value", "id", 540002)
    local time = tonumber(v) * TimeUnit.MILLISECOND
    local cv = API.GetTable(actor, __CustomTransmitKey) or {}
    local preTime = cv.throwsTime or 0
    local now = getbaseinfo(actor, "now")
    if preTime + time >= now then
        tipinfo(actor,"传送门冷却中")
        additemtobag(actor, cfgId, 1)
        return
    end
    cv.throwsTime = now
    cv.throwsItem = cfgId
    API.SetTable(actor, __CustomTransmitKey, cv)

    sendluamsg(actor, LuaMessageIdToClient.RES_THROWS_ITEM_TRANSFER, cv)
end

function CustomTransmit.throwsItemTransfer(actor)
    local cv = API.GetTable(actor, __CustomTransmitKey) or {}
    local now = getbaseinfo(actor, "now")
    local throwsTime = cv.throwsTime
    local v = ConfigDataManager.getTableValue("cfg_global", "value", "id", 540002)
    local time = tonumber(v) * TimeUnit.MILLISECOND
    if throwsTime + time < now then
        -- 时间已过
        tipinfo(actor,"传送时间已过")
        return
    end
    local cfgId = cv.throwsItem
    if not this.checkValid(actor, cfgId) then
        return
    end
    local config = ConfigDataManager.getById("cfg_item", cfgId)
    local transferId = config.useparam
    if string.isNullOrEmpty(transferId) then
        return
    end
    local data = {id = transferId, line = 1}
    CustomTransmit.mapMoveTransfer(actor, data)
end

function this.checkValid(actor, cfgId)
    local config = ConfigDataManager.getById("cfg_item", cfgId)
    if table.isEmpty(config) then
        return false
    end
    if tonumber(config.type) ~= 3 or tonumber(config.subtype) ~= 52 then
        return false
    end
    local level = getbaseinfo(actor, "level")
    local v = ConfigDataManager.getTableValue("cfg_global", "value", "id", 540001)
    local needLevel = tonumber(v)
    if level < needLevel then
        return false
    end
    return true
end

MessageRouter:register(LuaMessageIdToSever.REQ_MAP_MOVE_TRANSFER, CustomTransmit.mapMoveTransfer)
MessageRouter:register(LuaMessageIdToSever.REQ_CUSTOM_TRANSFER, CustomTransmit.reqCustomTransfer)
MessageRouter:register(LuaMessageIdToSever.REQ_THROWS_ITEM_TRANSFER, CustomTransmit.throwsItemTransfer)

-- ====================================测试========================================
function testcustomtransmit(actor, ...)
    local args = { ... }
    local opt = tonumber(args[1])
    if opt == 1 then
        CustomTransmit.throwsItemTransfer(actor)
    elseif opt == 2 then
        CustomTransmit.throwsItem(actor, 2000021)
    end
end
