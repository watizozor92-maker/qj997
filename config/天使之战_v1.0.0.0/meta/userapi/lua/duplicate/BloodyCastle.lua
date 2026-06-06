--血色城堡副本
BloodyCastle = {}
local this = {}
-- @description 客户端请求面板数据
-- @param 玩家对象；请求参数
-- @return
function BloodyCastle.ReqGetPanelInfo(actor, msgData)
    local configId = tonumber(msgData)
    if configId == nil or configId <= 0 then
        gameDebug.assertPrintTrace(false, actor:toString() .. "请求血色城堡面板，参数有误！configId:" .. configId)
        return
    end
    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    local leftCount = getleftcountofactivity(actor, activityId)
    local activityInfo = getactivityinfo(activityId)
    local isOpen = activityInfo["open"]
    local nextOpenTime
    if isOpen then
        nextOpenTime = activityInfo["closetime"]
    else
        nextOpenTime = activityInfo["nextopentime"]
    end
    local resInfo = { configId, leftCount, isOpen, tostring(nextOpenTime) }
    -- 血色城堡面板协议
    sendluamsg(actor, LuaMessageIdToClient.RES_BLOODY_CASTLE_PANEL, resInfo)
end

function BloodyCastle.doTeamEnter(actor, enterMembers, configId)
    local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    local mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, false)
    for _, memberActor in pairs(enterMembers) do
        -- 回蓝回血
        DuplicateCommon.RecoverHPMP(memberActor)
        -- 进入地图
        BloodyCastle.PlayerEnterBloodyCastle(memberActor, mapId, x, y, configId)
    end
end

-- @description 请求进入血色城堡
-- @param 玩家对象；cfg_rep的id
-- @return
function BloodyCastle.ReqEnterBloodyCastle(actor, configId)
    --个人进入
    if DuplicateCommon.CheckEnterConditonCommon(actor, configId) ~= EnterLimitResultConst.ALLOW then
        return
    end
    callonserial(actor, "enter_bloody_castle_on_serial", configId)
    --寻找是否有可进入的副本，如果没有创建副本
    -- local mapId = DuplicateCommon.FindEnterableDupCommon(configId, 1)
    -- local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    -- if mapId == 0 then
    --     if BloodyCastle.isMaxDupNums(configId) then
    --         noticeTip.noticeinfo(actor, StringIdConst.TEXT45001)
    --         return
    --     end
    --     mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, true)
    -- end
    -- --回蓝回血
    -- DuplicateCommon.RecoverHPMP(actor)
    -- BloodyCastle.PlayerEnterBloodyCastle(actor, mapId, x, y, configId)
end

function BloodyCastle.EnterBloodyCastle(actor, configId)
    --个人进入
    if DuplicateCommon.CheckEnterConditonCommon(actor, configId) ~= EnterLimitResultConst.ALLOW then
        return
    end

    --寻找是否有可进入的副本，如果没有创建副本
    local mapId = DuplicateCommon.FindEnterableDupCommon(configId, 1)
    local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    if mapId == 0 then
        if BloodyCastle.isMaxDupNums(configId) then
            noticeTip.noticeinfo(actor, StringIdConst.TEXT45001)
            return
        end
        mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, true)
    end
    --回蓝回血
    DuplicateCommon.RecoverHPMP(actor)
    BloodyCastle.PlayerEnterBloodyCastle(actor, mapId, x, y, configId)
end

function enter_bloody_castle_on_serial(actor, configId)
    BloodyCastle.EnterBloodyCastle(actor, configId)
end

function BloodyCastle.isMaxDupNums(configId)
    local nowNums = DuplicateCommon.getCurrentDupNumById(configId)
    local limitNums = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 520002))
    return nowNums >= limitNums
end

