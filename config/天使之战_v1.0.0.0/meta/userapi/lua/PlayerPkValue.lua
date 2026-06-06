-- 玩家PK值功能
PK = {}
local this = {}
DropEquipType = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }

---设置玩家pk值
function PK.setpkvalue(actor, pkValue)
    setplaydef(actor, PlayerDefKey.pkValue.PK_VALUE, pkValue)
    local msg = { rid = actor, pkValue = pkValue }
    sendrefluamsg(actor, LuaMessageIdToClient.PK_VALUE_CHANGE, msg)
end


---获取指定玩家PK值
function PK.getpkvalue(actor)
    local pkValue = getplaydef(actor, PlayerDefKey.pkValue.PK_VALUE) or 0
    return string.tonumber(pkValue)
end

--- 是否可以修改PK值
function PK.canSet(actor)
    local mapUid = getbaseinfo(actor, "unimapid")
    local mapInfo = getmapinfobyid(actor, mapUid)
    if mapInfo.isdup then
        return false
    end
    if not table.isNullOrEmpty(mapInfo) then
        local mapCfgId = table.getValue(mapInfo, "cfgid")
        local mapLine = table.getValue(mapInfo, "line")
        local pkLine = ConfigDataManager.getTableValue("cfg_map_line", "pkline", "id", mapCfgId)
        if not string.isNullOrEmpty(pkLine) then
            local pkLines = string.split(pkLine, "|")
            for _, line in pairs(pkLines) do
                if tonumber(mapLine) == tonumber(line) then
                    return false
                end
            end
        end
    end
    return true
end





---击杀玩家处理
function PK.killplayerpkvaluehandle(actor, diePlayer)
    if not PK.canSet(actor) then
        return
    end
    -- 清除diePlayer身上存储的防卫时间信息
    setplaydef(diePlayer, PlayerDefKey.pkValue.LAST_ATTACK, {})
    -- 判断是否在防卫时间内击杀的玩家，如果在防卫时间内击杀玩家则不增加PK值
    local attackInfo = getplaydef(actor, PlayerDefKey.pkValue.LAST_ATTACK)
    local now = tonumber(getbaseinfo("now"))
    local defenseTime = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DEFENSE_TIME)
    if attackInfo and next(attackInfo) then
        for index = 1, #attackInfo do
            if attackInfo[index].attackId == diePlayer then
                if defenseTime and now - tonumber(attackInfo[index].timeStamp) <= tonumber(defenseTime) then
                    gameDebug.print(actor:toString() .. "在防卫时间内击杀了" .. tostring(diePlayer) .. " 不增加PK值")
                    return
                end
            end
        end
    end
    -- 判断击杀的玩家是否是红名玩家，是红名玩家不增加PK值
    local redNameNeed = ConfigDataManager.getTableValue("cfg_pk_count", "redNameNeed", "id", 1)
    local diePlayerPkValue = PK.getpkvalue(diePlayer)
    if not string.isNullOrEmpty(redNameNeed) and (diePlayerPkValue) >= tonumber(redNameNeed) then
        gameDebug.print(actor:toString() .. "击杀了红名玩家" .. tostring(diePlayer) .. " 不增加PK值")
        -- 红名玩家被击杀全服跑马灯
        -- noticeTip.noticeinfo(diePlayer, actor:toString())
        return
    end

    -- 根据配表增加PK值
    local curPkValue = PK.getpkvalue(actor)
    if curPkValue > 0 then
        local addByKill = 0
        local pkCountTable = ConfigDataManager.getList("cfg_pk_count")
        if pkCountTable and next(pkCountTable) then
            local maxPkValue = 0
            for i = 1, #pkCountTable do
                local nameColor = pkCountTable[i].namecolor
                local minPkValue = string.split(nameColor, "#")[1]
                maxPkValue = string.split(nameColor, "#")[2]
                if curPkValue >= tonumber(minPkValue) and curPkValue <= tonumber(maxPkValue) then
                    addByKill = pkCountTable[i].addbykill
                end
            end
            if tonumber(addByKill) == 0 and tonumber(curPkValue) > tonumber(maxPkValue) then
                addByKill = pkCountTable[#pkCountTable].addbykill
            end
            if addByKill == 0 then
                addByKill = pkCountTable[1].addbykill
            end
        end
        PK.setpkvalue(actor, tonumber(addByKill) + tonumber(curPkValue))
    else
        local addByKill = ConfigDataManager.getTableValue("cfg_pk_count", "addByKill", "id", 1)
        PK.setpkvalue(actor, addByKill)
    end
    local reduceByTime = ConfigDataManager.getTableValue("cfg_pk_count", "reduceByTime", "id", 1)
    local splitString = string.split(reduceByTime, "#")
    if splitString then
        setplaydef(actor, PlayerDefKey.pkValue.PK_REDUCE_TIME, splitString[1])
    else
        gameDebug.print("cfg_pk_count表 reduceByTime 字段为空, id = " .. 1)
        return
    end
end

---玩家被攻击处理
function PK.underattackpkvaluehandle(actor, fightParam)
    -- 当玩家攻击玩家时进行后面的逻辑
    if fightParam.castertype and fightParam.targettype and
        fightParam.castertype == MapObjectType.PLAYER and
        fightParam.targettype == MapObjectType.PLAYER then
        local lastAttackInfo = getplaydef(actor, PlayerDefKey.pkValue.LAST_ATTACK)
        if table.isEmpty(lastAttackInfo) then
            -- 没有玩家攻击时间信息存入新的
            local attackInfo = {
                attackId = fightParam.caster,
                timeStamp = tonumber(getbaseinfo("now"))
            }
            setplaydef(actor, PlayerDefKey.pkValue.LAST_ATTACK, attackInfo)
        else
            -- 有玩家攻击时间信息遍历判断是否已经存在攻击者id
            -- 如果存在，判断时间是否超时，如果超时存入新的时间戳
            local exists = false
            local now = tonumber(getbaseinfo("now"))
            local defenseTime = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DEFENSE_TIME)
            for index = 1, #lastAttackInfo do
                if tonumber(lastAttackInfo[index].attackId) == tonumber(fightParam.caster) then
                    exists = true
                    local lastTime = lastAttackInfo[index].timeStamp
                    if defenseTime and (now - tonumber(lastTime)) > tonumber(defenseTime) then
                        table.remove(lastAttackInfo, index)
                        lastAttackInfo[#lastAttackInfo + 1] = {
                            attackId = fightParam.caster,
                            timeStamp = now
                        }
                        setplaydef(actor, PlayerDefKey.pkValue.LAST_ATTACK, lastAttackInfo)
                    end
                    break
                end
            end
            -- 如果不存在则存入
            if not exists then
                lastAttackInfo[#lastAttackInfo + 1] = {
                    attackId = fightParam.caster,
                    timeStamp = tonumber(getbaseinfo("now"))
                }
                setplaydef(actor, PlayerDefKey.pkValue.LAST_ATTACK, lastAttackInfo)
            end
        end
    end
