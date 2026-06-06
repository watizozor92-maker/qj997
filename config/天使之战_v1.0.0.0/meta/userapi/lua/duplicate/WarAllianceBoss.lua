-- 战盟拍卖相关全局表id
local WarAllianceGlobalConfig = {
    REWARD_COUNT_LIMIT = 14001001,         -- 奖励拍卖战盟数量限制
    AUCTION_DIVIDEND = 14001002,           -- 分红比例
    PHRASE_AND_TRANS_POINT = 14001003,     -- 层级和传送点
    KILL_BOSS_REWARD_EXP_CFGID = 14001004, -- 击杀boss获得的战盟经验奖励
}

local WarAllianceTaskPhrase = {
    ONE = 1, FIVE = 5,
}
-- 战盟副本数据
 local WarAllianceConst = {
    KILL_MONSTER_COUNT = 2,                                     -- 任务类型 杀指定怪
    WAR_ALLIANCE_DUP_HORSE_LAMP = 66,                           -- 战盟boss被击杀跑马灯id
    WAR_ALLIANCE_DUP_CHAT = 75,                                 -- 战盟boss被击杀世界频道
    WAR_ALLIANCE_TYPE = 14001,                                  -- 战盟boss任务活动类型

    WAR_ALLIANCE_DUP_TASK_INFO = "G$AllianceDupTaskInfo",       -- 战盟副本任务信息
    WAR_ALLIANCE_DUP_BELONGS = "G$AllianceDupBelongs",          -- 战盟地图归属
    WAR_ALLIANCE_DUP_TRANS_POINT = "G$AllianceDupTransPoint",   -- 传送点信息
    WAR_ALLIANCE_PLAYER = "G$InvolovedPlayers",                 -- 进入过副本的玩家
    WAR_ALLIANCE_MONSTER_STATE = "G$MonsterState",              -- 怪物状态

    WAR_ALLIANCE_CURR_MAX_LEVEL = "G$AllianceMaxLevel",         -- 战盟共享的最高关卡进度,战盟进入下一个阶段跟新
    WAR_ALLIANCE_CAN_REWARD_ALLIANCES = "G$CanRewardAlliances", -- 前n个可以领取奖励的战盟
    WAR_ALLIANCE_BOSS_HURT = "G$CuseDamage",                    -- 对战盟boss造成过伤害的玩家
}

-- 战盟玩家变量
local WarAlliancePlayerConst = {
    MY_ALLIANCE_MAP_INFO = "J$MyAllianceMapInfo",
}

-- 拍卖玩家变量
local AuctionConst = {
    AUCTION_WAY = 1,               -- 战盟boss全部可拍卖物品ID
    AUCTION_DIVIDE_EMAIL = 106012, -- 拍卖分红邮件
}

WarAlliance = {}

function WarAlliance.WarAllianceStateUpdate(system, mapId, state, nextStateStartTime, configId)
    if state == DuplicateState.PREPARE then
        WarAlliance.InitWarAllianceTaskInfo(mapId, configId)
    elseif state == DuplicateState.FIGHT then
        local monsterId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", configId)
        DuplicateCommon.DupGenMonsterCommon(mapId, monsterId)
        WarAlliance.ResAllPlayCurrencyStateInfo(mapId)
    elseif state == DuplicateState.FINISH then
        -- lg("清除所有个人副本信息key", key)
        local involvedAactors = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_PLAYER) or {}
        if involvedAactors == "" then
            involvedAactors = {}
        end
        -- lg("要清除信息的involvedAactors", involvedAactors)
        for i = 1, #involvedAactors do
            local thisActor = involvedAactors[i]
            setplaydef(thisActor, WarAlliancePlayerConst.MY_ALLIANCE_MAP_INFO, {})
        end
        setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_PLAYER, {})

        WarAlliance.ResAllPlayCurrencyStateInfo(mapId)
    end
end

