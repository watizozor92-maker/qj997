-- 怪物来袭活动
MonAtk = {}
local this = {}
local MONSTER_ATTACK_INFO_KEY = "G$MONSTER_ATTACK_INFO"
local ITEM_PICK_COUNT_KEY = "J$_ITEM_PICK_COUNT"
local DROP_INFO_KEY = "Q$_DROP_INFO_KEY"

-- 怪物来袭活动ID缓存
local MonAtkActivityIdsCache = {}
-- 怪物来袭[怪物ID - 活动ID] 缓存
local MonCfgId2ActivityIdCache = {}


local MonAtkActData = {}
MonAtkActData.__index = MonAtkActData
function MonAtkActData.new(activityId)
    local self = setmetatable({}, MonAtkActData)
    self.activityId = activityId
    self.monList = {}
    return self
end

function MonAtkActData:save()
    setsysvar(MONSTER_ATTACK_INFO_KEY .. self.activityId, self)
end

function MonAtkActData:clear()
    self.monList = {}
end


function MonAtkActData.get(activityId)
    local data = getsysvar(MONSTER_ATTACK_INFO_KEY .. activityId) or {}
    local instance = MonAtkActData.new(activityId)
    instance.monList = data.monList or {}
    setmetatable(instance, MonAtkActData)
    return instance
end


function MonAtk.isMonAtkActivity(activityId)
    if table.count(MonAtkActivityIdsCache) <= 0 then
        local configList = ConfigDataManager.getList("cfg_monster_attack")
        local t = {}
        for _, config in pairs(configList) do
            local actId = tonumber(config.ruleid)
            t[actId] = actId
        end
        MonAtkActivityIdsCache = t
    end
    return MonAtkActivityIdsCache[activityId] ~= nil
end




function this.getActivityIdByMonCfgId(monsterCfgId)
    monsterCfgId     = tonumber(monsterCfgId)
    local activityId = MonCfgId2ActivityIdCache[monsterCfgId]
    if activityId == nil then
        local value = ConfigDataManager.getTableValue("cfg_monster_attack", "ruleId", "monid", monsterCfgId)
        local numValue = string.tonumber(value)
        if numValue ~= nil and numValue > 0 then
            activityId = numValue
            MonCfgId2ActivityIdCache[monsterCfgId] = activityId
        end
    end
    return activityId
end


function this.isMonsterAttacking()
    local allActivity = getallactivities()
    for _, actInfo in pairs(allActivity) do
        if actInfo.open then
            if MonAtk.isMonAtkActivity(actInfo.activityid) then
                return true
            end
        end
    end
    return false
end




function this.getAttackConfig(actId)
    local configList = ConfigDataManager.getList("cfg_monster_attack")
    local result = {}
    for _, config in pairs(configList) do
        local ruleId = config["ruleid"]
        local items = string.split(ruleId, "#")

        if (table.contains(items, actId)) then
            table.insert(result, config)
        end
    end
    return result
end

