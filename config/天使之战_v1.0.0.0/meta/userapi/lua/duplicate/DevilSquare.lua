--恶魔广场副本
DevilSquare = {}

DevilSquare.EXPSCORE_DIV = 5
-- @description 客户端请求面板数据
-- @param 玩家对象；请求参数
-- @return
function DevilSquare.ReqGetPanelInfo(actor, msgData)
    local configId = tonumber(msgData)
    if configId == nil or configId <= 0 then
        error("DevilSquare.ReqGetPanelInfo param is wrong", msgData)
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
    sendluamsg(actor, LuaMessageIdToClient.RES_DEVIL_SQUARE_PANEL, resInfo)
end

function DevilSquare.doTeamEnter(actor, enterMembers, configId)
    local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    local mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, false)
    for _, memberActor in pairs(enterMembers) do
        -- 回蓝回血
        DuplicateCommon.RecoverHPMP(memberActor)
        -- 进入地图
        DevilSquare.PlayerEnterDevilSquare(memberActor, mapId, x, y, configId)
    end
end

-- @description 请求进入恶魔广场
-- @param 玩家对象；cfg_rep的id
-- @return
function DevilSquare.ReqEnterDevilSquare(actor, configId)
    if DuplicateCommon.CheckEnterConditonCommon(actor, configId) ~= EnterLimitResultConst.ALLOW then
        return
    end
    callonserial(actor, "enter_devil_square_on_serial", configId)
    -- --寻找是否有可进入的副本，如果没有创建副本
    -- local mapId = DuplicateCommon.FindEnterableDupCommon(configId, 1)
    -- local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    -- if mapId == 0 then
    --     if DevilSquare.isMaxDupNums(configId) then
    --         noticeTip.noticeinfo(actor, StringIdConst.TEXT45001)
    --         return
    --     end
    --     mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, true)
    -- end
    -- --回蓝回血
    -- DuplicateCommon.RecoverHPMP(actor)
    -- DevilSquare.PlayerEnterDevilSquare(actor, mapId, x, y, configId)
end

function DevilSquare.enterDup(actor, configId)
    if DuplicateCommon.CheckEnterConditonCommon(actor, configId) ~= EnterLimitResultConst.ALLOW then
        return
    end

    --寻找是否有可进入的副本，如果没有创建副本
    local mapId = DuplicateCommon.FindEnterableDupCommon(configId, 1)
    local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    if mapId == 0 then
        if DevilSquare.isMaxDupNums(configId) then
            noticeTip.noticeinfo(actor, StringIdConst.TEXT45001)
            return
        end
        mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, true)
    end
    --回蓝回血
    DuplicateCommon.RecoverHPMP(actor)
    DevilSquare.PlayerEnterDevilSquare(actor, mapId, x, y, configId)
end


function enter_devil_square_on_serial(actor, configId)
    DevilSquare.enterDup(actor, configId)
end

function DevilSquare.isMaxDupNums(configId)
    local nowNums = DuplicateCommon.getCurrentDupNumById(configId)
    local limitNums = tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", 520001))
    return nowNums >= limitNums
end

-- @description 组队进入副本
-- @param 玩家对象；队伍id；副本配置
-- @return
function DevilSquare.DoTeamEnter(actor, teamId, configId)
    -- local teamInfo = getteaminfo(actor, teamId)
    -- local members = teamInfo["allteammemberinfo"]
    -- for index, memberInfo in ipairs(members) do
    --     local memberId = memberInfo["rid"]
    --     local memberActor = getactor(actor, memberId)
    --     local check = DuplicateCommon.CheckEnterConditonCommon(memberActor, configId)
    --     if check ~= EnterLimitResultConst.ALLOW then
    --         error("组队进入成员条件不满足" .. memberId)
    --         return
    --     end
    -- end
    -- local memberActors = {}
    -- --扣除次数；扣除道具
    -- for index, memberInfo in ipairs(members) do
    --     local memberId = memberInfo["rid"]
    --     local memberActor = getactor(actor, memberId)
    --     --DevilSquare.RemoveItemBeforeEnter(memberActor, configId)
    --     DuplicateCommon.RemoveItemBeforeEnter(actor, configId, "恶魔广场")
    --     table.insert(memberActors, memberActor)
    --     --回蓝回血
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
function DevilSquare.RemoveItemBeforeEnter(actor, configId)
    -- 扣除道具
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
            removeitemfrombag(actor, key, value, 0, 9999, '恶魔广场')
        end
    else
        for key, value in pairs(otherItemTable) do
            removeitemfrombag(actor, key, value, 0, 9999, '恶魔广场')
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
function DevilSquare.PlayerEnterDevilSquare(actor, mapId, x, y, configId)
    -- local isMeet = DuplicateCommon.RemoveItemBeforeEnter(actor, configId, "恶魔广场")
    -- if isMeet then
    --     enterduplicate(actor, mapId, x, y)
    -- end

    local r = DevilSquare.RemoveItemBeforeEnter(actor, configId)
    if r then
        enterduplicate(actor, mapId, x, y)
    end