-- @description 初始化副本数据
function WarAlliance.InitWarAllianceTaskInfo(mapId, configId)
    --初始化任务信息
    local taskId = ConfigDataManager.getTableValue("cfg_rep", "reptarget", "id", configId)
    local taskInfo = DuplicateCommon.GenDupTaskInfoCommon(taskId)
    table.insert(taskInfo, 1, WarAllianceTaskPhrase.ONE)
    setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO, taskInfo)

    WarAlliance.ResAllTaskPhaseUpdate(mapId)
end

-- @description 客户端请求面板数据
function WarAlliance.GetWarAlliancePanelInfo(actor, msgData)
    local configId = tonumber(msgData['configId'])
    if configId == nil or configId <= 0 then
        -- 拿到距离开服的天数最近的副本cfgid
        local severOpenDays = getbaseinfo(actor, "serveropendays")
        configId = WarAlliance.GetShouldEnterDupCfgId(severOpenDays)
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
    -- 战盟的进度
    local maxLevels = getsysvar(actor, WarAllianceConst.WAR_ALLIANCE_CURR_MAX_LEVEL) or {}
    if maxLevels == "" then
        maxLevels = {}
    end
    local allianceId = getbaseinfo(actor, "guildid")
    local maxLevel = maxLevels[allianceId] or 0

    local resInfo = { configId, leftCount, isOpen, tostring(nextOpenTime), maxLevel }
    sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_BOSS_PANEL, resInfo)
end

-- 进入副本之后响应一些数据
function WarAlliance.AfterEnterWarAlliance(actor, mapId, state, nextStateStartTime, configId)
    info(actor,actor,"玩家进入战盟boss")
    local playerDupInfo = getplaydef(actor, WarAlliancePlayerConst.MY_ALLIANCE_MAP_INFO)
    local newEnter = false
    if playerDupInfo == nil or playerDupInfo == "" or next(playerDupInfo) == nil then
        newEnter = true
    else
        local lastMapId = playerDupInfo[1]
        if mapId ~= lastMapId then
            newEnter = true
        end
    end
    if newEnter == true then
        -- clearallbuff(actor)
        sethp(actor, getattrinfo(actor, "maxHP"))
        setmp(actor, getattrinfo(actor, "maxMP"))
        clearallskillcd(actor)
    end
    -- 进入新的副本，初始化玩家变量
    local taskInfo = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO)
    local nowPhrase = taskInfo[1] -- 当前玩家自己所在的副本阶段,相对于总任务阶段
    local position = nowPhrase    -- 玩家当前所在第几层位置
    playerDupInfo = { mapId, configId, nowPhrase, position }
    setplaydef(actor, WarAlliancePlayerConst.MY_ALLIANCE_MAP_INFO, playerDupInfo)

    local players = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_PLAYER) or {}
    if players == "" then
        players = {}
    end
    local hasRecord = false
    for _, player in ipairs(players) do
        if player:toString() == actor:toString() then
            hasRecord = true
            break
        end
    end
    if not hasRecord then
        table.insert(players, actor)
    end
    setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_PLAYER, players)

    WarAlliance.ResCurrencyStateInfo(actor, mapId)
    WarAlliance.ResTaskPhaseUpdate(actor, mapId)
end

-- @description 请求进入战盟boss活动
function WarAlliance.ReqEnterWarAlliance(actor, msgData)
    if WarAlliance.isWarAlliance(actor) then
        tipinfo(actor, "您已经在战盟boss挑战中")
        return
    end
    local configId = msgData['configId']
    if configId == nil then
        local severOpenDays = getbaseinfo(actor, "serveropendays")
        configId = WarAlliance.GetShouldEnterDupCfgId(severOpenDays)
    end
    -- 检查是否满足战盟boss进入条件
    if not WarAlliance.CanEnterWarAlliance(actor, configId) then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT393)
        return
    end
    -- 通用检查
    if DuplicateCommon.CheckEnterConditonCommon(actor, configId) ~= EnterLimitResultConst.ALLOW then
        tipinfo(actor, "战盟boss副本进入条件不满足")
        return
    end

    -- 寻找是否有可进入的副本，如果没有创建副本
    local mapId = WarAlliance.FindEnterableDup(actor, configId, 1)
    local x, y
    if mapId ~= 0 then
        -- 找到一个已经有的,判断如果不是一阶段,传送点应该是前一个阶段的目标传送点
        local taskInfo = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO)
        if taskInfo then
            local nowPhrase = taskInfo[1]
            if nowPhrase > 1 then
                -- 前一个阶段
                nowPhrase = nowPhrase - 1
                local transferPointInfo = WarAlliance.GetShouldEnteredPoint(nowPhrase)
                if transferPointInfo == nil then
                    error("战盟boss传送点未找到")
                    return
                end
                local targetPonit = transferPointInfo["targetposition"]
                local targetXY = string.splitByAll(targetPonit, "#")
                -- lg("进入地图寻找点", nowPhrase, targetXY[1], targetXY[2])
                x, y = tonumber(targetXY[1]), tonumber(targetXY[2])
            else
                x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
            end
        end
    else
        x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    end
    if mapId == 0 then
        mapId = DuplicateCommon.CreateDupMapCommon(actor, configId, true)
    end
    WarAlliance.PlayerEnterWarAlliance(actor, mapId, x, y, configId)
