-- 狼魂要塞副本
WolfSoul = {}

local this = {}

local WOLF_SOUL_ALL_MAP = "G$狼魂战盟2副本映射"
local WOLF_SOUL_SCORE_KEY = "score_key_"
local WOLF_SOUL_KILL_COUNT_KEY = "kill_count_key"
local WOLF_SOUL_MSG_DATA_KEY = "message_data_key"

local ONE_DAY = 24 * 60 * 60 * 1000

-- @description 请求进入狼魂要塞
-- @param 玩家对象；副本配置id
-- @return
function WolfSoul.ReqEnterWolfSoul(actor)
    --限制条件
    --玩家必须加入战盟
    local unionId = getbaseinfo(actor, "guildid")
    if unionId == 0 then
        return
    end
    --战盟副本必须存在
    local union2Dup = getsysvar(WOLF_SOUL_ALL_MAP)

    local dupId = union2Dup[unionId]
    if dupId == nil then
        tipinfo(actor, "当前不在活动时间")
        return
    end
    local dupInfo = getduplicate(dupId)
    if dupInfo == nil then
        tipinfo(actor, "当前不在活动时间")
        return
    end

    local configId = dupInfo["dupcfgid"]
    local state = dupInfo["state"]
    if state ~= DuplicateState.PREPARE and state ~= DuplicateState.FIGHT then
        tipinfo(actor, "当前不在活动时间")
        return
    end
    --回蓝回血
    DuplicateCommon.RecoverHPMP(actor)
    --进入副本
    local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    enterduplicate(actor, dupId, x, y)
end

-- @description 请求召唤守护者
-- @param 玩家对象；守护者id
-- @return
function WolfSoul.ReqSummonWarder(actor, monsterId)
    -- 获取副本信息
    local mapId = getbaseinfo(actor, "unimapid")
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    if dupInfo["state"] ~= DuplicateState.PREPARE then
        return
    end
    local repId = dupInfo["dupcfgid"]
    local needPos = ConfigDataManager.getTableValue("cfg_wolf_soul", "post", "repId", repId)
    local needPosList = string.split(needPos, "#")
    -- 玩家职位限制
    local unionInfo = getunioninfo(actor)
    local position = unionInfo["unionposition"]
    position = tostring(position)
    if not array.contains(needPosList, position) then
        return
    end
    -- 召唤的是第几个守护者，守护者位置
    local oldCount = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_WARDER_COUNT)
    local maxCount = tonumber(ConfigDataManager.getTableValue("cfg_wolf_soul", "guardians", "repId", repId))
    if oldCount >= maxCount then
        return
    end
    -- 守护者消耗配置
    local itemId, itemCount
    local guardiansType = ConfigDataManager.getTableValue("cfg_wolf_soul", "guardiansType", "repId", repId)
    local guardiansTypeList = string.split(guardiansType, "|")
    for _, value in pairs(guardiansTypeList) do
        local valueList = string.split(value, "#")
        local monId = tonumber(valueList[1])
        if monId == tonumber(monsterId) then
            itemId = tonumber(valueList[2])
            itemCount = tonumber(valueList[3])
            break
        end
    end
    local bagCount = getbagitemcountbyid(actor, itemId)
    if tonumber(bagCount) < tonumber(itemCount) then
        return
    end
    -- 扣除道具,刷怪
    local guardiansPosition = ConfigDataManager.getTableValue("cfg_wolf_soul", "guardiansPosition", "repId", repId)
    local guardiansPositionList = string.split(guardiansPosition, "|")
    local nowPos = guardiansPositionList[oldCount + 1]
    local nowPosList = string.split(nowPos, "#")
    local x = nowPosList[1]
    local y = nowPosList[2]
    local dir = nowPosList[3]
    removeitemfrombag(actor, itemId, itemCount, 0, 9999, '狼魂要塞')
    local monsterActor = mongen(mapId, x, y, 0, monsterId, 1)
    setmapobjectdir(monsterActor[1], dir)
    setenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_WARDER_COUNT, oldCount + 1)
    --同步消息
    this.SendAllPreparePanel(mapId)
end