end

---击杀怪物PK值处理
function PK.killmonsterpkvaluehandle(actor, monsterCfgId, monsterLevel)
    local levelDiff = ConfigDataManager.getTableValue("cfg_pk_count", "levelDiff", "id", 1)
    local level = getbaseinfo(actor, "level")
    if tonumber(level) - tonumber(levelDiff) >= tonumber(monsterLevel) then
        return
    end
    local pkValue = PK.getpkvalue(actor)
    if pkValue > 0 then
        local monsterType = ConfigDataManager.getTableValue("cfg_monster", "type", "id", monsterCfgId)
        local reduceByMonster = ConfigDataManager.getTableValue("cfg_pk_count", "reduceByMonster", "id", 1)
        local time = string.split(reduceByMonster, "#")
        if time and next(time) then
            local reduceTime = getplaydef(actor, PlayerDefKey.pkValue.REDUCE_TIME)
            if reduceTime and reduceTime ~= "" then
                setplaydef(actor, PlayerDefKey.pkValue.REDUCE_TIME,
                    tonumber(reduceTime) + tonumber(time[tonumber(monsterType)]))
            else
                setplaydef(actor, PlayerDefKey.pkValue.REDUCE_TIME, tonumber(time[tonumber(monsterType)]))
            end
        end
    end
end