end

function WarAlliance.isWarAlliance(actor)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if not dupInfo then
        return false
    end
    local type = dupInfo["type"]
    if type ~= DuplicateType.WAR_ALLIANCE then
        return false
    end
    return true
end

-- 进入副本根据当前阶段获取进入的坐标
function WarAlliance.GetShouldEnteredPoint(nowPhrase)
    local transferInfo = ConfigDataManager.getTableValue("cfg_repglobal", "value", "id",
        WarAllianceGlobalConfig.PHRASE_AND_TRANS_POINT)
    if transferInfo == "" then
        error("战盟boss传送点未找到")
        return
    end
    -- 获取传送点
    local nowTransferPointId
    local phraseAndPoints = string.splitByAll(transferInfo, "|")
    for _, phraseAndPoint in ipairs(phraseAndPoints) do
        local phraseAndPointInfo = string.splitByAll(phraseAndPoint, "#")
        local phrase = tonumber(phraseAndPointInfo[1])
        if phrase == nowPhrase then
            nowTransferPointId = tonumber(phraseAndPointInfo[2])
        end
    end
    local transferPointInfos = ConfigDataManager.getTable("cfg_transfer_point", "id", nowTransferPointId)
    if next(transferPointInfos) == nil then
        error("战盟boss传送点未找到")
        return
    end
    local transferPointInfo = transferPointInfos[1]
    return transferPointInfo
end

-- 根据开服天数获取应该进入的副本配置rep_id
function WarAlliance.GetShouldEnterDupCfgId(openDays)
    local configId = ConfigDataManager.getTableValue("cfg_rep", "id", "type", DuplicateType.WAR_ALLIANCE, "startday",
        openDays)
    if configId ~= "" and type ~= nil then
        return tonumber(configId)
    end
    local lines = ConfigDataManager.getTable("cfg_rep", "type", DuplicateType.WAR_ALLIANCE)
    local findLine
    local maxDay = 0
    for _, line in ipairs(lines) do
        local day = tonumber(line["startday"])
        if day > maxDay then
            findLine = line
            maxDay = day
        end
    end
    if findLine then
        configId = findLine["id"]
        return tonumber(configId)
    end
    error("找不到对应的任务关卡配置")
end

-- 根据当前战盟的击杀层数和副本cfgid,找到应该去的任务配置
function WarAlliance.FindShouldEnterDupByLevel(level, cfgId)
    local nextId = ConfigDataManager.getTableValue("cfg_repTask", "nextid", "id", cfgId)
    if nextId == "" or nextId == nil then
        return cfgId
    end
    nextId = tonumber(nextId)
    level = level - 1
    if level == 0 then
        return nextId
    end
    return WarAlliance.FindShouldEnterDupByLevel(level, nextId)
end