-- @description 活动开启创建副本
-- @param
-- @return
function WolfSoul.OpenDuplicate(system)
    -- 一个战盟一个副本
    -- 根据服务器开服天数，开启进入不同得副本ID
    local repId
    local severOpenDays = tonumber(getbaseinfo("serveropendays"))
    local wolfSoulConfigList = ConfigDataManager.getList("cfg_wolf_soul")
    for key, config in pairs(wolfSoulConfigList) do
        local dayStr = config["numberday"]
        local dayList = string.split(dayStr, "#")
        local startDay = tonumber(dayList[1])
        local endDay = tonumber(dayList[2])
        if startDay <= severOpenDays and severOpenDays <= endDay then
            repId = tonumber(config["repid"])
        end
    end
    if repId == nil then
        error("WolfSoul.OpenDuplicate() cant find config")
        return
    end
    local unionId2DupMap = {}
    local allUninonInfo = getallunionsummary()
    for key, unionInfo in pairs(allUninonInfo) do
        local unionId = unionInfo["unionid"]
        local mapId = DuplicateCommon.CreateDupMapCommon(system, repId, true)
        unionId2DupMap[unionId] = mapId
    end
    setsysvar(WOLF_SOUL_ALL_MAP, unionId2DupMap)
end

-- @description 玩家进入副本后
-- @param 玩家对象；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function WolfSoul.AfterEnterWolfSoul(actor, mapId, state, nextStateStartTime, configId)
    -- 记录参与的玩家
    local rid = actor:toString()
    local players = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_ALL_PLAYERS)
    if type(players) ~= "table" then
        players = {}
    end
    if not array.contains(players, rid) then
        table.insert(players, rid)
        setenvirvar(mapId, WOLF_SOUL_SCORE_KEY .. actor:toString(), 0)
    end
    setenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_ALL_PLAYERS, players)
    -- 发送面板信息
    if state == DuplicateState.PREPARE then
        this.SendStateInfo(actor, configId, state, nextStateStartTime)
        this.SendPreparePanel(actor, mapId, nextStateStartTime)
    elseif state == DuplicateState.FIGHT then
        this.SendStateInfo(actor, configId, state, nextStateStartTime)
        this.SendFightPanel(actor, mapId)
    elseif state == DuplicateState.FINISH then
        this.SendStateInfo(actor, configId, state, nextStateStartTime)
    end
end

-- @description 副本阶段更新
-- @param 系统id；地图唯一id；副本类型；副本阶段(1-准备 2-战斗 3-结算)；下一阶段开始时间戳；配置id(cfg_rep的id)
-- @return
function WolfSoul.DupStateUpdate(system, mapId, state, nextStateStartTime, configId)
    if state == DuplicateState.PREPARE then
        local WolfSoulId = ConfigDataManager.getTableValue("cfg_wolf_soul", "id", "repId", configId)
        -- 刷雕像
        local platformId = ConfigDataManager.getTableValue("cfg_wolf_soul", "platformID", "id", WolfSoulId)
        local platformPos = ConfigDataManager.getTableValue("cfg_wolf_soul", "platformPosition", "id", WolfSoulId)
        local platformPosSplit = string.split(platformPos, "#")
        local platformX = tonumber(platformPosSplit[1])
        local platformY = tonumber(platformPosSplit[2])
        local platformDir = tonumber(platformPosSplit[3])
        local monsterActor = mongen(mapId, platformX, platformY, 0, platformId, 1)
        setmapobjectdir(monsterActor[1], platformDir)
        setenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_STATUE, monsterActor[1])
        -- 初始化召唤物数量
        setenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_WARDER_COUNT, 0)
    elseif state == DuplicateState.FIGHT then
        -- 挑战阶段副本无人直接关闭副本
        local playerCount = getplaycountinmap(mapId)
        if playerCount <= 0 then
            setduplicatestate(mapId, SetDuplicateStateConst.TO_CLOSED)
            return
        end
        this.SendAllStateInfo(mapId, configId, state, nextStateStartTime)
        -- 刷怪
        local repMonCfg = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", configId)
        this.GenMonster(mapId, repMonCfg)
    elseif state == DuplicateState.FINISH then
        --结算阶段
        this.SendAllStateInfo(mapId, configId, state, nextStateStartTime)
        -- 如果雕像存活，则胜利；如果雕像死亡，则失败
        local statue = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_STATUE)
        local monsterInfo = getmonsterinfo(statue)
        if monsterInfo == nil then
            -- 雕像死亡
            this.Settlement(mapId, configId, false)
        else
            --雕像存活
            this.Settlement(mapId, configId, true)
        end
    end