end

--恶魔广场阶段更新
function DevilSquare.DevilSquareStateUpdate(system, mapId, state, nextStateStartTime, configId)
    if state == DuplicateState.PREPARE then
        -- 初始化副本数据
        DevilSquare.InitDupDataDevilSquare(mapId, configId)
    elseif state == DuplicateState.FIGHT then
        --战斗阶段，进入下一波次
        -- 刷怪初始配置
        local monsterId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", configId)
        DevilSquare.OpenNextWave(mapId, monsterId)
        DevilSquare.ResAllPlayCurrencyStateInfo(mapId)
        DevilSquare.ResAllPlayDupTaskUpdate(mapId)
    elseif state == DuplicateState.FINISH then
        clearmapmon(mapId)
        local dupInfo = getduplicate(mapId)
        local players = dupInfo["players"]
        for index, actor in ipairs(players) do
              quitduplicate(actor)
        end
        -- DevilSquare.ResAllPlayDupTaskUpdate(mapId)
        -- DevilSquare.ResAllPlayCurrencyStateInfo(mapId)
    end
end

-- 秒钟心跳
function DevilSquare.DupSecondHeart(mapId, dupConfig, state)
    if state == DuplicateState.FIGHT then
        local nowSec = getbaseinfo("nowsec")
        local clearTime = getenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_NEXT_STATE_TIME)
        if nowSec >= clearTime then
            DevilSquare.OpenNextWave(mapId)
        end
        DevilSquare.ResAllPlayDupTaskUpdate(mapId)
    end
end

-- 进入下一波次
function DevilSquare.OpenNextWave(mapId, firstGenMonId)
    local nowSec = getbaseinfo("nowsec")

    local nextConfigId
    if firstGenMonId then
        nextConfigId = firstGenMonId
    else
        local currentGenMonsterId = getenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_MONSTER_GEN_CONFIG)
        local currentConfig = ConfigDataManager.getById("cfg_repMonster", currentGenMonsterId)
        nextConfigId = currentConfig.nextid
        -- 检查是否存在下一波怪物配置
        if currentConfig.nextid == "" or string.tonumber(currentConfig.nextid) == 0 then
            -- 已经是最后一波，转换到结束状态
            setduplicatestate(mapId, SetDuplicateStateConst.TO_FINISH)
            return
        end
    end


    local nextConfig = ConfigDataManager.getById("cfg_repMonster", nextConfigId)
    if nextConfig == nil then
        -- 下一波配置不存在，转换到结束状态
        setduplicatestate(mapId, SetDuplicateStateConst.TO_FINISH)
        return
    end

    -- 清除当前地图上的所有怪物
    clearmapmon(mapId)

    -- 生成下一波怪物
    DuplicateCommon.DupGenMonsterCommon(mapId, nextConfig.id)

    -- 设置下一波次切换时间
    local clearTime = nowSec + tonumber(nextConfig.cleartime)
    setenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_NEXT_STATE_TIME, clearTime)

    -- 更新波次计数
    local currentWave = getenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_STATE)
    setenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_STATE, currentWave + 1)

    -- 记录当前使用的怪物生成配置
    setenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_MONSTER_GEN_CONFIG, nextConfigId)

    -- 通知地图内所有玩家更新任务信息
    DevilSquare.ResAllPlayDupTaskUpdate(mapId)
end

