--- @class DivineTradeRouteInfo
--- @field gameData DivineTradeRouteGameData 副本数据
--- @field score DivineTradeRouteScoreInfo 积分
--- @field rangeData table<number, DivineTradeRouteInRangeData> 商队附近范围数据
--- @field rankData DivineTradeRankData 积分排名
--- @field dieTimes table<number, number> 死亡次数

--- @class DivineTradeRouteGameData
--- @field stage number 行进阶段
--- @field state number 状态 0-准备 1-进行
--- @field teamMonster number 商队怪物ID
--- @field teamMonsterOwner number 商队归属战盟ID
--- @field teamMonsterOwnerName string 商队归属战盟名称

--- @class DivineTradeRouteScoreInfo
--- @field playerScore table<number, DivineTradeRoutePlayerScore> 个人积分
--- @field unionScore table<number, DivineTradeRouteUnionScore> 联盟积分

--- @class DivineTradeRoutePlayerScore
--- @field id number 唯一ID
--- @field name string 玩家名称
--- @field career number 玩家职业
--- @field score number 积分
--- @field time number 变动时间

--- @class DivineTradeRouteUnionScore
--- @field id number 唯一ID
--- @field name string 玩家名称
--- @field killNum number 击杀数量
--- @field successNum number 成功数量
--- @field score number 积分

--- @class DivineTradeRouteInRangeData
--- @field count number 连续次数
--- @field time number 时间数据

--- @class DivineTradeRankData
--- @field playerRank table<number> 玩家排行数据
--- @field unionRank table<number> 联盟排行数据

DivineTradeRoute = {}
DivineTradeRoute.__index = DivineTradeRoute

local this = {}

this.DuplicateId = 22001
this.state = {
    PREPARE = 0,
    FIGHT = 2,
}
this.faction = {
    ATTACK = 1,
    DEFEND = 2,
}

local function __globalKey()
    return "R$_GLOBAL_DIVINE_TRADE_ROUTE_DATA"
end

-- ----------------------------------------------------------------- --

function DivineTradeRoute.TryEnterDuplicate(actor, duplicateId)
    this.tryEnterDuplicate(actor, duplicateId)
end

function DivineTradeRoute.DupStateUpDate(system, id, state, nextStateStartTime, configId)
    this.dupStateUpDate(system, id, state, nextStateStartTime, configId)
end

function DivineTradeRoute.AfterPlayerEnter(actor, mapId, state, nextTime, configId)
    this.afterPlayerEnter(actor, mapId, state, nextTime, configId)
end

function DivineTradeRoute.DupSecondHeart(mapId, dupConfig, state)
    this.dupSecondHeart(mapId, dupConfig, state)
end

function DivineTradeRoute.isInMap(actor)
    this.isInMap(actor)
end

function DivineTradeRoute.Attack(actor, fightData)
    this.playerAttack(actor, fightData)
end

function DivineTradeRoute.MonsterDie(mapId, killer, monCfgId, monActor)
    this.monsterDie(mapId, killer, monCfgId, monActor)
end

-- ----------------------------------------------------------------- --

function this.tryEnterDuplicate(actor, duplicateId)
    local unionId = getbaseinfo(actor, "unionid")
    if string.tonumber(unionId) < 1 then
        this.info(actor, "还没有加入战盟")
        return
    end

    local level = getbaseinfo(actor, "level")
    if string.tonumber(level) < 400 then
        return
    end

    local ret = DuplicateCommon.CheckEnterConditonCommon(actor, duplicateId)
    if ret ~= EnterLimitResultConst.ALLOW then
        return
    end

    local x, y = DuplicateCommon.GetEnterPointXYCommon(duplicateId)
    local mapId = DuplicateCommon.CreateDupMapCommon(actor, duplicateId, true)

    -- 进入副本
    enterduplicate(actor, mapId, x, y)
end

function this.dupStateUpDate(system, id, state, nextStateStartTime, configId)
    if state == DuplicateState.PREPARE then
        -- initData
        local monsterId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", configId)
        local monsterActors = DuplicateCommon.DupGenMonsterCommon(id, monsterId)
        this.print("神域商路开始刷怪", configId, id, state, monsterActors)

        this.enterNextStage()
    elseif state == DuplicateState.FINISH then
        this.print("神域商路活动结束, 关闭活动")
        closeactivity(DuplicateType.DIVINE_TRADE_ROUTE)
    end
end

function this.afterPlayerEnter(actor, mapId, state, nextTime, configId)
    -- 改变攻击模式
    -- local dupInfo = getduplicate(mapId)
    -- ScriptFightModel.setScriptFightModel(actor)
    --
    -- local flagId = ScriptFightModel.FlagId.DivineTradeRoute
    -- ScriptFightModel.setPlayerFightModelValue(actor, flagId, 1, { 1 })
end

function this.killPlayer(actor, dieActor)
    local rid = string.tonumber(actor:toString())
    local targetRid = string.tonumber(dieActor:toString())
    if rid < 1 or targetRid < 1 then
        return
    end

    -- 改变玩家buff
    local data = DivineTradeRoute.GetGlobal()
    local actorCount = data.fightData[rid]
    data.fightData[rid] = 0
    delbuff(actor, 100001110)

    local dieActorCount = data.fightData[targetRid]
    delbuff(dieActor, 100001110)

    dieActorCount = dieActorCount + 1
    addbuff(dieActor, 100001110)
    data.fightData[targetRid] = dieActorCount
    data:SaveGlobal()
end

