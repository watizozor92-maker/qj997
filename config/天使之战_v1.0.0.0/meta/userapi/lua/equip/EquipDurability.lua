---
--- Created by zhouzhipeng.
--- DateTime: 2025/11/7 下午1:54
--- Desc：装备耐久度
---

EquipDurability = {}


local this = {}

local durabilityTime = "@durability_times"
local autoRepairKey = "T$autoRepairitems"
local durabilityAccumulationKey = "T$durabilityAccumulation"

function EquipDurability.reqEquipRepair(actor, msgData, isAutoRepair)
    local itemIds = msgData.itemId

    local durabilityRepairCost = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_REPAIR_COST1)
    local cost = string.split(durabilityRepairCost, "#")
    local itemCfgId = string.tonumber(cost[1])

    local allCostCount = 0
    for _, itemId in pairs(itemIds) do
        local equip = getequipinfo(actor, itemId, 1)
        if not equip then
            return
        end
        local cfgId = equip.cfgid
        local cfg = ConfigDataManager.getById("cfg_equip_guard", cfgId)
        local repair = (not table.isEmpty(cfg)) and cfg.repair or 0
        if table.isEmpty(cfg) or string.tonumber(repair) > 0 then
            local itemExtData = EquipAndAppear.getItemExtData(actor, itemId)
            local durabilityNum = itemExtData.durabilityNum or 0
            local maxDurability = this.getMaxDurability(cfgId, itemExtData.strengthlv or 0)
            local repairNum = maxDurability - durabilityNum
            allCostCount = allCostCount + (string.tonumber(cost[2]) * repairNum)
        end
    end
    allCostCount = math.floor(allCostCount)

    if allCostCount < 1 then
        if not isAutoRepair then
            tipinfo(actor, "没有可修理的装备")
        end
        return
    end

    if not Bag.checkItem(actor, itemCfgId, allCostCount) then
        if isAutoRepair then
            -- 取消勾选自动修理
            EquipDurability.changeAutoRepair(actor, true)
            tipinfo(actor, "修理金币不足，自动修理已关闭")
        else
            tipinfo(actor, "金币不足")
        end
        return
    end
    Bag.cost(actor, itemCfgId, allCostCount, "装备耐久度修理消耗")


    local isSend = false
    for _, itemId in pairs(itemIds) do
        local equip = getequipinfo(actor, itemId, 1)
        local itemExtData = EquipAndAppear.getItemExtData(actor, itemId)
        local cfgId = equip.cfgid
        local cfg = ConfigDataManager.getById("cfg_equip_guard", cfgId)
        local repair = (not table.isEmpty(cfg)) and cfg.repair or 0
        if table.isEmpty(cfg) or string.tonumber(repair) > 0 then
            local maxDurability = this.getMaxDurability(cfgId, itemExtData.strengthlv or 0)
            if itemExtData.durabilityNum < 1 then
                isSend = true
            end
            itemExtData.durabilityNum = maxDurability
            local durabilityAccumulation = EquipDurability.getDurabilityAccumulation(actor)
            durabilityAccumulation[itemId] = 0
            EquipDurability.setDurabilityAccumulation(actor, durabilityAccumulation)

            --local reduceRate = EquipDurability.getReduceRate(cfgId, itemExtData.strengthlv or 0, itemExtData.durabilityNum or 0)
            --if itemExtData.durabilityNum < 1 then
            --    EquipDurability.updateDurabilityAttr(actor, itemExtData, cfgId, 10000)
            --end
            EquipDurability.updateDurabilityAttr(actor, itemExtData, cfgId)

            EquipAndAppear.SetItemExtData(actor, itemId, itemExtData)
        end
    end
    -- 装备修理完，更新属性
    EquipAndAppear.updateluaextattr(actor)
    --info(actor, "玩家", actor, "修理装备 道具id" , itemId, "cfgId:" , equip.cfgid,"装备价值", equipmentValue , "基础修理基数" , repairBase, "修理前耐久度", durabilityNum
    --, "耐久度消耗比例", durabilityConsumeRatio, "tempX", tempX, "tempY", tempY, "修理费用", repairCost, "是否卓越", this.isExcellent(equip.cfgid))

    if isSend then
        this.sendDurabilityChange(actor, {})
    end
    info(actor, "玩家", actor, "修理装备 道具id：", itemIds, "cfgId:", itemCfgId, "消耗数量：", allCostCount, "是否自动修理：", isAutoRepair)