-- @description 组队进入副本
-- @param 玩家对象；队伍id；副本配置
-- @return
function BloodyCastle.DoTeamEnter(actor, teamId, configId)
    -- local teamInfo = getteaminfo(actor, teamId)
    -- local members = teamInfo["allteammemberinfo"]
    -- for index, memberInfo in ipairs(members) do
    --     local memberId = memberInfo["rid"]
    --     local memberActor = getactor(actor, memberId)
    --     local check = DuplicateCommon.CheckEnterConditonCommon(memberActor, configId)
    --     if check ~= EnterLimitResultConst.ALLOW then
    --         gameDebug.assertPrintTrace(false, actor:toString() .. "组队进入成员条件不满足!memberId:" .. memberId)
    --         return
    --     end
    -- end
    -- local memberActors = {}
    -- --扣除次数；扣除道具
    -- for index, memberInfo in ipairs(members) do
    --     local memberId = memberInfo["rid"]
    --     local memberActor = getactor(actor, memberId)
    --     --BloodyCastle.RemoveItemBeforeEnter(memberActor, configId)
    --     DuplicateCommon.RemoveItemBeforeEnter(actor, configId, "血色城堡")
    --     table.insert(memberActors, memberActor)
    --     DuplicateCommon.RecoverHPMP(memberActor)
    -- end
    -- --组队进入
    -- local size = #members
    -- --寻找是否有可进入的副本，如果没有创建副本
    -- local mapId = DuplicateCommon.FindEnterableDupCommon(configId, size)
    -- local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    -- if mapId == 0 then
    --     mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, true)
    -- end
    -- enterduplicate(actor, mapId, x, y, memberActors)
end

-- @description 进入副本扣除次数和道具
-- @param
-- @return
function BloodyCastle.RemoveItemBeforeEnter(actor, configId)
    local itemString = ConfigDataManager.getTableValue("cfg_rep", "itemId", "id", configId)
    local itemTable = string.toIntIntMap(itemString, "#", "|")
    local otherItemString = ConfigDataManager.getTableValue("cfg_rep", "otherItemId", "id", configId)
    local otherItemTable = string.toIntIntMap(otherItemString, "#", "|")
    local isMeet = true
    local deleteType = 0
    for itemId, count in pairs(itemTable) do
        itemId = tonumber(itemId)
        count = tonumber(count)
        local ownCount = getbagitemcountbyid(actor, itemId)
        if ownCount < count then
            isMeet = false
            break
        end
    end

    ---有其他通用消耗也能进入副本
    if not isMeet then
        if not string.isNullOrEmpty(otherItemString) then
            for itemId, count in pairs(otherItemTable) do
                itemId = tonumber(itemId)
                count = tonumber(count)
                local ownCount = getbagitemcountbyid(actor, itemId)
                ---也不够就返回
                if ownCount < count then
                    return false
                end
            end
            deleteType = 1
        else
            return false
        end
    end

    if deleteType == 0 then
        for key, value in pairs(itemTable) do
            removeitemfrombag(actor, key, value, 0, 9999, '血色城堡')
        end
    else
        for key, value in pairs(otherItemTable) do
            removeitemfrombag(actor, key, value, 0, 9999, '血色城堡')
        end
    end


    -- 扣除次数
    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    reduceactivitytimes(actor, activityId)
    return true
end

-- @description 玩家传送进副本
-- @param  玩家对象；地图id；x坐标；y坐标；cfg_rep的id
-- @return
function BloodyCastle.PlayerEnterBloodyCastle(actor, mapId, x, y, configId)
    local r = BloodyCastle.RemoveItemBeforeEnter(actor, configId)
    if r then
        enterduplicate(actor, mapId, x, y)
    end
end

-- @description 玩家进入副本后
-- @param 玩家对象；地图id；副本阶段；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function BloodyCastle.AfterPlayerBloodyCaster(actor, mapId, state, nextStateStartTime, configId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    local playerDupInfo = getplaydef(actor, BloodyCastlePlayerConst.BLOODY_CASTLE_MAP_INFO)
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
        setplaydef(actor, BloodyCastlePlayerConst.BLOODY_CASTLE_MAP_INFO, playerDupInfo)
        setplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_COUNT, 0)
        setplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_EXP, 0)
        setplaydef(actor, BloodyCastlePlayerConst.ARCHANGEL_SWORD_ID, 0)
    end

    local maxCount = ConfigDataManager.getTableValue("cfg_rep", "warNumMax", "id", configId)

    if state == DuplicateState.PREPARE then
        -- 如果是准备阶段，判断人满立即开启
        local playerCount = #players
        if playerCount >= tonumber(maxCount) then
            setduplicatestate(mapId, SetDuplicateStateConst.TO_FIGHT)
            return
        else
            -- 阶段信息
            BloodyCastle.ResCurrencyStateInfo(actor, mapId)
        end
    elseif state == DuplicateState.FIGHT then
        BloodyCastle.ResCurrencyStateInfo(actor, mapId)
        -- 战斗阶段任务信息
        BloodyCastle.ResTaskPhaseUpdate(actor, mapId)
        -- 大天使武器视野包
        BloodyCastle.ResSwordRoundMsg(actor)
    end