-- @description 玩家进入副本后
-- @param 玩家对象；地图id；副本阶段；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function DevilSquare.AfterPlayerEnterDevilSquare(actor, mapId, state, nextStateStartTime, configId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    local playerDupInfo = getplaydef(actor, DevilSquarePlayerConst.DEVIL_SQUARE_MAP_INFO)
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
        setplaydef(actor, DevilSquarePlayerConst.DEVIL_SQUARE_MAP_INFO, playerDupInfo)
        setplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_COUNT, 0)
        setplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_EXP, 0)
    end

    local maxCount = ConfigDataManager.getTableValue("cfg_rep", "warNumMax", "id", configId)

    -- 如果是准备阶段，判断人满立即开启
    if state == DuplicateState.PREPARE then
        local playerCount = #players
        if playerCount >= tonumber(maxCount) then
            setduplicatestate(mapId, SetDuplicateStateConst.TO_FIGHT)
            return
        else
            --阶段信息
            DevilSquare.ResCurrencyStateInfo(actor, mapId)
        end
    elseif state == DuplicateState.FIGHT then
        --阶段信息
        DevilSquare.ResCurrencyStateInfo(actor, mapId)
        DevilSquare.ResDupTaskUpdate(actor, mapId)
    end
end


function DevilSquare.playerDie(actor)
--    quitduplicate(actor)
end



-- @description 初始化副本数据
-- @param 副本地图唯一id
-- @return
function DevilSquare.InitDupDataDevilSquare(mapId,configId)
    --当前波次怪物击杀数量
    setenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_STATE_KILL_COUNT, 0)
    --波次
    setenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_STATE, 0)
end

-- @description 刷怪
-- @param 地图唯一id；刷怪表id
-- @return
function DevilSquare.GenMonsterDevilSquare(mapId, genMonCfgId)
    --战斗阶段才可以刷怪
    local dupInfo = getduplicate(mapId)
    if dupInfo["state"] ~= DuplicateState.FIGHT then
        return
    end
    DuplicateCommon.DupGenMonsterCommon(mapId, genMonCfgId)
end

function DevilSquare.IncreaseKillCount(actor, mapId)
    local playerDupInfo = getplaydef(actor, DevilSquarePlayerConst.DEVIL_SQUARE_MAP_INFO)
    if not playerDupInfo or playerDupInfo == "" then
        return
    end
    local killCount = getplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_COUNT)
    if killCount == nil or killCount <= 0 then
        killCount = 0
    end
    killCount = killCount + 1
    setplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_COUNT, killCount)
end
-- @description 击杀怪物
-- @param 归属者;默认掉落经验；怪物配置id
-- @return 经验值
function DevilSquare.KillMonterInDevilSquare(actor, mapId, monCfgId)
    local dupInfo = getduplicate(mapId)
    if dupInfo["state"] == DuplicateState.FIGHT and actor:toString() ~= "0" then
        -- 当前波次击杀的怪物
        local oldCount = getenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_STATE_KILL_COUNT)
        local newCount = oldCount + 1
        local genMonCfgId = getenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_MONSTER_GEN_CONFIG)
        local totalCount = ConfigDataManager.getTableValue("cfg_repMonster", "kill", "id", genMonCfgId)
        totalCount = string.tonumber(totalCount)
        if totalCount > 0 then
            if newCount >= totalCount then
                newCount = 0
                DevilSquare.OpenNextWave(mapId)
            end
            setenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_STATE_KILL_COUNT, newCount)
        end
        -- local teamMembers = Team.GetAllMemberRids(actor)
        -- if teamMembers == nil or #teamMembers <= 0 then
        --     -- 玩家击杀数量
        --     DevilSquare.IncreaseKillCount(actor, mapId)
        -- else
        --     info("玩家击杀数量 in ", mapId, " ", #teamMembers)
        --     for _, memberRid in ipairs(teamMembers) do
        --         local memberActor = getactor(actor, memberRid)
        --         DevilSquare.IncreaseKillCount(memberActor, mapId)
        --     end
        -- end
    end
end

function DevilSquare.OnGetExp(actor, mapId, originExp)
    return math.floor(originExp / DevilSquare.EXPSCORE_DIV)
end

function DevilSquare.AddExp(actor, mapId, exp)
    -- 玩家杀怪经验
    local killExp = getplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_EXP)
    if killExp == nil or killExp <= 0 then
        killExp = 0
    end
    killExp = killExp + exp
    setplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_EXP, killExp)
    --处理组队经验
    -- local teamMembers = Team.GetAllMemberRids(actor)
    -- if teamMembers == nil or #teamMembers <= 0 then
    --     -- 玩家杀怪经验
    --     local killExp = getplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_EXP)
    --     if killExp == nil or killExp <= 0 then
    --         killExp = 0
    --     end
    --     killExp = killExp + exp
    --     setplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_EXP, killExp)
    --     return
    -- end
    -- local addExp = exp / #teamMembers
    -- for _, member in ipairs(teamMembers) do
    --     local memberActor = getactor(actor, member)
    --     local memberExp = getplaydef(memberActor, DevilSquarePlayerConst.KILL_MONSTER_EXP)
    --     if memberExp == nil or memberExp <= 0 then
    --         memberExp = 0
    --     end
    --     memberExp = memberExp + addExp
    --     setplaydef(memberActor, DevilSquarePlayerConst.KILL_MONSTER_EXP, memberExp)
    -- end