-- 尝试找出一个本战盟且可进入的副本
function WarAlliance.FindEnterableDup(actor, configId, needSize)
    local warAllianceId = getbaseinfo(actor, "guildid")
    local mapId = 0
    local maxSize = ConfigDataManager.getTableValue("cfg_rep", "warNumMax", "id", configId)
    if maxSize == "" or tonumber(maxSize) <= 0 then
        local alliance = getunioninfo(actor)
        maxSize = alliance["maxnum"]
    end
    local type = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    local existDupList = getduplicatelist(type)
    for index, dupInfo in ipairs(existDupList) do
        local players = dupInfo["players"]
        local state = dupInfo["state"]
        local dupConfig = dupInfo["dupcfgid"]
        local leftSize = tonumber(maxSize) - #players
        local currMapId = dupInfo["id"]
        local currBelongsAllianceId = getenvirvar(currMapId, WarAllianceConst.WAR_ALLIANCE_DUP_BELONGS) or 0
        if (state == DuplicateState.PREPARE or state == DuplicateState.FIGHT)
            and leftSize >= needSize and tonumber(dupConfig) == tonumber(configId)
            and warAllianceId == currBelongsAllianceId then
            mapId = currMapId
            break
        end
    end
    return mapId
end

-- @description 玩家能否进入战盟boss活动
function WarAlliance.CanEnterWarAlliance(actor, configId)
    -- 检查活动是否开启
    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    local activityInfo = getactivityinfo(activityId)
    if not activityInfo["open"] then
        return false
    end
    -- 检查是否拥有战盟
    local warAllianceId = getbaseinfo(actor, "guildid")
    if warAllianceId == 0 then
        return false
    end
    return true
end

-- @description 玩家传送进战盟boss活动
function WarAlliance.PlayerEnterWarAlliance(actor, mapId, x, y, configId)
    -- 把这个副本设置为战盟专属
    WarAlliance.SetDupBelongs(actor, mapId)

    -- 强制战斗模式为战盟
    setplayersetting(actor, 1, 5)

    -- 扣除次数
    local activityId = ConfigDataManager.getTableValue("cfg_rep", "type", "id", configId)
    reduceactivitytimes(actor, activityId)

    enterduplicate(actor, mapId, x, y)
end

-- 设置战盟专属副本
function WarAlliance.SetDupBelongs(actor, mapId)
    local currBelongsAllianceId = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_BELONGS)
    local allianceId = getbaseinfo(actor, "guildid")
    if not currBelongsAllianceId then
        setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_BELONGS, allianceId)
    end
end

-- @description 玩家击杀战盟boss
function WarAlliance.OnKillWarAllianceMonster(mapId, killer, monCfgId, monActor)
    if mapId <= 0 then
        return
    end
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil or next(dupInfo) == nil then
        return
    end
    local dupType = dupInfo["type"]
    if dupType ~= WarAllianceConst.WAR_ALLIANCE_TYPE then
        return
    end

    local taskInfo = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO)
    -- lg("怪物死亡taskInfo", taskInfo)
    local taskId = taskInfo[2]
    local taskType = taskInfo[3]
    if taskType == WarAllianceConst.KILL_MONSTER_COUNT then
        local totalCount = taskInfo[4]
        local oldCount = taskInfo[5]
        local newCount = oldCount + 1
        if newCount >= totalCount then
            WarAlliance.UpdateOwnTaskInfo(killer, taskInfo, taskId, totalCount, newCount, dupInfo)
            -- 怪物死亡数量,单独记录是因为最后一阶段不会更新任务信息
            -- 根据怪物死亡数给新进的玩家推送最后一层信息
            setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_MONSTER_STATE, newCount)

            WarAlliance.UpdateNextTaskPhrase(mapId, taskId, killer)
        else
            -- 更新任务
            taskInfo[5] = newCount
            setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO, taskInfo)
            WarAlliance.ResAllTaskPhaseUpdate(mapId)
        end
    end

    -- 战盟经验奖励
    WarAlliance.GiveRewardToAlliance(killer)

    local allianceName = getbaseinfo(killer, "guildname")
    local bossName = ConfigDataManager.getTableValue("cfg_monster", "name", "id", monCfgId)
    noticeTip.noticeinfo(killer, WarAllianceConst.WAR_ALLIANCE_DUP_HORSE_LAMP, allianceName, bossName)
    noticeTip.noticeinfo(killer, WarAllianceConst.WAR_ALLIANCE_DUP_CHAT, allianceName, bossName)