end

function BloodyCastle.DupSecondHeart(mapId, dupConfig, state)
    if state == DuplicateState.FIGHT then
        BloodyCastle.ResAllTaskPhaseUpdate(mapId)
    end
end

function BloodyCastle.playerDie(actor)
    -- quitduplicate(actor)
end

-- @description 玩家进入任意地图事件
-- @param 玩家对象；上一个地图配置id；当前地图配置id
-- @return
function BloodyCastle.EnterAllMapDS(actor, lastMapCfgId, mapCfgId)
    -- 判断发送副本结算
    local dupInfo = getplaydef(actor, BloodyCastlePlayerConst.BLOODY_CASTLE_MAP_INFO)
    if dupInfo == nil or dupInfo == "" then
        return
    end
    local bloodyId = dupInfo[1]
    local mapId = getbaseinfo(actor, "unimapid")
    local mapInfo = getmapinfobyid(mapId)
    local isDup = mapInfo["isdup"]
    if isDup == true and bloodyId ~= mapId then
        BloodyCastle.ClearPlayerDef(actor)
        return
    end
    if bloodyId ~= mapId then
        -- 结算
        BloodyCastle.PlayerSettleMent(actor)
    end
end

--  击杀怪物
function BloodyCastle.KillMonterInBloodyCastle(actor)
    -- 玩家击杀数量
    local killCount = getplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_COUNT)
    if killCount == nil or killCount <= 0 then
        killCount = 0
    end
    killCount = killCount + 1
    setplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_COUNT, killCount)
end

function BloodyCastle.AddExp(actor, mapId, exp)
    -- 玩家杀怪经验
    local killExp = getplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_EXP)
    if killExp == nil or killExp <= 0 then
        killExp = 0
    end
    killExp = killExp + exp
    setplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_EXP, killExp)
end

--血色城堡阶段更新
function BloodyCastle.BloodyCastleStateUpdate(system, mapId, state, nextStateStartTime, configId)
    if state == DuplicateState.PREPARE then
        -- 初始化副本数据，初始化第一个任务
        BloodyCastle.InitBloodyCastle(mapId, configId)
    elseif state == DuplicateState.FIGHT then
        --战斗阶段
        local monsterId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", configId)
        DuplicateCommon.DupGenMonsterCommon(mapId, monsterId) --刷怪
        -- 一阶段刷新城门怪
        local dupLevel = ConfigDataManager.getTableValue("cfg_rep", "repLevel", "id", configId)
        dupLevel = tonumber(dupLevel)
        local configStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.BLOODY_CASTLE_GATE_MONSTER)
        local configList = string.split(configStr, "|")
        for index, value in ipairs(configList) do
            local valueList = string.split(value, "#")
            local levelCfg = tonumber(valueList[1])
            local monCfgId = valueList[2]
            local x = valueList[3]
            local y = valueList[4]
            if dupLevel == levelCfg then
                local gateMons = mongen(mapId, x, y, 0, monCfgId, 1)
                local gateMon = gateMons[1]
                setmapobjectdir(gateMon, -1)
            end
        end

        BloodyCastle.ResAllPlayCurrencyStateInfo(mapId) --阶段信息
        BloodyCastle.ResAllTaskPhaseUpdate(mapId)       -- 任务信息
    end
end

-- @description 初始化副本数据
-- @param 副本地图id；cfg_rep的id
-- @return
function BloodyCastle.InitBloodyCastle(mapId, configId)
    --当前任务信息
    local taskId = ConfigDataManager.getTableValue("cfg_rep", "repTarget", "id", configId)
    local taskInfo = DuplicateCommon.GenDupTaskInfoCommon(taskId)
    table.insert(taskInfo, 1, BloodyCastleTaskPhase.ONE)
    setenvirvar(mapId, DuplicateVarConst.BLOODY_CASTLE_TASK_INFO, taskInfo)
end

