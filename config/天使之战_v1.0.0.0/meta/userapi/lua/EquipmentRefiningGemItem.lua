EquipmentRefiningGemItem = {}
local this = {}

EquipmentRefiningGemItem.RandomResult = {
    DECREASE = 1,
    INCREASE = 2
}

EquipmentRefiningGemItem.config = {
    rateGlobalId = 900008, --成功失败概率gloablId
    strengthenGlobalId = 900001, -- 强化等级要求gloablId
    attackGemId = 50030015, -- 攻击洗练宝石id
    defenseGemId = 50030016, -- 防御洗练宝石id
    restoreGemId = 50030017, -- 还原洗练宝石id
    typeMap = {
        [1] = {
            gemId = 50030015,
            tips = "攻击洗练宝石配置不存在"
        },
        [2] = {
            gemId = 50030016,
            tips = "防御洗练宝石配置不存在"
        }
    },
    randomMaxValue = 9999,
    randomScale = 10000,
    defaultRate = "3500#6500" -- 默认成功失败概率

}

function EquipmentRefiningGemItem.onClick(actor, msgData)
    if not msgData then
        error("EquipmentRefiningGemItem.onClick: msgData is nil")
        return
    end

    local uid = msgData.itemId
    local type = msgData.type

    if not uid then
        error("EquipmentRefiningGemItem.onClick: uid is nil")
        return
    end

    if type ~= 1 and type ~= 2 then
        error("EquipmentRefiningGemItem.onClick: type error")
        return
    end

    local equipinfo = getequipinfo(actor, uid, 1)
    if table.count(equipinfo) == 0 then
        error("EquipmentRefiningGemItem.onClick: equipinfo is empty")
        return
    end

    local checkResult, equipConfig, itemConfig, equipdata = this.checkEquipCanRefining(actor, uid, equipinfo, type)
    if not checkResult and equipConfig == "需目标装备不满足洗练条件" then
        tipinfo(actor, equipConfig)
        return
    elseif not checkResult then
        error("EquipmentRefiningGemItem.onClick: checkEquipCanRefining failed" .. equipConfig)
        return
    end
    local typeConfig = EquipmentRefiningGemItem.config.typeMap[type]
    local costMap = { [typeConfig.gemId] = 1 }
    if not Bag.checkCostMap(actor, costMap) then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "道具不足")
        return
    end
    Bag.costMap(actor, costMap, "洗练消耗")
    local result, randomResult = this.changeEquipBaseAttr(actor, uid, equipinfo, itemConfig)
    if not result then
        error("EquipmentRefiningGemItem.onClick: changeEquipBaseAttr failed")
        return
    end
    equipdata.refining = result
    setitemextdata(actor, uid, equipdata)
    sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_REFINE_GEM_INFO, randomResult == EquipmentRefiningGemItem.RandomResult.INCREASE)
end

function this.doRandomCheck()
    local config = ConfigDataManager.getTableValue("cfg_global", "value", "id", EquipmentRefiningGemItem.config.rateGlobalId)
    if not config or config == "" then
        config = EquipmentRefiningGemItem.config.defaultRate
    end
    local rate = this.parseStringArray(config)
    if table.count(rate) == 0 then
        return EquipmentRefiningGemItem.RandomResult.DECREASE
    end
    local decreaseRate = rate[1][2]
    local randomValue = math.random(0, EquipmentRefiningGemItem.config.randomMaxValue)
    if randomValue < decreaseRate then
        return EquipmentRefiningGemItem.RandomResult.DECREASE
    else
        return EquipmentRefiningGemItem.RandomResult.INCREASE
    end
end

function this.checkEquipCanRefining(actor, uid, equipinfo, type)
    local equipdata = EquipAndAppear.getItemExtData(actor, uid)
    if not equipdata then
        return false, "需目标装备不满足洗练条件"
    end
    local level = ConfigDataManager.getTableValue("cfg_global", "value", "id", EquipmentRefiningGemItem.config.strengthenGlobalId)
    if not level or level == "" then
        return false, "洗练强化条件限制配置不存在"
    end
    if (not equipdata.strengthlv or equipdata.strengthlv < tonumber(level)) and type == 1 then
        return false, "需目标装备不满足洗练条件"
    end

    if equipdata.refining ~= nil then
        return false, "需目标装备不满足洗练条件"
    end

    local equipConfig = ConfigDataManager.getById("cfg_item", tonumber(equipinfo.cfgid))
    if not equipConfig then
        return false, "洗练装备配置不存在,equipId:" .. equipinfo.cfgid
    end

    local typeConfig = EquipmentRefiningGemItem.config.typeMap[type]
    if not typeConfig then
        return false, "洗练类型参数错误:" .. type
    end

    local itemConfig = ConfigDataManager.getById("cfg_item", typeConfig.gemId)
    if not itemConfig then
        return false, typeConfig.tips
    end

    local useparam = itemConfig.useparam
    if useparam and useparam ~= "" then
        local subtypeList = this.parseStringArray(useparam)
        if table.count(subtypeList) > 0 and not table.contains(subtypeList[1], tonumber(equipConfig.subtype)) then
            return false, "需目标装备不满足洗练条件"
        end
    end

    return true, equipConfig, itemConfig, equipdata
