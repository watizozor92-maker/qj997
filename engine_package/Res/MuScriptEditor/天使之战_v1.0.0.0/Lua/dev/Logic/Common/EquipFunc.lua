---@class EquipFunc
EquipFunc = {}
local this = EquipFunc

local delayCheckAttr = nil

function this.Init()
    this.otherEquips = nil
    this.RegistEvents()
    this.equipIdToSuitId = {}
    local tbls = SL:GetConfigTable("cfg_equip_suit")
    ---@param v cfg_equip_suit_column
    for _, v in pairs(tbls) do
        for _, id in pairs(v.suitItemId) do
            this.equipIdToSuitId[id] = v.id
        end
    end

    -- 背包和锻造的内观缩放(已弃用,可使用GetItemEquipScale())
    this.bagEquipScale = SL:HasConfig("cfg_global", 570001) and tonumber(SL:GetConfig("cfg_global", 570001).value) or 1
    this.forgeEquipScale = SL:HasConfig("cfg_global", 570002) and tonumber(SL:GetConfig("cfg_global", 570002).value) or 1
    this.forgeShowEquipScale = SL:HasConfig("cfg_global", 570003) and tonumber(SL:GetConfig("cfg_global", 570003).value) or
    1
    ---合成的增加强化等级预览
    this.addStrengthLevel = 0
    this.canRun = false
    this.canSwim = false
    local run_str1 = SL:GetConfig("cfg_global",630003).value
    this.canRun_level = tonumber(run_str1)
    local run_str2 = SL:GetConfig("cfg_global",630004).value
    this.canSwim_level = tonumber(run_str2)
end

function this.Reset()
    this.UnRegistEvents()
    this.otherEquips = nil
    if delayCheckAttr then
        SL:UnSchedule(delayCheckAttr)
        delayCheckAttr = nil
    end
    this.canRun = false
    this.canSwim = false
end

function this.RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_INFO, this.ResOtherRoleInfoMessage)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, this.LUA_EVENT_ROLE_PROPERTY_CHANGE)
    SL:RegisterLUAEvent(LUA_EVENT_ENTER_MAP, this.LUA_EVENT_ENTER_MAP)
    SL:RegisterTrigger(LUA_TRIGGER_ME_OPEN_WALK_TO_RUN, this.LUA_TRIGGER_ME_OPEN_WALK_TO_RUN)
    SL:RegisterLUAEvent(LUA_EVENT_STRENGTH_OK, this.LUA_EVENT_STRENGTH_OK)
    SL:RegisterLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, this.OnEquipTakeOn)
    SL:RegisterLUAEvent(LUA_EVENT_TAKE_OFF_EQUIP, this.OnEquipTakeOff)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.STRENGTH_EQUIP_RESULT, this.STRENGTH_EQUIP_RESULT)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.APPEND_EQUIP_RESULT, this.APPEND_EQUIP_RESULT)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_REFINE_GEM_INFO, this.RES_EQUIP_REFINE_GEM_INFO)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_RESTORE_GEM_INFO, this.RES_EQUIP_RESTORE_GEM_INFO)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_REGENERATION_RESULT, this.RES_REGENERATION_RESULT)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_REGENERATION_EVOLUTION_RESULT, this.RES_REGENERATION_EVOLUTION_RESULT)
end

function this.UnRegistEvents()
    SL:UnRegisterLUAEvent(LUA_EVENT_ROLE_INFO, this.ResOtherRoleInfoMessage)
    SL:UnRegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, this.LUA_EVENT_ROLE_PROPERTY_CHANGE)
    SL:UnRegisterLUAEvent(LUA_EVENT_ENTER_MAP, this.LUA_EVENT_ENTER_MAP)
    SL:UnRegisterTrigger(LUA_TRIGGER_ME_OPEN_WALK_TO_RUN, this.LUA_TRIGGER_ME_OPEN_WALK_TO_RUN)
    SL:UnRegisterLUAEvent(LUA_EVENT_STRENGTH_OK, this.LUA_EVENT_STRENGTH_OK)
    SL:UnRegisterLUAEvent(LUA_EVENT_TAKE_ON_EQUIP, this.OnEquipTakeOn)
    SL:UnRegisterLUAEvent(LUA_EVENT_TAKE_OFF_EQUIP, this.OnEquipTakeOff)
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.STRENGTH_EQUIP_RESULT, this.STRENGTH_EQUIP_RESULT)
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.APPEND_EQUIP_RESULT, this.APPEND_EQUIP_RESULT)
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_REFINE_GEM_INFO, this.RES_EQUIP_REFINE_GEM_INFO)
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_EQUIP_RESTORE_GEM_INFO, this.RES_EQUIP_RESTORE_GEM_INFO)
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_REGENERATION_RESULT, this.RES_REGENERATION_RESULT)
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_REGENERATION_EVOLUTION_RESULT, this.RES_REGENERATION_EVOLUTION_RESULT)
end

------------------------用来显示别人的装备信息-----------start--------------------------------------
---@param message UserProtos.OtherRoleInfoRes
function this.ResOtherRoleInfoMessage(_, message)
    if message.type == 4 and tostring(message.role.rid) == this.otherRid then
        local equips = {}
        for _, v in pairs(message.equipIndex) do
            local wearBar, pos = SL:GetWearBarAndPosBaseEquipIndex(v.index)
            if not equips[wearBar] then
                equips[wearBar] = {}
            end
            equips[wearBar][pos] = v.equip
        end
        this.otherEquips = equips
    end
end

function this.OtherGetEquipWearBarIdPos(id)
    local index = this.GetEquipIndexByItemId(id)
    if not index then
        return
    end
    local wearBarId, pos = SL:GetWearBarAndPosBaseEquipIndex(index)
    return wearBarId, pos
end

function this.GetEquipIndexByItemId(itemId)
    if not this.otherEquips then
        return
    end
    for wearBar, posEquipInfo in pairs(this.otherEquips) do
        for pos, equip in pairs(posEquipInfo) do
            if (equip.id == itemId) then
                return this.GetIdxOfEquip(pos, wearBar)
            end
        end
    end
end

function this.checkOtherEquips()
    if not this.otherEquips then
        return false
    end
    return true
end

------------------------用来显示别人的装备信息-------end------------------------------------------

function this.GetIdxOfEquip(pos, gemWearCellId)
    if not gemWearCellId then
        return pos
    end
    return gemWearCellId << 16 | pos
end

-- 获取装备名字颜色
function this.GetEquipNameColor(cfgId)
    local colorid = SL:GetConfig('cfg_item', cfgId).color
    return SL:GetConfigMultiKeys('cfg_color', colorid, 'id').color
end

-- 获取装备强化等级
function this.GetEquipStrengthLevel(item)
    local strengthLevel = 0
    if item then
        if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" then
            strengthLevel = SL:JsonDecode(item.luaExtData).strengthlv or 0
        elseif item.gmExtInfo and item.gmExtInfo.luaExt and item.gmExtInfo.luaExt ~= "null" and item.gmExtInfo.luaExt ~= "" then
            local luaExt = SL:JsonDecode(item.gmExtInfo.luaExt)
            strengthLevel = luaExt.strengthlv or 0
        elseif item.modelExtInfo and item.modelExtInfo.strengthLevel then
            strengthLevel = item.modelExtInfo.strengthLevel
        elseif item.strenthlv then
            strengthLevel = item.strenthlv
        end
        if this.addStrengthLevel and this.addStrengthLevel > 0 then
            strengthLevel = strengthLevel + this.addStrengthLevel
        end
    end
    return strengthLevel
end

-- 获取装备的技能展示
function this.GetEquipSkillShow(item)
    if item then
        if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" and not string.isNullOrEmpty(SL:JsonDecode(item.luaExtData).skillName) then
            return SL:JsonDecode(item.luaExtData).skillName
        end
    end
    return nil
end

-- 获取装备技能id
function this.GetEquipSkillId(item)
    if item then
        if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" then
            return SL:JsonDecode(item.luaExtData).skillId or 0
        end
    end
    return nil
end

-- 获取装备的耐久度
function this.GetDurability(itemInfo)
    local Durability = 0
    if itemInfo.luaExtData ~= "null" and itemInfo.luaExtData ~= "" then
        local decode = SL:JsonDecode(itemInfo.luaExtData)
        Durability = decode.durabilityNum or 0
    end
    if this.addStrengthLevel and this.addStrengthLevel > 0 then
        local strengthLevel = this.GetEquipStrengthLevel(itemInfo)
        local curMax = this.GetMaxDurability(itemInfo, strengthLevel - this.addStrengthLevel)
        local nexMax = this.GetMaxDurability(itemInfo, strengthLevel)
        Durability = Durability + (nexMax - curMax) -- 固定值
    end
    return Durability
end

function this.GetMaxDurability(itemInfo, level)
    if not itemInfo then
        return 0
    end
    local maxDurability = SL:GetConfig("cfg_item", itemInfo.cfgId).Durability or 0
    if level == nil then
        level = this.GetEquipStrengthLevel(itemInfo)
    end
    if level == 0 then
        return maxDurability
    end
    local add1, add2, add3
    for i = 1, level do
        if i < 5 then
            if add1 == nil then
                add1 = tonumber(SL:GetConfig("cfg_global", 320012).value)
            end
            maxDurability = maxDurability + add1
        elseif i < 10 then
            if add2 == nil then
                add2 = tonumber(SL:GetConfig("cfg_global", 320013).value)
            end
            maxDurability = maxDurability + add2
        else
            if add3 == nil then
                add3 = tonumber(SL:GetConfig("cfg_global", 320014).value)
            end
            maxDurability = maxDurability + (i - add3)
        end
    end

    return maxDurability
end

---装备是否可强化
function this.EquipIsCanStrength(equip)
    if equip then
        if SL:HasConfig('cfg_equip_strengthen', equip['cfgId']) then
            ---@type cfg_equip_strengthen_column
            local strength_tbl = SL:GetConfig('cfg_equip_strengthen', equip['cfgId'])
            local nowLv = this.GetEquipStrengthLevel(equip)
            if nowLv >= 9 then
                return false
            end
            local maxLevel = strength_tbl.maxLevel
            ---首饰换表处理
            local ornament_tbl = SL:HasConfig('cfg_equip_ornamentsMain', equip['cfgId'])
            if ornament_tbl then
                maxLevel = InfoManager.equipJewelryInfo:GetCurLevelMaxStrength(equip)
            end
            local lv = nowLv + 1
            if nowLv >= maxLevel then
                return false
            end
            if SL:HasConfigTwoKeys('cfg_equip_strengthenCost', strength_tbl.costId, lv, 'costGroupId', 'level') then
                ---@type cfg_equip_strengthenCost_column
                local strengthenCostCfg = SL:GetConfigTwoKeys('cfg_equip_strengthenCost', strength_tbl.costId, lv,
                    'costGroupId', 'level')
                for _, v in ipairs(strengthenCostCfg.strengthenCost) do
                    ---@type cfg_equip_strengthenCost_column
                    local cfg = SL:GetConfig("cfg_equip_strengthenCost_v2", v)
                    local cfgId = cfg.costTag[1]
                    local needCount = cfg.costTag[2]
                    local bagCount = SL:GetBagItemCount(cfgId)
                    if bagCount >= needCount then
                        return true
                    end
                end
            end
            return false
        else
            return false
        end
    else
        return false
    end
    return true
end

--装备是否可强化
function this.EquipIsCanStrength2(equip)
    if equip then
        if SL:HasConfig('cfg_equip_strengthen', equip['cfgId']) then
            ---@type cfg_equip_strengthen_column
            local strength_tbl = SL:GetConfig('cfg_equip_strengthen', equip['cfgId'])
            local nowLv = this.GetEquipStrengthLevel(equip)
            if nowLv >= 9 then
                SL:TipMessage( SL:GetConfig('cfg_string',40002).text, 1, NoticeType.NoticeMid )
                return false
            end
            local maxLevel = strength_tbl.maxLevel
            ---首饰换表处理
            local ornament_tbl = SL:HasConfig('cfg_equip_ornamentsMain', equip['cfgId'])
            if ornament_tbl then
                maxLevel = InfoManager.equipJewelryInfo:GetCurLevelMaxStrength(equip)
            end
            local lv = nowLv + 1
            if nowLv >= maxLevel then
                SL:TipMessage( SL:GetConfig('cfg_string',40002).text, 1, NoticeType.NoticeMid )
                return false
            end
            if SL:HasConfigTwoKeys('cfg_equip_strengthenCost', strength_tbl.costId, lv, 'costGroupId', 'level') then
                ---@type cfg_equip_strengthenCost_column
                local strengthenCostCfg = SL:GetConfigTwoKeys('cfg_equip_strengthenCost', strength_tbl.costId, lv,
                    'costGroupId', 'level')
                for _, v in ipairs(strengthenCostCfg.strengthenCost) do
                    ---@type cfg_equip_strengthenCost_column
                    local cfg = SL:GetConfig("cfg_equip_strengthenCost_v2", v)
                    local cfgId = cfg.costTag[1]
                    local needCount = cfg.costTag[2]
                    local bagCount = SL:GetBagItemCount(cfgId)
                    if bagCount >= needCount then
                        return true
                    end
                end
            end
            SL:TipMessage( SL:GetConfig('cfg_string',268).text, 1, NoticeType.NoticeMid )
            return false
        else
            SL:TipMessage( SL:GetConfig('cfg_string',268).text, 1, NoticeType.NoticeMid )
            return false
        end
    else
        SL:TipMessage( SL:GetConfig('cfg_string',268).text, 1, NoticeType.NoticeMid )
        return false
    end
    return true