end

function WarAlliance.UpdateOwnTaskInfo(killer, taskInfo, taskId, totalCount, newCount, dupInfo)
    local nowPhrase = taskInfo[1]
    local response = {}
    response["phrase"] = nowPhrase
    response["taskId"] = taskId
    response["nowCount"] = newCount
    response["totalCount"] = totalCount
    local playerMapInfo = getplaydef(killer, WarAlliancePlayerConst.MY_ALLIANCE_MAP_INFO) or {}
    response["position"] = playerMapInfo[4]
    local myPhrase = playerMapInfo[3] + 1 > 5 and 5 or playerMapInfo[3] + 1
    response["myCurrPhrase"] = myPhrase
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_TASK_INFO, response)
    end
end

-- 战盟经验奖励
function WarAlliance.GiveRewardToAlliance(actor)
    local itemAndCount = ConfigDataManager.getTableValue("cfg_repglobal", "value", "id",
        WarAllianceGlobalConfig.KILL_BOSS_REWARD_EXP_CFGID)
    if itemAndCount ~= "" and itemAndCount ~= nil then
        local item = string.splitByAll(itemAndCount, "#")[1]
        local count = string.splitByAll(itemAndCount, "#")[2]
        additemtobag(actor, tonumber(item), tonumber(count), 0, 9999, ItemActionProxy.GUILD_BOSS)
    end
end

-- @description 更新下一关任务,
function WarAlliance.UpdateNextTaskPhrase(mapId, taskId, actor)
    local taskInfo = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO)
    local nextTaskId = ConfigDataManager.getTableValue("cfg_repTask", "nextid", "id", taskId)
    -- lg("下一关任务id:", nextTaskId)

    if nextTaskId == nil or nextTaskId == "" then
        -- 后进游戏的玩家要发上一个阶段的任务信息,下一个阶段的任务信息虽然已经存了
        -- 但是还没开始发放,页面显示的还是上一个阶段的任务信息,只有怪物数变了
        local monsterDieCount = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_MONSTER_STATE) or 0
        if monsterDieCount ~= 0 then
            taskInfo[5] = tonumber(monsterDieCount)
            setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO, taskInfo)
        end
    end

    local nowPhrase = taskInfo[1]
    -- 保存共享的关卡进度
    local guild = getmyguild(actor)
    local allianceId = tonumber(guild:toString())
    local maxLevels = getsysvar(actor, WarAllianceConst.WAR_ALLIANCE_CURR_MAX_LEVEL) or {}
    if maxLevels == "" then
        maxLevels = {}
    end
    maxLevels[allianceId] = nowPhrase
    setsysvar(actor, WarAllianceConst.WAR_ALLIANCE_CURR_MAX_LEVEL, maxLevels)

    --最后一个阶段,有N个战盟到达最后关,开启拍卖行
    if nowPhrase == WarAllianceTaskPhrase.FIVE then
        local canReward = getsysvar(actor, WarAllianceConst.WAR_ALLIANCE_CAN_REWARD_ALLIANCES) or {}
        if canReward == "" then
            canReward = {}
        end
        local count = #canReward
        local limit = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id",
            WarAllianceGlobalConfig.REWARD_COUNT_LIMIT)
        limit = tonumber(limit)
        if count == limit then
            info("战盟boss拍卖名额已满", actor:toString())
            return
        end
        local hasRecord =  WarAlliance.HasRecord(canReward,allianceId)
        if count < limit and (not hasRecord) then
            table.insert(canReward, guild)
            count = #canReward
            setsysvar(actor, WarAllianceConst.WAR_ALLIANCE_CAN_REWARD_ALLIANCES, canReward)

            taskInfo[7] = true
            setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO, taskInfo)

            -- 外置竞拍行
            local hasDamgeInfos = getsysvar(actor, WarAllianceConst.WAR_ALLIANCE_BOSS_HURT) or {}
            local myHurtMember = hasDamgeInfos[allianceId] or {}
            info("战盟boss开启拍卖行,战盟id:", allianceId, "本战盟伤害列表:", myHurtMember,"所有战盟列表:", canReward)
            Auction.NoticeClientToStartAuction(actor, allianceId, myHurtMember, canReward)
            WarAlliance.FlushActivity(actor)
            return
        end
        WarAlliance.FlushActivity(actor)
        return
    end

    WarAlliance.transferAndflushTask(actor, mapId, taskInfo, nextTaskId)
