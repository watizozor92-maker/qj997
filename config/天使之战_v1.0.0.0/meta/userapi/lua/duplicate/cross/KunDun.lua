KunDun = {}

local dataFunc = {}

local this = {}

--巨龙
local FACTION_TYPE_JL = 1
--猎鹰
--local FACTION_TYPE_LY = 2
--苍狼
local FACTION_TYPE_CL = 3

local KUN_DUN_REP_TYPE = 21001

--昆顿副本玩家数据
KunDun.KUN_DUN_TAG = "R$_CROSS_KUNDUN_DUP"

--昆顿副本状态
local CROSS_STATE_TAG = "G$_CROSS_STATE"
-- 昆顿副本心跳间隔记录
local LAST_HEART_BEAT_TIME = "G$_KUN_DUN_LAST_HEART_MILLS"

local HURT_INTEGRAL_ID = 21001001
local KILL_INTEGRAL_ID = 21001002
local REWARD_ID = 21001003
local RANK_INTEGRAL_ID = 21001006;
local RANK_FLUSH_SECONDS_ID = 21001007;

-- 排行榜最小刷新间隔
local RANK_FLUSH_MIN_SECONDS = 3

KunDun.TaskStage = {
    DEFAULT = 0,
    DUP_FINISH = 1,
    ALL_FINISH = 2,
}

function dataFunc.getCrossGlobalData(key)
    local serverType = string.tonumber(getbaseinfo("servertype"))
    local isCross = serverType == 2 and 1 or nil
    return getsysvar(key, isCross) or {}
end

function dataFunc.setCrossGlobalData(key, value)
    setsysvar(key, value, 1)

    -- 同步数据到所有主机
    local hosts = gethosts()
    for _, host in ipairs(hosts) do
        setsysvar(host, key, value)
    end
end

function dataFunc.getAllKunDunData()
    return dataFunc.getCrossGlobalData(KunDun.KUN_DUN_TAG)
end

function dataFunc.setAllKunDunData(data)
    dataFunc.setCrossGlobalData(KunDun.KUN_DUN_TAG, data)
end

function dataFunc.getAllKunDunPlayerData()
    local data = dataFunc.getAllKunDunData()
    if data ~= nil then
        return data["players"] or {}
    else
        return {}
    end
end

function dataFunc.getKunDunTaskData()
    local data = dataFunc.getAllKunDunData()
    if data ~= nil then
        return data["task"] or {}
    else
        return {}
    end
end

function dataFunc.setKunDunTaskData(taskData)
    local data = dataFunc.getAllKunDunData()
    data["task"] = taskData
    dataFunc.setAllKunDunData(data)
end

function dataFunc.getKunDunPlayerData(actor)
    local id = actor:toString()
    local data = dataFunc.getAllKunDunPlayerData()
    local roleData = data[id]
    if roleData == nil then
        return {}
    else
        return roleData
    end
end

function dataFunc.setKunDunPlayerData(actor, roleData)
    local id = actor:toString()
    local data = dataFunc.getAllKunDunPlayerData()
    data[id] = roleData

    local allData = dataFunc.getAllKunDunData(data)
    allData["players"] = data
    dataFunc.setAllKunDunData(allData)
end

function dataFunc.getKunDunRankData()
    local data = dataFunc.getAllKunDunData()
    return data["rank"] or {}
end

function dataFunc.setKunDunRankData(rankList)
    local data = dataFunc.getAllKunDunData()
    data["rank"] = rankList
    dataFunc.setAllKunDunData(data)
end

function dataFunc.getAllKunDunFactionData()
    local data = dataFunc.getAllKunDunData()
    return data["faction"] or {}
end

function dataFunc.getKunDunFactionData(faction)
    local data = dataFunc.getAllKunDunData()
    local factionData = data["faction"] or {}
    return factionData[faction] or {}
end

function dataFunc.setKunDunFactionData(faction, data)
    local allData = dataFunc.getAllKunDunData()
    local factionData = allData["faction"] or {}
    factionData[faction] = data
    allData["faction"] = factionData
    dataFunc.setAllKunDunData(allData)
end

function dataFunc.getKunDunFactionRankData()
    local data = dataFunc.getAllKunDunData()
    return data["factionRank"] or {}
end

function dataFunc.setKunDunFactionRankData(rank)
    local allData = dataFunc.getAllKunDunData()
    allData["factionRank"] = rank
    dataFunc.setAllKunDunData(allData)
end

function dataFunc.setRankFlushInterval(data)
    setsysvar(LAST_HEART_BEAT_TIME, data)