end

-- @Deprecated 改成心跳检测了
function WolfSoul.MonsterHPChange(performer, currHP, maxHP, performerType)
    if performerType ~= MapObjectType.MONSTER then
        return
    end
    local mapId = getbaseinfo(performer, "unimapid")
    if mapId == nil then
        return
    end
    local dupInfo = getduplicate(mapId)
    if dupInfo == nil then
        return
    end
    local dupType = dupInfo["type"]
    if dupType ~= DuplicateType.WOLF_SOUL then
        return
    end
    local repId = dupInfo["dupcfgid"]
    local monsterInfo = getmonsterinfo(performer)
    local monCfgId = monsterInfo["cfgid"]
    local platformID = ConfigDataManager.getTableValue("cfg_wolf_soul", "platformID", "repId", repId)
    if tonumber(platformID) ~= tonumber(monCfgId) then
        return
    end
    this.SendAllFightPanel(mapId)
end

-- @description 副本地图怪物死亡移除
-- @param killer有可能是守护者
-- @return
function WolfSoul.MapMonsterRemove(mapId, killer, monCfgId)
    local dupInfo = getduplicate(mapId)
    local state = dupInfo["state"]
    if state == DuplicateState.FIGHT then
        local repId = dupInfo["dupcfgid"]
        -- 如果是神狼雕像，任务失败
        local platformID = ConfigDataManager.getTableValue("cfg_wolf_soul", "platformID", "repId", repId)
        if tonumber(monCfgId) == tonumber(platformID) then
            -- 任务失败
            setduplicatestate(mapId, SetDuplicateStateConst.TO_FINISH)
            return
        end

        -- 记录地图中死亡怪物数量
        local killCount = getenvirvar(mapId, WOLF_SOUL_KILL_COUNT_KEY) or 0
        setenvirvar(mapId, WOLF_SOUL_KILL_COUNT_KEY, killCount + 1)

        -- 给击杀者加积分
        --击杀者需要是玩家
        local killerType = getbaseinfo(killer, "mapobjecttype")
        if tonumber(killerType) == MapObjectType.PLAYER then
            local killerId = killer:toString()
            local score = getenvirvar(mapId, WOLF_SOUL_SCORE_KEY .. killerId)
            if score == nil or score <= 0 then
                score = 0
            end
            local killPoint = ConfigDataManager.getTableValue("cfg_wolf_soul", "killPoint", "repId", repId)
            local killPointList = string.split(killPoint, "|")
            for _, value in pairs(killPointList) do
                local valueList = string.split(value, "#")
                local monId = valueList[1]
                local addScore = tonumber(valueList[2])
                if tonumber(monId) == tonumber(monCfgId) then
                    score = score + addScore
                    break
                end
            end
            setenvirvar(mapId, WOLF_SOUL_SCORE_KEY .. killerId, score)
            --刷新任务面板
            this.SendFightPanel(killer, mapId)
        end

        -- 没有怪了就刷新下一波怪
        -- 雕像和守护者也是怪
        local monCount = getmoncount(mapId)
        local guardians = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_WARDER_COUNT)
        monCount = monCount - guardians - 1

        local genMonData = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_GEN_MONSTER)
        if genMonData == nil then
            return
        end

        local repMonCfg = genMonData[1]
        local cfgKill = string.tonumber(ConfigDataManager.getTableValue("cfg_repMonster", "kill", "id", repMonCfg))
        -- cfgKill = 30
        -- jprint(string.format("副本怪物数量统计 -----> 配置 %d 击杀 %d 剩余 %d", cfgKill, killCount, monCount))

        -- 地图中已没有怪物, 直接进入下阶段
        -- 地图中还有怪物, 但是击杀数已达标进入下阶段
        -- 如果击杀数没有要求的情况下, 不再处理击杀数的逻辑
        if cfgKill == 0 and monCount > 0 then
            return
        end
        if monCount ~= 0 and cfgKill > 0 and killCount < cfgKill then
            return
        end

        setenvirvar(mapId, WOLF_SOUL_KILL_COUNT_KEY, 0)

        local nextId = tonumber(ConfigDataManager.getTableValue("cfg_repMonster", "nextID", "id", repMonCfg))
        -- jprint(string.format("副本怪物数量统计 -----> 开始进入下一阶段 %s 配置-> %d 击杀 %d 剩余 %d", tostring(nextId), cfgKill, killCount, monCount))
        
        if nextId ~= nil then
            -- 给奖励
            this.DefendSuccess(mapId, repMonCfg)
            this.GenMonster(mapId, nextId)
        else
            -- 如果没有下一波怪，则胜利
            this.DefendSuccess(mapId, repMonCfg)
            -- 任务成功
            setduplicatestate(mapId, SetDuplicateStateConst.TO_FINISH)
        end
    end