end

---装备是否可追加
function this.EquipIsCanAppend(equip)
    if equip then
        if SL:HasConfig('cfg_equip_appends', equip['cfgId']) then
            ---@type cfg_equip_appends_column
            local strength_tbl = SL:GetConfig('cfg_equip_appends', equip['cfgId'])
            local nowLv = this.GetEquipAppendLevel(equip)
            if nowLv >= 9 then
                return false
            end
            local maxLevel = strength_tbl.maxLevel
            ---首饰换表处理
            local ornament_tbl = SL:HasConfig('cfg_equip_ornamentsMain', equip['cfgId'])
            if ornament_tbl then
                maxLevel = InfoManager.equipJewelryInfo:GetCurLevelMaxAppend(equip)
            end
            local lv = nowLv + 1
            if nowLv >= maxLevel then
                return false
            end
            if SL:HasConfigTwoKeys('cfg_equip_appendsCost', strength_tbl.costId, lv, 'costGroupId', 'level') then
                ---@type cfg_equip_appendsCost_column
                local strengthenCostCfg = SL:GetConfigTwoKeys('cfg_equip_appendsCost', strength_tbl.costId, lv,
                    'costGroupId', 'level')
                for _, v in ipairs(strengthenCostCfg.appendCost) do
                    ---@type cfg_equip_appendsCost_v2_column
                    local cfg = SL:GetConfig("cfg_equip_appendsCost_v2", v)
                    local cfgId = cfg.costTag[1]
                    local needCount = cfg.costTag[2]
                    local bagCount = SL:GetBagItemCount(cfgId)
                    if bagCount >= needCount then
                        return true
                    end
                end
            end
            return false
        else
            return false
        end
    else
        return false
    end
    return true
end

---装备是否可追加
function this.EquipIsCanAppend2(equip)
    if equip then
        if SL:HasConfig('cfg_equip_appends', equip['cfgId']) then
            ---@type cfg_equip_appends_column
            local strength_tbl = SL:GetConfig('cfg_equip_appends', equip['cfgId'])
            local nowLv = this.GetEquipAppendLevel(equip)
            if nowLv >= 9 then
                return false
            end
            local maxLevel = strength_tbl.maxLevel
            ---首饰换表处理
            local ornament_tbl = SL:HasConfig('cfg_equip_ornamentsMain', equip['cfgId'])
            if ornament_tbl then
                maxLevel = InfoManager.equipJewelryInfo:GetCurLevelMaxAppend(equip)
            end
            local lv = nowLv + 1
            if nowLv >= maxLevel then
                SL:TipMessage( SL:GetConfig('cfg_string',74002).text, 1, NoticeType.NoticeMid )
                return false
            end
            if SL:HasConfigTwoKeys('cfg_equip_appendsCost', strength_tbl.costId, lv, 'costGroupId', 'level') then
                ---@type cfg_equip_appendsCost_column
                local strengthenCostCfg = SL:GetConfigTwoKeys('cfg_equip_appendsCost', strength_tbl.costId, lv,
                    'costGroupId', 'level')
                for _, v in ipairs(strengthenCostCfg.appendCost) do
                    ---@type cfg_equip_appendsCost_v2_column
                    local cfg = SL:GetConfig("cfg_equip_appendsCost_v2", v)
                    local cfgId = cfg.costTag[1]
                    local needCount = cfg.costTag[2]
                    local bagCount = SL:GetBagItemCount(cfgId)
                    if bagCount >= needCount then
                        return true
                    end
                end
            end
            SL:TipMessage( SL:GetConfig('cfg_string',259).text, 1, NoticeType.NoticeMid )
            return false
        else
            SL:TipMessage( SL:GetConfig('cfg_string',259).text, 1, NoticeType.NoticeMid )
            return false
        end
    else
        SL:TipMessage( SL:GetConfig('cfg_string',259).text, 1, NoticeType.NoticeMid )
        return false
    end
    return true
end

---装备是否可幸运激活
function this.EquipIsCanLucky(equip)
    if equip then
        if SL:HasConfig('cfg_equip_luck', equip['cfgId']) then
            ---@type cfg_equip_luck_column
            local strength_tbl = SL:GetConfig('cfg_equip_luck', equip['cfgId'])
            local nowLv = 0

            if not table.isNullOrEmpty(this.GetEquipLuckyAttr(equip)) then
                return false
            end
            if SL:HasConfigTwoKeys('cfg_equip_luckCost_v2', strength_tbl.groupId, nowLv, 'costGroupId', 'level') then
                ---@type cfg_equip_luckCost_v2_column
                local strengthenCostCfg = SL:GetConfigTwoKeys('cfg_equip_luckCost_v2', strength_tbl.groupId, nowLv,
                    'costGroupId', 'level')
                local cfg = strengthenCostCfg
                local cfgId = cfg.costTag[1]
                local needCount = cfg.costTag[2]
                local bagCount = SL:GetBagItemCount(cfgId, false)
                if bagCount >= needCount then
                    return true
                end
            end
            return false
        else
            return false
        end
    else
        return false
    end
    return false
end

-- 获取全身装备强化等级
function this.GetAllStrengthLevel()
    local equipAll = SL:GetMetaValue(EMetaVarGetKey.EQUIP_DATA)
    if not next(equipAll) or not next(equipAll[1]) then
        return 0
    end
    local allLevel = 0
    for _, v in pairs(equipAll[1]) do
        local level = this.GetEquipStrengthLevel(v)
        allLevel = allLevel + level
    end
    return allLevel
end

-- 获取装备追加等级
function this.GetEquipAppendLevel(item)
    local strengthLevel = 0
    if item then
        if item.luaExtData and item.luaExtData ~= "" then
            strengthLevel = SL:JsonDecode(item.luaExtData).appendlv or 0
        end
    end
    return strengthLevel
end

-- 获取全身装备追加等级
function this.GetAllAppendLevel()
    local equipAll = SL:GetMetaValue(EMetaVarGetKey.EQUIP_DATA)
    if not next(equipAll) or not next(equipAll[1]) then
        return 0
    end
    local allLevel = 0
    for _, v in pairs(equipAll[1]) do
        local level = this.GetEquipAppendLevel(v)
        allLevel = allLevel + level
    end
    return allLevel
end

-- 获取装备流光id
function this.GetEquipLiuGuangId(item, strengthlv)
    if not SL:HasConfig('cfg_equip_strengthen', item.cfgId) then
        return
    end
    local stream = SL:GetConfig('cfg_equip_strengthen', item.cfgId).stream
    local ret
    if stream then
        local strengthLevel = strengthlv or EquipFunc.GetEquipStrengthLevel(item)
        for _, streamInfo in ipairs(stream) do
            local nowStrengthLevel = streamInfo[1]
            if strengthLevel >= nowStrengthLevel then
                ret = streamInfo[2]
            else
                return ret
            end
        end
    end

    return ret
end

-- 获取装备幸运数据
function this.GetEquipLuckyAttr(item)
    if SL:HasConfig('cfg_equip_luck', item.cfgId) then
        local equipLuckTbl = SL:GetConfig('cfg_equip_luck', item.cfgId)
        if equipLuckTbl and item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" and SL:JsonDecode(item.luaExtData).luckAttr then
            local data = this.DataChange(SL:JsonDecode(item.luaExtData).luckAttr)
            local rate = SL:GetConfigTwoKeys("cfg_equip_luckGroup", 1, 1, "group", "lv").luckrate

            for i, v in ipairs(data) do
                v.luck = true
            end

            local rateData = {
                type = 600003,
                num = rate[2][1],
                luck = true
            }
            table.insert(data, rateData)
            table.sort(data, function(a, b)
                ---@type cfg_att_info_column
                local a_cfg = SL:GetConfig("cfg_att_info", a.type)
                local b_cfg = SL:GetConfig("cfg_att_info", b.type)
                return b_cfg.sort > a_cfg.sort
            end)
            return data
        end
    end
    return {}
end

--获取幸运属性增加的锻造概率，未激活未0
function this.GetEquipLuckyRate(item, cfgId)
    if table.isNullOrEmpty(this.GetEquipLuckyAttr(item)) then
        return 0
    end
    local luckLevel = 1 --暂时没有幸运等级
    local groupId = SL:GetConfig('cfg_equip_luck', item.cfgId).groupId
    if not SL:HasConfigTwoKeys('cfg_equip_luckGroup', groupId, luckLevel, 'group', 'lv') then
        return 0
    end
    local cfg = SL:GetConfigTwoKeys('cfg_equip_luckGroup', groupId, luckLevel, 'group', 'lv')
    local rateData = cfg.luckrate
    if table.contains(rateData[1], cfgId) then
        return rateData[2][1]
    else
        return 0
    end
end

---获取装备强化成功率幸运加成
function this.GetEquipStrengthLuckyRate(item)
    local luckAtt = this.GetEquipLuckyAttr(item)
    if table.isNullOrEmpty(luckAtt) then
        return 0
    end
    for i, v in pairs(luckAtt) do
        if v.type == 600003 then
            return v.num
        end
    end
    return 0
end

-- 获取装备基础属性数据
--[[function this.GetEquipStrengthAttr(item)
    local strengthenTbl = SL:GetConfig('cfg_equip_strengthen', item.cfgId)
    if strengthenTbl then
        local groupId = SL:GetConfig('cfg_equip_strengthen', item.cfgId).groupId
        local strengthLevel = this.GetEquipStrengthLevel(item)
        local nowAttrInfo = SL:GetConfigTwoKeys('cfg_equip_strengthenGroup', groupId, strengthLevel, 'group', 'lv')
        if strengthLevel > 0 then
            local att = this.DataChange(SL:JsonDecode(item.luaExtData).strengthattr)
            return att
        end
        if nowAttrInfo then
            return nowAttrInfo.att
        end
    end

    return {}
end]]

-- 获取装备强化数据
function this.GetEquipStrengthAttr(item)
    if SL:HasConfig('cfg_equip_strengthen', item.cfgId) then
        local groupId = SL:GetConfig('cfg_equip_strengthen', item.cfgId).groupId
        local strengthLevel = this.GetEquipStrengthLevel(item)
        local nowAttrInfo
        if strengthLevel > 0 then
            nowAttrInfo = SL:GetConfigTwoKeys('cfg_equip_strengthenGroup', groupId, strengthLevel, 'group', 'lv')
            local att = this.DataChange(SL:JsonDecode(item.luaExtData).strengthattr)
            local part = this.GetEquipModelPart(item.cfgId)
            if this.addStrengthLevel and this.addStrengthLevel > 0 then
                for _, v in pairs(nowAttrInfo.att) do
                    for _, k in pairs(att) do
                        if v[1] == k.type then
                            k.num = this.EquipStrengthAttrCal(v[2], strengthLevel, v[1], part)
                        end
                    end
                end
            end
            return att
        end
        if nowAttrInfo then
            return nowAttrInfo.att
        end
    end

    return {}
end

-- 获取装备基础属性数据
function this.GetEquipBaseAttr(item)
    if item then
        if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" and not table.isNullOrEmpty(SL:JsonDecode(item.luaExtData).baseAttr) then
            return this.DataChange(SL:JsonDecode(item.luaExtData).baseAttr)
        end
    end
    return {}
end

-- 获取装备套装部位属性数据
function this.GetEquipTaoZhuangEWai(item)
    if item then
        if item.luaExtData ~= "null" and item.luaExtData ~= "" and not table.isNullOrEmpty(SL:JsonDecode(item.luaExtData).tTaoZhuangEWai) then
            local attr = SL:JsonDecode(item.luaExtData).tTaoZhuangEWai
            local temp = {}
            for i, v in pairs(attr) do
                local s = string.split(v, '#')
                temp[tonumber(s[1])] = tonumber(s[2])
            end
            return this.DataChange(temp)
        end
    end
    return {}
end

---获取装备追加属性
function this.GetEquipAppendAttr(item)
    local outData = {}
    if SL:HasConfig('cfg_equip_appends', item.cfgId) then
        local appendTbl = SL:GetConfig('cfg_equip_appends', item.cfgId)
        local appendLevel = this.GetEquipAppendLevel(item)
        for i, groupId in pairs(appendTbl.groupId) do
            ---@type cfg_equip_appendsGroup_column
            local nowAttrInfo = SL:GetConfigTwoKeys('cfg_equip_appendsGroup', groupId, appendLevel, 'group', 'lv')
            if appendLevel > 0 then
                local appendAttr = SL:JsonDecode(item.luaExtData).appendattr
                local id = nowAttrInfo.att[1][1]
                local value = appendAttr[tostring(id)]
                table.insert(outData, { type = id, num = value, tips = nowAttrInfo.tips})
            end
        end
    end
    return outData
end

-- 获取装备Tips上追加需要展示的数据
function this.GetEquipAppendAttrInTips(item)
    local outData = {}
    local appendAtt = this.GetEquipAppendAttr(item)
    for i, v in pairs(appendAtt) do
        local attCfg = SL:GetConfig("cfg_att_info", tonumber(v.type))
        local value2 = this.GetAttrValueText(attCfg, v.num, true)
        local tips = string.format(v.tips, value2)
        table.insert(outData, { name = tips })
    end
    return outData
end

-- 获取装备再生等级
function this.GetEquipRegenerateLevel(item)
    local regenerationLevel = 0
    if item.luaExtData ~= "null" and item.luaExtData ~= "" then
        regenerationLevel = SL:JsonDecode(item.luaExtData).regenerationlv or 0
    end
    return tonumber(regenerationLevel)