end

function dataFunc.getRankFlushInterval()
    return getsysvar(LAST_HEART_BEAT_TIME) or 0
end

function dataFunc.addFactionPlayer(faction, rid)
    local data = dataFunc.getAllKunDunData()
    local factionData = data["factionPlayers"] or {}
    local ridList = factionData[faction] or {}
    table.insert(ridList, rid)
    factionData[faction] = ridList
    data["factionPlayers"] = factionData
    dataFunc.setAllKunDunData(data)
end

function dataFunc.getAllFactionPlayers()
    local data = dataFunc.getAllKunDunData()
    return data["factionPlayers"] or {}
end

function dataFunc.getFactionPlayers(faction)
    local data = dataFunc.getAllKunDunData()
    local factionData = data["factionPlayers"] or {}
    return factionData[faction] or {}
end

function KunDun.getKunDunState()
    return dataFunc.getCrossGlobalData(CROSS_STATE_TAG)
end

function KunDun.setKunDunState(start, mapId, x, y)
    local stateData = {
        start = start,
        mapId = mapId,
        x = x,
        y = y
    }
    dataFunc.setCrossGlobalData(CROSS_STATE_TAG, stateData)
end

function KunDun.combine()
    dataFunc.setAllKunDunData(nil)
end

function KunDun.FightModelChange(actor, type, value)
    if not KunDun.isInKunDun(actor) then
        return
    end
    if tonumber(type) ~= 1 then
        return
    end
    if tonumber(value) ~= 13 then
        ScriptFightModel.setScriptFightModel(actor)
    end
end

-- ------------------------------------------------------------- --

function KunDun.sendPanelData(actor, stage, nextTime)
    local resData = {}
    resData["stage"] = stage
    resData["nextStateStartTime"] = nextTime

    local taskData = dataFunc.getKunDunTaskData()
    resData["taskStage"] = taskData["stage"]

    local playerList = KunDun.calculateTop3RankList(actor)
    resData["playerRank"] = playerList

    local factionList = KunDun.calculateFactionRankList()
    resData["factionRank"] = factionList

    this.debug("KunDun.sendPanelData", resData)
    sendluamsg(actor, LuaMessageIdToClient.RES_KUN_DUN_PANEL_INFO, resData)
end

function KunDun.selectFaction()
    local factionData = dataFunc.getAllFactionPlayers()
    if table.isNullOrEmpty(factionData) then
        return math.random(FACTION_TYPE_JL, FACTION_TYPE_CL)
    else
        local minType
        local minCount
        for type = FACTION_TYPE_JL, FACTION_TYPE_CL do
            local players = factionData[type] or {}
            local count = #players
            if minType == nil then
                minType = type
                minCount = count
            else
                if count < minCount then
                    minType = type
                    minCount = count
                end
            end
        end
        return minType
    end
end

--function KunDun.addFactionPlayers(faction)
--    local factionData = KunDun.getFactionData()
--    local count = table.getValue(factionData, faction)
--    if count == nil then
--        count = 0
--    end
--    count = count + 1
--    factionData[faction] = count
--    KunDun.setFactionData(factionData)
--end

function KunDun.getHurtIntegralConfig()
    local integralConfigStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", HURT_INTEGRAL_ID)
    if string.isNullOrEmpty(integralConfigStr) then
        return nil, nil
    end
    local items = string.split(integralConfigStr, "#")
    local hurtHpPercent = tonumber(items[1])
    local integral = tonumber(items[2])
    return hurtHpPercent, integral
end

function KunDun.getKillIntegralConfig()
    local integralConfigStr = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", KILL_INTEGRAL_ID)
    if integralConfigStr == nil then
        return nil
    end
    return tonumber(integralConfigStr)
end

function KunDun.getRankIntegralLimit()
    local integral = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RANK_INTEGRAL_ID)
    if integral == nil then
        return nil
    end
    return tonumber(integral)
end

function KunDun.getRewardConfig(rank)
    local rewardString = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", REWARD_ID)
    if string.isNullOrEmpty(rewardString) then
        return
    end
    local rewardRanks = string.split(rewardString, "|")
    for _, rankRewardStr in pairs(rewardRanks) do
        local items = string.split(rankRewardStr, "#")
        if #items > 2 then
            local startRank = tonumber(items[1])
            local endRank = tonumber(items[2])
            if startRank <= rank and endRank >= rank then
                local index = 3
                local itemMap = {}
                while index <= #items do
                    local itemId = tonumber(items[index])
                    local itemCount = tonumber(items[index + 1])
                    itemMap[itemId] = itemCount
                    index = index + 2
                end
                return itemMap
            end
        end
    end
    return nil