end

-- @description 副本秒钟心跳
-- @param 地图id；副本配置；副本阶段
-- @return
function WolfSoul.SecondHeart(mapId, dupConfig, state)
    if state == DuplicateState.PREPARE then

    elseif state == DuplicateState.FIGHT then
        -- 战斗阶段
        -- 血量变化改成心跳
        this.SendAllFightPanel(mapId)
        -- 经过指定时间刷下一波怪
        local nowMillis = getbaseinfo("now")
        local genMonData = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_GEN_MONSTER)
        if genMonData == nil then
            return
        end
        local repMonCfg = genMonData[1]
        local nextGenTime = genMonData[2]
        if nowMillis >= nextGenTime then
            local nextId = tonumber(ConfigDataManager.getTableValue("cfg_repMonster", "nextID", "id", repMonCfg))
            if nextId ~= nil then
                this.DefendSuccess(mapId, repMonCfg)
                this.GenMonster(mapId, nextId)
            end
        end
    end
end

-- @description 被攻击事件
-- @param 地图对象；参数
-- @return
-- function WolfSoul.PerformerBeAttacked(actor, fightParam)
--     local targetType = fightParam["targettype"]
--     if targetType ~= 2 then
--         return
--     end
--     local mapId = fightParam["mapid"]
--     local dupInfo = getduplicate(mapId)
--     if dupInfo == nil then
--         return
--     end
--     local type = dupInfo["type"]
--     if type ~= DuplicateType.WOLF_SOUL then
--         return
--     end
--     local monsterId = fightParam["targetcfgid"]
--     local repId = dupInfo["dupcfgid"]
--     local platformId = ConfigDataManager.getTableValue("cfg_wolf_soul", "platformID", "repId", repId)
--     if tonumber(monsterId) ~= tonumber(platformId) then
--         return
--     end
--     --todo 雕像被攻击了
--     this.SendAllFightPanel(mapId)
-- end

function this.GenMonster(mapId, repMonCfg)
    -- 非战斗阶段
    local dupInfo = getduplicate(mapId)
    if dupInfo["state"] ~= DuplicateState.FIGHT then
        return
    end
    -- 刷怪记录当前刷怪配置和时间
    local nowMillis = getbaseinfo("now")
    local nextId = tonumber(ConfigDataManager.getTableValue("cfg_repMonster", "nextID", "id", repMonCfg))
    
    local time = ONE_DAY
    if nextId ~= nil then
        local cfgTime = string.tonumber(ConfigDataManager.getTableValue("cfg_repMonster", "time", "id", repMonCfg))
        if cfgTime > 0 then
            time = cfgTime * 1000
        end
    end

    local nextGenTime = nowMillis + time
    local genMonData = { repMonCfg, nextGenTime }
    setenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_GEN_MONSTER, genMonData)
    local monsterList = DuplicateCommon.DupGenMonsterCommon(mapId, repMonCfg)
    local statue = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_STATUE)
    local monsterInfo = getmonsterinfo(statue)
    if monsterInfo == nil then
        return
    end
    --仇恨值
    local hate = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RepGlobalConfig.WOLF_SOUL_HATE_TO_PLATFORM)
    -- 怪物需要攻击神像
    for _, monster in pairs(monsterList) do
        addthreat(monster, statue, hate, 1)
    end
    this.SendAllFightPanel(mapId)
end

function this.SendStateInfo(actor, repId, state, nextStateStartTime)
    sendluamsg(actor, LuaMessageIdToClient.RES_WOLF_SOUL_STATE, { repId, state, tostring(nextStateStartTime) })