end

-- 获取装备再生属性
function this.GetEquipRegenerate(item)
    if not item or not SL:HasConfig('cfg_equip_regeneration', item.cfgId) then
        return
    end
    local regenerateTbl = SL:GetConfig('cfg_equip_regeneration', item.cfgId)
    if regenerateTbl then
        if item.luaExtData ~= "null" and item.luaExtData ~= "" then
            local tab = SL:JsonDecode(item.luaExtData).regenerationattr
            return tab
        end
    end
end

function this.GetEquipRegenerateAttr(item)
    local message = this.GetEquipRegenerate(item)
    if message then
        local all_attr_id = {}
        for i = 1, 10, 1 do
            if message[tostring(i)] then
                table.insert(all_attr_id, message[tostring(i)].id)
            else
                break
            end
        end
        local att_list = {}
        for _, v in ipairs(all_attr_id) do
            local str = SL:GetConfig('cfg_equip_regenerationGroup', v).att
            local oneList = string.split(str, '#')
            table.insert(att_list, { type = tonumber(oneList[1]), num = tonumber(oneList[2]) })
        end
        return att_list
    end
end

---@param item CommonProtos.Item
---@param strengthenState number
---@param appendState number
---@param rebornState number
function this.GetTransferCost(item, strengthenState, appendState, rebornState)
    local strengthenCost = {}
    local appendCost = {}
    local rebornCost = {}
    local strengthenLevel = EquipFunc.GetEquipStrengthLevel(item)
    local appendLevel = EquipFunc.GetEquipAppendLevel(item)
    local rebornLevel = EquipFunc.GetEquipRegenerateLevel(item)
    ---@type cfg_equip_transfer_column
    local sourceTbl = SL:GetConfig("cfg_equip_transfer", item.cfgId)
    if strengthenState == "1" then
        for _, v in ipairs(sourceTbl.strengthenCost) do
            if strengthenLevel >= v[1] then
                strengthenCost["id"] = v[2]
                strengthenCost["num"] = v[3]
            else
                break
            end
        end
    end

    if appendState == "1" then
        for _, v in ipairs(sourceTbl.appendsCost) do
            if appendLevel >= v[1] then
                appendCost["id"] = v[2]
                appendCost["num"] = v[3]
            else
                break
            end
        end
    end

    if rebornState == "1" then
        for _, v in ipairs(sourceTbl.regenerationCost) do
            if rebornLevel >= v[1] then
                rebornCost["id"] = v[2]
                rebornCost["num"] = v[3]
            else
                break
            end
        end
    end

    local totalCost = { id = 0, num = 0 }
    if strengthenCost.id then
        totalCost.id = strengthenCost.id
        totalCost.num = strengthenCost.num + totalCost.num
    end

    if appendCost.id then
        totalCost.id = appendCost.id
        totalCost.num = appendCost.num + totalCost.num
    end

    if rebornCost.id then
        totalCost.id = rebornCost.id
        totalCost.num = rebornCost.num + totalCost.num
    end

    return totalCost
end

---@param sourceItem CommonProtos.Item @转移装备
---@param targetItem CommonProtos.Item @继承装备
function this.CheckEquipCanTransfer(sourceItem, targetItem)
    if sourceItem and targetItem then
        ---继承装备未曾锻造过
        if EquipFunc.GetEquipStrengthLevel(targetItem) == 0 and EquipFunc.GetEquipAppendLevel(targetItem) == 0 then
            ---目标装备无再生属性
            local targetRegenerate = EquipFunc.GetEquipRegenerate(targetItem)
            if targetRegenerate and next(targetRegenerate) then
                return false
            end
            ---转移装备有属性可转移
            if EquipFunc.GetEquipStrengthLevel(sourceItem) > 0 or EquipFunc.GetEquipAppendLevel(sourceItem) > 0 then
                ---@type cfg_equip_transfer_column
                local sourceTbl = SL:GetConfig("cfg_equip_transfer", sourceItem.cfgId)
                ---@type cfg_equip_transfer_column
                local targetTbl = SL:GetConfig("cfg_equip_transfer", targetItem.cfgId)
                if targetTbl and sourceTbl then
                    ---隶属同一转移组可转移
                    if targetTbl.transferGroup == sourceTbl.transferGroup then
                        local regenerate = EquipFunc.GetEquipRegenerate(sourceItem)
                        ---有再生追加判断再生组
                        if regenerate and next(regenerate) then
                            if targetTbl.regenerationGroup == sourceTbl.regenerationGroup then
                                return true
                            end
                        else
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function this.LUA_EVENT_ROLE_PROPERTY_CHANGE()
    if delayCheckAttr then
        SL:UnSchedule(delayCheckAttr)
        delayCheckAttr = nil
    end

    delayCheckAttr = SL:ScheduleOnce(0.2, function()
        local strength = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.strength)
        if SL:GetMeData() == nil then
            return
        end
        local agility = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.agility)
        local intelligence = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.intelligence)
        local itemList_1 = SL:GetWearBarsData(EEquipWearBarType.BaseEquip)
        local all_take_off = {}
        if itemList_1 then
            for _, item in pairs(itemList_1) do
                local is_off = false
                local cfg_id = item.cfgId
                local useAttLimit = SL:GetEquipValue(EMetaVarGetKey.EQUIP_WEAR_LIMIT, "", cfg_id)
                local entryAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_ENTRY_ATTR, "equip", cfg_id, item.id)
                for _, att in ipairs(useAttLimit) do
                    local att_type = att[1]
                    local att_num = att[2]
                    local offsetValue = EquipFunc.GetAttrValueOffset(att_type, att_num, entryAttr)
                    att_num = att_num - offsetValue
                    if att_type == EMUCharacterAttrType.strength then
                        if strength < att_num then
                            is_off = true
                            break
                        end
                    elseif att_type == EMUCharacterAttrType.agility then
                        if agility < att_num then
                            is_off = true
                            break
                        end
                    elseif att_type == EMUCharacterAttrType.intelligence then
                        if intelligence < att_num then
                            is_off = true
                            break
                        end
                    end
                end
                if is_off then
                    table.insert(all_take_off, item)
                end
            end
        end
        if table.count(all_take_off) > 0 then
            local all_str = ""
            for idx, item in ipairs(all_take_off) do
                local tab = SL:GetConfig("cfg_item", item.cfgId)
                local name = tab.name
                local color_id = tab.color
                local color_str = SL:GetConfig("cfg_color", color_id).color
                local one_str = "<color=" .. color_str .. ">" .. name .. "</color>"
                if idx < #all_take_off then
                    one_str = one_str .. "，"
                end
                all_str = all_str .. one_str
                local wearBarId, pos = SL:GetEquipWearBarIdPos(item.id)
                SL:TakeOffEquip(wearBarId, pos)
            end
            local str_cfg = SL:GetConfig("cfg_string", 28001).text
            local str = string.format(str_cfg, all_str)
            SL:CommonTipsMessage({ showTips = str, sureBtnText = "确定" })
        end
    end)
end

---替换装备背包界面按钮图片
function this:ReplaceEquipBagButton(list)
    for i, v in ipairs(list) do
        ---@type cfg_bagButton_column
        local cfg = SL:GetConfig("cfg_bagButton", i)
        GUI:Image_loadTexture(v, cfg.icon, "Atlas/UIBagPanel_Out.spriteatlas")
        GUI:setPosition(v, cfg.position[1], cfg.position[2])
        GUI:setPositionZ(v, cfg.position[3])
        GUI:setVisible(v, cfg.show == 1)
    end
end

---@return cfg_FashionGuide_column[]
function this.GetMeFashionEquipCfgs()
    local career = SL:MeData_GetCareer().baseCareer
    local tblcs = SL:GetConfigTable("cfg_FashionGuide")
    local fashionDatas = {}
    ---@param v cfg_FashionGuide_column
    for _, v in pairs(tblcs) do
        if v.career == career then
            table.insert(fashionDatas, v)
        end
    end
    return fashionDatas
end

---获取该套时装当前穿戴数量
function this.CheckFashionEquipWearNum(id)
    local count = 0
    if SL:HasConfig("cfg_FashionGuide", id) then
        ---@type cfg_FashionGuide_column
        local tbl = SL:GetConfig("cfg_FashionGuide", id)
        for _, v in pairs(tbl.fashionId) do
            ---@type cfg_item_column
            local itemCfg = SL:GetConfig("cfg_item", v)
            if itemCfg.strPart[1] then
                local equip = SL:MeData_GetEquipByPosAndWearBar(itemCfg.strPart[1], tbl.wearing)
                if equip then
                    count = count + 1
                end
            end
        end
    end
    return count
end

---获取属性文本
---@param round boolean 是否四舍五入
function this.GetAttText(attId, value, connectSign, round)
    connectSign = connectSign or " +"
    ---@type cfg_att_info_column
    local attCfg = SL:GetConfig("cfg_att_info", attId)
    if not string.isNullOrEmpty(attCfg.zuoYueMing) then
        return attCfg.zuoYueMing
    end
    local attText = attCfg.name .. connectSign .. this.GetAttrValueText(attCfg, value, round)
    return attText
end

---获取属性值文本
---@param round boolean 是否四舍五入
function this.GetAttrValueText(attCfg, attrValue, round)
    if attCfg.remarks == 1 then
        if round then
            return math.round(attrValue)
        end
        return attrValue
    else
        local temp = attrValue % 100 == 0
        local value = attrValue / 100
        return (temp and math.floor(value) or value) .. '%'
    end
end

---对属性列表进行文本处理
---@param isShowHead boolean 是否展示单手双手攻击力
---@param showMinMaxAtt boolean 是否展示最小最大属性(默认为 true)
---@param param {isOnlyUseName:boolean 是否只使用外部传入的 v.name round:boolean 属性值是否四舍五入 }
function this.GetBaseAttr(baseAttr, equip_pos, cfgId, id, connectSign, isShowHead, showMinMaxAtt, params)
    local baseAttrList = {}
    isShowHead = isShowHead and isShowHead or false
    showMinMaxAtt = showMinMaxAtt == nil and true or showMinMaxAtt
    local isOnlyUseName
    local round
    if params then
        isOnlyUseName = params.isOnlyUseName
        round = params.round
    end

    if isOnlyUseName then
        for i, v in pairs(baseAttr) do
            table.insert(baseAttrList, { name = v.name, value = "", type = v.type, color = v.color })
        end
        return baseAttrList
    end

    if not baseAttr then
        return baseAttrList
    end
    local max1
    local min1
    local max2
    local min2
    local max3
    local min3
    local max4
    local min4
    local max5
    local min5
    for i, v in pairs(baseAttr) do
        if v.type == 201011 then
            max1 = v
        elseif v.type == 201021 then
            min1 = v
        elseif v.type == 202011 then
            max2 = v
        elseif v.type == 202021 then
            min2 = v
        elseif v.type == 205021 then
            max3 = v
        elseif v.type == 205011 then
            min3 = v
        elseif v.type == 203021 then
            max4 = v
        elseif v.type == 203011 then
            min4 = v
        elseif v.type == 200011 then
            min5 = v
        elseif v.type == 200021 then
            max5 = v
        end
    end


    local speConnectSign = connectSign or " +"
    local twoHanded = 1
    local attackTypeName = ""
    -- 提前获取一次 twoHanded 避免重复调用
    if SL:HasConfig("cfg_equip_entryLib", cfgId) and isShowHead then
        twoHanded = equip_pos and SL:GetEquipValue(EMetaVarGetKey.EQUIP_TWO_HANDED, equip_pos, cfgId, id) or 1
        attackTypeName = (twoHanded == 1) and "双手" or "单手"
    end

    -- 封装插入基础属性的方法
    local function insertBaseAttr(minVal, maxVal)
        -- 增加 nil 安全检查防止运行时报错
        if not minVal or not maxVal or not minVal.num or not maxVal.num then
            return
        end
        local _value = minVal.num
        if showMinMaxAtt then
            _value = math.round(_value) .. " ˜ " .. math.round(maxVal.num)
        end
        table.insert(baseAttrList, {
            name = attackTypeName .. (isShowHead and "攻击力" or EAtkAttrTypeStr[minVal.type]),
            name = attackTypeName .. (isShowHead and "攻击力" or EAtkAttrTypeStr[minVal.type]),
            value = speConnectSign .. _value, -- 保证前后都有空格
            index = minVal.index,
            gemBelong = minVal.gemBelong,
            color = minVal.color,
            color_not_change = minVal.color_not_change
        })
    end

    -- 使用封装方法处理各组数据
    insertBaseAttr(min1, max1)
    insertBaseAttr(min2, max2)
    insertBaseAttr(min3, max3)
    insertBaseAttr(min4, max4)
    insertBaseAttr(min5, max5)
    for i, v in pairs(baseAttr) do
        if v.type == 201011 or v.type == 201021 or v.type == 202011 or v.type == 202021 or v.type == 205021 or v.type == 205011 or v.type == 203021 or v.type == 203011 then
        else
            if v.entryId and SL:HasConfig("cfg_equip_att", v.entryId) then
                local cfg = SL:GetConfig("cfg_equip_att", v.entryId)
                local nameAttr
                if cfg.name then
                    nameAttr = cfg.name
                end
                table.insert(baseAttrList,
                    { name = "", value = nameAttr, type = v.type, color = v.color, index = v.index, gemBelong = v
                    .gemBelong, luck = v.luck })
            else
                if SL:HasConfig("cfg_att_info", v.type) then
                    local nameAttr = SL:GetConfig("cfg_att_info", v.type).name
                    local _value
                    if this.chenckAttrShow(v.type) then
                        _value = EquipFunc.GetAttText(v.type, v.num, connectSign, round)
                        if not this.chenckAttrValue(v.type) then
                            _value = nameAttr
                        end
                        table.insert(baseAttrList,
                            { name = "", value = _value, type = v.type, color = v.color, index = v.index, gemBelong = v
                            .gemBelong, luck = v.luck })
                    end
                end
            end
        end
    end
    return baseAttrList