end

function KunDun.isInKunDun(actor)
    local mapCfgId = getbaseinfo(actor, "mapid")
    local config = ConfigDataManager.getById("cfg_rep", KUN_DUN_REP_TYPE)
    if config == nil then
        return false
    end
    if tonumber(config["mapid"]) ~= mapCfgId then
        return false
    end
    local state = KunDun.getKunDunState()
    if state ~= nil and state.start then
        return true
    else
        return false
    end
end

function KunDun.addIntegralByHurt(actor, maxHP, totalHurt)
    local now = tonumber(getbaseinfo("now"))
    local hurtHpPercent, integral = KunDun.getHurtIntegralConfig()

    local newIntegral = math.floor(totalHurt / (maxHP * hurtHpPercent / 10000)) * integral

    -- 获取个人记录
    local roleData = dataFunc.getKunDunPlayerData(actor)
    local oldIntegral = roleData["integral"] or 0

    -- 更新个人记录
    roleData["integral"] = newIntegral
    roleData["arrivalTime"] = now
    dataFunc.setKunDunPlayerData(actor, roleData)

    -- 计算阵营积分的差值
    local integralDiff = newIntegral - oldIntegral

    -- 更新阵营记录
    local faction = roleData["faction"]
    local factionData = dataFunc.getKunDunFactionData(faction)
    local factionTotal = factionData["integral"] or 0
    factionData["integral"] = factionTotal + integralDiff
    factionData["arrivalTime"] = now
    dataFunc.setKunDunFactionData(faction, factionData)
    return roleData
end

function KunDun.MonsterDie(mapId, _, monCfgId, monActor)
    if not KunDun.isInKunDun(monActor) then
        return
    end
    local config = ConfigDataManager.getById("cfg_rep", KUN_DUN_REP_TYPE)
    local kunDunMonsterCfgId = tonumber(config["monster"])
    if monCfgId ~= kunDunMonsterCfgId then
        return
    end

    -- 更新阶段 怪物已被击杀
    local taskData = dataFunc.getKunDunTaskData()
    taskData["stage"] = KunDun.TaskStage.DUP_FINISH
    dataFunc.setKunDunTaskData(taskData)
    -- this.debug("------ 更改交易行状态 -----", taskData, dataFunc.getKunDunTaskData(), dataFunc.getAllKunDunData())

    -- 个人积分重新排名
    local integralList = KunDun.calculatePlayerRankList()
    dataFunc.setKunDunRankData(integralList)

    -- 结算个人奖励
    for i = 1, #integralList do
        local integralItem = integralList[i]
        local id = integralItem["id"]
        local rewardMap = KunDun.getRewardConfig(i)
        this.debug(" --- integralItem --- ", integralItem, rewardMap, i)
        if not table.isNullOrEmpty(rewardMap) then
            local playerActor = getactor(id, mapId)

            local title = "昆顿入侵"
            local content = "恭喜您在" .. title .. "活动中排名第" .. i
            sendmailbyrid(playerActor, id, title, content, rewardMap)
        end
    end

    -- 阵营积分重新排名
    local factionList = KunDun.calculateFactionRankList()
    dataFunc.setKunDunFactionRankData(factionList)

    -- 结束活动
    setduplicatestate(mapId, SetDuplicateStateConst.TO_FINISH)

    -- 拍卖行上架道具
    KunDunAuction.Publish()
end

function KunDun.calculatePlayerRankList()
    local integralList = {}
    local allPlayerData = dataFunc.getAllKunDunPlayerData()
    local integralLimit = KunDun.getRankIntegralLimit()
    for id, playerData in pairs(allPlayerData) do
        local integral = playerData["integral"] or 0
        local arrivalTime = playerData["arrivalTime"] or 0
        if integral >= integralLimit then
            local actor = getactor(id)
            local name = getbaseinfo(actor, "rolename")
            table.insert(integralList,
                { ["id"] = id, ["name"] = name, ["integral"] = integral, ["arrivalTime"] = arrivalTime })
        end
    end

    table.sort(integralList, this.integralSortFunc)
    return integralList
end

function this.integralSortFunc(a, b)
    if a.integral ~= b.integral then
        return b.integral < a.integral
    else
        return b.arrivalTime < a.arrivalTime
    end
end