end

-- @description 玩家副本结算
-- @param 玩家对象；
-- @return
function DevilSquare.PlayerSettleMentDevilSquare(actor)
    -- 击杀怪物
    local killCount = getplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_COUNT)
    -- 获得经验
    local killExp = getplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_EXP)
    local playerDupInfo = getplaydef(actor, DevilSquarePlayerConst.DEVIL_SQUARE_MAP_INFO)
    local configId = playerDupInfo[2]
    local score, scoreExp = DevilSquare.CalcuScoreAndExp(configId)
    local totalScoreExp = math.floor(killCount / DevilSquare.EXPSCORE_DIV * score ) * scoreExp
    -- 经验加成
    -- totalScoreExp = Player.calculExpByAddRate(actor, totalScoreExp)
    -- 这里发放积分经验
    additemtobag(actor, ItemConfigId.EXP, totalScoreExp, 0, 9999, ItemActionProxy.DEMON_SQUARE)
    -- 活动剩余次数
    local leftCount = getleftcountofactivity(actor, DuplicateType.DEVIL_SQUARE)
    -- 发回给客户端
    local response = {}
    response["configId"] = configId      --配置表id
    response["kill"] = killCount         --击杀怪物数量
    response["killExp"] = killExp        --击杀怪物掉落的经验
    response["scoreExp"] = totalScoreExp --积分经验
    response["leftCount"] = leftCount    --剩余次数
    info("[DevilSquare] 玩家结算积分经验", totalScoreExp)
    sendluamsg(actor, LuaMessageIdToClient.RES_DEVIL_SQUARE_SETTLEMENT, response)
end

-- @description 计算配置的积分及积分经验
-- @param cfg_rep的id
-- @return 积分，积分经验
function DevilSquare.CalcuScoreAndExp(configId)
    local repLevel = ConfigDataManager.getTableValue("cfg_rep", "repLevel", "id", configId)
    repLevel = tonumber(repLevel)
    local configStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.DEVIL_SQUARE_SCORE_EXP)
    local configList = string.split(configStr, "|")
    local score
    local scoreExp
    for index, value in ipairs(configList) do
        local valueList = string.split(value, "#")
        local configLevel = tonumber(valueList[1])
        if repLevel == configLevel then
            score = tonumber(valueList[2])
            scoreExp = tonumber(valueList[3])
            return score, scoreExp
        end
    end
    return 0, 0
end

-- @description 玩家进入任意地图事件
-- @param 玩家对象；上一个地图配置id；当前地图配置id
-- @return
function DevilSquare.EnterAllMapDS(actor, lastMapCfgId, mapCfgId)
    -- 判断发送副本结算
    local dupInfo = getplaydef(actor, DevilSquarePlayerConst.DEVIL_SQUARE_MAP_INFO)
    if dupInfo == nil or dupInfo == "" then
        return
    end
    local devilSquareId = dupInfo[1]
    local mapId = getbaseinfo(actor, "unimapid")
    local mapInfo = getmapinfobyid(mapId)
    local isDup = mapInfo["isdup"]
    if isDup == true and devilSquareId ~= mapId then
        error("恶魔广场有未结算的奖励")
        DevilSquare.ClearPlayerDevilSquareDef(actor)
        return
    end
    if devilSquareId ~= mapId then
        -- 结算
        DevilSquare.PlayerSettleMentDevilSquare(actor)
    end
end