end

function EquipDurability.onTime(actor)
    local onHook = getbaseinfo(actor, "onhook")
    -- 离线挂机，不扣耐久度
    if onHook == 1 then
        return
    end
    if not insafezone(actor) then
        this.updateEquipDurability(actor)
    end
end

function this.updateEquipDurability(actor)
    local lastTime = this.getDurabilityTime(actor)
    local allEquipInfo = getputonequipinfo(actor)
    local currentTime = getbaseinfo(actor, "nowsec")

    local isSend = false
    local repairItems = {}
    local isChange = false
    for _, equip in pairs(allEquipInfo) do
        local cfgId = equip.cfgid
        local id = equip.id
        local equipIndex = equip.equipindex
        local durability = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "durability", "id", cfgId))
        if durability < 1 then
            goto continue
        end
        local durabilityResistance = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "durabilityresistance", "id", cfgId))
        if durabilityResistance < 1 then
            goto continue
        end

        local itemExtData = EquipAndAppear.getItemExtData(actor, id)
        local durabilityNum = itemExtData.durabilityNum or 0
        if durabilityNum < 1 then
            goto continue
        end

        local time = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_DEDUCT_TIME))

        if currentTime - lastTime >= time then
            local durabilityAccumulation = EquipDurability.getDurabilityAccumulation(actor)
            local totalDurabilityAccumulation = (durabilityAccumulation[id] or 0) + 1
            local isDurabilityChange = false
            if totalDurabilityAccumulation >= durabilityResistance then
                -- 减耐久值
                itemExtData.durabilityNum = math.max(itemExtData.durabilityNum - 1, 0)
                totalDurabilityAccumulation = 0
                isDurabilityChange = true
            end
            durabilityAccumulation[id] = totalDurabilityAccumulation
            EquipDurability.setDurabilityAccumulation(actor, durabilityAccumulation)
            local pos = gameequip.pos(equipIndex)
            -- if this.isGuard(pos) and itemExtData.durabilityNum <= 0 then
            --     this.removeEquip(actor, equip, "守护耐久度为0移除")
            --     -- local reduceRate = EquipDurability.getReduceRate(cfgId, itemExtData.strengthlv or 0, itemExtData.durabilityNum or 0)
            --     -- if itemExtData.durabilityNum < 1 then
            --     --    EquipDurability.updateDurabilityAttr(actor, itemExtData, cfgId)
            --     -- end
            -- else
                --ZzpTest.print("攻击怪物 最新耐久累积值:" .. itemExtData.durabilityAccumulation, "本次累计耐久累积值:" .. totalDurabilityAccumulation, "减少1耐久需要造成的伤害段数：" .. durabilityResistValue, "耐久值:" .. itemExtData.durabilityNum)
                if isDurabilityChange then
                    if itemExtData.durabilityNum < 1 then
                        isSend = true
                    end
                    local autoRepairValue = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_AUTO_REPAIR_VALUE))
                    local durabilityPer = this.getDurabilityPer(cfgId, itemExtData.strengthlv or 0, itemExtData.durabilityNum or 0)
                    if durabilityPer <= autoRepairValue and this.isAutoRepair(actor) then
                        -- 触发自动修复
                        table.insert(repairItems, equip.id)
                    end
                    EquipDurability.updateDurabilityAttr(actor, itemExtData, cfgId)
                    isChange = true
                end
                EquipAndAppear.SetItemExtData(actor, id, itemExtData)
            -- end
        end

        :: continue ::
    end
    this.setDurabilityTime(actor, lastTime)
    if isChange then
        -- 耐久度变化,计算属性
        EquipAndAppear.updateluaextattr(actor)
    end
    if table.notEmpty(repairItems) then
        EquipDurability.reqEquipRepair(actor, { itemId = repairItems }, true)
    end
    if isSend then
        this.sendDurabilityChange(actor, {})
    end