function this.monsterGen(monsterAttackInfo, config)
    local mapCfgId = config["mapid"]
    local lineId = config["line"]
    local monsterid = config["monid"]
    local coordinates = config["poz"]
    local range = config["range"]
    local count = 1
    local xy = string.split(coordinates, "#")
    local lines = string.split(lineId, "#")
    local x = xy[1]
    local y = xy[2]

    -- 随机一条线路
    local line = lines[math.random(#lines)]
    local mapId = gamemap.getMapKey(mapCfgId, line)
    --生成怪物
    local monActorList = mongen(mapId, x, y, range, monsterid, count)
    if table.isNullOrEmpty(monActorList) then
        error("怪物来袭活动，创建怪物失败！cfgId:"..config.id)
    else
        for _, mactor in pairs(monActorList) do
            local monsterUid = mactor:toString()
            local monsterInfo = {
                mapId = mapId,
                monsterId = monsterid,
                invalid = false,
            }
            monsterAttackInfo[monsterUid] = monsterInfo
        end
    end
end

function MonAtk.reqMonsterInfo(actor, monsterCfgId)
    local result = {}
    local activityId = this.getActivityIdByMonCfgId(monsterCfgId)
    local monAtkData = MonAtkActData.get(activityId)
    for id, m in pairs(monAtkData.monList) do
        local invalid = table.getValue(m, "invalid")
        if not invalid then
            local mapId = table.getValue(m, "mapId")
            local mid = table.getValue(m, "monsterId")
            local mapCfgId, mapLine = gamemap.parseMapKey(mapId)
            if tostring(mid) == tostring(monsterCfgId) then
                table.insert(result, {
                    monsterid = mid,
                    mapid = mapId,
                    mapCfgId = mapCfgId,
                    mapLine = mapLine,
                })
            end
        end
    end
    sendluamsg(actor, LuaMessageIdToClient.MONSTER_ATTACK_BOSS_INFO, result)
end


function this.start(actId)
    local configs = this.getAttackConfig(tostring(actId))
    if table.isNullOrEmpty(configs) then
        error("怪物来袭活动未找到活动配置表，activityId:" .. actId)
        return
    end

    local monAtkData =  MonAtkActData.get(actId)
    if table.count(monAtkData.monList) > 0 then
        error("怪物来袭活动上次活动数据未清除，activityId:" .. actId, monAtkData)
        this.stop(actId)
        monAtkData = MonAtkActData.get(actId)
    end

    local monsterAttackInfo = monAtkData.monList
    for _, value in pairs(configs) do
        this.monsterGen(monsterAttackInfo, value)
    end
    monAtkData:save()
end

function this.stop(activityId)
    -- 移除怪物
    local monAtkData = MonAtkActData.get(activityId)
    local monList = monAtkData.monList
    if table.count(monList) > 0 then
        for monId, monInfo in pairs(monList) do
            local mapId = monInfo.mapId
            local monActor = getactor(monId, mapId)
            removemapobject(monActor)
            local rids = getinmonsterthreatrids(monActor, monId)
            if not table.isNullOrEmpty(rids) then
                for index, rid in pairs(rids) do
                    -- 给正在打怪物的玩家发送tips
                    local actor = getactor(rid, mapId)
                    noticeTip.noticeinfo(actor, StringIdConst.TEXT50001)
                end
            end
        end
    end
    monAtkData:clear()
    monAtkData:save()
end


function MonAtk.run(activityId, action)
    if tonumber(action) == 1 then
        this.start(activityId)
    elseif tonumber(action) == 0 then
        this.stop(activityId)
    end
end

function this.getDropInfo()
    local dropInfo = getsysvar(DROP_INFO_KEY)
    if dropInfo == nil then
        dropInfo = {}
    end
    return dropInfo
end

function this.setDropInfo(dropInfo)
    setsysvar(DROP_INFO_KEY, dropInfo)
end

function MonAtk.monsterDieDrop(actor, dropData)
    local monsterUid = tostring(table.getValue(dropData, "monsterid"))
    local monsterCfgId = dropData.monstercfgid
    local activityId = this.getActivityIdByMonCfgId(monsterCfgId)
    if activityId == nil then
        return
    end
    local monAtkData = MonAtkActData.get(activityId)
    local monsterAttackInfo = monAtkData.monList
    local monsterItem = monsterAttackInfo[monsterUid]
    if table.isNullOrEmpty(monsterItem) then
        return
    end

    local dropItems = table.getValue(dropData, "dropitems")

    local dropInfo = this.getDropInfo()

    local dropTime = getbaseinfo("now")
    for _, dropItem in pairs(dropItems) do
        local id = table.getValue(dropItem, "id")
        local cfgId = table.getValue(dropItem, "cfgid")
        local count = table.getValue(dropItem, "count")
        local dataItem = {
            cfgid = cfgId,
            count = count,
            droptime = dropTime
        }
        dropInfo[tostring(id)] = dataItem
    end
    this.setDropInfo(dropInfo)
end

function MonAtk.pickUpItem(actor, items)
    if not this.isMonsterAttacking() then
        return nil
    end

    if table.isNullOrEmpty(items) then
        return nil
    end
    for _, item in pairs(items) do
        local itemId = item["id"]
        --只处理第一项即可
        return this.checkPickUpItem(actor, itemId)
    end
    return nil
end

function this.addTodayPickUpCount(actor, itemId, itemCount)
    local pickCountInfo = getplaydef(actor, ITEM_PICK_COUNT_KEY)
    if pickCountInfo == nil then
        pickCountInfo = {}
    end
    local strItemId = tostring(itemId)
    local count = table.getValue(pickCountInfo, strItemId)
    if count == nil then
        count = 0
    end
    count = count + tonumber(itemCount)
    pickCountInfo[strItemId] = count
    setplaydef(actor, ITEM_PICK_COUNT_KEY, pickCountInfo)
end

function this.getTodayPickCount(actor, itemId)
    local pickCountInfo = getplaydef(actor, ITEM_PICK_COUNT_KEY)
    if pickCountInfo == nil then
        return 0
    end
    local value = table.getValue(pickCountInfo, tostring(itemId))
    if value == nil then
        return 0
    end
    return tonumber(value)
end

function this.getPickCountLimit(itemCfgId)
    local value = ConfigDataManager.getTableValue("cfg_global", "value", "id", 3101)
    if value == nil then
        return -1
    end
    local map = string.toStringStringMap(value, "#", "|")
    local value2 = table.getValue(map, tostring(itemCfgId))
    if string.isNullOrEmpty(value2) then
        return -1
    end
    return tonumber(value2)
end

function this.checkPickUpItem(actor, itemId)
    local dropInfo = this.getDropInfo()
    local dropItem = table.getValue(dropInfo, tostring(itemId))
    if dropItem == nil then
        return nil
    end

    local itemCfgId = table.getValue(dropItem, "cfgid")
    local count = table.getValue(dropItem, "count")
    local pickCount = this.getTodayPickCount(actor, itemCfgId)
    local pickLimit = this.getPickCountLimit(itemCfgId)
    if pickLimit == -1 then
        return nil
    end
    if pickLimit > pickCount then
        if pickCount + count > pickLimit then
            local genCount = pickCount + count - pickLimit
            count = pickLimit - pickCount
            -- 剩余的数量重新生成
            -- local x = getbaseinfo(actor, "x")
            -- local y = getbaseinfo(actor, "y")
            -- local uniMapId = getbaseinfo(actor, "unimapid")
            -- throwitem(actor, uniMapId, x, y, 1, itemId, genCount)
        end
        this.addTodayPickUpCount(actor, itemCfgId, count)
        return { allow = true, count = count }
    else
        noticeTip.noticeinfo(actor, StringIdConst.TEXT336)
        return { allow = false }
    end
end