function KunDun.calculateFactionRankList()
    local integralList = {}
    local allData = dataFunc.getAllKunDunFactionData()

    for faction, factionData in pairs(allData) do
        local integral = factionData["integral"] or 0
        local arrivalTime = factionData["arrivalTime"] or 0
        table.insert(integralList, { ["faction"] = faction, ["integral"] = integral, ["arrivalTime"] = arrivalTime })
    end
    table.sort(integralList, this.integralSortFunc)
    return integralList
end

function KunDun.calculateTop3RankList(actor)
    local playerTopList = {}
    local rid = actor == nil and 0 or string.tonumber(actor:toString())
    local ridIndex
    local rankList = dataFunc.getKunDunRankData()
    for i, v in ipairs(rankList) do
        if v.id == rid then
            ridIndex = i
            break
        end
    end

    for i = 1, math.min(3, #rankList) do
        table.insert(playerTopList, rankList[i])
    end

    if ridIndex and ridIndex > 3 then
        table.insert(playerTopList, rankList[ridIndex])
    end
    return playerTopList
end

function KunDun.KillPlayer(actor, diePlayer)
    if not KunDun.isInKunDun(actor) then
        return
    end
    jprint("------- 开始调用 l_kun_dun_player_killer_func -------")
    callonserial(actor, "l_kun_dun_player_killer_func", diePlayer)
end

function KunDun.Attack(actor, fightData)
    if not KunDun.isInKunDun(actor) then
        return
    end
    local targetActor = fightData["target"]
    local targetType = fightData["targettype"]
    if tonumber(targetType) ~= MapObjectType.MONSTER then
        return
    end
    local hurt = fightData["targethurt"]
    jprint("------- 开始调用 l_kun_dun_player_attack_func -------")
    callonserial(actor, "l_kun_dun_player_attack_func", targetActor, hurt)
end

function KunDun.EnterKunDun(actor, _)
    local stateData = KunDun.getKunDunState()
    jprint("昆顿副本，stateData", stateData)
    if stateData == nil then
        this.info(actor, "活动未开启")
        return
    end
    local start = stateData.start
    if start ~= 1 then
        this.info(actor, "活动未开启。")
        return
    end

    local mapId = stateData.mapId
    local x = stateData.x
    local y = stateData.y

    local kunDunData = dataFunc.getKunDunPlayerData(actor)
    --处理阵营
    local faction = table.getValue(kunDunData, "faction")
    if faction == nil then
        faction = KunDun.selectFaction()
        kunDunData["faction"] = faction
        dataFunc.setKunDunPlayerData(actor, kunDunData)
        dataFunc.addFactionPlayer(faction, tonumber(actor:toString()))
    end

    --进入副本
    local configId = KUN_DUN_REP_TYPE
    local dupCheck = DuplicateCommon.CheckEnterConditonCommon(actor, configId)
    this.debug("----- dup check ------", configId, dupCheck)
    if dupCheck ~= EnterLimitResultConst.ALLOW then
        this.info(actor, "不满足进入副本条件")
        return
    end
    enterduplicate(actor, mapId, x, y)
end

function KunDun.DupStateUpdate(system, id, state, nextStateStartTime, configId)
    local now = getbaseinfo("now")
    local dupInfo = getduplicate(id)
    local players = table.getValue(dupInfo, "players")

    if state == DuplicateState.PREPARE then
        jprint("【昆顿】副本开始", configId, id, state)
    elseif state == DuplicateState.FIGHT then
        --战斗阶段，刷怪
        local monsterId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", configId)
        local monsterActors = DuplicateCommon.DupGenMonsterCommon(id, monsterId)
        jprint("【昆顿】战斗阶段开始刷怪", configId, id, state, monsterActors)

        -- 更新阶段 怪物已被创建
        local taskData = dataFunc.getKunDunTaskData()
        taskData["stage"] = KunDun.TaskStage.DEFAULT
        dataFunc.setKunDunTaskData(taskData)
    elseif state == DuplicateState.FINISH then
        jprint("【昆顿】副本结束", configId, id, state)
        closeactivity(DuplicateType.KUN_DUN)
    end
end

function KunDun.AfterEnterKunDun(actor, _, state, nextStateStartTime, _)
    KunDun.sendPanelData(actor, state, nextStateStartTime)

    local faction = KunDun.getKunDunViewData(actor)
    SceneMap.sendEnterViewInfoByType(actor, SceneMap.viewKey.KUN_DUN_FACTION, faction)

    -- 更改攻击模式
    ScriptFightModel.setScriptFightModel(actor)

    local flagId = ScriptFightModel.FlagId.KunDun
    ScriptFightModel.setPlayerFightModelValue(actor, flagId, faction, { faction })
end

--function KunDun.getKunDunViewData(actor)
--    local data = {}
--    local rid = tonumber(actor:toString())
--    local rank = 0;
--
--    local roleData = dataFunc.getKunDunPlayerData(actor)
--    data['faction'] = roleData["faction"]
--
--    local playerList = KunDun.calculateTop3RankList(actor)
--    for i, v in pairs(playerList) do
--        if v.id == rid then
--            rank = i
--            break
--        end
--    end
--    data['rank'] = rank
--    return data
--end

function KunDun.getKunDunViewData(actor)
    local roleData = dataFunc.getKunDunPlayerData(actor)
    return roleData["faction"]
end

function KunDun.start()
    -- 清理上次昆顿副本内容
    dataFunc.setAllKunDunData(nil)

    local configId = KUN_DUN_REP_TYPE
    --寻找是否有可进入的副本，如果没有创建副本
    local nullActor = getactor(0, 0)
    local mapId = DuplicateCommon.CreateDupMapCommon(nullActor, configId, true)
    local x, y = DuplicateCommon.GetEnterPointXYCommon(configId)
    jprint("昆顿副本开始", mapId, x, y)
    KunDun.setKunDunState(1, mapId, x, y)
end

function KunDun.stop()
    KunDun.setKunDunState(0, 0, 0, 0)
end

function KunDun.Run(action)
    local serverType = getbaseinfo("servertype")
    if serverType ~= 2 then
        return
    end
    if tonumber(action) == 1 then
        KunDun.start()
    elseif tonumber(action) == 0 then
        KunDun.stop()
    end
end

function KunDun.DupSecondHeart(mapId, dupConfig, state)
    local stateData = KunDun.getKunDunState() or {}
    local start = stateData.start or 0
    if start ~= 1 then
        return
    end

    if state ~= DuplicateState.FIGHT then
        return
    end

    local now = tonumber(getbaseinfo("now"))
    local intervalData = dataFunc.getRankFlushInterval()
    if intervalData < 1 then
        local configLimit = ConfigDataManager.getTableValue("cfg_repGlobal", "value", "id", RANK_FLUSH_SECONDS_ID)
        local interval = math.max(tonumber(configLimit), RANK_FLUSH_MIN_SECONDS)
        intervalData = interval
        dataFunc.setRankFlushInterval(intervalData)
    end

    -- X秒一次
    if math.floor((now / 1000) % intervalData) ~= 0 then
        return
    end

    -- 心跳刷新排行榜
    local rankList = KunDun.calculatePlayerRankList()
    dataFunc.setKunDunRankData(rankList)
    this.sendPanelRankData()
end

function this.sendPanelRankData()
    local resData = {}

    local factionList = KunDun.calculateFactionRankList()
    resData["factionRank"] = factionList

    local playerData = dataFunc.getAllKunDunPlayerData()

    for rid, _ in pairs(playerData) do
        local actor = getactor(rid)
        if KunDun.isInKunDun(actor) then
            local playerList = KunDun.calculateTop3RankList(actor)
            resData["playerRank"] = playerList

            sendluamsg(actor, LuaMessageIdToClient.RES_KUN_DUN_PANEL_INFO, resData)
        end
    end
end

-- ------------------------------------------------------------- --

function l_kun_dun_player_attack_func(actor, targetActor, hurt)
    jprint("------- 结束调用 l_kun_dun_player_attack_func -------")
    local roleData = dataFunc.getKunDunPlayerData(actor)
    local totalHurt = roleData["hurt"] or 0
    totalHurt = totalHurt + hurt

    local maxHP = getattrinfo(targetActor, "maxHP")
    roleData = KunDun.addIntegralByHurt(actor, maxHP, totalHurt)
    roleData["hurt"] = totalHurt
    dataFunc.setKunDunPlayerData(actor, roleData)
end

function l_kun_dun_player_killer_func(actor, dieActor)
    jprint("------- 结束调用 l_kun_dun_player_killer_func -------")
    local addIntegralPercent = KunDun.getKillIntegralConfig() / 10000
    local dieRoleData = dataFunc.getKunDunPlayerData(dieActor)
    local dieRoleIntegral = dieRoleData["integral"] or 0
    if dieRoleIntegral <= 0 then
        return
    end
    local plunderIntegral = math.floor(dieRoleIntegral * addIntegralPercent)
    local now = getbaseinfo("now")

    -- 个人数据
    dieRoleData["integral"] = dieRoleIntegral - plunderIntegral
    dataFunc.setKunDunPlayerData(dieActor, dieRoleData)

    local selfRoleData = dataFunc.getKunDunPlayerData(actor)
    selfRoleData["integral"] = (selfRoleData["integral"] or 0) + dieRoleIntegral
    selfRoleData["arrivalTime"] = now
    dataFunc.setKunDunPlayerData(actor, selfRoleData)

    -- 阵营数据
    local dieFactionData = dataFunc.getKunDunFactionData(dieRoleData["faction"])
    dieFactionData["integral"] = dieFactionData["integral"] - plunderIntegral
    dataFunc.setKunDunFactionData(dieRoleData["faction"], dieFactionData)

    local selfFactionData = dataFunc.getKunDunFactionData(selfRoleData["faction"])
    selfFactionData["integral"] = (selfFactionData["integral"] or 0) + dieRoleIntegral
    selfFactionData["arrivalTime"] = now
    dataFunc.setKunDunFactionData(selfRoleData["faction"], selfFactionData)
end

-- ------------------------------------------------------------- --

KunDunAuction = {}

local aucDbFunc = {}

local function __AuctionDbKey()
    return "R$_CROSS_GLOBAL_KUN_DUN_AUCTION_DATA"
end

local function _flushTime()
    return 5
end

local function _stallWay()
    return 1
end

local AucMailConst = {
    SUCCESS = 910001,
    FAIL = 910002,
    A_BONUS = 910003
}

function KunDunAuction.ontimer()
    this.onTimer()
end

function KunDunAuction.Publish()
    jprint("----------- 1")
    callonserial("l_kundun_auction_publish_goods")
end

function KunDunAuction.PlayerBidding(actor, msgData)
    callonserial("l_kun_dun_auction_player_bidding", actor, msgData)
end

function KunDunAuction.login(actor)
    this.sendAuctionPanelData(actor)
end

-- 
function l_kundun_auction_publish_goods()
    jprint("------------ 2")
    if not this.auctionIsOpen() then
        return
    end
    jprint("------------ 3")

    local configList = ConfigDataManager.getTable("cfg_stall", 'way', _stallWay())
    if table.isEmpty(configList) then
        return
    end

    local now = getbaseinfo("now")
    local goodsMap = {}
    for _, config in pairs(configList) do
        local probability = string.tonumber(config["probability"])
        local cfgid = tonumber(config['id'])
        local count = tonumber(config['number'])

        if probability > 0 then
            local num = math.random(1, 10000)
            if probability < num then
                goto continue
            end
        end

        local goodsInfo = createitemsbymap({ [cfgid] = count })
        if table.isEmpty(goodsInfo) then
            goto continue
        end

        local endTime = now + tonumber(config['time']) * 60 * 1000
        for _, goods in pairs(goodsInfo) do
            goods['bidderId'] = 0
            goods['startTime'] = now
            goods['endTime'] = endTime
            goods['price'] = tonumber(config["startingprice"])
            goods['coinType'] = tonumber(config['money'])
            goods['fixedPrice'] = tonumber(config['fixedprice'])
            goods['auction'] = tonumber(config['auction'])
            goods['addTimes'] = tonumber(config['addtime'])
            goodsMap[goods['id']] = goods
        end
        :: continue ::
    end

    this.debug("---- 拍卖行上架道具 -----", goodsMap)
    aucDbFunc.setPublishGoods(goodsMap)
    GlobalTimer.setontimerex(TimerIds.KUN_DUN_AUCTION, _flushTime())

    local goods = aucDbFunc.getPublishGoods()
    this.sendOnLinePlayerPanel(this.sendAuctionPanelData, goods)
end

function l_kun_dun_auction_player_bidding(actor, msgData)
    local goodsId = string.tonumber(msgData['goodsId'])
    if goodsId < 1 then
        return
    end
    if not this.auctionIsOpen() then
        this.info(actor, "拍卖未开启")
        return
    end
    if not this.isParticipate(actor) then
        this.info(actor, "您未参与昆顿活动")
        return
    end

    local goodsMap = aucDbFunc.getPublishGoods()
    local goods = goodsMap[goodsId]
    if table.isEmpty(goods) then
        this.info(actor, "该商品已被购买或已下架")
        return
    end
    local now = getbaseinfo("now")
    local endTime = goods['endTime']
    if endTime < now then
        this.info(actor, "该商品已下架")
        return
    end

    local buyNow = string.tonumber(msgData['type']) == 1
    local rid = tonumber(actor:toString())
    local lastBidder = goods['bidderId']
    if not buyNow and lastBidder == rid then
        this.info(actor, "您已参与竞拍, 请勿重复参与")
        return
    end
    local bidPrice = goods["price"]

    local fixedPrice = tonumber(goods['fixedprice'])
    local newPrice = buyNow and fixedPrice or this.calculateNewPrice(goods)

    local coinType = goods['coinType']
    local coinCount = getbagitemcountbyid(actor, coinType)
    if coinCount < newPrice then
        this.info(actor, "资源不足, 无法竞拍")
        return
    end

    removeitemfrombag(actor, coinType, newPrice, 0, 9999, "昆顿竞拍")
    goods['bidderId'] = rid
    goods['price'] = newPrice

    -- 一口价进入结算阶段
    if buyNow or newPrice == fixedPrice then
        this.toSettleAuction(goods)
        -- 结算并清理缓存
        goodsMap[goodsId] = nil
        goods['endTime'] = 0
    else
        -- 增加时间 保存变动内容
        local finalTime = goods["addTimes"] * 1000 + endTime
        goods["endTime"] = finalTime
        goodsMap[goodsId] = goods
    end
    aucDbFunc.setPublishGoods(goodsMap)

    -- 返还上个竞拍玩家道具
    if lastBidder > 0 then
        this.bidFailMail(lastBidder, goodsId, coinType, bidPrice)
    end
    local result = { ["result"] = true, ["goods"] = goods }
    this.sendOnLinePlayerPanel(this.sendAuctionResult, result)
end

function this.sendAuctionResult(actor, result)
    sendluamsg(actor, LuaMessageIdToClient.RES_KUN_DUN_AUCTION_BUY_RESULT, result)
end

-- ------------------------------------------------------------- --

function this.sendAuctionPanelData(actor, goods)
    local data = {}
    if goods == nil then
        goods = aucDbFunc.getPublishGoods()
    end
    this.debug("---- 发送拍卖行面板数据 -----", goods, this.auctionIsOpen(), this.isParticipate(actor))
    if this.auctionIsOpen() and this.isParticipate(actor) and table.notEmpty(goods) then
        data['isOpen'] = true
        data['goods'] = goods
    else
        data['isOpen'] = false
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_KUN_DUN_AUCTION_PANEL_INFO, data)
end

