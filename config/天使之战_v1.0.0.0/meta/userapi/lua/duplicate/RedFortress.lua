--赤色要塞副本
RedFortress = {}
local this = {}

local NoteType = { KILL = 1, RELIVE = 2 }


-- @description 请求进入副本
-- @param 玩家对象；cfg_rep的id
-- @return
function RedFortress.ReqEnterFortress(actor, configId)
    -- 验证等级
    local playerLevel = tonumber(getbaseinfo(actor, "level"))
    local levelConfig = ConfigDataManager.getTableValue("cfg_rep", "level", "id", configId)
    local levelList = string.split(levelConfig, "#")
    local minLevel = tonumber(levelList[1])
    local maxLevel = tonumber(levelList[2])
    if playerLevel < minLevel or playerLevel > maxLevel then
        tipinfo(actor, "等级不足")
        error(actor:toString() .. "赤色要塞副本进入等级不符合要求{" .. playerLevel .. "}{" .. configId .. "}")
        return
    end
    -- 寻找空闲副本
    local mapId = DuplicateCommon.FindEnterableDupCommon(configId, 1)
    if mapId == 0 then
        mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, true)
    end
    local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    --回蓝回血
    DuplicateCommon.RecoverHPMP(actor)
    enterduplicate(actor, mapId, x, y)
end