end

---不同属性用不同的攻击力
---@param attrTable table 属性表
---@param connectSign string|nil 连接符号，如果为空则只返回攻击力名称
---@return table<number,{text:string,min_atk:number,max_atk:number}> 文本描述, 最小攻击力值, 最大攻击力值
function this.GetAtkAttrText(attrTable, connectSign)
    if not attrTable or type(attrTable) ~= "table" then
        return "", 0, 0
    end

    local outData = {}
    for _, data in pairs(EAtkAttrTypeTable) do
        local min_atk = math.huge
        local max_atk = 0
        local name = ""
        for i, v in pairs(attrTable) do
            if data.min == v.type then
                min_atk = v.num
                name = EAtkAttrTypeStr[data.min]
            end

            if data.max == v.type then
                max_atk = v.num
                name = EAtkAttrTypeStr[data.max]
            end
        end

        if min_atk ~= math.huge then
            if connectSign == nil then
                name = name
            else
                name = name .. math.floor(min_atk) .. connectSign .. math.floor(max_atk)
            end
            table.insert(outData, { text = name, min_atk = min_atk, max_atk = max_atk })
        end
    end

    return outData
end

function this.chenckAttrShow(attId)
    return true
end

function this.chenckAttrValue(attId)
    local attShow = SL:GetConfig("cfg_att_info", attId).attShow

    if attShow == 1 then
        return true
    end
    return false
end

--- baseAttrs{{type=11100000,num=2},{type=11100000,num=2},}|strengthenAttrs{{1=11100000,num=2},{type=1113330,num=4},}
--- return baseAttrs{{type=11100000,num=4},{type=11100000,num=2},}|strengthenAttrs{{type=1113330,num=4},}
function this.MergeBaseAndStrengthenAttrs(baseAttrs, strengthenAttrs)
    if not baseAttrs or not strengthenAttrs then
        return baseAttrs or {}, strengthenAttrs or {}
    end
    baseAttrs = SL:CopyData(baseAttrs)
    -- 创建一个映射表，用于快速查找基础属性的位置
    local baseMap = {}
    for i, attr in ipairs(baseAttrs) do
        local attrType = attr.type
        if not baseMap[attrType] then
            baseMap[attrType] = {}
        end
        table.insert(baseMap[attrType], { index = i, attr = attr })
    end

    local unmergedStrengthen = {}

    -- 处理强化属性
    for _, strengAttr in ipairs(strengthenAttrs) do
        local strengType = strengAttr.type
        local strengValue = strengAttr.num

        -- 查找是否有对应的基础属性
        if baseMap[strengType] and #baseMap[strengType] > 0 then
            -- 取第一个匹配的基础属性进行合并
            local baseInfo = table.remove(baseMap[strengType], 1)
            local baseValue = baseInfo.attr.num

            -- 合并数值（相加）
            baseAttrs[baseInfo.index].num = baseValue + strengValue
            baseAttrs[baseInfo.index].color = "#80B2FF"
            baseAttrs[baseInfo.index].color_not_change = true
        else
            -- 没有对应的基础属性，保留为未合并的强化属性
            table.insert(unmergedStrengthen, strengAttr)
        end
    end

    return baseAttrs, unmergedStrengthen
end

--- {"attrId":"value",} -> {{type = attrId,num = value}}
--- {"11100000" = "2",} -> {{type = 11100000,num = 2}}
function this.DataChange(originData)
    if not originData then
        return {}
    end

    local result = {}
    for attrId, value in pairs(originData) do
        local id = tonumber(attrId)
        ---@type cfg_att_info_column
        local attTbl = SL:GetConfig("cfg_att_info", id)
        if not attTbl.attHide[1] or attTbl.attHide[1] ~= 0 then
            table.insert(result, {
                type = id,
                num = tonumber(value)
            })
        end
    end

    return result
end

-- 获取装备再生等级
function this.GetEquipOrigin(item)
    if item.luaExtData ~= "null" and item.luaExtData ~= "" then
        local originData = SL:JsonDecode(item.luaExtData)
        if originData and originData.fromType then
            local owner = ""
            local crateTime = os.date('%Y/%m/%d %H:%M', tonumber(originData.createTime))
            if originData.fromType == 1 and originData.owner then
                owner = "击杀：" .. originData.owner
                --else
                --owner = "作者：" .. originData.owner
            end
            return {
                fromText = originData.fromText or "",
                mapName = originData.mapName or "",
                owner = owner or "",
                crateTime = crateTime or "",
                fromType = originData.fromType or ""
            }
        end
    end
    return nil
end

---获取强化大师激活属性
---@return { { id, value } } 没激活就是空
function this.GetStrengthMasterActiveAttr(uiType, count)
    if uiType == nil then
        uiType = 1 -- 1 锻造， 2 追加
    end
    if count == nil then
        count = 1 -- 0计算部位总和等级，1计算每个部位等级
    end
    local tbl = SL:GetConfigTable("cfg_equip_master")
    local strPartIds = tbl[1].strPartId
    -- 孔位装备等级
    local strPartEquipLvs = {}
    local equips = SL:GetWearBarsData(1)
    -- 获取目标等级
    local targetLevel = count == 0 and 0 or 999
    for i, v in pairs(strPartIds) do
        if equips[v] then
            local level = uiType == 1 and this.GetEquipStrengthLevel(equips[v]) or this.GetEquipAppendLevel(equips[v])
            strPartEquipLvs[v] = level
        else
            strPartEquipLvs[v] = 0
        end
    end
    --- 计算当前等级
    for i, v in pairs(strPartEquipLvs) do
        if count == 0 then
            targetLevel = targetLevel + v
        else
            targetLevel = targetLevel > v and v or targetLevel
        end
    end

    local tempDatas = {}
    ---@type cfg_equip_master_column
    local cfg
    ---@param v cfg_equip_master_column
    for i, v in pairs(tbl) do
        if v.type == uiType and v.count == count then
            table.insert(tempDatas, v)
        end
    end

    -- 从小到大排序
    table.sort(tempDatas, function(a, b)
        return a.lv < b.lv
    end)

    ---@param v cfg_equip_master_column
    for i, v in pairs(tempDatas) do
        if targetLevel >= v.lv then
            cfg = v
        else
            break
        end
    end

    if cfg then
        local attr = {}
        local career = SL:MeData_GetCareer().baseCareer
        for i, v in pairs(cfg.att) do
            if v[1] == career then
                table.insert(attr, { id = v[2], value = v[3] })
            end
        end
        return attr
    end

    return nil
end

---获取装备颜色
function this.GetEquipOrItemNameColor(cfgId, itemInfo)
    if not cfgId and itemInfo then
        cfgId = itemInfo.cfgId
    end
    ---@type cfg_item_column
    local itemData = SL:GetConfig("cfg_item", cfgId)
    if itemData.type == 5 then
        if itemData.subType == 4 then
            return "#B266FF"
        end
        return "#FFCC19"
    elseif itemData.type == 2 then
        --装备颜色 及 强化后的颜色
        local strengthen = 0
        if itemInfo then
            strengthen = EquipFunc.GetEquipStrengthLevel(itemInfo)
        end
        if not (this.IsSuitEquip(cfgId) or this.IsExcellentEquip(cfgId)) then
            return strengthen > 6 and "#FFCC19" or "#FFFFFF"
        end
    end
    --通用获取颜色
    local name_color = SL:GetConfig("cfg_item", cfgId).color
    local color = SL:GetConfig("cfg_color", name_color).color
    return color
end

function this.IsSuitEquip(cfgId)
    if SL:HasConfig('cfg_equip_entryLib', cfgId) then
        ---@type cfg_equip_entryLib_column
        local entryLib = SL:GetConfig('cfg_equip_entryLib', cfgId)
        local qualityTbl = SL:GetConfigTable("cfg_equip_quality")
        ---@param v cfg_equip_quality_column
        for _, v in pairs(qualityTbl) do
            if not string.isNullOrEmpty(v.logo) and entryLib.initialRating >= v.stage[1] and entryLib.initialRating <= v.stage[2] then
                if v.logo == "img_icon_suit" then
                    return true
                end
            end
        end
    end
    return false
end

---是否是卓越装备
function this.IsExcellentEquip(cfgId)
    if SL:HasConfig('cfg_equip_entryLib', cfgId) then
        ---@type cfg_equip_entryLib_column
        local entryLib = SL:GetConfig('cfg_equip_entryLib', cfgId)
        local qualityTbl = SL:GetConfigTable("cfg_equip_quality")
        ---@param v cfg_equip_quality_column
        for _, v in pairs(qualityTbl) do
            if not string.isNullOrEmpty(v.logo) and entryLib.initialRating >= v.stage[1] and entryLib.initialRating <= v.stage[2] then
                if v.logo == "img_icon_excellent" then
                    return true
                end
            end
        end
    end
    return false
end

function this.IsWhiteEquip(cfgId)
    if SL:HasConfig('cfg_equip_entryLib', cfgId) then
        ---@type cfg_equip_entryLib_column
        local entryLib = SL:GetConfig('cfg_equip_entryLib', cfgId)
        local qualityTbl = SL:GetConfigTable("cfg_equip_quality")
        ---@param v cfg_equip_quality_column
        for _, v in pairs(qualityTbl) do
            if entryLib.initialRating >= v.stage[1] and entryLib.initialRating <= v.stage[2] then
                if v.name == "白装" then
                    return true
                end
            end
        end
    end
    return false
end

function this.GetItemIsBind(cfgId, itemInfo)
    if not cfgId and itemInfo then
        cfgId = itemInfo.cfgId
    end
    if not cfgId then
        return false
    end
    local isDeal = 0
    if itemInfo then
        if itemInfo.bind then
            isDeal = 2
        else
            local lockItem = SL:GetConfig("cfg_item", cfgId).lockItem
            if lockItem[1] then
                isDeal = lockItem[1]
            else
                isDeal = 1
            end
        end
    else
        local lockItem = SL:GetConfig("cfg_item", cfgId).lockItem
        if lockItem[1] then
            isDeal = lockItem[1]
        end
    end
    return isDeal == 2
end

--是否显示绑定信息
function this.ShowBindTips(cfgId)
    local show = SL:GetConfig("cfg_item", cfgId).tipsShow
    return show ~= 1
end

-- 获取道具成功率
function EquipFunc.getItemSuccessRate(cfg_synthesis, cfgId, itemInfo)
    -- SL:LogTable(cfg_synthesis, true)
    if cfg_synthesis == nil then
        -- SL:LogError("getItemSuccessRate", cfgId, itemInfo)
        return 0
    end
    -- 额外道具提供的成功率
    local specialConsumeRateCfg = cfg_synthesis.specialConsumeRate
    local specialConsumeRate = {}
    for i, v in pairs(specialConsumeRateCfg) do
        specialConsumeRate[v[1]] = v[2]
    end
    local item_cfg = SL:GetConfig("cfg_item", cfgId)
    if item_cfg.type == 2 then
        return EquipFunc.getEquipSuccessRate(cfg_synthesis, itemInfo)
    end
    -- 计算道具价值，转化成功率
    local jiazhi = item_cfg.value
    jiazhi = tonumber(jiazhi) or 0
    local successRate = 0
    local reduce = (cfg_synthesis.reduceitemrate == 0) and 1 or cfg_synthesis.reduceitemrate / 10000
    successRate = successRate + math.floor(jiazhi / 200 * reduce)

    local specialRate = specialConsumeRate[cfgId] or 0
    successRate = successRate + specialRate
    -- SL:LogError("getItemSuccessRate", jiazhi,reduce,successRate,specialRate)
    -- 计算装备强化的额外成功率
    return successRate
end

--强化系数
local tQiangHuaXiShu = {
    [5] = 4,
    [6] = 10,
    [7] = 25,
    [8] = 45,
    [9] = 65,
    [10] = 95,
    [11] = 135,
    [12] = 185,
    [13] = 245,
    [14] = 305,
    [15] = 365,
}
--获取装备价值
function EquipFunc.getEquipJiaZhi(itemInfo)
    local cfgId = itemInfo.cfgId
    local item_cfg = SL:GetConfig("cfg_item", cfgId)
    local value = item_cfg.value
    value = tonumber(value) or 0
    if value > 0 then
        return value
    end

    --装备等级（道具表字段 只参与价值计算）
    local level = item_cfg.calculatelevel
    level = tonumber(level) or 0
    --强化等级
    local strengthLevel = EquipFunc.GetEquipStrengthLevel(itemInfo)
    --装备系数
    local equipXiShu = level + strengthLevel * 3
    if tQiangHuaXiShu[strengthLevel] then
        equipXiShu = equipXiShu + tQiangHuaXiShu[strengthLevel]
    end
    --装备价值
    local equipCost = 0
    local isZhuoYueEquip = item_cfg.Outstanding == 1
    --是否是卓越装备
    if isZhuoYueEquip then
        equipCost = math.ceil((((equipXiShu + 25) + 40) * (equipXiShu + 25) * (equipXiShu + 25) / 8 + 100) / 100) * 100
    else
        equipCost = math.ceil(((equipXiShu + 40) * equipXiShu * equipXiShu / 8 + 100) / 100) * 100
    end

    local subType = item_cfg.subType

    --翅膀
    if tonumber(subType) == 13 then
        equipCost = math.ceil((equipXiShu + 40) * equipXiShu * equipXiShu * 11) + 40000000
    end
    --单手武器衰减
    local strPart = item_cfg.strPart
    if strPart == 1 or strPart == 2 then
        equipCost = equipCost * 80 / 100
    end
    ---装备价值不能超出
    if equipCost > 3000000000 then
        equipCost = 3000000000
    end
    return math.floor(equipCost)