end

function WarAlliance.HasRecord(canReward,allianceId)
    for _, guild in ipairs(canReward) do
        if tonumber(guild:toString()) == allianceId then
            return true
        end
    end
    return false
end

function WarAlliance.FlushActivity(actor)
    local severOpenDays = getbaseinfo(actor, "serveropendays")
    local configId = WarAlliance.GetShouldEnterDupCfgId(severOpenDays)
    DuplicateCommon.FinishDupActivity(actor, configId)
end

-- 准备传送数据,更新任务
function WarAlliance.transferAndflushTask(actor, mapId, taskInfo, nextTaskId)
    -- 任务阶段
    local nowPhrase = taskInfo[1]
    local transferPointInfo = WarAlliance.GetShouldEnteredPoint(nowPhrase)
    if transferPointInfo == nil then
        error("战盟boss传送点未找到")
        return
    end
    local targetMapCfgId = transferPointInfo["targetid"]
    local showPonit = transferPointInfo["position"]
    local showXY = string.splitByAll(showPonit, "#")
    local targetPonit = transferPointInfo["targetposition"]
    local targetXY = string.splitByAll(targetPonit, "#")

    local targetPointInfo = {
        showXY = showXY,
        targetXY = targetXY,
        targetMapCfgId = targetMapCfgId,
    }
    -- 保存传送目标点信息
    setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TRANS_POINT, targetPointInfo)

    sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_OPEN_TRANSFER, { showXY = showXY })

    -- 刷怪
    DuplicateCommon.DupGenMonsterCommon(mapId, nextTaskId)

    --  设置更新下一个任务
    local nextPhrase = nowPhrase + 1
    local nextTaskInfo = DuplicateCommon.GenDupTaskInfoCommon(nextTaskId)
    table.insert(nextTaskInfo, 1, nextPhrase)
    setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO, nextTaskInfo)
end

function WarAlliance.CheckTransfer(actor, currX, currY, x, y)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if not dupInfo then
        return nil
    end
    if tonumber(dupInfo["activityid"]) == WarAllianceConst.WAR_ALLIANCE_TYPE then
        local targetPointInfo = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TRANS_POINT)
        if targetPointInfo == nil or next(targetPointInfo) == nil or targetPointInfo == "" then
            return { result = true, reason = "传送点信息为空" , ignoreNotice = true}
        end

        local taskInfo = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO)
        local nowPhrase = taskInfo[1]
        local playerMapInfo = getplaydef(actor, WarAlliancePlayerConst.MY_ALLIANCE_MAP_INFO) or {}
        if playerMapInfo == "" then
            playerMapInfo = {}
        end
        local position = playerMapInfo[4]
        if nowPhrase == playerMapInfo[3] and nowPhrase == position then
            return { result = true, reason = "同一层不执行传送" , ignoreNotice = true}
        end

        -- 计算自己当前层数时和传送点位置的距离
        local myPointInfo = WarAlliance.GetShouldEnteredPoint(position) or {}
        local showPonit = myPointInfo["position"]
        local showXY = string.splitByAll(showPonit, "#")
        local distance = math.abs(tonumber(currX) - tonumber(showXY[1])) ^ 2 +
            math.abs(tonumber(currY) - tonumber(showXY[2])) ^ 2
        if distance > 9 then
            return { result = true, reason = "不在传送点附近,不能传送" , ignoreNotice = true}
        end

        return WarAlliance.DoTransferAndFlushTask(actor, nowPhrase, playerMapInfo)
    end
    return { result = true, reason = "该副本内传送" , ignoreNotice = true}
end