-- @description 完成当前任务
-- @param 地图id；任务id
-- @return
function BloodyCastle.FinishTaskBloodyCastle(mapId, taskId, actor)
    -- 更新任务，掉落任务奖励
    --奖励
    local reward = ConfigDataManager.getTableValue("cfg_repTask", "reward", "id", taskId)
    if reward ~= nil and reward ~= "" then
        local split = string.split(reward, "|")
        -- 权重算法
        local index = -1
        local weights = {}
        local sum = 0
        for i, value in ipairs(split) do
            local valueSplit = string.split(value, "#")
            local weight = tonumber(valueSplit[3])
            weights[i] = weight
            sum = sum + weight
        end
        local randomNum = math.random(sum)
        for k, v in pairs(weights) do
            if randomNum <= v then
                index = k
                break
            else
                randomNum = randomNum - v
            end
        end

        if index > 0 and index <= #split then
            local itemData = split[index]
            local itemDataTable = string.split(itemData, "#")
            local itemId = tonumber(itemDataTable[1])
            local count = tonumber(itemDataTable[2])
            local x = getbaseinfo(actor, "x")
            local y = getbaseinfo(actor, "y")
            throwitem(actor, mapId, x, y, 1, itemId, count, 10000000, 3, 0)
        end
    end
    -- 更新任务和阶段
    BloodyCastle.UpdateNextTaskPhaseBloodyCastle(mapId, taskId, actor)
end

function BloodyCastle.UpdateNextTaskPhaseBloodyCastle(mapId, taskId, actor)
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.BLOODY_CASTLE_TASK_INFO)
    local nextTask = ConfigDataManager.getTableValue("cfg_repTask", "nextID", "id", taskId)
    if nextTask == nil or nextTask == "" then
        return
    end
    local dupInfo = getduplicate(mapId)
    local dupConfig = dupInfo["dupcfgid"]
    local dupLevel = ConfigDataManager.getTableValue("cfg_rep", "repLevel", "id", dupConfig)
    dupLevel = tonumber(dupLevel)
    local nowPhase = taskInfo[1]
    local nextPhase = nowPhase + 1
    if nextPhase == BloodyCastleTaskPhase.TWO then
        --阶段二
    elseif nextPhase == BloodyCastleTaskPhase.FOUR then
        --阶段四，刷新水晶灵柩怪
        local configStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.BLOODY_CASTLE_CRYSTAL_MONSTER)
        local configList = string.split(configStr, "|")
        for index, value in ipairs(configList) do
            local valueList = string.split(value, "#")
            local levelCfg = tonumber(valueList[1])
            local monCfgId = valueList[2]
            local x = valueList[3]
            local y = valueList[4]
            if dupLevel == levelCfg then
                mongen(mapId, x, y, 0, monCfgId, 1)
            end
        end
    elseif nextPhase == BloodyCastleTaskPhase.FIVE then
        -- 阶段五，大天使武器给击杀者
        local taskConfig = ConfigDataManager.getTableValue("cfg_repTask", "param", "id", nextTask)
        local taskSplit = string.split(taskConfig, "#")
        local swordId = tonumber(taskSplit[1])
        setplaydef(actor, BloodyCastlePlayerConst.ARCHANGEL_SWORD_ID, swordId)
        -- 视野包
        BloodyCastle.ResSwordRoundMsg(actor)
    end
    --  设置下一个任务
    local nextTaskInfo = DuplicateCommon.GenDupTaskInfoCommon(nextTask)
    table.insert(nextTaskInfo, 1, nextPhase)
    setenvirvar(mapId, DuplicateVarConst.BLOODY_CASTLE_TASK_INFO, nextTaskInfo)
end

-- @description 血色城堡中怪物死亡
-- @param 副本地图id；怪物击杀者；怪物的配置id
-- @return
function BloodyCastle.BloodyCastleOnMonsterDie(mapId, killer, monCfgId)
    BloodyCastle.KillMonterInBloodyCastle(killer)
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.BLOODY_CASTLE_TASK_INFO)
    local taskId = taskInfo[2]
    local taskType = taskInfo[3]
    if taskType == DuplicateTaskType.KILL_MONSTER_COUNT then
        local totalCount = taskInfo[4]
        local oldCount = taskInfo[5]
        local newCount = oldCount + 1
        if newCount >= totalCount then
            -- 完成任务，给客户端回包
            BloodyCastle.FinishTaskBloodyCastle(mapId, taskId, killer)
        else
            -- 更新记录，给客户端回包
            taskInfo[5] = newCount
            setenvirvar(mapId, DuplicateVarConst.BLOODY_CASTLE_TASK_INFO, taskInfo)
        end
    elseif taskType == DuplicateTaskType.KILL_TARGET_MONSTER then
        local targetMon = taskInfo[6]
        local totalCount = taskInfo[4]
        local oldCount = taskInfo[5]
        if tonumber(monCfgId) ~= targetMon then
            return
        end
        local newCount = oldCount + 1
        if newCount >= totalCount then
            -- 完成任务，给客户端回包
            BloodyCastle.FinishTaskBloodyCastle(mapId, taskId, killer)
        else
            -- 更新记录，给客户端回包
            taskInfo[5] = newCount
            setenvirvar(mapId, DuplicateVarConst.BLOODY_CASTLE_TASK_INFO, taskInfo)
        end
    end
    -- BloodyCastle.ResAllTaskPhaseUpdate(mapId) -- 任务信息