end

-- 获取装备成功率
function EquipFunc.getEquipSuccessRate(cfg_synthesis, itemInfo)
    -- 额外道具提供的成功率
    local specialConsumeRateCfg = cfg_synthesis.specialConsumeRate
    local specialConsumeRate = {}
    for i, v in pairs(specialConsumeRateCfg) do
        specialConsumeRate[v[1]] = v[2]
    end
    -- 计算道具价值，转化成功率
    local jiazhi = EquipFunc.getEquipJiaZhi(itemInfo)
    -- SL:LogError("getEquipSuccessRate", jiazhi)
    jiazhi = tonumber(jiazhi) or 0
    local successRate = 0
    local reduce = (cfg_synthesis.reduceitemrate == 0) and 1 or cfg_synthesis.reduceitemrate / 10000
    successRate = successRate + math.floor(jiazhi / 200 * reduce)

    local specialRate = specialConsumeRate[itemInfo.itemConfigId] or 0
    successRate = successRate + specialRate
    -- SL:LogError("getEquipSuccessRate", jiazhi,reduce,successRate)
    -- 计算装备强化的额外成功率
    return successRate
end

local equipAppedLevelStr = {
    [1] = "z4",
    [2] = "z8",
    [3] = "z12",
    [4] = "z16",
}
---获取装备追加等级字符串
function EquipFunc.GetEquipAppendLevelStr(appedLevel)
    if equipAppedLevelStr[appedLevel] then
        return equipAppedLevelStr[appedLevel]
    end
    return tostring(appedLevel)
end

---获取装备的套装id
function EquipFunc.GetSuitIdByEquipCfgId(cfgId)
    local suitId = this.equipIdToSuitId[cfgId]
    if suitId == nil then
        local cfg = SL:GetConfig("cfg_item", cfgId)
        if cfg.bindEqualItem ~= 0 then
            suitId = this.equipIdToSuitId[cfg.bindEqualItem]
        end
    end

    return suitId
end

---获取装备的使用属性限制值
function this.GetEquipUseAttLimit(equip, cfgId, strengthLevel)
    if cfgId == nil then
        cfgId = equip.cfgId
    end
    if strengthLevel == nil then
        strengthLevel = this.GetEquipStrengthLevel(equip)
    end
    local limitAttInfo = {}
    -- if strengthLevel == 0 then
        local entryLibCfg = SL:GetConfig("cfg_equip_entryLib", cfgId)
        for i, v in pairs(entryLibCfg.useAttLimit) do
            limitAttInfo[v[1]] = v[2]
        end
        -- return limitAttInfo
    -- end
    -- local itemCfg = SL:GetConfig("cfg_item", cfgId)
    -- local addUseAttrLimit = itemCfg.Outstanding == 1 and 25 or 0 -- 卓越装备会有较高的属性限制

    -- if itemCfg.Qianghuall > 0 then
    --     limitAttInfo[EMUCharacterAttrType.strength] = this.GetUseAttLimitValue(itemCfg.Qianghuall, itemCfg
    --     .Calculatelevel, strengthLevel, addUseAttrLimit)
    -- end
    -- if itemCfg.Qianghuamj > 0 then
    --     limitAttInfo[EMUCharacterAttrType.agility] = this.GetUseAttLimitValue(itemCfg.Qianghuamj, itemCfg.Calculatelevel,
    --         strengthLevel, addUseAttrLimit)
    -- end
    -- if itemCfg.Qianghuazl > 0 then
    --     limitAttInfo[EMUCharacterAttrType.intelligence] = this.GetUseAttLimitValue(itemCfg.Qianghuazl,
    --         itemCfg.Calculatelevel, strengthLevel, addUseAttrLimit)
    -- end
    -- if itemCfg.Qianghuatl > 0 then
    --     limitAttInfo[EMUCharacterAttrType.spirit] = this.GetUseAttLimitValue(itemCfg.Qianghuatl, itemCfg.Calculatelevel,
    --         strengthLevel, addUseAttrLimit)
    -- end
    -- if itemCfg.Qianghuallts > 0 then
    --     limitAttInfo[EMUCharacterAttrType.command] = this.GetUseAttLimitValue(itemCfg.Qianghuallts,
    --         itemCfg.Calculatelevel, strengthLevel, addUseAttrLimit)
    -- end

    return limitAttInfo
end

---获取装备使用属性限制值公式计算
function this.GetUseAttLimitValue(attValue, itemLevel, strengthLevel, addUseAttrLimit)
    return math.floor(3 * (3 * strengthLevel + itemLevel + addUseAttrLimit) * (attValue / 100) + 20)
end

---获取装备是否可装备
function this.GetEquipCanPutOn(equip, cfgId, equip_pos, strengthLevel)
    if cfgId == nil then
        cfgId = equip.cfgId
    end
    if strengthLevel == nil then
        strengthLevel = this.GetEquipStrengthLevel(equip)
    end
    local entryAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_ENTRY_ATTR, equip_pos, cfgId, equip.id)
    local limitAttInfo = this.GetEquipUseAttLimit(nil, cfgId, strengthLevel)
    for i, v in pairs(limitAttInfo) do
        local my_attValue = SL:MeData_GetSpecialAttrValue(i)
        local offsetValue = this.GetAttrValueOffset(i, v, entryAttr)
        local attValue = v - offsetValue
        if my_attValue < attValue then
            return false
        end
    end

    return true
end

---获取被属性衰减过的实际生效属性
---@param attrList CommonProtos.EquipEntryAttrVo[] 幸运属性
function this.GetAttrValueOffset(attrId, attrValue, attrList)
    if not attrList then
        return 0
    end
    local specialValue = 0
    ---@type cfg_att_special_column[]
    local specialTable = SL:GetConfigTable("cfg_att_special")
    for i, a in pairs(specialTable) do
        if tostring(attrId) == a.param and table.count(a.type) > 0 and a.type[1] == 21 then
            ---@type cfg_att_special_column
            local specialTbl = a
            for _, v in pairs(attrList) do
                if v.type == specialTbl.id then
                    specialValue = v.num
                    break
                end
            end
            ---@type cfg_att_info_column
            local tbl = SL:GetConfig("cfg_att_info", specialTbl.id)
            if tbl then
                if tbl.remarks == 2 then
                    specialValue = attrValue * specialValue * 100
                end
            end
            break
        end
    end
    return specialValue
end


function this.CheckLevelCanEquip(equip)
    ---@type cfg_item_column
    local cfgInfo = SL:GetConfig("cfg_item", equip.cfgId)
    local needLevelList = cfgInfo.needLevelList
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    local count = #needLevelList
    if count ~= 0 then
        -- 超过某一级才能使用的装备
        if count == 1 then
            if tonumber(needLevelList[1]) > playerLevel then
                return false
            end
            -- 等级在某一区间才能用
        elseif count == 2 then
            if tonumber(needLevelList[1]) > playerLevel or playerLevel > tonumber(needLevelList[2]) then
                return false
            end
        end
    end
    return true
end

---@param equip CommonProtos.Item
function this.CheckJobCanEquip(equip)
    ---@type cfg_item_column
    local cfgInfo = SL:GetConfig("cfg_item", equip.cfgId)
    if cfgInfo.job[1] == nil or cfgInfo.job[1][1] == 0  then
        return true
    end
    local career = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN)
    for _, jobInfo in pairs(cfgInfo.job) do
        local baseCareer = jobInfo[1]
        local careerRank = jobInfo[2]
        if career.baseCareer == baseCareer and career.careerRank >= careerRank then
            return true
        end
    end
    return false
end

---@param item CommonProtos.Item
function this.CheckAttrsCanEquip(item)
    local strengthLevel = EquipFunc.GetEquipStrengthLevel(item)
    local needAttrs = {}
    -- 属性判断
    local needAttrList = EquipFunc.GetEquipUseAttLimit(item, item.cfgId, strengthLevel)
    for i, v in pairs(needAttrList) do
        local attrId = i
        local attrValue = v
        local attrCfg = SL:GetConfig("cfg_att_info", attrId)
        if attrCfg ~= nil then
            local haveAttr = SL:MeData_GetSpecialAttrValue(attrId)
            if this.attrOffset and this.attrOffset[attrId] then
                attrValue = attrValue + this.attrOffset[attrId]
            end
            if haveAttr < attrValue then
                table.insert(needAttrs, {attrId = attrId, attrValue = attrValue, subValue = attrValue - haveAttr})
            end
        end
    end

    this.attrOffset = nil
    return needAttrs
end

function this.SetRoleAttrValueOffset(offsetTbl)
    this.attrOffset = offsetTbl
end



---获取装备是否拥有后缀
function this.GetEquipHasSuffix(item)
    return not table.isNullOrEmpty(this.GetEquipSuffix(item))
end

---获取装备后缀
function this.GetEquipSuffix(item)
    local searchname = ""
    if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" then
        local suffix = SL:JsonDecode(item.luaExtData)
        if suffix then
            local strengthLevel = EquipFunc.GetEquipStrengthLevel(item)
            local appendLv = EquipFunc.GetEquipAppendLevel(item)
            if strengthLevel ~= 0 then
                searchname = searchname .. " +" .. strengthLevel
            end
            if appendLv ~= 0 then
                searchname = searchname .. " +属性"
            end
            if suffix.IsLuck and suffix.IsLuck == 1 then
                searchname = searchname .. " +幸运"
            end
            if suffix.skillName and not this.IsExcellentEquip(item.cfgId) then -- 卓越和大天使不显示 +技能
                local cfg = SL:GetConfig("cfg_item", item.cfgId)
                if cfg.wearBarID[1] ~= EEquipWearBarType.Archange then
                    searchname = searchname .. " +技能"
                end
            end
        end
    end

    return searchname
end

---获取装备是否拥有指定后缀
function this.GetEquipHasDesignatedSuffix(item, findSuffixes)
    local suffix = this.GetEquipSuffix(item)
    if string.isNullOrEmpty(suffix) then
        return false
    end
    for i, v in pairs(findSuffixes) do
        if string.contains(suffix, v) then
            return true
        end
    end

    return false
end

---获取词条
function this.GetEquipAttNameList()
    local tbls = SL:GetConfigTable("cfg_equip_att")
    local map = {}
    local out = {}
    table.insert(out, { stallShow = "卓越词条"})
    for i, v in ipairs(tbls) do
        if map[v.stallNum] == nil and v.stallNum ~= 0 then
            map[v.stallNum] = 1
            table.insert(out, v)
        end
    end
    
    return out
end

function this.SetTipsPos(self)
    if self.args.info and (self.args.info.posX or self.args.info.posY) then
        -- 获取屏幕宽度
        --local screenWidth = SL:GetMetaValue(EMetaVarGetKey.SCREEN_WIDTH)

        --local clickControl = self.clickControl or (self.args.info and self.args.info.clickControl) or InfoManager.mainUIInfo.clickControl
        --local x,y = GUI:GetWorldPosition(clickControl)
        
        -- 计算理想位置（右侧显示）
        local x = self.args.info.posX
        --local scrPoint_ = SL:ConvertWorldPos2Screen(x, y)
        -- 如果左侧，则在左侧显示
        if x <= 0 then
            self.isLeft = true
        else
            self.isLeft = false
        end
        return true
    end

    if self.args.equip_pos and self.args.equip_pos ~= "" then
        if self.args.equip_pos == "bag" or GUI:GetUI("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel") then
            GUI:setPositionX(self.view.root, 116)
        elseif self.args.equip_pos == "recover" then
            GUI:setPositionX(self.view.root, -301)
        end
        return true
    end
    return false
end

---获取装备的内观缩放
function this.GetEquipInScaleAtt(cfgId, itemCfg, mscale)
    if itemCfg == nil then
        itemCfg = SL:GetConfig("cfg_item", cfgId)
    end
    local modelCfg = SL:GetConfig("cfg_model_charactor", itemCfg.shape[1])
    local scale = modelCfg.inscale * mscale
    return scale .. "," .. scale .. "," .. scale
end

local dropItemColor = {}
function this.GetEquipNameAndColor(item)
    local cfg = SL:GetConfig("cfg_item", item.cfgId)
    local color = SL:GetConfig("cfg_color", cfg.dropcolor).color
    local name = cfg.name

    if cfg.type == 2 then
        if SL:HasConfig("cfg_equip_strengthen", item.cfgId) then
            if EquipFunc.IsExcellentEquip(item.cfgId) then -- 卓越装备
                color = this.GetDropItemNameColor(480005)
            else
                local strengthLevel = EquipFunc.GetEquipStrengthLevel(item)
                if this.GetEquipHasDesignatedSuffix(item, { "属性", "幸运", "技能" }) then -- 后缀词条装备
                    color = this.GetDropItemNameColor(480003)
                elseif strengthLevel > 0 and strengthLevel < 3 then
                    color = this.GetDropItemNameColor(480001)
                elseif strengthLevel > 2 then
                    color = this.GetDropItemNameColor(480002)
                end
            end
        else
            if cfg.wearBarID[1] == EEquipWearBarType.Archange then         -- 大天使装备
                color = this.GetDropItemNameColor(480004)
            elseif EquipFunc.GetSuitIdByEquipCfgId(item.cfgId) ~= nil then -- 套装
                color = this.GetDropItemNameColor(480005)
            end
        end

        name = this.GetEquipSuffix(item)
        --[[if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" and not string.isNullOrEmpty(SL:JsonDecode(item.luaExtData).searchname)  then
            name = SL:JsonDecode(item.luaExtData).searchname
        end]]
    end

    return name, color