end

function this.sendDurabilityChange(actor, res)
    sendluamsg(actor, LuaMessageIdToClient.RES_DURABILITY_CHANGE, res)
end

function this.getDurabilityTime(actor)
    return getplaydef(actor, durabilityTime) or getbaseinfo(actor, "nowsec")
end

function this.setDurabilityTime(actor, data)
    return setplaydef(actor, durabilityTime, data)
end

--- 获取耐久度变化需要减少的比率
function EquipDurability.getReduceRate(itemCfgId, strengthlv, durabilityNum)
    local durabilityPer = this.getDurabilityPer(itemCfgId, strengthlv, durabilityNum)
    local reduceRate = 0
    local str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_ARMOR_REDUCE_RANGE)
    local rangeStr = string.split(str, "|")
    for _, v in pairs(rangeStr) do
        local range = string.split(v, "#")
        if durabilityPer <= tonumber(range[1]) and durabilityPer > tonumber(range[2]) then
            reduceRate = tonumber(range[3])
        end
    end
    return reduceRate
end

function this.getDurabilityPer(cfgId, strengthlv, durability)
    local maxDurability = this.getMaxDurability(cfgId, strengthlv)
    return math.max(durability / maxDurability * 10000, 0)
end

--- 更新耐久对属性的影响
function EquipDurability.updateDurabilityAttr(actor, itemExtData, cfgId)
    local reduceRate
    if itemExtData.durabilityNum < 1 then
        reduceRate = 10000
    else
        reduceRate = 0
    end
    -- 总共需要减少的属性
    local reduceAttr = {}
    -- 需要减少的强化属性
    local reduceStrengthAttr = {}
    -- 最新强化属性
    local newStrengthAttr = {}
    local originalStrengthattr = itemExtData.originalStrengthattr or {}
    for attrId, value in pairs(originalStrengthattr) do
        local attrValue = value * reduceRate / 10000
        reduceStrengthAttr[attrId] = -attrValue
        newStrengthAttr[attrId] = value - attrValue
    end
    itemExtData.strengthattr = newStrengthAttr
    table.mergeAdd(reduceAttr, reduceStrengthAttr)

    -- 需要减少的追加属性
    local reduceAppendAttr = {}
    -- 最新追加属性
    local newAppendAttr = {}
    local originalAppendattr = itemExtData.originalAppendattr or {}
    for attrId, value in pairs(originalAppendattr) do
        local attrValue = value * reduceRate / 10000
        reduceAppendAttr[attrId] = -attrValue
        newAppendAttr[attrId] = value - attrValue
    end
    itemExtData.appendattr = newAppendAttr
    table.mergeAdd(reduceAttr, reduceAppendAttr)

    -- 最新基础属性
    local newBaseAttr = {}
    -- 需要减少的基础属性
    local reduceBaseAttr = {}
    local attribute = string.toIntIntMap(ConfigDataManager.getTableValue("cfg_equip_entryLib", "attribute", "id", cfgId))
    for attrId, value in pairs(attribute) do
        local attrValue = value * reduceRate / 10000
        reduceBaseAttr[attrId] = -attrValue
        newBaseAttr[attrId] = value - attrValue
    end
    itemExtData.baseAttr = newBaseAttr
    table.mergeAdd(reduceAttr, reduceBaseAttr)
    itemExtData.reduceAttr = reduceAttr
    --ZzpTest.print("测试查看属性","玩家", actor:toString(), getbaseinfo(actor, "rolename"), "道具cfgid", cfgId, "耐久度变化需要减少的属性:"
    --, reduceAttr, "耐久度万分比:", this.getDurabilityPer(cfgId, itemExtData.strengthlv or 0, itemExtData.durabilityNum or 0), "需要减少的耐久度百分比:", reduceRate
    --, "原始强化属性:", originalStrengthattr, "当前强化属性:", newStrengthAttr, "需要减少的强化:", reduceStrengthAttr
    --, "原始追加属性:", originalAppendattr, "当前追加属性:", newAppendAttr, "需要减少的追加:", reduceAppendAttr
    --, "初始基础属性:", attribute, "当前基础属性:", newBaseAttr, "需要减少的基础:", reduceBaseAttr)