function this.sendOnLinePlayerPanel(func, resData)
    local data = dataFunc.getAllKunDunPlayerData()
    this.debug("---- 获取所有玩家数据 -----", resData, data)
    for rid, _ in pairs(data) do
        local actor = getactor(rid)
        local onlineState = tonumber(getbaseinfo(actor, "onlinestate"))
        if onlineState == 1 then
            func(actor, resData)
        end
    end
end

function this.bidFailMail(bidderId, goodsId, costType, costNum)
    local itemName = ConfigDataManager.getTableValue("cfg_item", "name", "id", goodsId)
    local costName = ConfigDataManager.getTableValue("cfg_item", "name", "id", costType)
    local param = itemName .. "#" .. costName
    local actor = getactor(bidderId)
    sendconfigmailbyrid(actor, bidderId, AucMailConst.FAIL, { [costType] = costNum }, param)
end

function this.calculateNewPrice(goods)
    local bidPrice = goods["price"]
    local auction = goods["auction"]
    local fixedPrice = goods["fixedPrice"]
    local newPrice = math.ceil(bidPrice * (1 + auction * 0.0001))
    this.debug("---- 拍卖行计算价格 -----", goods, bidPrice, auction, "|", "fixedPrice", fixedPrice, "newPrice", newPrice)

    return math.min(newPrice, fixedPrice)