end

function this.changeEquipBaseAttr(actor, uid, equipinfo, itemConfig)
    if not itemConfig or not itemConfig.useparam2 then
        return nil, nil
    end

    local bagindex = equipinfo.bagindex
    local userParam2 = itemConfig.useparam2
    local useparam2List = this.parseStringArray(userParam2)

    if table.count(useparam2List) == 0 then
        return nil, nil
    end

    local atttable
    if bagindex == 0 then
        atttable = getitemattinfo(actor, 3, tonumber(equipinfo.cfgid), uid)
    else
        atttable = getitemattinfo(actor, 1, tonumber(equipinfo.cfgid), uid)
    end

    if not atttable or table.count(atttable) == 0 or not atttable.baseatt then
        return nil, nil
    end
    local addatt = {}
    local result = {}
    local randomResult = EquipmentRefiningGemItem.RandomResult.DECREASE
    randomResult = this.doRandomCheck()
    for k, v in pairs(atttable.baseatt) do
        for _, attgroup in pairs(useparam2List) do
            if attgroup[1] == tonumber(k) then
                local source = tonumber(v)
                local changeRate = attgroup[2] / EquipmentRefiningGemItem.config.randomScale
                local changeValue = math.max(1, math.floor(source * math.abs(changeRate) + 0.5))
                if randomResult == EquipmentRefiningGemItem.RandomResult.DECREASE then
                    v = source - changeValue
                else
                    v = source + changeValue
                    randomResult = EquipmentRefiningGemItem.RandomResult.INCREASE
                end
                result[k] = { source = source, current = v }
            end
        end
        table.insert(addatt, { attrid = tonumber(k), value = tonumber(v) })
    end
    setequipbasicattr(actor, uid, 1, addatt)
    return result, randomResult
end

function EquipmentRefiningGemItem.revertGem(actor, msgData)
    if not msgData then
        error("EquipmentRefiningGemItem.revertGem: msgData is nil")
        return
    end
    local uid = msgData.itemId
    if not uid then
        error("EquipmentRefiningGemItem.revertGem: uid is nil")
        return
    end
    local equipinfo = getequipinfo(actor, uid, 1)
    if table.count(equipinfo) == 0 then
        error("EquipmentRefiningGemItem.revertGem: equipinfo is empty")
        return
    end
    local equipdata = EquipAndAppear.getItemExtData(actor, uid)
    if not equipdata or not equipdata.refining then
        tipinfo(actor, "目标装备未洗练")
        return
    end

    local costMap = { [EquipmentRefiningGemItem.config.restoreGemId] = 1 }
    if not Bag.checkCostMap(actor, costMap) then
        sendluamsg(actor, LuaMessageIdToClient.TIPS, "道具不足")
        return
    end
    Bag.costMap(actor, costMap, "还原洗练消耗")
    local result = equipdata.refining
    local bagindex = equipinfo.bagindex
    local atttable
    if bagindex == 0 then
        atttable = getitemattinfo(actor, 3, tonumber(equipinfo.cfgid), uid)
    else
        atttable = getitemattinfo(actor, 1, tonumber(equipinfo.cfgid), uid)
    end

    if not atttable or not atttable.baseatt then
        error("EquipmentRefiningGemItem.revertGem: atttable is invalid")
        return
    end
    local addatt = {}
    for k1, v1 in pairs(atttable.baseatt) do
        local finalValue = v1
        if result and result[k1] then
            finalValue = result[k1].source
        end
        table.insert(addatt, { attrid = tonumber(k1), value = finalValue })
    end
    setequipbasicattr(actor, uid, 1, addatt)
    equipdata.refining = nil
    setitemextdata(actor, uid, equipdata)
    sendluamsg(actor, LuaMessageIdToClient.RES_EQUIP_RESTORE_GEM_INFO, true)
end

function this.parseStringArray(str)
    if not str or str == "" then
        return {}
    end
    local result = {}
    for part in string.gmatch(str, "[^|]+") do
        local subParts = {}
        for subPart in string.gmatch(part, "[^#]+") do
            table.insert(subParts, tonumber(subPart) or 0)
        end
        table.insert(result, subParts)
    end
    return result
end

MessageRouter:register(LuaMessageIdToSever.REQ_EQUIP_REFINE_GEM, EquipmentRefiningGemItem.onClick)
MessageRouter:register(LuaMessageIdToSever.REQ_EQUIP_RESTORE_GEM, EquipmentRefiningGemItem.revertGem)