end

function this.SendAllStateInfo(mapId, repId, state, nextStateStartTime)
    local allPlayers = getmapplayer(mapId)
    if #allPlayers > 0 then
        for _, actor in pairs(allPlayers) do
            this.SendStateInfo(actor, repId, state, nextStateStartTime)
        end
    end
end

-- @description 发送准备阶段面板信息
-- @param
-- @return
function this.SendPreparePanel(actor, mapId, nextStateStartTime)
    -- 召唤物数量
    local warderCount = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_WARDER_COUNT)
    -- 发送协议包
    sendluamsg(actor, LuaMessageIdToClient.RES_WOLF_SOUL_PREPARE_PANEL, { warderCount })
end

function this.SendAllPreparePanel(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for _, actor in pairs(players) do
        this.SendPreparePanel(actor, mapId)
    end
end

-- @description 发送战斗阶段面板信息
-- @param
-- @return
function this.SendFightPanel(actor, mapId)
    -- 雕像生命值万分比
    local statue = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_STATUE)
    local statueMonster = getmonsterinfo(statue)
    local hpPercent
    if statueMonster == nil then
        hpPercent = 0
    else
        local nowHP = getbaseinfo(statue, "hp")
        local maxHP = getbaseinfo(statue, "maxhp")
        hpPercent = math.ceil(nowHP / maxHP * 10000)
    end
    -- 击杀积分
    local score = getenvirvar(mapId, WOLF_SOUL_SCORE_KEY .. actor:toString())
    -- 个人排名
    local rank = this.GetPlayerRank(actor, mapId)
    -- 剩余波数
    local genMonData = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_GEN_MONSTER)
    local repMonCfg = genMonData[1]
    local leftWaves = this.GetLeftWaves(repMonCfg)
    -- repMonsterId
    local repMonsterId = genMonData[1]
    -- 击杀数量
    local killCount = getenvirvar(mapId, WOLF_SOUL_KILL_COUNT_KEY)
    -- 下一波倒计时
    local nextGenTime = genMonData[2]
    if leftWaves <= 0 then
        local dupInfo = getduplicate(mapId)
        nextGenTime = dupInfo["nextstatetime"]
    end

    local resMsg = { hp = hpPercent, score = score, rank = rank, nextGenTime = tostring(nextGenTime), left = leftWaves , killCount = killCount, repMonsterId = repMonsterId}
    -- 发送消息
    sendluamsg(actor, LuaMessageIdToClient.RES_WOLF_SOUL_FIGHT_PANEL, resMsg)
end

function this.SendAllFightPanel(mapId)
    local dupInfo = getduplicate(mapId)
    local players = dupInfo["players"]
    for _, actor in pairs(players) do
        this.SendFightPanel(actor, mapId)
    end
end

-- @description 波次防守成功
-- @param 地图id;刷怪配置
-- @return
function this.DefendSuccess(mapId, repMonCfg)
    local mapPlayers = getmapplayer(mapId)
    local reward = ConfigDataManager.getTableValue("cfg_repMonster", "reward", "id", repMonCfg)
    if reward == "" then
        return
    end
    local itemMap = string.toIntIntMap(reward, "#", "|")
    for _, actor in pairs(mapPlayers) do
        additemmaptobag(actor, itemMap, 0, 9999, ItemActionProxy.WOLF_SOUL)
        GameTips.sendGetRewardMsg(actor, itemMap)
    end
end