---角色PK值心跳
function PK.SecondHeartPkValue(actor)
    local pkValue = PK.getpkvalue(actor)
    if pkValue > 0 then
        local pkValueReduceTime = getplaydef(actor, PlayerDefKey.pkValue.PK_REDUCE_TIME)
        if pkValueReduceTime and tonumber(pkValueReduceTime) > 0 then
            local reduceTime = getplaydef(actor, PlayerDefKey.pkValue.REDUCE_TIME)
            if reduceTime and tonumber(reduceTime) > 0 then
                if tonumber(reduceTime) >= tonumber(pkValueReduceTime) then
                    setplaydef(actor, PlayerDefKey.pkValue.REDUCE_TIME,
                        tonumber(reduceTime) - tonumber(pkValueReduceTime)
                    )
                    setplaydef(actor, PlayerDefKey.pkValue.PK_REDUCE_TIME, 0)
                    pkValueReduceTime = 0
                else
                    setplaydef(actor, PlayerDefKey.pkValue.PK_REDUCE_TIME,
                        tonumber(pkValueReduceTime) - tonumber(reduceTime)
                    )
                    setplaydef(actor, PlayerDefKey.pkValue.REDUCE_TIME, 0)
                    return
                end
            else
                pkValueReduceTime = tonumber(pkValueReduceTime) - 5
                if pkValueReduceTime > 0 then
                    setplaydef(actor, PlayerDefKey.pkValue.PK_REDUCE_TIME, pkValueReduceTime)
                    return
                end
            end
        end
        if pkValueReduceTime and pkValueReduceTime <= 0 then
            local reduceByTime = ConfigDataManager.getTableValue("cfg_pk_count", "reduceByTime", "id", 1)
            local splitString = string.split(reduceByTime, "#")
            if splitString and next(splitString) then
                PK.setpkvalue(actor, pkValue - splitString[2])
                setplaydef(actor, PlayerDefKey.pkValue.PK_REDUCE_TIME, splitString[1])
            end
        end
    else
        return
    end
end

---免罪符使用PK值处理
function PK.exonerationcharmpkvaluehnadle(actor, itemConfigId, count)
    local value =
        ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.EXONERATION_CHARM_MINUS_COUNT)
    for i = 1, tonumber(count) do
        if itemConfigId == ItemConfigId.EXONERATION_CHARM then
            if value then
                local pkValue = PK.getpkvalue(actor)
                if pkValue > 0 then
                    pkValue = math.max(0, pkValue - tonumber(value))
                end
                PK.setpkvalue(actor, pkValue)
            end
        end
    end
end

---角色进入视野发送玩家的PK值
function PK.sendenterviewpkvalue(actor, targetPlayer)
    sendluamsg(targetPlayer, LuaMessageIdToClient.PK_VALUE_CHANGE, { rid = actor, pkValue = tonumber(PK.getpkvalue(actor)) })
end

-- 玩家被击杀
function PK.PlayerDie(actor, dieInfo, killInfo)
    local killerType = killInfo.type
    if killerType ~= MapObjectType.PLAYER then
        return
    end

    local redNameNeed = ConfigDataManager.getTableValue("cfg_pk_count", "redNameNeed", "id", 1)
    local pkValue = PK.getpkvalue(actor)
    if not string.isNullOrEmpty(redNameNeed) and pkValue >= tonumber(redNameNeed) then
        this.redNameDrop(actor, dieInfo, killInfo, pkValue)
    else
        this.normalDrop(actor, dieInfo, killInfo, pkValue)
    end
end

function this.redNameDrop(actor, dieInfo, killInfo, pkValue)
    -- 红名死亡掉背包一个道具＋穿戴栏一件装备
    local killerId = killInfo.id
    local killer = getactor(actor, killerId)
    local killerName = killInfo.name

    local oneTable = this.findPkConfigTable(pkValue)
    if oneTable == nil then
        return
    end

    -- 处理道具掉落
    local dropItem = string.split(oneTable.dropitem, "#")
    this.handleDropItem(actor, killer, killerName, dropItem)

    -- 被击杀掉落穿戴装备概率
    local dropRate = string.tonumber(oneTable.dropequip) / 10000
    this.findDropEquipment(actor, killerId, killerName, dropRate)
end

function this.normalDrop(actor, dieInfo, killInfo, pkValue)
    -- 白名被击杀掉背包一个道具
    local killerId = killInfo.id
    local killer = getactor(actor, killerId)
    local killerName = killInfo.name

    local oneTable = this.findPkConfigTable(pkValue)
    if oneTable == nil then
        return
    end

    -- 处理道具掉落
    local dropItem = string.split(oneTable.dropitem, "#")
    this.handleDropItem(actor, killer, killerName, dropItem)
end