-- 执行传送和任务回包
function WarAlliance.DoTransferAndFlushTask(actor, nowPhrase, playerMapInfo)
    local mapId = getbaseinfo(actor, "unimapid")
    local targetPointInfo = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TRANS_POINT)
    local targetXY = targetPointInfo["targetXY"]
    local targetMapCfgId = targetPointInfo["targetMapCfgId"]
    info("战盟boss传送", actor:toString(), targetXY[1],targetXY[2], targetMapCfgId)
    maptransfer(actor, tonumber(targetXY[1]), tonumber(targetXY[2]), tonumber(targetMapCfgId))


    local myPhrase = playerMapInfo[3] or 1
    if nowPhrase > myPhrase then
        playerMapInfo[3] = nowPhrase
    end
    -- local position = playerMapInfo[4] or 1
    playerMapInfo[4] = math.max(myPhrase, nowPhrase)
    setplaydef(actor, WarAlliancePlayerConst.MY_ALLIANCE_MAP_INFO, playerMapInfo)

    -- 设置怪物死亡数量为零
    local monsterState = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_MONSTER_STATE)
    if monsterState ~= 0 then
        setenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_MONSTER_STATE, 0)
    end

    WarAlliance.ResTaskPhaseUpdate(actor, mapId)
    return { result = true, reason = "战盟boss副本内传送" , ignoreNotice = true}
end

-- @description 通知地图所有玩家更新当前阶段
function WarAlliance.ResAllPlayCurrencyStateInfo(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        WarAlliance.ResCurrencyStateInfo(actor, mapId)
    end
end

-- @description 响应给客户端当前阶段
function WarAlliance.ResCurrencyStateInfo(actor, mapId)
    local dupInfo = getduplicate(mapId)
    local state = dupInfo["state"]
    local configId = dupInfo["dupcfgid"]
    local nextStateStartTime = dupInfo["nextstatetime"]
    -- lg("当前阶段信息:", { state, tostring(nextStateStartTime), configId })
    sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_STATE_INFO,
        { state, tostring(nextStateStartTime), configId })
end

-- @description 通知地图玩家任务阶段更新响应
function WarAlliance.ResAllTaskPhaseUpdate(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for index, actor in ipairs(players) do
        WarAlliance.ResTaskPhaseUpdate(actor, mapId)
    end
end

-- @description 任务阶段更新响应
function WarAlliance.ResTaskPhaseUpdate(actor, mapId)
    local playerMapInfo = getplaydef(actor, WarAlliancePlayerConst.MY_ALLIANCE_MAP_INFO) or {}
    local myPhrase = playerMapInfo[3] or 1
    local position = playerMapInfo[4] or 1
    local taskInfo = getenvirvar(mapId, WarAllianceConst.WAR_ALLIANCE_DUP_TASK_INFO)
    -- lg("任务阶段更新信息:", taskInfo)
    local nowPhrase = taskInfo[1]
    local taskId = taskInfo[2]
    local totalCount = taskInfo[4]
    local nowCount = taskInfo[5]
    local response = {}
    response["phrase"] = nowPhrase
    response["taskId"] = taskId
    response["nowCount"] = nowCount
    response["totalCount"] = totalCount
    response["myCurrPhrase"] = myPhrase
    response["position"] = position
    local openedGoods = taskInfo[7] or false
    if openedGoods then
        local goods = Auction.GetSomeGoods(actor, { 0, 0, 0, 0, 0, 0 }, true)
        if #goods > 0 then
            response["goAuction"] = true
        end
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_TASK_INFO, response)
end