end

function EquipDurability.changeAutoRepair(actor, isClose, ignore)
    local autoRepair = getplaydef(actor, autoRepairKey) or 0
    autoRepair = 1 - autoRepair
    autoRepair = isClose and 0 or autoRepair
    local state = autoRepair == 1 and true or false
    local is_open, _ = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.AUTOREPAIR)
    -- 勾选自动修理，需要有月卡
    if state and not is_open and not ignore then
        tipinfo(actor, "特权不足")
        return
    end

    setplaydef(actor, autoRepairKey, autoRepair)
    sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_AUTO_REPAIR_STATE, { state = state })
    --if state then
    --    -- 勾选自动修理触发 修理装备阈值
    --    this.repairEquip(actor)
    --end
end

function EquipDurability.getMaxDurability(cfgId, lv)
    return this.getMaxDurability(cfgId, lv)
end

function this.getMaxDurability(cfgId, lv)
    local durability = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "durability", "id", cfgId))

    local strengthDurability = 0
    if lv > 0 then
        strengthDurability = this.getDurabilityByLv(lv)
    end
    return durability + strengthDurability
end

function this.getDurabilityByLv(lv)
    local durabilityStrengthValue1 = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_STRENGTH_VALUE1))
    local durabilityStrengthValue2 = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_STRENGTH_VALUE2))
    local durabilityStrengthValue3 = string.tonumber(ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_STRENGTH_VALUE3))

    local strengthDurability = 0
    for i = 1, lv do
        if i <= 4 then
            strengthDurability = strengthDurability + durabilityStrengthValue1
        elseif i > 4 and i < 10 then
            strengthDurability = strengthDurability + durabilityStrengthValue2
        else
            strengthDurability = strengthDurability + (i - durabilityStrengthValue3)
        end
    end
    return strengthDurability
end

function EquipDurability.getChangeDurability(strengthLv, oldStrengthLv)
    local addDurability1 = this.getDurabilityByLv(strengthLv)
    local addDurability2 = this.getDurabilityByLv(oldStrengthLv)
    return addDurability2 - addDurability1
end

function EquipDurability.canRelease(actor)
    local baseCareer = getbaseinfo(actor, "getbasecareer")
    if baseCareer ~= CareerType.GONG_JIAN_SHOU then
        return true
    end
    if this.checkJianDai(actor) then
        return true
    end
    return false
end

function this.checkJianDai(actor)
    local equips = getputonequipinfo(actor)
    if table.isEmpty(equips) then
        return true
    end

    local equipList = {}
    for _, equip in pairs(equips) do
        local idxOfEquip = equip.equipindex
        local wearBar = gameequip.wearBar(idxOfEquip)
        --local pos = gameequip.pos(idxOfEquip)
        local wearBarEquips = equipList[wearBar] or {}
        table.insert(wearBarEquips, equip)
        equipList[wearBar] = wearBarEquips
    end

    local tip
    for wearBar, wearBarEquips in pairs(equipList) do
        local mainEquip
        local secEquip
        for _, equip in pairs(wearBarEquips) do
            local idxOfEquip = equip.equipindex
            local pos = gameequip.pos(idxOfEquip)
            if pos == 1 then
                mainEquip = equip
            end
            if pos == 3 then
                mainEquip = equip
            end
            if pos == 2 then
                secEquip = equip
            end
        end
        if not mainEquip then
            return true
        end
        local shape = string.split(ConfigDataManager.getTableValue("cfg_item", "shape", "id", mainEquip.cfgid), "#")
        if table.isEmpty(shape) then
            tip = "没有shape1"
            goto continue
        end
        local part = tonumber(ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", shape[1]))
        if part == 6 or part == 7 then
            if secEquip then
                local shape2 = string.split(ConfigDataManager.getTableValue("cfg_item", "shape", "id", secEquip.cfgid), "#")
                if table.isEmpty(shape2) then
                    tip = "没有shape2"
                    goto continue
                end
                local part2 = tonumber(ConfigDataManager.getTableValue("cfg_model_charactor", "part", "id", shape2[1]))
                if part2 == 114 or part2 == 115 then
                    local itemExtData = EquipAndAppear.getItemExtData(actor, secEquip.id)
                    if itemExtData.durabilityNum < 1 then
                        tip = "箭袋耐久度不足"
                    else
                        return true
                    end
                end
            else
                tip = "未穿戴箭袋"
            end
        else
            return true
        end

        :: continue ::
    end
    tipinfo(actor, tip)
    return false
end

function this.isAutoRepair(actor)
    local autoRepair = getplaydef(actor, autoRepairKey) or 0
    return autoRepair == 1
end

function this.login(actor)
    local autoRepair = getplaydef(actor, autoRepairKey) or 0
    local state = autoRepair == 1 and true or false
    sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_AUTO_REPAIR_STATE, { state = state })
