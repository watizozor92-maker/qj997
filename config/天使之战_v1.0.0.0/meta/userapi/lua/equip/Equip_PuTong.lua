Equip_PuTong = {}
local this = Equip_PuTong
local filename = "Equip_PuTong"

function this.getData(actor)
    local tab = {}
    return tab
end


---@param isDrop number 是否掉落  paramsource等于0为掉落触发，为1是生成触发
function this.qzEquipAtt(itemCfgId, mboxCfg, isDrop)
    local result = {}
    local itemTable = ConfigDataManager.getById("cfg_item", itemCfgId)
    if itemTable == nil then
        return result
    end
    if itemTable.type ~= "2" then
        return result
    end

    local isCan = isDrop == string.tonumber(itemTable.paramsource)
    -- 强化
    if not string.isNullOrEmpty(mboxCfg.strengthenzidai) then
        this.genStrengthen(result, itemCfgId, mboxCfg.strengthenzidai)
    else
        if not string.isNullOrEmpty(itemTable.strengthenzidai) and isCan then
            this.genStrengthen(result, itemCfgId, itemTable.strengthenzidai)
        end
    end

    -- 追加
    if not string.isNullOrEmpty(mboxCfg.appendszidai) then
        this.processAppendAttribute(result, itemCfgId, mboxCfg.appendszidai)
    else
        if not string.isNullOrEmpty(itemTable.appendszidai) and isCan then
            this.processAppendAttribute(result, itemCfgId, itemTable.appendszidai)
        end
    end

    -- 幸运
    if not string.isNullOrEmpty(mboxCfg.luckzidai) then
        this.processLuckAttribute(result, itemCfgId, mboxCfg.luckzidai)
    else
        if not string.isNullOrEmpty(itemTable.luckzidai) and isCan then
            this.processLuckAttribute(result, itemCfgId, itemTable.luckzidai)
        end
    end

    -- 技能

    if not string.isNullOrEmpty(mboxCfg.skillzidai) then
        this.radomSkill(result, mboxCfg.skillzidai)
    else
        if not string.isNullOrEmpty(itemTable.skillzidai) and isCan then
            this.radomSkill(result, itemTable.skillzidai)
        end
    end

    if isDrop == 0 then
        -- 防止掉落触发了，进背包再次触发
        result["isDropTrigger"] = true
    end

    return result
end

function this.radomSkill(result, skillzidai)
    local skillResult, skillInfo = Equip_JiNeng.radomSkill(skillzidai)
    if skillResult then
        result["skillName"] = skillInfo[1]
        result["skillId"] = skillInfo[2]
        result["skillLevel"] = skillInfo[3]
        result["IsSetSkill"] = 1
    end
end

-- 处理追加属性
function this.processAppendAttribute(result, itemCfgId, appendConfigString)
    local attCountWeight = ItemSynthesis.string2table(appendConfigString)
    local appendLevels = {}
    for _, value in pairs(attCountWeight) do
        table.insert(appendLevels, {lv = tonumber(value[2]), qz = tonumber(value[1])})
    end
    local index = API.GetQZ(appendLevels)
    local selectedInfo = appendLevels[index]
    if selectedInfo.lv > 0 then
        local groupId = ConfigDataManager.getTableValue("cfg_equip_appends", "groupId", "id", itemCfgId)
        local attr = EquipAndAppear.getZhuiJiaAttrs(selectedInfo.lv, groupId)

        result["appendlv"] = selectedInfo.lv
        result["appendattr"] = attr
        result["originalAppendattr"] = attr
    end
end

-- 处理幸运属性
function this.processLuckAttribute(result, itemCfgId, luckConfigString)
    local randomNum = math.random(10000)
    if randomNum <= tonumber(luckConfigString) then
        local groupId = ConfigDataManager.getTableValue("cfg_equip_luck", "groupId", "id", itemCfgId)
        local att = ConfigDataManager.getTableValue("cfg_equip_luckGroup", "att", "group", groupId, "lv", 1)
        local luckAttributes = string.toIntIntMap(att, "#", "|")
        result["IsLuck"] = 1
        result["luckAttr"] = luckAttributes
    end
end


-- 上下文；道具配置id;表字段配置，格式要求统一
function this.genStrengthen(result, itemCfgId, cfgString)
    local attCountWeight = ItemSynthesis.string2table(cfgString)
    local tNum = {}
    for _, value in pairs(attCountWeight) do
        table.insert(tNum, { lv = tonumber(value[2]), qz = tonumber(value[1]) })
    end
    local index = API.GetQZ(tNum)
    local info = tNum[index]
    if info.lv > 0 then
        result["strengthlv"] = info.lv
        local groupId = ConfigDataManager.getTableValue("cfg_equip_strengthen", "groupid", "id", itemCfgId)
        local att = ConfigDataManager.getTableValue("cfg_equip_strengthenGroup", "att", "group", groupId, "lv", info.lv)
        local durability = string.tonumber(ConfigDataManager.getTableValue("cfg_item", "durability", "id", itemCfgId))
        local addDurability = EquipDurability.getChangeDurability(0, info.lv)
        local attr = string.toIntIntMap(att, "#", "|")
        result["strengthattr"] = attr
        result["originalStrengthattr"] = attr
        result["durabilityNum"] = math.min(durability + addDurability, EquipDurability.getMaxDurability(itemCfgId, info.lv))
    end
end







function Equip_PuTong.randomBoxQzEquipAtt(itemCfgId, tableName)
    local boxConfig = ConfigDataManager.getTableFirst(tableName, "item", itemCfgId)
    if table.isNullOrEmpty(boxConfig) then
        error("随机宝箱生成装备数据失败,配置不存在，tableName:" .. tableName .. ";itemCfgId:" .. itemCfgId)
    end
    local result = {}
    -- 强化
    if not string.isNullOrEmpty(boxConfig.strengthenbaoxiang) then
        this.genStrengthen(result, itemCfgId, boxConfig.strengthenbaoxiang)
    end
    -- 追加
    if not string.isNullOrEmpty(boxConfig.appendsbaoxiang) then
        this.processAppendAttribute(result, itemCfgId, boxConfig.appendsbaoxiang)
    end
    -- 幸运
    if not string.isNullOrEmpty(boxConfig.luckbaoxiang) then
        this.processLuckAttribute(result, itemCfgId, boxConfig.luckbaoxiang)
    end
    -- 技能
    if not string.isNullOrEmpty(boxConfig.skillbaoxiang) then
        local skillResult, skillInfo = Equip_JiNeng.radomSkill(boxConfig.skillbaoxiang)
        if skillResult then
            result["skillName"] = skillInfo[1]
            result["skillId"] = skillInfo[2]
            result["skillLevel"] = skillInfo[3]
            result["IsSetSkill"] = 1
        end
    end

    -- 作为标识，防止生成道具也触发了这个规则
    result["isDropTrigger"] = true


    return result
end