-- @description 副本结算
-- @param 地图id；副本配置；true-成功，false-失败
-- @return
function this.Settlement(mapId, repId, success)
    local allPlayers = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_ALL_PLAYERS)
    -- 检查 allPlayers 是否为非空表
    if not (type(allPlayers) == "table" and #allPlayers > 0) then
        return
    end
    -- 所有参与过的玩家，发积分奖励
    local ranks = this.CalcuPlayerRank(mapId)
    local resMsg = {}
    local rankList = {}
    for rid, rank in pairs(ranks) do
        local innerData = {}
        --rid
        innerData["rid"] = tostring(rid)
        --排名
        innerData["rank"] = rank
        --玩家名字
        local actor = getactor(rid)
        local name = getbaseinfo(actor, "rolename")
        innerData["name"] = name
        --职业
        local career = getbaseinfo(actor, "getbasecareer")
        innerData["career"] = career
        --等级
        local level = getbaseinfo(actor, "level")
        innerData["level"] = level
        --击杀积分
        local score = tonumber(getenvirvar(mapId, WOLF_SOUL_SCORE_KEY .. rid))
        if score == nil then
            score = 0
        end
        innerData["score"] = score
        table.insert(rankList, innerData)
        -- 发邮件
        this.SettleMentReward(actor, repId, rank, success)
    end
    resMsg["list"] = rankList
    resMsg["success"] = success
    -- 还在副本内的玩家，发结算面板
    local mapPlayers = getmapplayer(mapId)
    for _, actor in pairs(mapPlayers) do
        -- 发送消息
        sendluamsg(actor, LuaMessageIdToClient.RES_WOLF_SOUL_SETTLEMENT_PANEL, resMsg)
    end
end

-- @description 发送结算奖励
-- @param 玩家对象；副本配置id；排名；true-成功，false-失败
-- @return
function this.SettleMentReward(actor, repId, rank, success)
    local rewardConfigStr
    if success then
        rewardConfigStr = ConfigDataManager.getTableValue("cfg_wolf_soul", "victoryReward", "repId", repId)
    else
        rewardConfigStr = ConfigDataManager.getTableValue("cfg_wolf_soul", "defeatReward", "repId", repId)
    end
    local rewardConfigList = string.split(rewardConfigStr, "|")
    local itemBing = ConfigDataManager.getTableValue("cfg_bind", "bind", "id", BindConfig.WOLF_SOUL)
    for _, rankReward in pairs(rewardConfigList) do
        local rankSplit = string.split(rankReward, "#")
        local min = tonumber(rankSplit[1])
        local max = tonumber(rankSplit[2])
        local times = (#rankSplit - 2) / 2
        local start = 3
        local itemMap = {}
        for i = 1, times do
            local itemId = tonumber(rankSplit[start])
            local itemCount = tonumber(rankSplit[start + 1])
            if itemId ~= nil then
                itemMap[itemId] = itemCount
            end
            start = start + 2
        end
        local itemId = tonumber(rankSplit[3])
        local itemCount = tonumber(rankSplit[4])
        if min <= rank and rank <= max then
            if success then
                sendconfigmailbyrid(actor, actor:toString(), MailConfig.WOLF_SOUL_SUCCESS, itemMap, rank, itemBing)
            else
                sendconfigmailbyrid(actor, actor:toString(), MailConfig.WOLF_SOUL_FAIL, itemMap, rank, itemBing)
            end
        end
    end
end

-- @description 获取剩余波数
-- @param cfg_repMonster表id
-- @return 次数
function this.GetLeftWaves(repMonCfg)
    local leftWaves = 0
    local flag = true
    while flag do
        local nextId = ConfigDataManager.getTableValue("cfg_repMonster", "nextID", "id", repMonCfg)
        if not tonumber(nextId) then
            flag = false
        else
            repMonCfg = nextId
            leftWaves = leftWaves + 1

            -- 防止出错无限循环
            if leftWaves >= 10000 then
                flag = false
            end
        end
    end
    return leftWaves
end

-- @description 获取指定玩家的积分排名
-- @param 玩家对象；地图id
-- @return 排名
function this.GetPlayerRank(actor, mapId)
    local ranking = this.CalcuPlayerRank(mapId)
    return ranking[actor:toString()]
end

-- @description 获取积分排名列表
-- @param 地图id
-- @return 列表<玩家id字符串；排名>
function this.CalcuPlayerRank(mapId)
    local players = getenvirvar(mapId, DuplicateVarConst.WOLF_SOUL_ALL_PLAYERS)
    local playerList = {}
    for index, actor in ipairs(players) do
        local score = getenvirvar(mapId, WOLF_SOUL_SCORE_KEY .. actor)
        table.insert(playerList, { rid = actor, score = score })
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
    local rank = 1 -- 当前排名

    for i = 1, #playerList do
        local player = playerList[i]
        -- 每次循环都增加排名
        ranks[player.rid] = rank
        rank = rank + 1
    end

    return ranks
end