-- @description 客户端请求领取奖励
-- @param 玩家对象；领取倍数
-- @return
function DevilSquare.ReqReciveRewardDevilSquare(actor, multipleCount)
    multipleCount = tonumber(multipleCount)
    local dupInfo = getplaydef(actor, DevilSquarePlayerConst.DEVIL_SQUARE_MAP_INFO)
    if dupInfo == nil or dupInfo == "" then
        return
    end
    -- 经验
    local killExp = getplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_EXP)
    local killCount = getplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_COUNT)
    local configId = dupInfo[2]
    local score, scoreExp = DevilSquare.CalcuScoreAndExp(configId)
    local totalScoreExp = math.floor(killCount / DevilSquare.EXPSCORE_DIV * score ) * scoreExp
    -- totalScoreExp = Player.calculExpByAddRate(actor, totalScoreExp)
    -- 副本进度任务刷新
    DuplicateCommon.FinishDupActivity(actor, configId)
    if multipleCount <= 1 then
        -- 清空角色副本信息
        DevilSquare.ClearPlayerDevilSquareDef(actor)
        return
    end
    local cfgString = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.DEVIL_SQUARE_MULTIPLE_REWARD)
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
            removeitemfrombag(actor, costItemId, costItemCount, 0, 9999, '恶魔广场')
            -- 发放奖励
            local totalExp = killExp * (multipleCount - 1) + totalScoreExp * (multipleCount - 1)
            info("[DevilSquare] 玩家领取奖励", totalExp)

            additemtobag(actor, ItemConfigId.EXP, totalExp, 0, 9999, ItemActionProxy.DEMON_SQUARE)
            -- 清空角色副本信息
            DevilSquare.ClearPlayerDevilSquareDef(actor)
        end
    end
end

-- @description 清除玩家在恶魔广场副本中的变量
-- @param 玩家对象
-- @return
function DevilSquare.ClearPlayerDevilSquareDef(actor)
    setplaydef(actor, DevilSquarePlayerConst.DEVIL_SQUARE_MAP_INFO, "")
    setplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_COUNT, 0)
    setplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_EXP, 0)
end

-- @description 响应给客户端当前阶段
-- @param 玩家对象；地图id
-- @return
function DevilSquare.ResCurrencyStateInfo(actor, mapId)
    local dupInfo = getduplicate(mapId)
    local state = dupInfo["state"]
    local configId = dupInfo["dupcfgid"]
    local nextStateStartTime = dupInfo["nextstatetime"]
    sendluamsg(actor, LuaMessageIdToClient.DEVIL_SQUARE_STATE, { state, tostring(nextStateStartTime), configId })
end

-- @description 通知地图所有玩家更新当前阶段
-- @param 地图id
-- @return
function DevilSquare.ResAllPlayCurrencyStateInfo(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        DevilSquare.ResCurrencyStateInfo(actor, mapId)
    end
end

-- @description 立即开启战斗
-- @param 玩家对象；请求参数
-- @return
function DevilSquare.ChangeToFight(actor, msgData)
    local mapId = getbaseinfo(actor, "unimapid")
    setduplicatestate(mapId, SetDuplicateStateConst.TO_FIGHT)
end

-- @description 副本任务更新响应
-- @param 玩家对象；副本id
-- @return
function DevilSquare.ResDupTaskUpdate(actor, mapId)
    local dupInfo = getduplicate(mapId)
    local configId = dupInfo["dupcfgid"]

    --波次
    local wave = getenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_STATE)
    --击杀数量
    local count = getenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_STATE_KILL_COUNT)
    --任务总数量
    local genMonCfgId = getenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_MONSTER_GEN_CONFIG)
    local totalCount = ConfigDataManager.getTableValue("cfg_repMonster", "kill", "id", genMonCfgId)

    local killCount = getplaydef(actor, DevilSquarePlayerConst.KILL_MONSTER_COUNT)
    --通关奖励
    local score, scoreExp = DevilSquare.CalcuScoreAndExp(configId)
    local totalScoreExp = math.floor(killCount / DevilSquare.EXPSCORE_DIV * score ) * scoreExp
    -- totalScoreExp = Player.calculExpByAddRate(actor, totalScoreExp)
    --击杀怪物积分
    local killScore = math.floor(killCount / DevilSquare.EXPSCORE_DIV * score)

    local response = {}
    response["wave"] = wave
    response["nowCount"] = count
    response["totalCount"] = totalCount
    response["rewardCount"] = totalScoreExp
    response["score"] = killScore
    response["nextWaveTime"] = getenvirvar(mapId, DuplicateVarConst.DEVIL_SQUARE_NEXT_STATE_TIME)
    info("[DevilSquare] 玩家结算积分经验", totalScoreExp)
    sendluamsg(actor, LuaMessageIdToClient.RES_DEVIL_SQUARE_TASK, response)
end

-- @description 通知地图所有玩家更新当前任务
-- @param 副本id
-- @return
function DevilSquare.ResAllPlayDupTaskUpdate(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        DevilSquare.ResDupTaskUpdate(actor, mapId)
    end
end



function DevilSquare.isInDup(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return false
    end
    if dupInfo.type ~= DuplicateType.DEVIL_SQUARE then
        return false
    end
    return true
end