end

function this.onTimer()
    local goodsData = aucDbFunc.getPublishGoods()
    -- this.debug("---- 拍卖行定时器 -----", goodsData)
    if table.notEmpty(goodsData) then
        local clearIdList = {}
        local now = string.tonumber(getbaseinfo("now"))
        for goodsId, goods in pairs(goodsData) do
            local endTime = goods["endTime"]
            if endTime < now then
                table.insert(clearIdList, goodsId)
            end
        end

        -- this.debug("---- 需要清理的拍卖行道具 -----", clearIdList)

        -- 结算到期竞拍道具
        for _, goodsId in pairs(clearIdList) do
            local goods = goodsData[goodsId]
            this.toSettleAuction(goods)
            goodsData[goodsId] = nil
        end
        aucDbFunc.setPublishGoods(goodsData)
    end

    -- 没有物品后关闭定时器
    if table.isEmpty(goodsData) then
        GlobalTimer.setofftimer(TimerIds.KUN_DUN_AUCTION)
    end
end

function this.toSettleAuction(goods)
    if table.isEmpty(goods) then
        return
    end
    local buyerId = goods['bidderId']
    if buyerId < 1 then
        return
    end

    -- 发放拍卖道具
    local buyer = getactor(buyerId)

    local mailConfig = ConfigDataManager.getById("cfg_mail", AucMailConst.SUCCESS)
    if table.notEmpty(mailConfig) then
        local title = mailConfig['title']
        local content = mailConfig['content']
        local itemName = ConfigDataManager.getTableValue("cfg_item", "name", "id", goods['cfgid'])
        content = string.format(content, itemName)
        sendmailbycompleteitems(buyer, buyerId, title, content, { goods })
    end

    -- 分红名单
    local ridList = {}

    -- 是否为稀有道具
    local rareItem = false
    if rareItem then
        local rankData = dataFunc.getKunDunFactionRankData()
        local faction = rankData[1]['faction']
        ridList = dataFunc.getFactionPlayers(faction)
    else
        local allPlayer = dataFunc.getAllKunDunPlayerData()
        for rid, _ in pairs(allPlayer) do
            table.insert(ridList, rid)
        end
    end

    local buyerName = getbaseinfo(buyer, "rolename")
    this.debug("---- 拍卖结算 ----", goods, buyerId, buyerName, "-- 分红名单 --", ridList)

    local cfgId = goods['cfgid']
    local coinType = goods['coinType']
    local price = goods['price']

    local taxStr = ConfigDataManager.getTableValue("cfg_stall", "tax", "id", cfgId, "way", _stallWay())
    this.debug("config_data", cfgId, _stallWay(), taxStr)
    local aBonus = this.calculationTax(price, taxStr)
    local getABonus = math.round(aBonus / #ridList)

    -- 发送邮件
    local reward = { [coinType] = aBonus }
    -- 解析文本配置
    local itemName = ConfigDataManager.getTableValue("cfg_item", "name", "id", cfgId)
    local priceTypeName = ConfigDataManager.getTableValue("cfg_item", "name", "id", coinType)

    local param = itemName .. "#" .. priceTypeName .. "#" .. aBonus .. "#" .. getABonus
    for _, rid in pairs(ridList) do
        if tonumber(rid) ~= buyerId then
            local player = getactor(rid)
            sendconfigmailbyrid(player, rid, AucMailConst.A_BONUS, reward, param)
        end
    end
end

-- 计算税率
function this.calculationTax(price, taxStr)
    local tableTax = {}
    string.putIntIntMap(tableTax, taxStr)
    local deleteRate = tableTax[1]
    this.debug("---- 拍卖行税率 ----", price, taxStr, tableTax)
    local totalPrice = math.round(price * (100 - deleteRate) / 100)

    local deleteCount = tableTax[2]
    totalPrice = totalPrice - deleteCount
    return totalPrice
end

function this.auctionIsOpen()
    -- boss被击杀才开启
    local taskData = dataFunc.getKunDunTaskData()
    return taskData["stage"] == KunDun.TaskStage.DUP_FINISH
end

function this.isParticipate(actor)
    -- 参与了活动
    local data = dataFunc.getKunDunPlayerData(actor)
    return table.notEmpty(data)
end

function aucDbFunc.getAuctionData()
    return dataFunc.getCrossGlobalData(__AuctionDbKey())
end

function aucDbFunc.setAuctionData(data)
    dataFunc.setCrossGlobalData(__AuctionDbKey(), data)
end

function aucDbFunc.getPublishGoods()
    local data = aucDbFunc.getAuctionData()
    return data['publishgoods'] or {}
end

function aucDbFunc.setPublishGoods(goodsData)
    local data = aucDbFunc.getAuctionData()
    data['publishgoods'] = goodsData
    aucDbFunc.setAuctionData(data)
end

-- ------------------------------------------------------------- --

this.log_open = false
this.log_name = "[KunDun]"

function this.debug(...)
    if not this.log_open then
        return
    end
    gameDebug.print(this.log_name, ...)
end

function this.print(...)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(this.log_name, ...)
end

function this.info(actor, ...)
    tipinfo(actor, ...)
    this.print(...)
end

-- ------------------------------------------------------------- --

-- 注册登录事件
LoginEventListerTable:eventLister("0", "昆顿入侵", KunDunAuction.login)