end

---获取掉落物的颜色
function this.GetDropItemNameColor(id)
    local color = dropItemColor[id]
    if dropItemColor[id] ~= nil then
        return dropItemColor[id]
    else
        if SL:HasConfig("cfg_global", id) then
            color = SL:GetConfig("cfg_global", id).value
        else
            color = "#FFFFFF"
        end

        dropItemColor[id] = color
        return color
    end
end

function this.GetEquipEndTime(item)
    if item then
        if item.endTime == 0 then
            if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" and SL:JsonDecode(item.luaExtData).endTime then
                return tonumber(SL:JsonDecode(item.luaExtData).endTime)
            end
        end
        return item.endTime
    end
    return 0
end

function this.GetTipNameColor(item, cfgId)
    local cfgId = cfgId
    if item then
        if this.IsWhiteEquip(cfgId) then
            if this.GetEquipSkillShow(item) or not table.isNullOrEmpty(this.GetEquipLuckyAttr(item)) or not table.isNullOrEmpty(this.GetEquipAppendAttrInTips(item)) then
                return "#80B2FF"
            end
        end
    end
    return this.GetEquipNameColor(cfgId)
end

function this.CheckHaveEquip0Durability()
    if not SL:GetMetaValue(EMetaVarGetKey.EQUIP_DATA) then
        return false
    end
    local equips = SL:GetTotalWearEquips()
    for _, equipList in pairs(equips) do
        for _, equip in pairs(equipList) do
            local now = EquipFunc.GetDurability(equip)
            local max = EquipFunc.GetMaxDurability(equip)
            if now <= 0 and max ~= 0 then
                return true
            end
        end
    end
    return false
end

function this.SetTipsCommonPos(view)
    GUI:setPositionY(view.equip_name, -12)
    GUI:SetAttr(view.equip_name, "deltay", -0.5)
    GUI:setContentSize(view.text_MU_node, ETipsParameter.TipsWidth, ETipsParameter.TipsElementHight)
    GUI:setContentSize(view.text_deal_node, ETipsParameter.TipsWidth, ETipsParameter.TipsElementHight)
    GUI:setContentSize(view.equip_need_level_titlt_node, ETipsParameter.TipsWidth, ETipsParameter.TipsElementHight)
    GUI:setContentSize(view.equip_time_node, ETipsParameter.TipsWidth, ETipsParameter.TipsElementHight)
end

function this.GetMountData()
    local equips = SL:GetWearBarsData(1)
    for i, v in pairs(equips) do
        if v and v.cfgId then
            local cfg = SL:GetConfig("cfg_item", v.cfgId)
            if cfg and cfg.type == 2 and cfg.subType == 10001 then
                return v
            end
        end
    end
    return nil
end

function this.GetDefaultMountId()
    local data = EquipFunc.GetMountData()
    if data then
        local cfgs = SL:GetConfigTable("cfg_mount")
        ---@type cfg_item_column
        local cfg = SL:GetConfig("cfg_item", data.cfgId)
        ---@param v cfg_mount_column
        for i, v in ipairs(cfgs) do
            if v.itemId == data.cfgId or (cfg.bindEqualItem ~= 0 and v.itemId == cfg.bindEqualItem) then
                return v.id
            end
        end
    end
    return 0
end

function this.GetMountIsShow()
    local data = EquipFunc.GetMountData()
    if data then
        local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
        local roleData = SL:GetRoleById(tonumber(rid)).data
        if roleData then
            return roleData.isShowMount
        end
    end
    return false
end

---设置本地显示坐骑,策划嫌攻击隐藏的太慢了，本地先改变下
function this.SetMeLocalMountIsShow(show)
    local rid = SL:GetMetaValue("MAIN_ACTOR_ID")
    local role = SL:GetRoleById(tonumber(rid))
    if role then
        SL:LogError("设置本地显示坐骑")
        local roleData = role.data
        roleData.IsShowMount = show
    end
end

---比较装备的替换评分
function this.CompareItemGradeAndEntrys(oldItem, newItem, newEquipPos)
    --先比较类型 然后比较评分
    --评分相同则比较词条数量
    local old = this.GetEquipReplaceRating(oldItem)
    local new = this.GetEquipReplaceRating(newItem)
    if old and new and old[1] == new[1] then
        local oldGrade = old[2] or 0
        local newGrade = new[2] or 0
        oldGrade = oldGrade + this.GetEquipCostScore("equip", oldItem)
        newGrade = newGrade + this.GetEquipCostScore(newEquipPos or "bag", newItem)
        if newGrade > oldGrade then
            return true
            --[[elseif newGrade == oldGrade then
                local oldEntrys = SL:GetEquipEntrys(oldItem)
                local newEntrys = SL:GetEquipEntrys(newItem)
                return table.count(newEntrys) > table.count(oldEntrys)]]
        end
    end
    return false
end

---获取装备替换评分
---@param item CommonProtos.Item
function this.GetEquipReplaceRating(item)
    if SL.replaceEngineFunc[EReplaceEngineFunc.CalcEquipGrade] then
        return SL.replaceEngineFunc[EReplaceEngineFunc.CalcEquipGrade](item)
    else
        local cfgId = item.cfgId
        --配置的初始评分
        if SL:HasConfig("cfg_equip_entryLib", cfgId) then
            local cfg = SL:GetConfig("cfg_equip_entryLib", cfgId)
            return cfg.replaceRating
        end
        return nil
    end
end

---获取装备价值评分
function this.GetEquipCostScore(pos,item)
    -- 2.物理攻击固定值x2，防御固定值x1，攻速x0.5，魔力%x300
    SL.OpenTips_item = item
    local baseAtt = SL:GetEquipValue(EMetaVarGetKey.EQUIP_BASE_ATTR, pos, item.cfgId, item.id)
    SL.OpenTips_item = nil
    local strengthenAtt = this.GetEquipStrengthAttr(item)
    local appendAtt = this.GetEquipAppendAttr(item)
    baseAtt, strengthenAtt = EquipFunc.MergeBaseAndStrengthenAttrs(baseAtt, strengthenAtt)
    local score = 0
    local function GetAttScore(att)
        local tempScore = 0
        for i, v in pairs(att) do
            -- 最大攻击力 固定值x2
            if v.type == 201011 or v.type == 202011 or v.type == 200021 or v.type == 205021 then -- 201011（物理），202011（魔法攻击力），200021（物理+魔法），205021（诅咒攻击力）
                tempScore = tempScore + v.num * 2
            elseif v.type == 206011 then -- 防御固定值x1
                tempScore = tempScore + v.num * 1
            elseif v.type == 213021 then -- 攻速x0.5
                tempScore = tempScore + v.num * 0.5
            elseif v.type == 202042 then -- 魔力百分比x300
                tempScore = tempScore + v.num / 10000 * 300
            end
        end
        return tempScore
    end
    score = GetAttScore(baseAtt) + GetAttScore(strengthenAtt) + GetAttScore(appendAtt)
    -- 3.卓越词条每条20
    local entryAtt = SL:GetEquipEntrys(item)
    score = score + table.count(entryAtt) * 20
    -- 4.幸运+10
    local luckAtt = this.GetEquipLuckyAttr(item)
    score = score + (table.isNullOrEmpty(luckAtt) and 0 or 10)
    -- 5.弓手和剑士的武器技能都+20
    local skillName = EquipFunc.GetEquipSkillShow(item)
    if not string.isNullOrEmpty(skillName) then
        local career = SL:MeData_GetCareer()
        local skillId = this.GetEquipSkillId(item)
        if skillId and skillId > 0 then
            ---@type cfg_skill_info_column
            local skillInfoCfg = SL:GetConfig("cfg_skill_info", skillId, "skillID")
            for i, v in pairs(skillInfoCfg.needCareer) do -- 技能职业匹配
                if v[1] == career.baseCareer then
                    score = score + 200
                    break
                end
            end
        end
    end
    
    return score
end

---检查背包装备是否更好
function this.CheckBagEquipIsBetter(equip, equipPos)
    if not SL:CheckEquipBaseCareer(equip) then
        return false
    end
    ---@type cfg_item_column
    local itemCfg = SL:GetConfig("cfg_item", equip.cfgId)
    local equips = SL:GetWearBarsData(itemCfg.wearBarID[1])
    if itemCfg.strPart[1] == EEquipSlotType.TwoHandWeapon then -- 双手武器
        if equips[EEquipSlotType.TwoHandWeapon] then           -- 比较双手武器
            if this.CompareItemGradeAndEntrys(equips[EEquipSlotType.TwoHandWeapon], equip, equipPos) then
                return true
            end
        else
            -- 比较主副手
            local weapon = equips[EEquipSlotType.Weapon]
            local offHandWeapon = equips[EEquipSlotType.OffHandWeapon]
            if weapon == nil and offHandWeapon == nil then -- 主手为空
                return true
            end
            if weapon then
                if this.CompareItemGradeAndEntrys(weapon, equip, equipPos) then
                    return true
                end
            else
                return this.CheckEquipWearLimit(equip, EEquipSlotType.OffHandWeapon)
            end
        end
        return false
    end

    if itemCfg.subType == E_ItemSubType_Equip.MainSecWeapon then
        -- 先与双手武器比较
        if equips[EEquipSlotType.TwoHandWeapon] then
            return this.CompareItemGradeAndEntrys(equips[EEquipSlotType.TwoHandWeapon], equip, equipPos)
        end
        --主副手武器
        local weapon = equips[EEquipSlotType.Weapon]
        local offHandWeapon = equips[EEquipSlotType.OffHandWeapon]
        if weapon == nil and offHandWeapon == nil then -- 主副手都为空
            return true
        end
        if weapon then -- 只与主武器比较
            if this.CompareItemGradeAndEntrys(weapon, equip, equipPos) then
                return true
            end
        end
        if offHandWeapon == nil then
            -- 检查副手职业限制
            return this.CheckEquipWearLimit(equip, EEquipSlotType.OffHandWeapon)
        end
        return false
    end

    for i, v in pairs(itemCfg.strPart) do
        if (v == EEquipSlotType.Weapon or v == EEquipSlotType.OffHandWeapon) then -- 主副手武器,提前检查是否有双手武器存在
            if equips[EEquipSlotType.TwoHandWeapon] then
                local twoHandWeapon = equips[EEquipSlotType.TwoHandWeapon]
                local itemCfg2 = SL:GetConfig("cfg_item", twoHandWeapon.cfgId)
                local modelCfg = SL:GetConfig("cfg_model_charactor", itemCfg2.shape[1])
                if modelCfg.part == 6 or modelCfg.part == 7 then -- 弓箭手的武器单独处理
                    itemCfg2 = SL:GetConfig("cfg_item", equip.cfgId)
                    modelCfg = SL:GetConfig("cfg_model_charactor", itemCfg2.shape[1])
                    if modelCfg.part == 114 or modelCfg.part == 115 then
                        if equips[v] then
                            return this.CompareItemGradeAndEntrys(equips[v], equip, equipPos)
                        end
                        return true
                    end
                    return false
                else
                    return this.CompareItemGradeAndEntrys(equips[EEquipSlotType.TwoHandWeapon], equip, equipPos)
                end
            else
                local modelCfg = SL:GetConfig("cfg_model_charactor", itemCfg.shape[1])
                if modelCfg.part == 114 or modelCfg.part == 115 then -- 弓箭手单独处理, 箭袋不能单独穿
                    return false
                end
            end
        end
        if equips[v] then
            if this.CompareItemGradeAndEntrys(equips[v], equip, equipPos) then
                return true
            end
        else
            return this.CheckEquipWearLimit(equip, v)
        end
    end
    return false
end

---检查装备穿戴限制
---@param equip CommonProtos.Item 穿戴的装备
---@param pos EEquipSlotType 要穿戴的部位
function this.CheckEquipWearLimit(equip, pos)
    local itemCfg = SL:GetConfig("cfg_item", equip.cfgId)
    if pos == EEquipSlotType.OffHandWeapon and itemCfg.subType == E_ItemSubType_Equip.MainSecWeapon then
        --穿戴主副手武器时， 有些职业的副手装备需要单独做检测
        ---@type cfg_equip_entryLib_column
        local entryLib = SL:GetConfig("cfg_equip_entryLib", equip.cfgId)
        if not table.isNullOrEmpty(entryLib.assistantJob) and entryLib.assistantJob[1][1] ~= 0 then
            local canEquip = false
            local career = SL:MeData_GetCareer()
            for _, jobInfo in pairs(entryLib.assistantJob) do
                local baseCareer = jobInfo[1]
                local careerRank = jobInfo[2]
                if career.baseCareer == baseCareer and career.careerRank >= careerRank then
                    canEquip = true
                    break
                end
            end
            if canEquip == false then
                return false
            end
        end
    end
    return true
end