end

-- @description 响应给客户端当前阶段
-- @param 玩家对象；地图id
-- @return
function BloodyCastle.ResCurrencyStateInfo(actor, mapId)
    local dupInfo = getduplicate(mapId)
    local state = dupInfo["state"]
    local configId = dupInfo["dupcfgid"]
    local nextStateStartTime = dupInfo["nextstatetime"]
    sendluamsg(actor, LuaMessageIdToClient.RES_BLOODY_CASTLE_STATE_UPDATE,
        { state, tostring(nextStateStartTime), configId })
end

-- @description 通知地图所有玩家更新当前阶段
-- @param 地图id
-- @return
function BloodyCastle.ResAllPlayCurrencyStateInfo(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        BloodyCastle.ResCurrencyStateInfo(actor, mapId)
    end
end

-- @description 任务阶段更新响应
-- @param 玩家对象；地图唯一id
-- @return
function BloodyCastle.ResTaskPhaseUpdate(actor, mapId)
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.BLOODY_CASTLE_TASK_INFO)
    local nowPhase = taskInfo[1]
    local taskId = taskInfo[2]
    local totalCount = taskInfo[4]
    local nowCount = taskInfo[5]
    local response = {}
    response["phase"] = nowPhase
    response["taskId"] = taskId
    response["nowCount"] = nowCount
    response["totalCount"] = totalCount
    -- 协议
    sendluamsg(actor, LuaMessageIdToClient.RES_BLOODY_CASTLE_TASK_UPDATE, response)
end

-- @description 通知地图玩家任务阶段更新响应
-- @param 玩家对象；地图唯一id
-- @return
function BloodyCastle.ResAllTaskPhaseUpdate(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        BloodyCastle.ResTaskPhaseUpdate(actor, mapId)
    end
end

-- @description 大天使宝剑视野包发给周围玩家
-- @param 地图id；玩家id
-- @return
function BloodyCastle.ResSwordRoundMsg(actor)
    local itemId = getplaydef(actor, BloodyCastlePlayerConst.ARCHANGEL_SWORD_ID)
    if itemId == nil or itemId == "" or itemId <= 0 then
        return
    end
    local rid = getbaseinfo(actor, "rid")
    -- 协议待定
    sendrefluamsg(actor, LuaMessageIdToClient.BLOODY_CASTLE_SWORD_VIEW, { tostring(rid), tostring(itemId) })
end

-- @description 玩家进入视野
-- @param 玩家对象；进入视野的玩家对象
-- @return
function BloodyCastle.PlayerEnterView(actor, target, mapId)
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.BLOODY_CASTLE_TASK_INFO)
    if taskInfo == nil then
        return
    end
    local nowPhase = taskInfo[1]
    if nowPhase ~= BloodyCastleTaskPhase.FIVE then
        return
    end
    local itemId = getplaydef(target, BloodyCastlePlayerConst.ARCHANGEL_SWORD_ID)
    if itemId == nil or itemId == "" or itemId == 0 then
        return
    end
    --携带大天使武器的视野包
    -- 协议待定
    local rid = getbaseinfo(target, "rid")
    sendluamsg(actor, LuaMessageIdToClient.BLOODY_CASTLE_SWORD_VIEW, { tostring(rid), tostring(itemId) })
end