function this.dupSecondHeart(mapId, dupConfig, state)
    if state ~= this.state.FIGHT then
        return
    end
    local monsterId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", dupConfig)
    if string.tonumber(monsterId) < 1 then
        return
    end
    local monsters = mapbossinfo(mapId, -1, monsterId)
    if table.isEmpty(monsters) then
        return
    end
    local monster = monsters[1]
    local x = monster.x
    local y = monster.y

    local range = 10
    local actorMap = getobjectinmap(mapId, x, y, range, MapObjectType.PLAYER)
    if table.isEmpty(actorMap) then
        return
    end

    local now = math.floor(tonumber(getbaseinfo("now")) / 1000)
    local countLimit = 5
    local addScore = 1

    local data = DivineTradeRoute.GetGlobal()
    for _, rid in ipairs(actorMap) do
        if not data.rangeData[rid] then
            data.rangeData[rid] = { time = now, count = 0 }
        end
        local rangeData = data.rangeData[rid]
        local curCount = rangeData.count + 1

        if now - rangeData.time == 1 then
            if curCount >= countLimit then
                local actor = getactor(rid)
                data:PlayerModifyScore(actor, addScore)
                curCount = 0
            end
        else
            curCount = 1
        end
        rangeData.time = now
        rangeData.count = curCount
    end
    data:SaveGlobal()
end

function this.playerAttack(actor, fightData)
    if not this.isInMap(actor) then
        return
    end

    local targetActor = fightData["target"]
    local targetType = fightData["targettype"]
    local hurt = string.tonumber(fightData["targethurt"])
    if tonumber(targetType) ~= MapObjectType.MONSTER then
        return
    end

    local data = DivineTradeRoute.GetGlobal()
    data:PlayerModifyScore(actor, 1)
    data:SaveGlobal()
end

function this.isInMap(actor)
    local mapCfgId = getbaseinfo(actor, "mapid")
    local config = ConfigDataManager.getById("cfg_rep", this.DuplicateId)
    if config == nil then
        return false
    end
    if tonumber(config["mapid"]) ~= mapCfgId then
        return false
    end
    return true
end

function this.calculateRank()
    local data = DivineTradeRoute.GetGlobal()
    local scoreMap = data.score.playerScore

    local scoreList = table.values(scoreMap)
    table.sort(scoreList, this.scoreSort)

    local unionScoreMap = data.score.unionScore
    local unionScoreList = table.values(unionScoreMap)
    table.sort(unionScoreList, this.scoreSort)

    data.rankData.playerRank = scoreList
    data.rankData.unionRank = unionScoreList
    data:SaveGlobal()

    this.debug("------ 排序结果 -------", scoreList, unionScoreList)
    return scoreList
end

function this.scoreSort(a, b)
    if a.integral ~= b.integral then
        return b.score < a.score
    else
        return b.time < a.time
    end
end

function this.monsterDie(mapId, killer, monCfgId, monActor)
    if not this.isInMap(monActor) then
        return
    end
    local kunDunMonsterCfgId = ConfigDataManager.getTableValue("cfg_rep", "monster", "id", this.DuplicateId)
    if monCfgId ~= tonumber(kunDunMonsterCfgId) then
        return
    end

    -- 怪物死亡 切换归属
    local data = DivineTradeRoute.GetGlobal()
    local oldUnionId = data.gameData.teamMonsterOwner or 0

    if oldUnionId > 0 then
        local oldUnion = getunioninfo(oldUnionId)
        local memberIds = table.keys(oldUnion.memberinfos)
        for _, memberId in ipairs(memberIds) do
            --TODO 更改攻击模式为攻方
        end
    end

    local unionId = getbaseinfo(killer, "unionid")
    local ownerUnion = getunioninfo(unionId)

    local ownerMemberIds = table.keys(ownerUnion.memberinfos)
    for _, memberId in ipairs(ownerMemberIds) do
        --TODO 更改攻击模式为守方
    end
    data.gameData.teamMonsterOwner = tonumber(unionId)
    data.gameData.teamMonsterOwnerName = ownerUnion.name
    data:SaveGlobal()
end

-- ----------------------------------------------------------------- --
-- DB Function --

function DivineTradeRoute:SaveGlobal()
    this.setCrossGlobalData(__globalKey(), self)
end

---@return DivineTradeRouteInfo
function DivineTradeRoute.GetGlobal()
    local data = this.getCrossGlobalData(__globalKey())
    return setmetatable(data, DivineTradeRoute)
end

function DivineTradeRoute:PlayerModifyScore(actor, scoreChange)
    local now = getbaseinfo("now")
    local rid = tonumber(actor:toString())
    local playerData = self.score.playerScore[rid] or self:buildPlayerData(actor, rid, 0, now)
    playerData.score = math.max(0, playerData.score + scoreChange)

    local unionId = getbaseinfo(actor, "unionid")
    local unionData = self.score.unionScore[unionId] or self:buildPlayerData(unionId, 0, now)
    unionData.score = math.max(0, unionData.score + scoreChange)
end

function DivineTradeRoute:buildPlayerData(id, score, time)
    return { id = id, score = score, time = time }
end

function this.changeDupState(state)
    local data = DivineTradeRoute.GetGlobal()
    data.state = state;
    data:SaveGlobal()
end

function this.enterNextStage()
    local data = DivineTradeRoute.GetGlobal()
    data.stage = data.stage + 1;
    data:SaveGlobal()
end

function this.getCrossGlobalData(key)
    local serverType = string.tonumber(getbaseinfo("servertype"))
    local isCross = serverType == 2 and 1 or nil
    return getsysvar(key, isCross) or {}
end

function this.setCrossGlobalData(key, value)
    setsysvar(key, value, 1)

    -- 同步数据到所有主机
    local hosts = gethosts()
    for _, host in ipairs(hosts) do
        setsysvar(host, key, value)
    end
end

-- ----------------------------------------------------------------- --

this.log_open = true
this.log_name = "[DivineTradeRoute]"

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
    info(actor, ...)
    this.print(...)
end