---背包界面的穿戴栏的缩放
function this.ItemBagEquipScale(itemCfgId)
    local scale = 1
    if itemCfgId and itemCfgId > 0 then
        local itemCfg = SL:GetConfig("cfg_item", itemCfgId)
        if itemCfg.shape[1] then
            local modelCfg = SL:GetConfig("cfg_model_charactor", itemCfg.shape[1])
            if modelCfg.bagwearzoom and modelCfg.bagwearzoom > 0 then
                scale = modelCfg.bagwearzoom
            end
        end
    end
    return scale
end

---锻造界面的穿戴栏的缩放
function this.ItemForgeEquipScale(itemCfgId)
    local scale = 1
    if itemCfgId and itemCfgId > 0 then
        local itemCfg = SL:GetConfig("cfg_item", itemCfgId)
        if itemCfg.shape[1] then
            local modelCfg = SL:GetConfig("cfg_model_charactor", itemCfg.shape[1])
            if modelCfg.forgewearzoom and modelCfg.forgewearzoom > 0 then
                scale = modelCfg.forgewearzoom
            end
        end
    end
    return scale
end

---锻造界面的展示装备的缩放
function this.ItemForgeShowEquipScale(itemCfgId)
    local scale = 1
    if itemCfgId and itemCfgId > 0 then
        local itemCfg = SL:GetConfig("cfg_item", itemCfgId)
        if itemCfg.shape[1] then
            local modelCfg = SL:GetConfig("cfg_model_charactor", itemCfg.shape[1])
            if modelCfg.displayzoom and modelCfg.displayzoom > 0 then
                scale = modelCfg.displayzoom
            end
        end
    end
    return scale
end

---获取展示装备的缩放
---@param itemCfgId number 装备的配置id
---@param equipScaleType EEquipScaleType 装备的缩放类型
---@return number 缩放值
function this.GetItemEquipScale(itemCfgId, equipScaleType)
    local scale = 1
    if equipScaleType == EEquipScaleType.BagEquipScale then
        return this.ItemBagEquipScale(itemCfgId)
    elseif equipScaleType == EEquipScaleType.ForgeEquipScale then
        return this.ItemForgeEquipScale(itemCfgId)
    elseif equipScaleType == EEquipScaleType.ForgeShowEquipScale then
        return this.ItemForgeShowEquipScale(itemCfgId)
    end
    return scale
end

local attrLimit
---获取装备强化属性值
function this.EquipStrengthAttrCal(value, lv, attrId, equipPart)
    if attrLimit == nil then
        attrLimit = {}
        if SL:GetConfig("cfg_global", 300001) then
            local limit = string.split(SL:GetConfig("cfg_global", 300001).value, '|')
            for i, v in pairs(limit) do
                local str = string.split(v, '#')
                attrLimit[tonumber(str[1])] = tonumber(str[2])
            end
        end
    end

    if attrId ~= nil and equipPart ~= nil then
        for i, v in pairs(attrLimit) do
            if i == equipPart and v == attrId then
                return math.round(value)
            end
        end
    end

    if lv > 9 then
        value = value + ( lv -  9) * (lv -  8) / 2
    end
    return math.round(value)
end

---获取装备模型部位
function this.GetEquipModelPart(cfgId)
    local itemCfg = SL:GetConfig("cfg_item", cfgId)
    return SL:GetConfig("cfg_model_charactor", itemCfg.shape[1]).part
end

function this.StrengthLevelChange()
    this.canRun = false
    this.canSwim = false
    local item1 = SL:GetMetaValue("EQUIP_DATA_LIST", EEquipSlotType.Boot)[1]
    -- SL:LogTable(item,true)
    if item1 then
        local strengthLevel = this.GetEquipStrengthLevel(item1)
        if strengthLevel >= this.canRun_level then
            this.canRun = true
        end
    end
    local item2 = SL:GetMetaValue("EQUIP_DATA_LIST", EEquipSlotType.Glove)[1]
    -- SL:LogTable(item2,true)
    if item2 then
        local strengthLevel = this.GetEquipStrengthLevel(item2)
        if strengthLevel >= this.canSwim_level then
            this.canSwim = true
        end
    end
end

function this.LUA_EVENT_ENTER_MAP()
    this.StrengthLevelChange()
end

function this.LUA_EVENT_STRENGTH_OK()
    SL:ScheduleOnce(0.1, function()
        this.StrengthLevelChange()
    end)
end

local no_run = false
function this.LUA_TRIGGER_ME_OPEN_WALK_TO_RUN()
    if EquipFunc.GetMountIsShow() then---骑乘不受影响
        return true
    end

    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    local mapCfg = SL:GetConfig("cfg_map_info",mapId)
    if mapCfg.area == 1 then
        return this.canRun
    elseif mapCfg.area == 2 then
        return this.canSwim
    end


    return no_run
end 

function this.OnEquipTakeOn()
    this.StrengthLevelChange()
end

function this.OnEquipTakeOff()
    this.StrengthLevelChange()
end

function this.STRENGTH_EQUIP_RESULT(_id, message)
    SL:onLUAEvent(LUA_EVENT_STRENGTH_OK,message)
    if not this.qianghua_item then
        return
    end
    if message.issuccess then
        local costId = SL:GetConfig('cfg_equip_strengthen', this.qianghua_item.cfgId).costId
        local firstRate = SL:GetConfigTwoKeys('cfg_equip_strengthenCost', costId, message.strengthlv, 'costGroupId', 'level').firstRate
        if firstRate == 1 then
            self:ShowEquipSuccessMask(this.qianghua_item.cfgId, message.strengthlv)
        end
    end 
    GUI:UIPanel_Close("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel")
    GUI:UIPanel_Open("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel",nil,nil,nil,false,function (temp)
        temp:UpdateData(message,1)
    end)
    this.qianghua_item = nil
end

function this.APPEND_EQUIP_RESULT(_id, message)
    SL:onLUAEvent(LUA_EVENT_APPEND_OK, message)
    GUI:UIPanel_Close("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel")
    GUI:UIPanel_Open("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel",nil,nil,nil,false,function (temp)
        temp:UpdateData(message,1)
    end)
end

--背包物品拖到穿戴栏锻造
function this.DragBagToEquipIForge(equip_id,bag_item,item_type)
    -- SL:LogError(equip_id)
    -- SL:LogTable(bag_item,true)
    local equip_item 
    if item_type == 0 then
        equip_item= SL:GetWearEquipByItemId(equip_id)
    elseif item_type == 1 then
        equip_item = SL:GetItemInfoByItemId(equip_id)
    end
    if not equip_item then
        return
    end
    if this.DragBagToEquipIForgeQiangHua(equip_id,bag_item,item_type) then
        return
    end
    if this.DragBagToEquipIForgeZhuiJia(equip_id,bag_item,item_type) then
        return
    end
    if this.DragBagToEquipIForgeXiLian(equip_id,bag_item,item_type) then
        return
    end
    if this.DragBagToEquipIForgeHuanYuan(equip_id,bag_item,item_type) then
        return
    end
    if this.DragBagToEquipIForgeZaiSheng(equip_id,bag_item,item_type) then
        return
    end
    if this.DragBagToEquipIForgeGaoJiJinHua(equip_id,bag_item,item_type) then
        return
    end
end


function this.DragBagToEquipIForgeQiangHua(equip_id,bag_item,item_type)
    local equip_item 
    if item_type == 0 then
        equip_item= SL:GetWearEquipByItemId(equip_id)
    elseif item_type == 1 then
        equip_item = SL:GetItemInfoByItemId(equip_id)
    end
    if not equip_item then
        return
    end
    --判断是否可以强化
    local item_id_data = SL:GetConfig("cfg_global",900002).value
    local item_id_list = string.split(item_id_data,'|')
    local no_bang_id = {}
    local bang_list = {}
    for i, v in ipairs(item_id_list) do
        local one_id = tonumber(v)
        table.insert(no_bang_id,one_id)
        local tab = SL:GetConfig("cfg_item",one_id)
        if tab.bindEqualItem then
            bang_list[one_id] = tab.bindEqualItem
        end
    end
    --是可以强化的道具
    if table.contains(no_bang_id,bag_item.cfgId) or table.contains(bang_list,bag_item.cfgId) then
        if this.EquipIsCanStrength2(equip_item) then
            local strengthLevel = this.GetEquipStrengthLevel(equip_item)
            local id1
            local id2
            if strengthLevel < 6 then
                if bang_list[no_bang_id[1]] then
                    if bag_item.cfgId ~= no_bang_id[1] and  bag_item.cfgId ~= bang_list[no_bang_id[1]] then
                        SL:TipMessage( SL:GetConfig('cfg_string',74001).text, 1, NoticeType.NoticeMid )
                        return true
                    end
                else
                    if bag_item.cfgId ~= no_bang_id[1] then
                        SL:TipMessage( SL:GetConfig('cfg_string',74001).text, 1, NoticeType.NoticeMid )
                        return true
                    end 
                end
                
            elseif strengthLevel < 9 then
                if bang_list[no_bang_id[2]] then
                    if bag_item.cfgId ~= no_bang_id[2] and  bag_item.cfgId ~= bang_list[no_bang_id[2]] then
                        SL:TipMessage( SL:GetConfig('cfg_string',74001).text, 1, NoticeType.NoticeMid )
                        return true
                    end
                else
                    if bag_item.cfgId ~= no_bang_id[2] then
                        SL:TipMessage( SL:GetConfig('cfg_string',74001).text, 1, NoticeType.NoticeMid )
                        return true
                    end
                end
            elseif strengthLevel >= 9 then
                SL:TipMessage( SL:GetConfig('cfg_string',40002).text, 1, NoticeType.NoticeMid )
                return true
            end
            -- 检查下一级属性够不够
            -- if not EquipFunc.GetEquipCanPutOn(equip_item, equip_item.cfgId, "Equip", EquipFunc.GetEquipStrengthLevel(equip_item) + 1) then
            --     SL:CommonTipsMessage({
            --                             showTips = SL:GetConfig("cfg_string", 53001).text,
            --                             isShowCancelBtn = false,
            --                         })
            --     return true
            -- end

            local costId = SL:GetConfig('cfg_equip_strengthen', equip_item.cfgId).costId
            local next_level = strengthLevel + 1
            local cost_info = SL:GetConfigTwoKeys('cfg_equip_strengthenCost', costId, next_level, "costGroupId", "level").strengthenCost
            local cfg_id
            for _, v in pairs(cost_info) do
                ---@type cfg_equip_strengthenCost_v2_column
                local cost2Cfg = SL:GetConfig("cfg_equip_strengthenCost_v2", v)
                if cost2Cfg.costTag[1] == bag_item.cfgId then
                    cfg_id = cost2Cfg.id
                end
            end
            this.qianghua_item = equip_item
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_STRENGTH_EQUIP, { itemId = equip_item.id, costCfgId = cfg_id })
        else
            -- SL:TipMessage( SL:GetConfig('cfg_string',268).text, 1, NoticeType.NoticeMid )--"该装备无法被强化",
        end
        return true
    end
end   
    
function this.DragBagToEquipIForgeZhuiJia(equip_id,bag_item,item_type)
    local equip_item 
    if item_type == 0 then
        equip_item= SL:GetWearEquipByItemId(equip_id)
    elseif item_type == 1 then
        equip_item = SL:GetItemInfoByItemId(equip_id)
    end
    if not equip_item then
        return
    end
    --判断是否可以追加
    local item_id_data = SL:GetConfig("cfg_global",900003).value
    local item_id_list = string.split(item_id_data,'|')
    local no_bang_id = {}
    local bang_list = {}
    for i, v in ipairs(item_id_list) do
        local one_id = tonumber(v)
        table.insert(no_bang_id,one_id)
        local tab = SL:GetConfig("cfg_item",one_id)
        if tab.bindEqualItem then
            bang_list[one_id] = tab.bindEqualItem
        end
    end
    --是可以追加的道具
    if table.contains(no_bang_id,bag_item.cfgId) or table.contains(bang_list,bag_item.cfgId) then
        if this.EquipIsCanAppend2(equip_item) then
            local strengthLevel = this.GetEquipAppendLevel(equip_item)
            local id1
            local id2
           if bang_list[no_bang_id[1]] then
                if bag_item.cfgId ~= no_bang_id[1] and  bag_item.cfgId ~= bang_list[no_bang_id[1]] then
                    SL:TipMessage( SL:GetConfig('cfg_string',74001).text, 1, NoticeType.NoticeMid )
                    return true
                end
            else
                if bag_item.cfgId ~= no_bang_id[1] then
                    SL:TipMessage( SL:GetConfig('cfg_string',74001).text, 1, NoticeType.NoticeMid )
                    return true
                end
            end
            
            local costId = SL:GetConfig('cfg_equip_appends', equip_item.cfgId).costId
            local next_level = strengthLevel + 1
            local cost_info = SL:GetConfigTwoKeys('cfg_equip_appendsCost', costId, next_level, "costGroupId", "level").appendCost
            local cfg_id
            for _, v in pairs(cost_info) do
                ---@type cfg_equip_appendsCost_v2_column
                local cost2Cfg = SL:GetConfig("cfg_equip_appendsCost_v2", v)
                if cost2Cfg.costTag[1] == bag_item.cfgId then
                    cfg_id = cost2Cfg.id
                end
            end
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_APPEND_EQUIP, { itemId = equip_item.id, costCfgId = cfg_id })
        else
            -- SL:TipMessage( SL:GetConfig('cfg_string',259).text, 1, NoticeType.NoticeMid )--"该装备无法被追加",
        end
        return true
    end

end