-- @description 玩家请求，大天使武器给npc
-- @param 玩家对象
-- @return
function BloodyCastle.ReqGive2NPC(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    local taskInfo = getenvirvar(mapId, DuplicateVarConst.BLOODY_CASTLE_TASK_INFO)
    local nowPhase = taskInfo[1]
    local count = taskInfo[5]
    if nowPhase ~= BloodyCastleTaskPhase.FIVE or count >= 1 then
        return
    end
    local itemId = getplaydef(actor, BloodyCastlePlayerConst.ARCHANGEL_SWORD_ID)
    if itemId == nil or itemId <= 0 then
        return
    end
    -- 副本结束d
    local taskId = taskInfo[2]
    taskInfo[5] = 1
    setenvirvar(mapId, DuplicateVarConst.BLOODY_CASTLE_TASK_INFO, taskInfo)
    -- 清掉玩家武器变量
    setplaydef(actor, BloodyCastlePlayerConst.ARCHANGEL_SWORD_ID, 0)
    BloodyCastle.FinishTaskBloodyCastle(mapId, taskId, actor)
    BloodyCastle.ResAllTaskPhaseUpdate(mapId) -- 任务信息
end

-- @description 清除玩家在副本中的变量
-- @param 玩家对象
-- @return
function BloodyCastle.ClearPlayerDef(actor)
    setplaydef(actor, BloodyCastlePlayerConst.BLOODY_CASTLE_MAP_INFO, "")
    setplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_COUNT, 0)
    setplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_EXP, 0)
    setplaydef(actor, BloodyCastlePlayerConst.ARCHANGEL_SWORD_ID, 0)
end

-- @description 玩家副本结算
-- @param 玩家对象；
-- @return
function BloodyCastle.PlayerSettleMent(actor)
    -- 击杀怪物
    local killCount = getplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_COUNT)
    -- 获得经验
    local killExp = getplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_EXP)
    local playerDupInfo = getplaydef(actor, BloodyCastlePlayerConst.BLOODY_CASTLE_MAP_INFO)
    local configId = playerDupInfo[2]
    -- 活动剩余次数
    local leftCount = getleftcountofactivity(actor, DuplicateType.BLOODY_CASTLE)
    -- 发回给客户端
    local response = {}
    response["configId"] = configId   --配置表id
    response["kill"] = killCount      --击杀怪物
    response["exp"] = killExp         --活动经验
    response["leftCount"] = leftCount --剩余次数
    sendluamsg(actor, LuaMessageIdToClient.RES_BLOODY_CASTLE_SETTLEMENT, response)
end

-- @description 客户端请求领取奖励
-- @param 玩家对象；领取倍数
-- @return
function BloodyCastle.ReqReciveReward(actor, multipleCount)
    multipleCount = tonumber(multipleCount)
    local dupInfo = getplaydef(actor, BloodyCastlePlayerConst.BLOODY_CASTLE_MAP_INFO)
    if dupInfo == nil or dupInfo == "" then
        return
    end
    -- 经验
    local killExp = getplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_EXP)
    local killCount = getplaydef(actor, BloodyCastlePlayerConst.KILL_MONSTER_COUNT)
    local configId = dupInfo[2]
    -- 副本进度任务刷新
    DuplicateCommon.FinishDupActivity(actor, configId)
    if multipleCount <= 1 then
        -- 清空角色副本信息
        BloodyCastle.ClearPlayerDef(actor)
        return
    end

    local cfgString = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.BLOODY_CASTLE_MULTIPLE_REWARD)
    local cfgList = string.split(cfgString, "|")
    for index, value in ipairs(cfgList) do
        local valueList = string.split(value, "#")
        if multipleCount == tonumber(valueList[1]) then
            local costItemId = tonumber(valueList[2])
            local costItemCount = tonumber(valueList[3])
            local costActivityCount = tonumber(valueList[4])
            local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
            local leftCount = getleftcountofactivity(actor, activityId)
            if leftCount < costActivityCount then
                --tipinfo(actor, "次数不足")
                return
            end

            local ownCount = getbagitemcountbyid(actor, costItemId)
            if ownCount < costItemCount then
                --tipinfo(actor, "扣除道具不足")
                return
            end
            -- 扣除次数和道具
            reduceactivitytimes(actor, activityId, costActivityCount)
            removeitemfrombag(actor, costItemId, costItemCount, 0, 9999, '血色城堡')
            -- 发放奖励
            local totalExp = killExp * (multipleCount - 1)
            additemtobag(actor, ItemConfigId.EXP, totalExp, 0, 9999, ItemActionProxy.BLOOD_CASTLE)
            -- 清空角色副本信息
            BloodyCastle.ClearPlayerDef(actor)
        end
    end
end