end

function this.removeEquip(actor, equip, desc)
    takeofftheequip(actor, equip["equipindex"])
    local bagIdx = gainbagidxbyitemid(actor, equip.id)
    removeitembyidxlist(actor, { bagIdx }, 9999, desc)
end

function this.isPVE(type1, type2)
    if type1 == MapObjectType.PLAYER and type2 == MapObjectType.MONSTER then
        return true
    end
    return false
end

function this.isWeapon(pos)
    local cfg_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_WEAPON_TYPE)
    local allWeaponPos = string.split(cfg_str, "#")
    if table.contains(allWeaponPos, tostring(pos)) then
        return true
    end
    return false
end

function this.isArmor(pos)
    local cfg_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_ARMOR_TYPE)
    local allWeaponPos = string.split(cfg_str, "#")
    if table.contains(allWeaponPos, tostring(pos)) then
        return true
    end
    return false
end

function this.isGuard(pos)
    local cfg_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_GUARD_TYPE)
    local allWeaponPos = string.split(cfg_str, "#")
    if table.contains(allWeaponPos, tostring(pos)) then
        return true
    end
    return false
end

function this.isJewelry(pos)
    local cfg_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.DURABILITY_JEWELRY_TYPE)
    local allWeaponPos = string.split(cfg_str, "#")
    if table.contains(allWeaponPos, tostring(pos)) then
        return true
    end
    return false
end

-- 耐久积累值
function EquipDurability.getDurabilityAccumulation(actor)
    return getplaydef(actor, durabilityAccumulationKey) or {}
end

function EquipDurability.setDurabilityAccumulation(actor, allData)
    setplaydef(actor, durabilityAccumulationKey, allData)
end

-- @lua moditemdurability 20310111 0
function moditemdurability(actor, itemCfgId, value)
    if tonumber(value) < 0 then
        return
    end
    local allEquipInfo = getallequipinfo(actor)
    jprint("moditemdurability222", allEquipInfo)
    for _, equip in pairs(allEquipInfo) do
        local cfgId = equip.cfgid
        if cfgId == tonumber(itemCfgId) then
            local itemExtData         = EquipAndAppear.getItemExtData(actor, equip.id)
            local lv                  = itemExtData.strengthlv or 0
            itemExtData.durabilityNum = math.min(tonumber(value), this.getMaxDurability(cfgId, lv))
            --local reduceRate = EquipDurability.getReduceRate(cfgId, itemExtData.strengthlv or 0, itemExtData.durabilityNum or 0)
            --if reduceRate > 0 then
            --if itemExtData.durabilityNum < 1 then
            --    EquipDurability.updateDurabilityAttr(actor, itemExtData, cfgId, 10000)
            --end
            EquipDurability.updateDurabilityAttr(actor, itemExtData, cfgId)
            EquipAndAppear.SetItemExtData(actor, equip.id, itemExtData)
            --EquipDurability.triggerAutoRepair(actor, equip, itemExtData.durabilityNum)
        end
    end
end

LoginEventListerTable:eventLister("0", "耐久度功能", this.login)