-- @description 副本阶段更新
-- @param 系统id；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function RedFortress.RedFortressStateUpdate(system, mapId, state, nextStateStartTime, configId)
    if state == DuplicateState.PREPARE then
        --准备阶段
        -- 初始化副本数据
        -- 战斗区域
        local fightAreaConfig = ConfigDataManager.getTableValue("cfg_repRedfortress", "start", "repId", configId)
        local fightAreaList = string.split(fightAreaConfig, "#")
        setenvirvar(mapId, DuplicateVarConst.RED_FORTRESS_FIGHT_AREA, fightAreaList)
        setenvirvar(mapId, DuplicateVarConst.RED_FORTRESS_PHASE, 1) --地图每减少一次阶段+1
    elseif state == DuplicateState.FIGHT then
        --更新阶段信息
        this.ResAllPlayCurrencyStateInfo(mapId)
        --战斗阶段
        -- 生成怪物
        local config = ConfigDataManager.getTableFirst("cfg_repRedfortress", "repId", configId)
        local monsterConfig = config.monsterid
        local monsterList = string.split(monsterConfig, "#")
        local playerCount = getplaycountinmap(mapId)
        playerCount = tonumber(playerCount or 1)
        local maxUnit = config.maxunit
        local leftCount = tonumber(maxUnit) - playerCount
        for i = 1, leftCount do
            --怪物id
            local randomIndex = math.random(#monsterList)
            local monsterId = monsterList[randomIndex]
            --随机点位
            local x, y = this.RandomFightPointXY(mapId, 100)
            mongen(mapId, x, y, 0, monsterId, 1)
        end
        -- 玩家传送到战斗区域
        local players = getmapplayer(mapId)
        for index, player in ipairs(players) do
            --随机点位
            local x, y = this.RandomFightPointXY(mapId, 100)
            maptransfer(player, x, y, 0, 0, 0)
        end
        this.ResAllPlayersTaskInfo(mapId, maxUnit)
    elseif state == DuplicateState.FINISH then
        --结算阶段
        this.ResAllPlayCurrencyStateInfo(mapId)
        -- 计算积分
        this.CalcuAndSetPlayerPointRank(mapId)
    end
end

-- @description 副本5秒钟心跳
-- @param
-- @return
function RedFortress.Dup5SecondHeart(mapId, dupConfig, state)
    if state == DuplicateState.FIGHT then
        local area = getenvirvar(mapId, DuplicateVarConst.RED_FORTRESS_FIGHT_AREA)
        local x1 = tonumber(area[1])
        local x2 = tonumber(area[2])
        local y1 = tonumber(area[3])
        local y2 = tonumber(area[4])
        -- 不在区域内的怪物死亡
        local monsterInfoList = mapbossinfo(mapId)
        for key, monInfo in pairs(monsterInfoList) do
            local monId = monInfo["id"]
            local px = monInfo["x"]
            local py = monInfo["y"]
            local isIn = this.IsPointInArea(px, py, x1, x2, y1, y2)
            if isIn == false then
                local monster = getactor(monId, mapId)
                removemapobject(monster)
            end
        end
    end
end

-- @description 玩家进入副本后
-- @param 玩家对象；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function RedFortress.AfterRedFortressEnter(actor, mapId, state, nextStateStartTime, configId)
    -- 清除召唤兽
    local petId = getbaseinfo(actor, "petid")
    local petActor = getactor(petId, mapId)
    removemapobject(petActor)

    local playerDupInfo = getplaydef(actor, RedFortressPlayerConst.MAP_INFO)
    -- 是否是新进入的副本
    local newEnter = false
    if playerDupInfo == nil or playerDupInfo == "" then
        newEnter = true
    else
        local lastMapId = playerDupInfo[1]
        if mapId ~= lastMapId then
            newEnter = true
        end
    end
    if newEnter == true then
        -- 进入新的副本，初始化玩家变量
        playerDupInfo = { mapId, configId }
        setplaydef(actor, RedFortressPlayerConst.MAP_INFO, playerDupInfo)
        -- 复活次数
        setplaydef(actor, RedFortressPlayerConst.RELIVE_TIMES, 0)
        -- 积分
        setplaydef(actor, RedFortressPlayerConst.KILL_SCORES, 0)
        -- 击杀数
        setplaydef(actor, RedFortressPlayerConst.KILL_COUNT, 0)
        -- 排名
        setplaydef(actor, RedFortressPlayerConst.PLAYER_RANK, 0)
    end
    this.ResCurrencyStateInfo(actor, mapId)
    if state == DuplicateState.PREPARE then
        -- 发送副本人数
        this.ResAllPreparePlayerCount(mapId)
    elseif state == DuplicateState.FIGHT then
        -- 随机传送
        local x, y = this.RandomFightPointXY(mapId, 100)
        maptransfer(actor, x, y, 0, 0, 0)
        this.ResPlayerTaskInfo(actor, mapId)
    end
end

-- @description 玩家退出副本
-- @param 玩家对象；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function RedFortress.AfterRedFortressQuit(actor, mapId, state, nextStateStartTime, configId)
    -- 排名更新；战斗阶段是人数；结算阶段是积分
    if state == DuplicateState.PREPARE then
        this.ResAllPreparePlayerCount(mapId)
    elseif state == DuplicateState.FIGHT then
        local players = getmapplayer(mapId)
        local playerCount = #players
        local monCount = getmoncount(mapId)
        local totalCount = monCount + playerCount
        setplaydef(actor, RedFortressPlayerConst.PLAYER_RANK, totalCount + 1)
        this.LeftCountChange(mapId, 0)
    end
end

-- @description 怪物死亡事件
-- @param 地图id；击杀者
-- @return
function RedFortress.OnMonsterDie(mapId, killer)
    this.LeftCountChange(mapId, 0)
    local dupInfo = getduplicate(mapId)
    local configId = dupInfo["dupcfgid"]
    if killer:toString() ~= "0" then
        -- 击杀者加积分；显示图标
        local oldCount = getplaydef(killer, RedFortressPlayerConst.KILL_SCORES)
        local pointConfig = ConfigDataManager.getTableValue("cfg_repRedfortress", "points", "repId", configId)
        local pointList = string.split(pointConfig, "#")
        local addPoint = tonumber(pointList[2])
        local newPoint = oldCount + addPoint
        setplaydef(killer, RedFortressPlayerConst.KILL_SCORES, newPoint)
        -- 加击杀次数
        local oldKill = getplaydef(killer, RedFortressPlayerConst.KILL_COUNT)
        setplaydef(killer, RedFortressPlayerConst.KILL_COUNT, oldKill + 1)
        sendluamsg(killer, LuaMessageIdToClient.RES_RED_FORTRESS_KILL_RELIVE, { NoteType.KILL, oldKill + 1 })
    end
end

-- @description 击杀玩家
-- @param 玩家对象；被击杀的玩家
-- @return
function RedFortress.KillPlayer(actor, diePlayer)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil or dupInfo == "" then
        return
    end
    local type = dupInfo["type"]
    if type ~= DuplicateType.RED_FORTRESS then
        return
    end
    local configId = dupInfo["dupcfgids"]
    -- 加积分
    local oldCount = getplaydef(actor, RedFortressPlayerConst.KILL_SCORES)
    local pointConfig = ConfigDataManager.getTableValue("cfg_repRedfortress", "points", "repId", configId)
    local pointList = string.split(pointConfig, "#")
    local addPoint = tonumber(pointList[1])
    local newPoint = oldCount + addPoint
    setplaydef(actor, RedFortressPlayerConst.KILL_SCORES, newPoint)
    -- 加击杀次数
    local oldKill = getplaydef(actor, RedFortressPlayerConst.KILL_COUNT)
    setplaydef(actor, RedFortressPlayerConst.KILL_COUNT, oldKill + 1)
    -- 击杀图标
    sendluamsg(actor, LuaMessageIdToClient.RES_RED_FORTRESS_KILL_RELIVE, { NoteType.KILL, oldKill + 1 })
end

-- @description 玩家死亡事件
-- @param 玩家对象
-- @return
function RedFortress.PlayerDie(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    local type = dupInfo["type"]
    if type ~= DuplicateType.RED_FORTRESS then
        return
    end
    local configId = dupInfo["dupcfgid"]
    -- 更新死亡次数
    local oldCount = getplaydef(actor, RedFortressPlayerConst.RELIVE_TIMES)
    local maxCount = ConfigDataManager.getTableValue("cfg_repRedfortress", "rebornChance", "repId", configId)
    if oldCount >= tonumber(maxCount) then
        -- 退出副本并结算
        DuplicateCommon.ReqQuitDuplicate(actor)
    else
        -- 延迟执行复活
        local delaySec = ConfigDataManager.getTableValue("cfg_repRedfortress", "rebornTime", "repId", configId)
        local delayMillis = tonumber(delaySec) * 1000
        intervalcalldelay(actor, delayMillis, 0, 1, "redfortressdorelive")
    end
end

function redfortressdorelive(actor)
    playrevive(actor, 7, 3)
end

function redfortresskillnotinrange(system, mapId, isFinal)
    local area = getenvirvar(mapId, DuplicateVarConst.RED_FORTRESS_FIGHT_AREA)
    local x1 = tonumber(area[1])
    local x2 = tonumber(area[2])
    local y1 = tonumber(area[3])
    local y2 = tonumber(area[4])
    -- 不在区域内的怪物死亡
    local monsterInfoList = mapbossinfo(mapId)
    for key, monInfo in pairs(monsterInfoList) do
        local monId = monInfo["id"]
        local px = monInfo["x"]
        local py = monInfo["y"]
        local isIn = this.IsPointInArea(px, py, x1, x2, y1, y2)
        if isIn == false then
            local monster = getactor(monId, mapId)
            removemapobject(monster)
        end
    end

    -- 缩圈阻挡点
    this.ShrinkingCircleBlockPoint(system, mapId)

    local players = getmapplayer(mapId)
    for key, actor in pairs(players) do
        local px = getbaseinfo(actor, "x")
        local py = getbaseinfo(actor, "y")
        local isIn = this.IsPointInArea(px, py, x1, x2, y1, y2)
        if isIn == false then
            sethp(actor, 0)
            local dupInfo = getduplicate(mapId)
            local configId = dupInfo["dupcfgid"]
            -- 延迟执行复活
            local delaySec = ConfigDataManager.getTableValue("cfg_repRedfortress", "rebornTime", "repId", configId)
            local delayMillis = tonumber(delaySec) * 1000
            intervalcalldelay(actor, delayMillis, 0, 1, "redfortressdorelive")
        end
    end

    if isFinal then
        local dupInfo = getduplicate(mapId)
        local configId = dupInfo["dupcfgid"]
        local maxCount = ConfigDataManager.getTableValue("cfg_repRedfortress", "rebornChance", "repId", configId)
        maxCount = tonumber(maxCount)
        for key, player in pairs(players) do
            setplaydef(player, RedFortressPlayerConst.RELIVE_TIMES, maxCount)
            -- clearallbuff(player)
        end
    end
end

-- @description 缩圈阻挡点
-- @param
-- @return
function this.ShrinkingCircleBlockPoint(system, mapId)
    local area = getenvirvar(mapId, DuplicateVarConst.RED_FORTRESS_FIGHT_AREA)
    local x1 = tonumber(area[1]) - 1
    local x2 = tonumber(area[2]) + 1
    local y1 = tonumber(area[3]) - 1
    local y2 = tonumber(area[4]) + 1
    for x = x1, x2 do
        setblockpoint(x, y1, true, mapId) -- 下边
    end
    for y = y1 + 1, y2 - 1 do
        setblockpoint(x2, y, true, mapId) -- 右边（不包括顶点）
    end
    for x = x2 - 1, x1 + 1, -1 do
        setblockpoint(x, y2, true, mapId) -- 上边（不包括顶点）
    end
    for y = y2 - 1, y1 + 1, -1 do
        setblockpoint(x1, y, true, mapId) -- 左边（不包括顶点）
    end

    -- 设置四个顶点
    setblockpoint(x1, y1, true, mapId) -- 左下角
    setblockpoint(x2, y1, true, mapId) -- 右下角
    setblockpoint(x1, y2, true, mapId) -- 左上角
    setblockpoint(x2, y2, true, mapId) -- 右上角
end

-- @description 玩家复活事件
-- @param 玩家对象
-- @return
function RedFortress.PlayerRelive(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    local type = dupInfo["type"]
    if type ~= DuplicateType.RED_FORTRESS then
        return
    end
    local configId = dupInfo["dupcfgid"]
    local maxCount = ConfigDataManager.getTableValue("cfg_repRedfortress", "rebornChance", "repId", configId)
    maxCount = tonumber(maxCount)
    -- 扣除复活次数
    local oldCount = getplaydef(actor, RedFortressPlayerConst.RELIVE_TIMES)
    local newCount = oldCount + 1
    if newCount > maxCount then
        newCount = maxCount
    end
    setplaydef(actor, RedFortressPlayerConst.RELIVE_TIMES, newCount)
    -- 传送
    --随机点位
    local x, y = this.RandomFightPointXY(mapId, 100)
    maptransfer(actor, x, y, 0, 0, 0)
    -- 被击杀图标
    sendluamsg(actor, LuaMessageIdToClient.RES_RED_FORTRESS_KILL_RELIVE, { NoteType.RELIVE, newCount })
    -- 面板消息
    this.ResPlayerTaskInfo(actor, mapId)
end

-- @description 地图玩家怪物数量改变
-- @param 地图id;偏移量
-- @return
function this.LeftCountChange(mapId, offset)
    -- 回包
    local dupInfo = getduplicate(mapId)
    local state = dupInfo["state"]
    local players = dupInfo["players"]
    local configId = dupInfo["dupcfgid"]
    local monCount = getmoncount(mapId)
    local totalCount = tonumber(monCount) + #players - offset

    if state == DuplicateState.PREPARE then
    elseif state == DuplicateState.FIGHT then
        this.ResAllPlayersTaskInfo(mapId, totalCount)
        -- 只剩最后一个玩家，则结束副本
        if totalCount <= 1 then
            setduplicatestate(mapId, SetDuplicateStateConst.TO_FINISH)
            return
        end

        -- 阶段更新，地形，
        local phase = getenvirvar(mapId, DuplicateVarConst.RED_FORTRESS_PHASE)
        local mapCutConfig = ConfigDataManager.getTableValue("cfg_repRedfortress", "mapCut", "repId", configId)
        local mapCutList = string.split(mapCutConfig, "|")
        if phase <= #mapCutList then
            local mapCutItemStr = mapCutList[phase]
            local mapCutItemList = string.split(mapCutItemStr, "#")
            local countCondition = mapCutItemList[1]
            if totalCount < tonumber(countCondition) then
                -- 阶段更新，地形
                local percentage = mapCutItemList[2]
                local area = getenvirvar(mapId, DuplicateVarConst.RED_FORTRESS_FIGHT_AREA)
                local oldX1 = tonumber(area[1])
                local oldX2 = tonumber(area[2])
                local oldY1 = tonumber(area[3])
                local oldY2 = tonumber(area[4])
                local newX1, newX2, newY1, newY2 = this.ShrinkRectangle(oldX1, oldX2, oldY1, oldY2, tonumber(percentage))
                -- 取整
                newX1 = math.floor(newX1)
                newX2 = math.floor(newX2)
                newY1 = math.floor(newY1)
                newY2 = math.floor(newY2)
                local newArea = { newX1, newX2, newY1, newY2 }
                setenvirvar(mapId, DuplicateVarConst.RED_FORTRESS_FIGHT_AREA, newArea)
                -- 回包
                this.ResAllShrinkingStage(mapId, phase, newArea)
                -- 延迟5秒，击杀所有不在区域内的玩家
                local warningCfg = ConfigDataManager.getTableValue("cfg_repRedfortress", "warning", "repId", configId)
                local warningList = string.split(warningCfg, "#")
                local delayMillis = tonumber(warningList[phase]) * 1000

                if phase >= #mapCutList then
                    -- 如果是最后一个阶段，扣除玩家所有复活次数和增益效果
                    -- local maxCount = ConfigDataManager.getTableValue("cfg_repRedfortress", "rebornChance", "repId", configId)
                    -- for key, player in pairs(players) do
                    --     setplaydef(player, RedFortressPlayerConst.RELIVE_TIMES, maxCount)
                    --     clearallbuff(player)
                    -- end
                    setenvirontimer(mapId, delayMillis, 0, 1, "redfortresskillnotinrange", mapId, true)
                else
                    setenvirontimer(mapId, delayMillis, 0, 1, "redfortresskillnotinrange", mapId, false)
                end
                setenvirvar(mapId, DuplicateVarConst.RED_FORTRESS_PHASE, phase + 1)
            end
        end
    end
end

-- @description 玩家进入任意地图事件
-- @param 玩家对象；上一个地图配置id；当前地图配置id
-- @return
function RedFortress.EnterAllMap(actor, lastMapCfgId, mapCfgId)
    -- 判断发送副本结算
    local dupInfo = getplaydef(actor, RedFortressPlayerConst.MAP_INFO)
    if dupInfo == nil or dupInfo == "" then
        return
    end
    local bloodyId = dupInfo[1]
    local mapId = getbaseinfo(actor, "unimapid")
    local mapInfo = getmapinfobyid(mapId)
    local isDup = mapInfo["isdup"]
    if isDup == true and bloodyId ~= mapId then
        error(actor:toString() .. "赤色要塞有未结算的奖励")
        RedFortress.ClearPlayerDef(actor)
        return
    end
    if bloodyId ~= mapId then
        -- 结算
        this.Settlement(actor)
    end
end

-- @description 结算
-- @param 玩家对象
-- @return
function this.Settlement(actor)
    local dupInfo = getplaydef(actor, RedFortressPlayerConst.MAP_INFO)
    if dupInfo == nil or dupInfo == "" then
        error("赤色要塞副本结算找不到副本信息")
        return
    end
    local killCount = getplaydef(actor, RedFortressPlayerConst.KILL_COUNT)
    local rank = getplaydef(actor, RedFortressPlayerConst.PLAYER_RANK)
    -- 发邮件奖励
    local configId = dupInfo[2]
    local rewardCfg = ConfigDataManager.getTableValue("cfg_repRedfortress", "reward", "repId", configId)
    local rewardRank = string.split(rewardCfg, "|")
    local itemBing = ConfigDataManager.getTableValue("cfg_bind", "bind", "id", 9)
    for key, value in pairs(rewardRank) do
        local innerList = string.split(value, "#")
        local min = tonumber(innerList[1])
        local max = tonumber(innerList[2])
        local itemMap = {}
        for i = 3, #innerList, 2 do
            if i + 1 <= #innerList then
                itemMap[tonumber(innerList[i])] = tonumber(innerList[i + 1])
            end
        end
        if min <= rank and rank <= max then
            sendconfigmailbyrid(actor, actor:toString(), MailConfig.RED_FORTRESS_REWARD, itemMap, rank, itemBing)
            break
        end
    end
    -- 发包
    sendluamsg(actor, LuaMessageIdToClient.RES_RED_FORTRESS_SETTLEMENT_PANEL, { killCount, rank })
    -- 清楚玩家变量
    RedFortress.ClearPlayerDef(actor)
end

function RedFortress.ClearPlayerDef(actor)
    setplaydef(actor, RedFortressPlayerConst.MAP_INFO, nil)
    setplaydef(actor, RedFortressPlayerConst.RELIVE_TIMES, 0)
    setplaydef(actor, RedFortressPlayerConst.KILL_SCORES, 0)
    setplaydef(actor, RedFortressPlayerConst.KILL_COUNT, 0)
    setplaydef(actor, RedFortressPlayerConst.PLAYER_RANK, 0)
end

-- @description 准备阶段人数响应
-- @param 地图id
-- @return
function this.ResAllPreparePlayerCount(mapId)
    local dupInfo = getduplicate(mapId)
    local state = dupInfo["state"]
    if state ~= DuplicateState.PREPARE then
        return
    end
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        sendluamsg(actor, LuaMessageIdToClient.RES_RED_FORTRESS_PREPARE_COUNT, #players)
    end
end

-- @description 响应给客户端当前阶段
-- @param 玩家对象；地图id
-- @return
function this.ResCurrencyStateInfo(actor, mapId)
    local dupInfo = getduplicate(mapId)
    local state = dupInfo["state"]
    local configId = dupInfo["dupcfgid"]
    local nextStateStartTime = dupInfo["nextstatetime"]
    sendluamsg(actor, LuaMessageIdToClient.RES_RED_FORTRESS_STATE_UPDATE, { state, tostring(nextStateStartTime), configId })
end

-- @description 通知地图所有玩家更新当前阶段
-- @param 地图id
-- @return
function this.ResAllPlayCurrencyStateInfo(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        this.ResCurrencyStateInfo(actor, mapId)
    end
end

-- @description 通知当前玩家任务数据
-- @param 地图id
-- @return
function this.ResPlayerTaskInfo(actor, mapId, totalCount)
    totalCount = tonumber(totalCount)
    if totalCount == nil or totalCount <= 0 then
        local monCount = getmoncount(mapId)
        local players = getmapplayer(mapId)
        totalCount = monCount + #players
    end
    -- 剩余复活次数
    local reliveCount = getplaydef(actor, RedFortressPlayerConst.RELIVE_TIMES)
    local dupInfo = getplaydef(actor, RedFortressPlayerConst.MAP_INFO)
    local configId = dupInfo[2]
    local maxCount = ConfigDataManager.getTableValue("cfg_repRedfortress", "rebornChance", "repId", configId)
    local leftCount = maxCount - reliveCount
    -- 协议待定
    sendluamsg(actor, LuaMessageIdToClient.RES_RED_FORTRESS_TASK_INFO, { totalCount, leftCount })
end

-- @description 通知地图所有玩家任务数据
-- @param 地图id
-- @return
function this.ResAllPlayersTaskInfo(mapId, totalCount)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        this.ResPlayerTaskInfo(actor, mapId, totalCount)
    end
end

-- @description 通知地图所有玩家缩圈信息
-- @param 地图id
-- @return
function this.ResAllShrinkingStage(mapId, phase, newArea)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        sendluamsg(actor, LuaMessageIdToClient.RES_RED_FORTRESS_SHRINKING_STAGE, { phase, newArea })
    end
end

-- @description 找一个战斗区域可用的点
-- @param 地图id；递归次数
-- @return
function this.RandomFightPointXY(mapId, times)
    -- 设置递归最大次数
    local maxTimes = 100
    if times > maxTimes then
        times = maxTimes
    end

    local area = getenvirvar(mapId, DuplicateVarConst.RED_FORTRESS_FIGHT_AREA)

    -- 检查 area 数据格式
    if not area or #area ~= 4 then
        gameDebug.printTraceback("获取战斗区域错误", area)
        return 0, 0
    end

    local x1 = tonumber(area[1])
    local x2 = tonumber(area[2])
    local y1 = tonumber(area[3])
    local y2 = tonumber(area[4])

    -- 检查转换后的数据是否为数字
    if not (x1 and x2 and y1 and y2) then
        gameDebug.printTraceback("参数错误", x1, x2, y1, y2)
        return 0, 0
    end

    local randomX = this.GetRandomInt(x1, x2)
    local randomY = this.GetRandomInt(y1, y2)
    local notEmpty = isnotemptyinmap(mapId, randomX, randomY)
    local notBlock = notblockpoint(randomX, randomY, mapId)

    if notEmpty == false or notBlock == false then
        if times > 0 then
            times = times - 1
            return this.RandomFightPointXY(mapId, times)
        else
            return 0, 0
        end
    else
        return randomX, randomY
    end
end

function this.GetRandomInt(a, b)
    -- 确保 a 小于等于 b
    if a > b then
        a, b = b, a
    end
    -- 生成 (a, b) 区间内的随机整数
    return math.random(a + 1, b - 1)
end

-- @description 计算缩小后的坐标点
-- @param x1, x2, y1, y2坐标点；缩小的百分比，例如20
-- @return x1, x2, y1, y2坐标点
function this.ShrinkRectangle(x1, x2, y1, y2, percentage)
    if x1 > x2 then
        x1, x2 = x2, x1
    end
    if y1 > y2 then
        y1, y2 = y2, y1
    end

    local r = percentage / 100
    local center_x = (x1 + x2) / 2
    local center_y = (y1 + y2) / 2
    local width = math.abs(x2 - x1)
    local height = math.abs(y2 - y1)

    local new_width = width * (1 - r)
    local new_height = height * (1 - r)

    local x1_new = center_x - new_width / 2
    local y1_new = center_y - new_height / 2
    local x2_new = center_x + new_width / 2
    local y2_new = center_y + new_height / 2

    return x1_new, x2_new, y1_new, y2_new
end

-- @description 判断坐标点在不在矩形区域内
-- @param
-- @return
function this.IsPointInArea(px, py, x1, x2, y1, y2)
    if x1 > x2 then
        x1, x2 = x2, x1
    end
    if y1 > y2 then
        y1, y2 = y2, y1
    end
    local isIn = not (px < x1 or px > x2 or py < y1 or py > y2)
    return isIn
end

-- @description 获取积分排名列表
-- @param 地图id
-- @return 列表<玩家id字符串；排名>
function this.GetScoreRanking(mapId)
    local players = getmapplayer(mapId)
    local playerList = {}
    for index, actor in ipairs(players) do
        local score = getplaydef(actor, RedFortressPlayerConst.KILL_SCORES)
        table.insert(playerList, { actor = actor, score = score })
    end
    -- 按积分从高到低排序，如果积分相同，保持原有顺序
    table.sort(
        playerList,
        function(a, b)
            return a.score > b.score
        end
    )
    -- 计算排名
    local ranks = {}
    local rank = 1          -- 当前排名
    local sameRankCount = 0 -- 相同积分的计数
    local lowestRank = 1    -- 当前积分组的最低排名

    for i = 1, #playerList do
        local player = playerList[i]
        local nextPlayer = playerList[i + 1]

        -- 判断下一名玩家是否与当前玩家积分相同
        if nextPlayer and player.score == nextPlayer.score then
            sameRankCount = sameRankCount + 1
        else
            -- 更新最低排名为当前排名加上相同积分玩家的数量
            lowestRank = rank + sameRankCount
            -- 将当前积分相同的所有玩家设为最低排名
            for j = i - sameRankCount, i do
                ranks[playerList[j].actor.toString] = lowestRank
            end
            -- 更新排名和计数
            rank = lowestRank + 1
            sameRankCount = 0
        end
    end

    return ranks
end

-- @description 获取指定玩家的积分排名
-- @param 玩家对象；地图id
-- @return 排名
function this.GetPlayerRank(actor, mapId)
    local ranking = this.GetScoreRanking(mapId)
    return ranking[actor.toString]
end

-- @description 计算并设置玩家积分
-- @param 地图id
-- @return
function this.CalcuAndSetPlayerPointRank(mapId)
    local players = getmapplayer(mapId)
    if #players <= 0 then
        return
    end
    local playerList = {}
    for index, actor in ipairs(players) do
        local score = getplaydef(actor, RedFortressPlayerConst.KILL_SCORES)
        table.insert(playerList, { actor = actor, score = score })
    end
    -- 按积分从高到低排序，如果积分相同，保持原有顺序
    table.sort(
        playerList,
        function(a, b)
            return a.score > b.score
        end
    )
    -- 计算排名
    local rank = 1          -- 当前排名
    local sameRankCount = 0 -- 相同积分的计数
    local lowestRank = 1    -- 当前积分组的最低排名

    if #playerList > 1 then
        for i = 1, #playerList do
            local player = playerList[i]
            local nextPlayer = playerList[i + 1]

            -- 判断下一名玩家是否与当前玩家积分相同
            if nextPlayer and player.score == nextPlayer.score then
                sameRankCount = sameRankCount + 1
            else
                -- 更新最低排名为当前排名加上相同积分玩家的数量
                lowestRank = rank + sameRankCount
                -- 将当前积分相同的所有玩家设为最低排名
                for j = i - sameRankCount, i do
                    local actor = playerList[j].actor
                    setplaydef(actor, RedFortressPlayerConst.PLAYER_RANK, lowestRank)
                end
                -- 更新排名和计数
                rank = lowestRank + 1
                sameRankCount = 0
            end
        end
    else
        local player = playerList[1].actor
        setplaydef(player, RedFortressPlayerConst.PLAYER_RANK, 1)
    end
end

function test_rolandchangestate(actor, state)
    local mapId = getbaseinfo(actor, "unimapid")
    setduplicatestate(mapId, state)
end