-- 处理掉落逻辑
function this.handleDropItem(actor, killer, killerName, dropItemConfig)
    local itemCfgId = tonumber(dropItemConfig[1])
    local count = tonumber(dropItemConfig[2])
    local itemConfig = ConfigDataManager.getById("cfg_item", itemCfgId)


    -- 非装备扣除数量然后地上生成
    local ownCount = getbagitemcountbyid(actor, itemCfgId)
    if ownCount < count then
        count = ownCount
    end

    if count > 0 then
        local dropTime = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "dropTime", "id", itemCfgId))
        dropTime = dropTime + 1000
        removeitemfrombag(actor, itemCfgId, count, 0, 9999, "红名惩罚")

        local mapId = getbaseinfo(actor, "unimapid")
        local x = getbaseinfo(actor, "x")
        local y = getbaseinfo(actor, "y")
        throwitem(killer, mapId, x, y, 1, itemCfgId, count, dropTime, 3, 0)
        info("红名惩罚：玩家死亡掉落道具。", actor:toString(), itemCfgId, count)

        -- 发邮件
        local itemName = itemConfig.name
        sendconfigmailbyrid(actor, actor:toString(), MailConfig.PK_DROP_ITEM, {},killerName .. "#" .. count .. "#" .. itemName)
    end
end

-- 查找可掉落装备
function this.findDropEquipment(actor, killerId, killerName, dropRate)
    if not math.selectRate(dropRate) then
        return
    end

    -- 先从背包找
    local allItemInfo = getallbagiteminfo(actor)
    math.shuffleTable(allItemInfo)
    for _, oneItem in pairs(allItemInfo) do
        -- 装备且非绑定状态
        if oneItem.type == ItemType.EQUIP then
            if oneItem.isbind == false then
                local equipCfgId = oneItem.cfgid
                local subType = tonumber(ConfigDataManager.getTableValue("cfg_item", "subType", "id", equipCfgId))
                if table.contains(DropEquipType, subType) then
                    -- 从背包掉落道具
                    local dropTime = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "dropTime", "id",
                        equipCfgId)) + 1000
                    dropequip(actor, oneItem.id, killerId, dropTime)
                    info("红名惩罚：玩家死亡掉落装备。", actor:toString(), oneItem)
                    -- 发邮件
                    local equipName = ConfigDataManager.getTableValue("cfg_item", "name", "id", equipCfgId)
                    sendconfigmailbyrid(actor, actor:toString(), MailConfig.PK_DROP_EQUIP, {},
                        killerName .. "#" .. equipName)
                    return
                end
            end
        end
    end

    -- 从穿戴栏找
    local allEquip = getputonequipinfo(actor)
    math.shuffleTable(allEquip)
    for _, oneEquip in pairs(allEquip) do
        if oneEquip.isbind == false then
            if table.contains(DropEquipType, oneEquip.subtype) then
                local equipCfgId = oneEquip.cfgid
                local dropTime = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "dropTime", "id",
                    equipCfgId))
                dropTime = dropTime + 1000
                dropequip(actor, oneEquip.id, killerId, dropTime)
                info("红名惩罚：玩家死亡掉落装备。", actor:toString(), oneEquip)
                -- 发邮件
                local equipName = ConfigDataManager.getTableValue("cfg_item", "name", "id", equipCfgId)
                sendconfigmailbyrid(actor, actor:toString(), MailConfig.PK_DROP_EQUIP, {},
                    killerName .. "#" .. equipName)
                return
            end
        end
    end
end

function this.findPkConfigTable(pkValue)
    local oneTable
    local pkCountTable = ConfigDataManager.getList("cfg_pk_count")
    if not table.isEmpty(pkCountTable) then
        for i = 1, #pkCountTable do
            local nameColor = pkCountTable[i].namecolor
            local minPkValue = string.split(nameColor, "#")[1]
            local maxPkValue = string.split(nameColor, "#")[2]
            if pkValue >= tonumber(minPkValue) and pkValue <= tonumber(maxPkValue) then
                oneTable = pkCountTable[i]
                break
            end
        end
    end
    return oneTable
end

function this.cancelRedName(actor)
    -- 去除红名要１００万金币

    if not Bag.checkCostMap(actor, { [10000] = 100 }) then
        return
    end
    Bag.costMap(actor, { [10000] = 100 }, "取消红名扣除")
    PK.setpkvalue(actor, 0)
end

MessageRouter:register(LuaMessageIdToSever.REQ_CANCEL_RED_NAME, this.cancelRedName)