-- 记录造成伤害的玩家,用来分红
function WarAlliance.savePlayerInvloveInfo(caster, target, hurt, monsterId)
    if hurt <= 0 then
        return
    end
    local allianceId = getbaseinfo(caster, "guildid")
    if allianceId == 0 then
        return
    end
    local mapId = getbaseinfo(caster, "unimapid")
    local dupInfo = getduplicate(mapId)
    if not dupInfo then
        return
    end
    local activityId = dupInfo["activityid"]
    if activityId ~= WarAllianceConst.WAR_ALLIANCE_TYPE then
        return
    end
    local openDays = getbaseinfo(caster, "serveropendays")
    local dupId = WarAlliance.GetShouldEnterDupCfgId(openDays)
    local firstLevelCfgId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", dupId)
    -- 判断target是否为战盟boss怪物
    local bosses = {}
    WarAlliance.getBosses(bosses, tonumber(firstLevelCfgId))
    for i = 1, #bosses do
        if tonumber(monsterId) == tonumber(bosses[i]) then
            -- 1.判断是否开启了拍卖,开启过了不记录
            local canReward = getsysvar(caster, WarAllianceConst.WAR_ALLIANCE_CAN_REWARD_ALLIANCES) or {}
            if canReward == "" then
                canReward = {}
            end
            local count = #canReward
            local limit = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id",
                WarAllianceGlobalConfig.REWARD_COUNT_LIMIT)
            limit = tonumber(limit)
            if count >= limit then
                return
            end
            if  WarAlliance.HasRecord(canReward,allianceId) then
                return
            end
            -- 2.判断caster是否记录过
            local hasDamgeInfos = getsysvar(caster, WarAllianceConst.WAR_ALLIANCE_BOSS_HURT) or {}
            if hasDamgeInfos == "" then
                hasDamgeInfos = {}
            end
            local myAllianceDamgeMembers = hasDamgeInfos[allianceId] or {}
            local hasDamge = array.contains(myAllianceDamgeMembers, caster:toString())
            if not hasDamge then
                info("战盟boss记录伤害,战盟id:" , allianceId , ",玩家id:" , caster:toString())
                table.insert(myAllianceDamgeMembers, caster:toString())
                hasDamgeInfos[allianceId] = myAllianceDamgeMembers
                setsysvar(caster, WarAllianceConst.WAR_ALLIANCE_BOSS_HURT, hasDamgeInfos)
            end
        end
    end
end

function WarAlliance.getBosses(bosses, repMonsterCfgId)
    local monsterInfo = ConfigDataManager.getTableValue("cfg_repmonster", "monster", "id", repMonsterCfgId)
    local monster = string.splitByAll(monsterInfo, "#")[1]
    if not array.contains(bosses, monster) then
        table.insert(bosses, monster)
    end
    local nextRepMonsterCfgId = ConfigDataManager.getTableValue("cfg_repmonster", "nextid", "id", repMonsterCfgId)
    if nextRepMonsterCfgId ~= "" and tonumber(nextRepMonsterCfgId) > 0 then
        WarAlliance.getBosses(bosses, nextRepMonsterCfgId)
    end
end

function WarAlliance.ClearThisTimeGameData()
    local time = TimeUtil.timeFormat(getbaseinfo("nowsec"))
    info("清除本次战盟副本数据,时间:" , time)
    setsysvar(WarAllianceConst.WAR_ALLIANCE_BOSS_HURT, {})
    setsysvar(WarAllianceConst.WAR_ALLIANCE_CURR_MAX_LEVEL, {})
    setsysvar(WarAllianceConst.WAR_ALLIANCE_CAN_REWARD_ALLIANCES, {})
end

--- 退出副本
function WarAlliance.reqExitWarAlliance(actor)
    -- local mapId = getbaseinfo(actor, "unimapid")
    -- local dupInfo = getduplicate(mapId)
    -- if dupInfo then
    --     quitduplicate(actor)
    --     sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_EXIT, {})
    -- end
    quitduplicate(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_WAR_ALLIANCE_EXIT, {})
end

--- 玩家复活后发送战盟BOSS任务状态
function WarAlliance.playerRelive(actor, reviveType)
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    local type = dupInfo["type"]
    if type ~= DuplicateType.WAR_ALLIANCE then
        return
    end
    local playerMapInfo = getplaydef(actor, WarAlliancePlayerConst.MY_ALLIANCE_MAP_INFO) or {}
    if reviveType ~= 3 then
        playerMapInfo[4] = 1
    end
    setplaydef(actor, WarAlliancePlayerConst.MY_ALLIANCE_MAP_INFO, playerMapInfo)
    WarAlliance.ResTaskPhaseUpdate(actor, mapId)
end