function this.IsXiLian(item)
    local xiLian = false
    if item then
        if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" then
            xiLian = SL:JsonDecode(item.luaExtData).refining or false
        end
    end
    return xiLian
end

function this.RES_EQUIP_REFINE_GEM_INFO(_id, message)
    GUI:UIPanel_Close("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel")
    GUI:UIPanel_Open("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel",nil,nil,nil,false,function (temp)
        temp:UpdateData({issuccess=message},2)
    end)
end

function this.DragBagToEquipIForgeXiLian(equip_id,bag_item,item_type)
    local equip_item 
    if item_type == 0 then
        equip_item= SL:GetWearEquipByItemId(equip_id)
    elseif item_type == 1 then
        equip_item = SL:GetItemInfoByItemId(equip_id)
    end
    if not equip_item then
        return
    end
    --判断是否可以洗练
    local item_id_data = SL:GetConfig("cfg_global",900004).value
    local item_id_list = string.split(item_id_data,'|')
    local no_bang_id = {}
    local bang_list = {}
    for i, v in ipairs(item_id_list) do
        local one_id = tonumber(v)
        table.insert(no_bang_id,one_id)
        local tab = SL:GetConfig("cfg_item",one_id)
        if tab.bindEqualItem then
            bang_list[one_id] = tab.bindEqualItem
        end
    end
    --是可以洗练的道具
    if table.contains(no_bang_id,bag_item.cfgId) or table.contains(bang_list,bag_item.cfgId) then
        local tab = SL:GetConfig("cfg_item",equip_item.cfgId)
        if tab.type ~= 2 then
            SL:TipMessage( SL:GetConfig('cfg_string',75002).text, 1, NoticeType.NoticeMid )
            return true
        end
        if this.IsXiLian(equip_item) then
            SL:TipMessage( SL:GetConfig('cfg_string',75001).text, 1, NoticeType.NoticeMid )
            return true
        end
        --攻击洗练石
        if tab.subType >= 1 and tab.subType <= 3 then
            if bag_item.cfgId == no_bang_id[2] or bag_item.cfgId == bang_list[2] then
                SL:TipMessage( SL:GetConfig('cfg_string',75002).text, 1, NoticeType.NoticeMid )
                return true
            end
            local strengthLevel = this.GetEquipStrengthLevel(equip_item)
            if strengthLevel < 9 then
                SL:TipMessage( SL:GetConfig('cfg_string',75003).text, 1, NoticeType.NoticeMid )
                return true
            end
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_REFINE_GEM, { itemId=equip_item.id,type=1})
        --防御洗练石
        elseif tab.subType==4 or tab.subType==6 or tab.subType==7 or tab.subType==8 or tab.subType==9 or tab.subType==11 then
            if bag_item.cfgId == no_bang_id[1] or bag_item.cfgId == bang_list[1] then
                SL:TipMessage( SL:GetConfig('cfg_string',75002).text, 1, NoticeType.NoticeMid )
                return true
            end
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_REFINE_GEM, { itemId=equip_item.id,type=2})
        else
            SL:TipMessage( SL:GetConfig('cfg_string',75002).text, 1, NoticeType.NoticeMid )
            return true
        end
        return true
    end
end

function this.RES_EQUIP_RESTORE_GEM_INFO(_id, message)
    GUI:UIPanel_Close("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel")
    GUI:UIPanel_Open("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel",nil,nil,nil,false,function (temp)
        temp:UpdateData({issuccess=message},3)
    end)
end

function this.DragBagToEquipIForgeHuanYuan(equip_id,bag_item,item_type)
    local equip_item 
    if item_type == 0 then
        equip_item= SL:GetWearEquipByItemId(equip_id)
    elseif item_type == 1 then
        equip_item = SL:GetItemInfoByItemId(equip_id)
    end
    if not equip_item then
        return
    end
    --判断是否可以还原
    local item_id_data = SL:GetConfig("cfg_global",900005).value
    local item_id_list = string.split(item_id_data,'|')
    local no_bang_id = {}
    local bang_list = {}
    for i, v in ipairs(item_id_list) do
        local one_id = tonumber(v)
        table.insert(no_bang_id,one_id)
        local tab = SL:GetConfig("cfg_item",one_id)
        if tab.bindEqualItem then
            bang_list[one_id] = tab.bindEqualItem
        end
    end
    --是可以还原的道具
    if table.contains(no_bang_id,bag_item.cfgId) or table.contains(bang_list,bag_item.cfgId) then
        if not this.IsXiLian(equip_item) then
            SL:TipMessage( SL:GetConfig('cfg_string',78001).text, 1, NoticeType.NoticeMid )
            return true
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_RESTORE_GEM, { itemId=equip_item.id,type=2})
        return true
    end
end

function this.RES_REGENERATION_RESULT(_,message)
    GUI:UIPanel_Close("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel")
    GUI:UIPanel_Open("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel",nil,nil,nil,false,function (temp)
        temp:UpdateData({issuccess=message},4)
    end)
end

function this.IsZaiSheng(item)
    local xiLian = false
    if item then
        if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" then
            local data = SL:JsonDecode(item.luaExtData)
            if data.regeneration and data.regeneration["1"] then
                xiLian = data.regeneration["1"]
            end
        end
    end
    return xiLian
end

function this.DragBagToEquipIForgeZaiSheng(equip_id,bag_item,item_type)
    local equip_item 
    if item_type == 0 then
        equip_item= SL:GetWearEquipByItemId(equip_id)
    elseif item_type == 1 then
        equip_item = SL:GetItemInfoByItemId(equip_id)
    end
    if not equip_item then
        return
    end
    --判断是否可以再生
    local item_id_data = SL:GetConfig("cfg_global",900006).value
    local item_id_list = string.split(item_id_data,'|')
    local no_bang_id = {}
    local bang_list = {}
    for i, v in ipairs(item_id_list) do
        local one_id = tonumber(v)
        table.insert(no_bang_id,one_id)
        local tab = SL:GetConfig("cfg_item",one_id)
        if tab.bindEqualItem then
            bang_list[one_id] = tab.bindEqualItem
        end
    end
    --是可以再生的道具
    if table.contains(no_bang_id,bag_item.cfgId) or table.contains(bang_list,bag_item.cfgId) then
        local tab = SL:GetConfig("cfg_item",equip_item.cfgId)
        if tab.type ~= 2 then
            SL:TipMessage( SL:GetConfig('cfg_string',77002).text, 1, NoticeType.NoticeMid )
            return true
        end
        if not SL:HasConfig("cfg_equip_regeneration", equip_item.cfgId) then
            SL:TipMessage( SL:GetConfig('cfg_string',77002).text, 1, NoticeType.NoticeMid )
            return true
        end
        if this.IsZaiSheng(equip_item) then
            SL:TipMessage( SL:GetConfig('cfg_string',77003).text, 1, NoticeType.NoticeMid )
            return true
        end
        local tar_level = SL:GetConfig('cfg_equip_regeneration',equip_item.cfgId).condition
        
        local strengthLevel = this.GetEquipStrengthLevel(equip_item)
        if strengthLevel < tar_level then
            SL:TipMessage( SL:GetConfig('cfg_string',77004).text, 1, NoticeType.NoticeMid )
            return true
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_REGENERATION, { itemId=equip_item.id})
    end
end

function this.RES_REGENERATION_EVOLUTION_RESULT(_,message)
    GUI:UIPanel_Close("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel")
    GUI:UIPanel_Open("dev/outui/KLEquipStrengthUI/Panel/KLEquipForgeEffect/KLEquipForgeEffectPanel",nil,nil,nil,false,function (temp)
        temp:UpdateData({issuccess=message},5)
    end)
end

function this.DragBagToEquipIForgeGaoJiJinHua(equip_id,bag_item,item_type)
    local equip_item 
    if item_type == 0 then
        equip_item= SL:GetWearEquipByItemId(equip_id)
    elseif item_type == 1 then
        equip_item = SL:GetItemInfoByItemId(equip_id)
    end
    if not equip_item then
        return
    end
    --判断是否可以高级进化
    local item_id_data = SL:GetConfig("cfg_global",900007).value
    local item_id_list = string.split(item_id_data,'|')
    local no_bang_id = {}
    local bang_list = {}
    for i, v in ipairs(item_id_list) do
        local one_id = tonumber(v)
        table.insert(no_bang_id,one_id)
        local tab = SL:GetConfig("cfg_item",one_id)
        if tab.bindEqualItem then
            bang_list[one_id] = tab.bindEqualItem
        end
    end
    --是可以高级进化的道具
    if table.contains(no_bang_id,bag_item.cfgId) or table.contains(bang_list,bag_item.cfgId) then
        local tab = SL:GetConfig("cfg_item",equip_item.cfgId)
        if tab.type ~= 2 then
            SL:TipMessage( SL:GetConfig('cfg_string',77001).text, 1, NoticeType.NoticeMid )
            return true
        end
        if not SL:HasConfig("cfg_equip_regeneration", equip_item.cfgId) then
            SL:TipMessage( SL:GetConfig('cfg_string',77001).text, 1, NoticeType.NoticeMid )
            return true
        end
        if not this.IsZaiSheng(equip_item) then
            SL:TipMessage( SL:GetConfig('cfg_string',77001).text, 1, NoticeType.NoticeMid )
            return true
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_REGENERATION_EVOLUTION, { itemId=equip_item.id})
    end
end

-- 获取镶嵌孔数量
function this.GetEquipGemHoleNum(item)
    local gemHoleNum = 0
    if item then
        if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" then
            gemHoleNum = SL:JsonDecode(item.luaExtData).gemHoleNum or 0
        end
    end
    return gemHoleNum
end

-- 获取萤石镶嵌数据
function this.GetEquipGemInlayData(item)
    local gemInlayData = {}
    if item then
        if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" then
            gemInlayData = SL:JsonDecode(item.luaExtData).gemScheme or {}
        end
    end
    gemInlayData = GUIUtil.tblkeytonumber(gemInlayData)
    return gemInlayData
end

-- 获取满足条件套装配置id列表
---@param item CommonProtos.Item
---@return table 满足条件套装配置id列表
function this.GetMeetGemSuitIdList(item)
    local suitCfgIds = {}
    if not item then
        return suitCfgIds
    end

    -- 点击item的镶嵌数据
    local gemTypeCountMap = {}
    local gemInlayData = EquipFunc.GetEquipGemInlayData(item)
    local actualGemTypes = {}
    for _, gemData in ipairs(gemInlayData) do
        local gemId = gemData.cfgId
        ---@type cfg_equip_gem_column
        local cfg_equip_gem = SL:GetConfig("cfg_equip_gem", gemId)
        if cfg_equip_gem then
            local gemType = cfg_equip_gem.gemBelong[1]
            table.insert(actualGemTypes, gemType)
            gemTypeCountMap[gemType] = (gemTypeCountMap[gemType] or 0) + 1
        else
            SL:LogError("cfg_equip_gem no config for id:" .. tostring(gemId))
        end
    end

    -- 判断是否是穿戴的装备，如果是穿戴的装备才会满足套装条件
    local isWearEquip = false
    local baseWearBar = SL:GeCareerBaseWearBar(SL:MeData_GetCareer())
    local equips = SL:GetWearBarsData(baseWearBar) or {}
    for _, equipItem in pairs(equips) do
        if equipItem.id == item.id then
            isWearEquip = true
        end
    end

    ---@type table<number, cfg_equip_gemSuit_column>
    local cfg_equip_gemSuitTable = SL:GetConfigTable("cfg_equip_gemSuit")
    for _, suitCfg in pairs(cfg_equip_gemSuitTable) do
        local condition = suitCfg.gemCondition
        local meetCondition = true
        local atttype = tostring(suitCfg.atttype)

        if atttype == "1" then
            -- 幸运荧光属性：保证镶嵌顺序和数量与条件完全一致
            -- 条件格式：{{gemType,count},{gemType,count},...}
            local expectedGemTypes = {}
            for _, cond in ipairs(condition or {}) do
                local gemType = cond[1]
                local gemCount = cond[2] or 0
                for _ = 1, gemCount do
                    table.insert(expectedGemTypes, gemType)
                end
            end

            if #expectedGemTypes ~= #actualGemTypes then
                meetCondition = false
            else
                for i = 1, #expectedGemTypes do
                    if expectedGemTypes[i] ~= actualGemTypes[i] then
                        meetCondition = false
                        break
                    end
                end
            end
        elseif atttype == "2" then
            -- 套装属性：要求该item是穿戴身上的装备，且满足镶嵌数量条件（不强制顺序）
            if not isWearEquip then
                meetCondition = false
            end
            if meetCondition then
                for _, cond in ipairs(condition or {}) do
                    local gemType = cond[1]
                    local gemCount = cond[2]
                    if (gemTypeCountMap[gemType] or 0) < gemCount then
                        meetCondition = false
                        break
                    end
                end
            end
        else
            -- 未知类型按“只校验数量条件”处理
            for _, cond in ipairs(condition or {}) do
                local gemType = cond[1]
                local gemCount = cond[2]
                if (gemTypeCountMap[gemType] or 0) < gemCount then
                    meetCondition = false
                    break
                end
            end
        end

        if meetCondition then
            table.insert(suitCfgIds, suitCfg.id)
        end
    end
    return suitCfgIds
end

-- 获取萤石属性
function this.GetGemAttr(item)
    local gemAttr = {}
     if item then
        if item.luaExtData and item.luaExtData ~= "null" and item.luaExtData ~= "" then
            gemAttr = SL:JsonDecode(item.luaExtData).gemAttr or {}
        end
    end
    return gemAttr
end
