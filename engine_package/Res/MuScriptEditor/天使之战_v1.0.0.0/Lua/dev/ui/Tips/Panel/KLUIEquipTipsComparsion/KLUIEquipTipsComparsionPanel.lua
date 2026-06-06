---@class KLUIEquipTipsComparsionPanel:UIKmlLuaPanelBase
---@field view KLUIEquipTipsComparsionPanelView
local KLUIEquipTipsComparsionPanel = class(UIKmlLuaPanelBase)
local this = KLUIEquipTipsComparsionPanel

---创建时调用一次
function this:Init()
    EquipFunc.SetTipsCommonPos(self.view)
    self.otherArchange = nil
    if self.args.info and self.args.info.hideMask then
        GUI:setVisible(self.view.background_close, false)
    else
        GUI:setVisible(self.view.background_close, true)
    end
    if self.args.info and self.args.info.isRight then
        GUI:setAnchorPoint(self.view.root, 2, 0)
    end
    if self.args.info and self.args.info.posX then
        GUI:setPositionX(self.view.root, self.args.info.posX)
    end
    
    GUI:DataListInitData(self.view.equipzhiyeNeedData, function()
        return self:NeedCareerDataListItemCountFunc()
    end, function(realIndex)
        return self:NeedCareerDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:NeedCareerDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:NeedCareerDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListInitData(self.view.equipNeedData, function()
        return self:NeedDataListItemCountFunc()
    end, function(realIndex)
        return self:NeedDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:NeedDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:NeedDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListInitData(self.view.all_info_data, function()
        return self:EquipAttrDataListItemCountFunc()
    end, function(realIndex)
        return self:EquipAttrDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:EquipAttrDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:EquipAttrDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListInitData(self.view.origin_info_data, function()
        return self:EquipOriginListItemCountFunc()
    end, function(realIndex)
        return self:EquipOriginListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:EquipOriginListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:EquipOriginListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListInitData(self.view.base_info_data, function()
        return #self.base_info
    end, function(realIndex)
        return self:EquipAttrDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:EquipAttrDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:EquipBaseAttrDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.firstCharge_list = { 28810531, 28820531, 28830531 }
    self.gemOtherPlayerId = nil
    self:InitControl()
    
    self.btnTempList = {
        [1] = self.view.duanzaobtn,
        [2] = self.view.breakbtn,
        [3] = self.view.tuoxiabtn,
        [4] = self.view.shengjibtn
    }
end

function this:InitControl()
    local alplValue = 90
    if SL:HasConfig("cfg_global", 290005, "id") then
        alplValue = tonumber(SL:GetConfig("cfg_global", 290005, "id").value)
    end
    --GUI:Image_setAlpha(self.view.panel_bg, alplValue / 100)
end

---界面显示时调用一次
function this:Show()
    if SL:GetConfig("cfg_item", self.args.cfgId, "id").wearBarID[1] == EEquipWearBarType.Archange and self.args.info and self.args.info.otherRid and self.args.id then
        ---@type KLUIRankListPanel
        local ui = GUI:GetUI("dev/outui/UIRankList/Panel/KLUIRankList/KLUIRankListPanel")
        if ui then
            self.otherArchange = ui:GetOtherAngelEquipInfo(self.args.id)
            self:Refresh()
        else
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OTHER_ANGE_EQUIP_INFO, { rid = self.args.info.otherRid, itemId = self.args.id })
        end
    end
end

function this:ChangeMid()
    self:ChangeMidOne(self.view.equip_need_level_titlt, self.view.equip_need_level)
    self:ChangeMidOne(self.view.equip_jie_root, self.view.equip_jie)
    self:ChangeMidOne(self.view.att_level_titlt, self.view.att_need_level)
end

function this:ChangeMidOne(control_name, control_value)
    local levelDes = GUI:Text_getString(control_name)
    local level = GUI:Text_getString(control_value)
    GUI:Text_setString(control_name, levelDes .. level)
    GUI:setVisible(control_value, false)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.archenge = {}
    self.base_info = {}
    local itemInfo = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    local name = SL:GetEquipValue(EMetaVarGetKey.EQUIP_NAME, self.args.equip_pos, self.args.cfgId, self.args.id)
    self.type = SL:GetMetaValue(EMetaVarGetKey.ITEMTYPE, self.args.cfgId)
    self.subType = SL:GetMetaValue(EMetaVarGetKey.ITEMSUBTYPE, self.args.cfgId)
    local hideBtn = false
    if not itemInfo then
        hideBtn = true
    end
    
    local twoHanded = SL:GetEquipValue(EMetaVarGetKey.EQUIP_TWO_HANDED, self.args.equip_pos, self.args.cfgId, self.args.id)
    local two_handed = ""
    if self.subType and self.subType <= 3 then
        if twoHanded and twoHanded == 1 then
            two_handed = "双手武器"
        else
            two_handed = "单手武器"
        end
    end
    local topDesc = SL:GetMetaValue(EMetaVarGetKey.ITEM_TOP_DESC,self.args.cfgId)
    local midDesc = SL:GetMetaValue(EMetaVarGetKey.ITEM_MID_DESC,self.args.cfgId)
    local bottomDesc = SL:GetMetaValue(EMetaVarGetKey.ITEM_BOTTOM_DESC,self.args.cfgId)
    GUI:setVisible(self.view.top_text, false)
    --if string.isNullOrEmpty(topDesc) then
    --    GUI:setVisible(self.view.top_text, false)
    --else
    --    GUI:setVisible(self.view.top_text, true)
    --    GUI:Text_setString(self.view.top_text, topDesc)
    --end

    if string.isNullOrEmpty(midDesc) then
        GUI:setVisible(self.view.mid_text, false)
    else
        GUI:Text_setString(self.view.mid_text, midDesc)
        GUI:setVisible(self.view.mid_text, true)
    end

    if string.isNullOrEmpty(bottomDesc) then
        GUI:setVisible(self.view.bottom_text, false)
    else
        GUI:setVisible(self.view.bottom_text, true)
        GUI:Text_setString(self.view.bottom_text, bottomDesc)
    end
    self:ComparsionConfig()
    --模型高度
    local modelHeight = 0
    --底部文字存在的情况下增加的高度
    local bottomDescHeight = 0
    --变身戒指or守护皮肤
    if self.type == 6 and (self.subType == 14 or self.subType == 13) then
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
        modelHeight = 180
    end
    
    if self.type == 2 and self.subType == E_ItemSubType_Equip.PriestHawk then
        if itemInfo and itemInfo.itemExtInfo and itemInfo.itemExtInfo.equipExtInfo then
            ---@type cfg_equip_priest_column
            local tbl = SL:GetConfigMultiKeys("cfg_equip_priest", itemInfo.itemExtInfo.equipExtInfo.level, self.subType, "hawkLv", "type")
            if tbl then
                GUI:Text_setString(self.view.exprience_txt, "经验值:" .. tostring(itemInfo.itemExtInfo.equipExtInfo.currentExperience) .. "/" .. tbl.hawkExp)
                GUI:Text_setString(self.view.level_txt, "等级:" .. itemInfo.itemExtInfo.equipExtInfo.level)
                GUI:setVisible(self.view.exprience_txt, true)
                GUI:setVisible(self.view.level_txt, true)
            end
        end
    else
        GUI:setVisible(self.view.exprience_txt, false)
        GUI:setVisible(self.view.level_txt, false)
    end
    
    local top_num = 0
    local grade = SL:GetEquipValue(EMetaVarGetKey.EQUIP_GRADE, self.args.equip_pos, self.args.cfgId, self.args.id)
    local name_color = EquipFunc.GetTipNameColor(itemInfo,self.args.cfgId)
    local rank = SL:GetEquipValue(EMetaVarGetKey.EQUIP_RANK, self.args.equip_pos, self.args.cfgId, self.args.id)
    local useLevelLimit = SL:GetEquipValue(EMetaVarGetKey.EQUIP_USE_LEVEL_LIMIT, self.args.equip_pos, self.args.cfgId, self.args.id)
    GUI:Text_setTextColor(self.view.equip_name, name_color)
    self:SetLiuGuang(itemInfo)
    local itemCfg = SL:GetConfig("cfg_item", self.args.cfgId)
    local shape = itemCfg.shape[1]
    local rotation = SL:GetConfig("cfg_model_charactor", shape).rotateAxis
    local rotation_str = rotation .. ",50,0"
    
    
    -- 大天使装备的阶数需要特殊处理
    if SL:GetConfig("cfg_item", self.args.cfgId, "id").wearBarID[1] == EEquipWearBarType.Archange then
        if not self.args.id or not InfoManager.archangeEquipInfo:IsHaveArchangeEquip(self.args.id) then
            if self.args.id and self.otherArchange then
                local rankStr = tostring(self.otherArchange.rank) .. "阶"
                GUI:Text_setString(self.view.equip_jie, rankStr)
                GUI:setVisible(self.view.equip_jie_root, true)
                top_num = top_num + 1
            else
                local rankStr = rank .. "阶"
                GUI:Text_setString(self.view.equip_jie, rankStr)
                GUI:setVisible(self.view.equip_jie_root, true)
                top_num = top_num + 1
            end
        else
            local archangeRank = InfoManager.archangeEquipInfo:GetEquipLevelInfo(self.args.id).rank
            local rankStr = tostring(archangeRank) .. "阶"
            GUI:Text_setString(self.view.equip_jie, rankStr)
            GUI:setVisible(self.view.equip_jie_root, true)
            top_num = top_num + 1
        end
    else
        if rank and rank ~= 0 then
            local rankStr = SL:NumberToChinese(rank)
            rankStr = rankStr .. "阶"
            GUI:Text_setString(self.view.equip_jie, rankStr)
            GUI:setVisible(self.view.equip_jie_root, true)
            top_num = top_num + 1
        else
            GUI:setVisible(self.view.equip_jie_root, false)
        end
    end
    
    if not string.isNullOrEmpty(useLevelLimit) then
        self.level_is_can_use = false
        local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        local level_color = "#FF3319"
        local level_str = ""
        local need_level = 0
        if string.contains(useLevelLimit, "#") then
            local levelLimit = SL:Split(useLevelLimit, "#")
            if tonumber(levelLimit[1]) <= level and tonumber(levelLimit[2]) >= level then
                self.level_is_can_use = true
            else
                need_level = tonumber(tonumber(levelLimit[1])) - level
            end
            level_str = levelLimit[1] .. "˜" .. levelLimit[2]
        
        else
            if tonumber(useLevelLimit) <= level then
                self.level_is_can_use = true
            else
                need_level = tonumber(tonumber(useLevelLimit)) - level
            end
            level_str = useLevelLimit
        end
        if self.level_is_can_use then
            level_color = "#FFFFFF"
        end
        
        if level_str ~= "0" then
            GUI:setVisible(self.view.equip_need_level_titlt, true)
            GUI:setVisible(self.view.equip_need_level_titlt_node, true)
            GUI:setVisible(self.view.red_equip_need_level_titlt_node, true)
            GUI:Text_setString(self.view.equip_need_level, level_str)
            GUI:Text_setTextColor(self.view.equip_need_level_titlt, level_color)
            top_num = top_num + 1
        else
            GUI:setVisible(self.view.equip_need_level, false)
            GUI:setVisible(self.view.equip_need_level_titlt, false)
            GUI:setVisible(self.view.equip_need_level_titlt_node, false)
        end
        
        if need_level ~= 0 then
            GUI:setVisible(self.view.red_equip_need_level_titlt, true)
            GUI:setVisible(self.view.red_equip_need_level_titlt_node, true)
            GUI:Text_setTextColor(self.view.red_equip_need_level_titlt, "#FF3319")
            GUI:Text_setString(self.view.red_equip_need_level_titlt, "（还需 " .. tostring(need_level) .. "）")
        else
            GUI:setVisible(self.view.red_equip_need_level_titlt, false)
            GUI:setVisible(self.view.red_equip_need_level_titlt_node, false)
        end
    else
        GUI:setVisible(self.view.red_equip_need_level_titlt_node, false)
        GUI:setVisible(self.view.equip_need_level_titlt_node, false)
    end
    GUI:ForceRebuildLayoutImmediate(self.view.equip_need_level_titlt_node)
    GUI:ForceRebuildLayoutImmediate(self.view.red_equip_need_level_titlt_node)
    local job = SL:GetEquipValue(EMetaVarGetKey.EQUIP_NEED_CAREER, self.args.equip_pos, self.args.cfgId, self.args.id)
    self.need_career = self:GetCareer(job)
    
    local useAttLimit = SL:GetEquipValue(EMetaVarGetKey.EQUIP_WEAR_LIMIT, self.args.equip_pos, self.args.cfgId, self.args.id)
    self.useAttLimit_list = self:GetUseAttLimit(useAttLimit, EquipFunc.GetEquipStrengthLevel(itemInfo))
    
    local useAttLv = SL:GetConfig("cfg_equip_entryLib", self.args.cfgId).useAttLv
    if not useAttLv or useAttLv == 0 then
        GUI:setVisible(self.view.att_level_titlt, false)
    else
        top_num = top_num + 1
        GUI:setVisible(self.view.att_level_titlt, true)
        GUI:setVisible(self.view.att_need_level, true)
        GUI:Text_setString(self.view.att_need_level, tostring(useAttLv))
        local level = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
        if level >= useAttLv then
            GUI:Text_setTextColor(self.view.att_level_titlt, "#FFFFFF")
            GUI:Text_setTextColor(self.view.att_need_level, "#FFFFFF")
        else
            GUI:Text_setTextColor(self.view.att_level_titlt, "#FF3319")
            GUI:Text_setTextColor(self.view.att_need_level, "#FF3319")
        end
    end
    
    ----属性需要排序
    
    local baseAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_BASE_ATTR, self.args.equip_pos, self.args.cfgId, self.args.id)
    local baseAttr_ = baseAttr
    if self.type == 2 and self.subType == E_ItemSubType_Equip.PriestHawk then
        if itemInfo and itemInfo.itemExtInfo and itemInfo.itemExtInfo.equipExtInfo then
            ---@type cfg_equip_priest_column
            local tbl = SL:GetConfigMultiKeys("cfg_equip_priest", itemInfo.itemExtInfo.equipExtInfo.level, self.subType, "hawkLv", "type")
            if tbl then
                baseAttr_ = {}
                for i, v in pairs(baseAttr) do
                    if baseAttr_[v.type] then
                        baseAttr_[v.type].num = baseAttr_[v.type].num + v.num
                    else
                        baseAttr_[v.type] = table.copyFrom({}, v)
                    end
                end
                for i = 1, #tbl.hawkAtt do
                    local att = tbl.hawkAtt[i]
                    if baseAttr_[att[1]] then
                        baseAttr_[att[1]].num = baseAttr_[att[1]].num + att[2]
                    else
                        table.insert(baseAttr_, { type = att[1] or 0, num = att[2] or 0 })
                    end
                end
            end
        end
    end
    
    local strengthen = 0
    local strengthenAttrList = {}
    local naijiuMax = EquipFunc.GetMaxDurability(itemInfo)
    local naijiu = naijiuMax
    local strengthenAttr = {}
    GUI:setVisible(self.view.txt_moveSpeed, false)
    GUI:setVisible(self.view.node_moveSpeed, false)
    if itemInfo then
        strengthen = EquipFunc.GetEquipStrengthLevel(itemInfo)
        if strengthen > 0 then
            strengthenAttr = EquipFunc.GetEquipStrengthAttr(itemInfo)
        end
        local itemT = SL:GetConfig("cfg_item", itemInfo.cfgId)
        local slot = itemT.strPart[1]
        if slot == EEquipSlotType.Boot or slot == EEquipSlotType.Glove then
            local global = SL:GetConfig("cfg_global", slot == EEquipSlotType.Boot and 630001 or 630002)
            local split = string.split(global.value, "#")
            if strengthen >= tonumber(split[3]) then
                GUI:setVisible(self.view.node_moveSpeed, true)
                GUI:setVisible(self.view.txt_moveSpeed, true)
                GUI:Text_setString(self.view.txt_moveSpeed, split[1])
            end
            local strengthenAttr2 = {}
            for kkkk, one_strengthenAttr in pairs(strengthenAttr) do
                if one_strengthenAttr.type ~= 318022 then
                    table.insert(strengthenAttr2,one_strengthenAttr)
                end
            end
            strengthenAttr = strengthenAttr2
        end
        naijiu = EquipFunc.GetDurability(itemInfo)
    end
    GUI:setVisible(self.view.equip_time_node, naijiuMax ~= 0)
    GUI:Text_setString(self.view.equip_time, string.format("耐久度：[%d/%d]", naijiu, naijiuMax))
    
    baseAttr_, strengthenAttr = EquipFunc.MergeBaseAndStrengthenAttrs(baseAttr_, strengthenAttr)
    for _, v in pairs(baseAttr_) do
        local attCfg = SL:GetConfig("cfg_att_info", v.type)
        if attCfg.remarks ~= 1 then
            --去除%后面的小数部分
            local temp = v.num % 100
            if temp ~= 0 then
                v.num = v.num - temp
            end
        end
    end
    baseAttr = self:GetBaseAttr(baseAttr_, "：",true)
    if strengthen and strengthen > 0 then
        name = name .. " +" .. strengthen
        if not (self:IsSuitEquip(self.args.cfgId) or self:IsExcellentEquip(self.args.cfgId)) then
            GUI:Text_setTextColor(self.view.equip_name, strengthen > 6 and "#FFCC19" or "#FFFFFF")
        end
    end

    if itemCfg.subType == E_ItemSubType_Equip.Mount then
        local bindCfgId = SL:GetItemBindCfgId(self.args.cfgId)
        local mount = SL:GetConfigMultiKeys("cfg_mount", bindCfgId, "itemId")
        if mount then
            -- 给坐骑加上移速属性显示
            local sudu = self:GetBaseAttr({ { type = 318022, num = mount.speed }}, "：",true)
            for i, v in pairs(sudu) do
                table.insert(baseAttr, v)
            end
        end
    end
    
    GUI:Text_setString(self.view.equip_name, name)
    --local appendAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_APPEND_ATTR, self.args.equip_pos, self.args.cfgId, self.args.id)
    local appendAttr = {}
    local appendAttrList = {}
    if itemInfo then
        local appLevel = EquipFunc.GetEquipAppendLevel(itemInfo)
        if appLevel > 0 then
            appendAttr = EquipFunc.GetEquipAppendAttrInTips(itemInfo)
        end
    end
    local originMagicAttrs = SL:GetEquipValue(EMetaVarGetKey.EQUIP_MAGIC_ATTR, self.args.equip_pos, self.args.cfgId, self.args.id)
    
    local gemSkills = SL:GetEquipSkills(itemInfo)
    local skillName = EquipFunc.GetEquipSkillShow(itemInfo)
    local luckAttrs = SL:GetEquipValue(EMetaVarGetKey.EQUIP_LUCK_ATTR, self.args.equip_pos, self.args.cfgId, self.args.id)
    self.all_info = {}
    
    self.IsHaveStrengthen = false ---是否有强化属性
    self.all_att_sort_list = {}
    if table.count(baseAttr) > 0 then
        table.insert(self.all_att_sort_list, { attr_type = 1, data = baseAttr })
    end
    if strengthenAttr and table.count(strengthenAttr) > 0 then
        local Attr = self:GetBaseAttr(strengthenAttr, nil, true, false)
        for i, v in ipairs(Attr) do
            v.name = "强化" .. v.name
            self.IsHaveStrengthen = true
        end
        if #Attr > 0 then
            table.insert(self.all_att_sort_list, { attr_type = 2, data = Attr })
        end
    end
    if appendAttr and table.count(appendAttr) > 0 then
        local Attr = self:GetBaseAttr(appendAttr, nil, nil, false,{isOnlyUseName = true})
        table.insert(self.all_att_sort_list, { attr_type = 3, data = Attr })
    end
    if originMagicAttrs and table.count(originMagicAttrs) > 0 then
        local magicAttr = self:GetBaseAttr(originMagicAttrs)
        for i, v in ipairs(magicAttr) do
            table.insert(self.all_info, v)
        end
    end
    if gemSkills and table.count(gemSkills) > 0 then
        local skillData = {}
        for i, v in ipairs(gemSkills) do
            
            local skill_id = v.skillId
            local skill_name = SL:GetConfig("cfg_skill", skill_id).name
            
            ---@type cfg_skill_info_column
            local skill_info_tbl = SL:GetConfig("cfg_skill_info", skill_id, "skillID")
            table.insert(skillData, { name = string.format("%s（MP：%s）", skill_name, skill_info_tbl.costMp), value = "" })
        end
        table.insert(self.all_att_sort_list, { attr_type = 11, data = skillData })
    end
    if skillName then
        local skillData = {}
        table.insert(skillData, { name = skillName, value = "" })
        table.insert(self.all_att_sort_list, { attr_type = 11, data = skillData })
    end
    
    if luckAttrs and table.count(luckAttrs) > 0 then
        table.insert(self.all_info, { title = "tips_attribute12" })
        local Attr = self:GetBaseAttr(luckAttrs)
        for i, v in ipairs(Attr) do
            v.color = "#50C2FD"
            table.insert(self.all_info, v)
        end
    end
    local entryAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_ENTRY_ATTR, self.args.equip_pos, self.args.cfgId, self.args.id)
    if entryAttr and table.count(entryAttr) > 0 then
        local Attr = self:GetBaseAttr(entryAttr)
        table.insert(self.all_att_sort_list, { attr_type = 4, data = Attr })
    else
        --首充装备特殊处理
        if self.args.info and self.args.info.firstCharge and table.contains(self.firstCharge_list, self.args.cfgId) then
            local zhuo_att = SL:GetConfig("cfg_equip_entryLib", self.args.cfgId).att1
            local zhuo_yue_group = zhuo_att[1][1]
            local zhuo_att_list = SL:FindConfigs("cfg_equip_att", "group", zhuo_yue_group)
            local first_entryAttr = {}
            for ii, one_data in ipairs(zhuo_att_list) do
                local att_list = one_data.att[1]
                table.insert(first_entryAttr, { type = att_list[1], num = att_list[2] })
            end
            if first_entryAttr and table.count(first_entryAttr) > 0 then
                table.insert(self.all_info, { title = "tips_attribute3" })
                local Attr = self:GetBaseAttr(first_entryAttr)
                table.insert(self.all_att_sort_list, { attr_type = 4, data = Attr })
            end
        else
            local zhuo_att = SL:GetConfig("cfg_equip_entryLib", self.args.cfgId).att1
            local attCountweight = SL:GetConfig("cfg_equip_entryLib", self.args.cfgId).attCountweight
            if table.count(attCountweight) > 0 then
                local min_num = 0
                local max_num = 0
                for Countweight_i, one_attCountweight in ipairs(attCountweight) do
                    if min_num == 0 then
                        min_num = Countweight_i
                    else
                        if Countweight_i < min_num then
                            min_num = Countweight_i
                        end
                    end
                    if max_num == 0 then
                        max_num = Countweight_i
                    else
                        if Countweight_i > max_num then
                            max_num = Countweight_i
                        end
                    end
                end
                local att_str_info = ""
                if min_num == max_num then
                    att_str_info = "随机获得 " .. min_num .. " 条属性"
                else
                    att_str_info = "随机获得 " .. min_num .. " ˜ " .. max_num .. " 条属性"
                end
                local zhuo_all_Attr = {}
                table.insert(zhuo_all_Attr, { name = att_str_info, value = "", color = "#4cc5fe", color_not_change = true })
                local zhuo_group = {}
                for zhuo_i = 1, table.count(attCountweight) do
                    local one_shuo_list = zhuo_att[zhuo_i]
                    for iii, zhuo_yue_group in ipairs(one_shuo_list) do
                        if not table.contains(zhuo_group, zhuo_yue_group) then
                            table.insert(zhuo_group, zhuo_yue_group)
                        end
                    end
                end
                for iiiii, zhuo_yue_group in ipairs(zhuo_group) do
                    local zhuo_att_list = SL:FindConfigs("cfg_equip_att", "group", zhuo_yue_group)
                    local one_group_Attr = {}
                    for iiiiii, group_one_data in ipairs(zhuo_att_list) do
                        local att_info = group_one_data.name
                        table.insert(zhuo_all_Attr, { name = att_info, vaule = "", color = "#999999", color_not_change = true })
                    end
                end
                
                table.insert(self.all_att_sort_list, { attr_type = 4, data = zhuo_all_Attr })
            end
        end
    end
    
    local regenerateToAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_REGENERATE_ATTR, self.args.equip_pos, self.args.cfgId, self.args.id)
    if regenerateToAttr and table.count(regenerateToAttr) > 0 then
        local Attr = self:GetBaseAttr(regenerateToAttr)
        table.insert(self.all_att_sort_list, { attr_type = 7, data = Attr })
    end
    -- 大天使装备处理
    if SL:GetConfig("cfg_item", self.args.cfgId, "id").wearBarID[1] == EEquipWearBarType.Archange then
        local datianshi_att_list = {}
        table.insert(datianshi_att_list, { name = "攻击野外怪物即可获得经验值", value = "", color = "#e6e600", color_not_change = true })
        local levelInfo
        if self.args.id then
            levelInfo = InfoManager.archangeEquipInfo:GetEquipLevelInfo(self.args.id)
            if not levelInfo then
                levelInfo = self.otherArchange
            end
        end
        if levelInfo then
            -- 有信息的装备
            --local levelInfo = InfoManager.archangeEquipInfo:GetEquipLevelInfo(self.args.id)
            local arcLevel = levelInfo.level
            local exp = levelInfo.exp
            local _, maxLevel = InfoManager.archangeEquipInfo:GetMaxAtt(self.args.cfgId)
            local curRank = levelInfo.rank
            local curMaxLevel = InfoManager.archangeEquipInfo:GetMaxLevel(curRank, self.args.cfgId)
            ---该装备所在的组
            local group = SL:GetConfig("cfg_equip_angelGroup", self.args.cfgId, "id").angelEquipGroup
            ---@type cfg_equip_angelAtt_column
            local attTbl = SL:GetConfigTwoKeys("cfg_equip_angelAtt", group, arcLevel, "ornamentsGroup", "lv")
            local basicAtt = attTbl.basicAtt
            
            local levelinfo = tostring(exp) .. "/" .. tostring(attTbl.lvDeplete)
            
            self.archenge["maxExp"] = attTbl.lvDeplete
            self.archenge["isMaxLv"] = false
            table.insert(datianshi_att_list, { name = "当前阶数等级上限", value = tostring(curMaxLevel), color = "#e6e600", color_not_change = true })
            -- archenge类型仅为大天使装备的特殊处理，若使用进度条，请使用loadingbar类型，如：{loadingbar = { name = "lv." .. tostring(arcLevel), value = (exp / attTbl.lvDeplete) * 100, valueInfo = levelinfo }}
            if arcLevel == maxLevel then
                self.archenge["isMaxLv"] = true
                --该装备是否满级
                table.insert(datianshi_att_list, { name = "装备已成长至满级", value = "", color = "#00ff00", color_not_change = true })
                levelinfo = "已满级"
                table.insert(datianshi_att_list, { archenge = { name = "<color='#00ff00'>Lv." .. tostring(arcLevel) .. "</color>", value = 100, valueInfo = levelinfo, color_not_change = true } })
            else
                table.insert(datianshi_att_list, { archenge = { name = "<color='#00ff00'>Lv." .. tostring(arcLevel) .. "</color>", value = (exp / attTbl.lvDeplete) * 100, valueInfo = levelinfo, color_not_change = true } })
            end
            local maxAtt = nil
            local minAtt = nil
            for i, v in pairs(basicAtt) do
                if v[1] == 200011 then
                    minAtt = v[2]
                elseif v[1] == 200021 then
                    maxAtt = v[2]
                else
                    table.insert(datianshi_att_list, { name = SL:GetConfig("cfg_att_info", v[1], "id").name, value = "+" .. tostring(v[2]), color = "#FFFFFF" })
                end
            end
            if minAtt and maxAtt then
                table.insert(datianshi_att_list, { name = two_handed == 1 and "双手攻击力" or "单手攻击力", value = tostring(minAtt) .. "˜" .. tostring(maxAtt), color = "#FFFFFF" })
            end
            
            if arcLevel ~= maxLevel then
                table.insert(datianshi_att_list, { name = "<size=18>Lv." .. tostring(arcLevel + 1) .. "</size>", value = "<size=18>下一级效果</size>", color = "#ff2323", color_not_change = true })
                --不满级展示下一级
                arcLevel = arcLevel + 1
                ---该装备所在的组
                group = SL:GetConfig("cfg_equip_angelGroup", self.args.cfgId, "id").angelEquipGroup
                basicAtt = SL:GetConfigTwoKeys("cfg_equip_angelAtt", group, arcLevel, "ornamentsGroup", "lv").basicAtt
                maxAtt = nil
                minAtt = nil
                for i, v in pairs(basicAtt) do
                    if v[1] == 200011 then
                        minAtt = v[2]
                    elseif v[1] == 200021 then
                        maxAtt = v[2]
                    else
                        table.insert(datianshi_att_list, { name = SL:GetConfig("cfg_att_info", v[1], "id").name, value = "+" .. tostring(v[2]), color_not_change = true, color = "#999999" })
                    end
                end
                if minAtt and maxAtt then
                    table.insert(datianshi_att_list, { name = two_handed == 1 and "双手攻击力" or "单手攻击力", value = tostring(minAtt) .. "˜" .. tostring(maxAtt), color = "#999999", color_not_change = true })
                end
            end
        else
            -- 无任何信息
            table.insert(datianshi_att_list, { name = "满级属性", value = "", color = "#00ff00", color_not_change = true })
            local attList, _ = InfoManager.archangeEquipInfo:GetMaxAtt(self.args.cfgId)
            local maxAtt = nil
            local minAtt = nil
            for i, v in pairs(attList) do
                if v[1] == 200011 then
                    minAtt = v[2]
                elseif v[1] == 200021 then
                    maxAtt = v[2]
                else
                    table.insert(datianshi_att_list, { name = SL:GetConfig("cfg_att_info", v[1], "id").name, value = " + " .. tostring(v[2]), color = "#FFFFFF" })
                end
            end
            if minAtt and maxAtt then
                table.insert(datianshi_att_list, { name = two_handed == 1 and "双手攻击力" or "单手攻击力", value = tostring(minAtt) .. "˜" .. tostring(maxAtt), color = "#FFFFFF" })
            end
        end
        if table.count(datianshi_att_list) > 0 then
            table.insert(self.all_att_sort_list, { attr_type = 8, data = datianshi_att_list })
        end
    end
    local equipInfoList, suitEffect = SL:GetSuitEquipInfoList(self.args.cfgId)
    local color1 = "#80B2FF"
    local color2 = "#666666"
    if equipInfoList and suitEffect then
        local all_suit = {}
        local suitIdList = SL:GetMetaValue(EMetaVarGetKey.GET_EQUIPSUIT_BY_ID, self.args.cfgId)
        
        local Attr = self:GetAttr(suitEffect)
        for i, v in ipairs(Attr) do
            if v.isActive then
                v.color = color1
                v.color_not_change = true
            else
                v.color = color2
                v.color_not_change = true
            end
            table.insert(all_suit, v)
        end
        table.insert(self.all_att_sort_list, { attr_type = 6, data = all_suit })
    end
    if itemInfo then
        local regenerateLevel = EquipFunc.GetEquipRegenerateLevel(itemInfo)
        if regenerateLevel > 0 then
            local regenerateAttr = EquipFunc.GetEquipRegenerateAttr(itemInfo)
            if regenerateAttr and table.count(regenerateAttr) > 0 then
                local Attr = self:GetBaseAttr(regenerateAttr)
                table.insert(self.all_att_sort_list, { attr_type = 7, data = Attr })
            end
        end
    end
    ---如果是首饰  特殊处理(能升级的首饰
    if SL:HasConfig('cfg_equip_ornamentsMain', self.args.cfgId) then
        local ornament_tbl = SL:GetConfig('cfg_equip_ornamentsMain', self.args.cfgId)
        if ornament_tbl then
            self:SetJewelryTips()
        end
    end
    ---大天使装备镶嵌的圣杯处理
    local archangeGrailInfo = InfoManager.archangeEquipInfo:GetEquipGrail(self.args.id)
    if self.otherArchange then
        archangeGrailInfo = self.otherArchange.grails
    end
    local shengbei = {}
    if self.args.id and not table.isNullOrEmpty(archangeGrailInfo) then
        local archangeGrailInfoSort = {}
        for i, v in pairs(archangeGrailInfo) do
            table.insert(archangeGrailInfoSort, { id = i, info = v })
        end
        table.sort(archangeGrailInfoSort, function(grailA, grailB)
            return grailA.info.grailPosition < grailB.info.grailPosition
        end)
        for i, v in pairs(archangeGrailInfoSort) do
            name = SL:GetConfig("cfg_item", v.info.itemConfigId, "id").name
            local strengthLv = 0
            if self.otherArchange then
                strengthLv = v.info.level
            else
                strengthLv = InfoManager.archangeEquipInfo:GetGrailStrengthLv(tonumber(v.id))
            end
            if strengthLv > 0 then
                name = name .. "  +" .. tostring(strengthLv)
            end
            local color = E_ArchangelGrailQualityColor[SL:GetConfig("cfg_equip_angelGrail", v.info.itemConfigId, "id").grailQuality]
            table.insert(shengbei, { itemInfo = { itemId = v.info.itemConfigId, name = name, color = color } })
        end
    end
    if #shengbei > 0 then
        table.insert(self.all_att_sort_list, { attr_type = 9, data = shengbei })
    end
    self:GetGemAtt()
    if self.all_gem_att and #self.all_gem_att > 0 then
        local gem_att = self:GetBaseAttr(self.all_gem_att)
        table.insert(self.all_att_sort_list, { attr_type = 5, data = gem_att })
    end
    ----注意-----新加属性放到这里，然后在下面排序----------------------cfg_equip_tips----------------------------------
    self:SetLuckyAtt()
    self:SetTaoZhuangEWaiAtt()
    
    ----拿到所有属性后进行排序
    table.sort(self.all_att_sort_list, function(a, b)
        local cfg_a = SL:GetConfig("cfg_equip_tips", a.attr_type)
        local cfg_b = SL:GetConfig("cfg_equip_tips", b.attr_type)
        
        local groupSort_a = cfg_a.attGroupSort or 0
        local groupSort_b = cfg_b.attGroupSort or 0
        
        if groupSort_a == groupSort_b then
            --如果attGroupSort相同，则按sort排序
            local sort_a = cfg_a.sort or 0
            local sort_b = cfg_b.sort or 0
            return sort_a < sort_b
        else
            --先按attGroupSort排序
            return groupSort_a < groupSort_b
        end
    end)
    
    
    
    ----排序后添加标题和设置颜色
    -- 先按attGroupSort分组
    local grouped_data = {}
    for i, one_data in ipairs(self.all_att_sort_list) do
        if table.count(one_data.data) > 0 then
            local one_tab = SL:GetConfig("cfg_equip_tips", one_data.attr_type)
            if one_tab.show and one_tab.show == 1 then
                local group_sort = one_tab.attGroupSort or 0
                if not grouped_data[group_sort] then
                    grouped_data[group_sort] = {}
                end
                table.insert(grouped_data[group_sort], one_data)
            end
        end
    end
    
    -- 按attGroupSort顺序处理数据
    local group_sorts = {}
    for group_sort, _ in pairs(grouped_data) do
        table.insert(group_sorts, group_sort)
    end
    table.sort(group_sorts)
    
    for _, group_sort in ipairs(group_sorts) do
        if group_sort ~= -1 then
            -- 添加标题
            table.insert(self.all_info, { name = "", value = "" })
        end
        if group_sort == 11 then
            table.sort(grouped_data[group_sort][1].data, function(a, b)
                return tonumber(a.index) < tonumber(b.index)
            end)
        end
        
        for _, one_data in ipairs(grouped_data[group_sort]) do
            local one_tab = SL:GetConfig("cfg_equip_tips", one_data.attr_type)
            if one_tab then
                local bg_str
                if not string.isNullOrEmpty(one_tab.bg) then
                    bg_str = one_tab.bg
                end
                local text_color = tostring(one_tab.textColor)
                if not string.isNullOrEmpty(one_tab.text) then
                    table.insert(self.all_info, { is_title = true, name = one_tab.text, value = "", color = text_color, bg = bg_str })
                end
                
                for j, v in ipairs(one_data.data) do
                    --设置属性颜色
                    if not v.color_not_change then
                        v.color = tostring(one_tab.attColor)
                        if one_tab.attNameColor and not string.isNullOrEmpty(v.name) then
                            local color_1 = SL:GetConfig("cfg_color", one_tab.attNameColor).color
                            v.name = "<color=" .. color_1 .. ">" .. v.name .. "</color>"
                        end
                    end
                    
                    v.bg = one_tab.attBg
                    if one_tab.id == 1 then
                        table.insert(self.base_info, v)
                    else
                        table.insert(self.all_info, v)
                    end
                end
            else
                SL:LogError("cfg_equip_tips 未配置id为" .. one_data.attr_type .. "的数据")
            end
        end
        -- if group_sort ~= 1 then
        --     -- 添加标题
        --     table.insert(self.all_info, { name = "", value = "" })
        -- end
    end
    local is_xilian = EquipFunc.IsXiLian(itemInfo)
    if is_xilian then
        if table.count(self.base_info) > 0 then
            local all_xi = {}
            local all_gongji_id = {"201011","201021","202011","202021","203021","203011","205021","205011"}
            if is_xilian["201011"] and is_xilian["201021"] then
                local _num2 = is_xilian["201011"].current-is_xilian["201011"].source
                local _num1 = is_xilian["201021"].current-is_xilian["201021"].source
                local _str = "洗练属性：攻击力"
                if _num1 >= 0 then
                    _str = _str .. "+" .._num1.."~".._num2
                else
                    _str = _str .. _num1.."~".. math.abs(_num2)
                end
                local one_t = {}
                one_t.type = 201011
                one_t.bg = self.base_info[1].bg
                one_t.color = "4001"
                one_t.value = _str
                table.insert(self.base_info, one_t)
            end
            if is_xilian["202011"] and is_xilian["202021"] then
                local _num2 = is_xilian["202011"].current-is_xilian["202011"].source
                local _num1 = is_xilian["202021"].current-is_xilian["202021"].source
                local _str = "洗练属性：魔法攻击力"
                if _num1 >= 0 then
                    _str = _str .. "+" .._num1.."~".._num2
                else
                    _str = _str .. _num1.."~".. math.abs(_num2)
                end
                local one_t = {}
                one_t.type = 201011
                one_t.bg = self.base_info[1].bg
                one_t.color = "4001"
                one_t.value = _str
                table.insert(self.base_info, one_t)
            end
            if is_xilian["203021"] and is_xilian["203011"] then
                local _num2 = is_xilian["203021"].current-is_xilian["203021"].source
                local _num1 = is_xilian["203011"].current-is_xilian["203011"].source
                local _str = "洗练属性：天鹰攻击力"
                if _num1 >= 0 then
                    _str = _str .. "+" .._num1.."~".._num2
                else
                    _str = _str .. _num1.."~".. math.abs(_num2)
                end
                local one_t = {}
                one_t.type = 201011
                one_t.bg = self.base_info[1].bg
                one_t.color = "4001"
                one_t.value = _str
                table.insert(self.base_info, one_t)
            end
            if is_xilian["205021"] and is_xilian["205011"] then
                local _num2 = is_xilian["205021"].current-is_xilian["205021"].source
                local _num1 = is_xilian["205011"].current-is_xilian["205011"].source
                local _str = "洗练属性：诅咒攻击力"
                if _num1 >= 0 then
                    _str = _str .. "+" .._num1.."~".._num2
                else
                    _str = _str .. _num1.."~".. math.abs(_num2)
                end
                local one_t = {}
                one_t.type = 201011
                one_t.bg = self.base_info[1].bg
                one_t.color = "4001"
                one_t.value = _str
                table.insert(self.base_info, one_t)
            end
            for kkk, vvv in pairs(is_xilian) do
                if not table.contains(all_gongji_id,kkk) then
                    local _att_id = tonumber(kkk)
                    local name = SL:GetConfig("cfg_att_info", _att_id).name
                    local _info = tostring(vvv.source)
                    local _num = vvv.current-vvv.source
                    if _num >= 0 then
                        _info ="+" .. self:GetAttrValue(_att_id,_num)
                    else
                        _info = self:GetAttrValue(_att_id,_num)
                    end
                    local _str = "洗练属性：" .. name.._info
                    local one_t = {}
                    one_t.type = _att_id
                    one_t.bg = self.base_info[1].bg
                    one_t.color = "4001"
                    one_t.value = _str
                    table.insert(self.base_info, one_t)
                end
            end
        end
    end

    local is_zaisheng = EquipFunc.IsZaiSheng(itemInfo)
    if is_zaisheng then
        for kkk, vvv in pairs(is_zaisheng.attr) do
            local _att_id = tonumber(kkk)
            local name = SL:GetConfig("cfg_att_info", _att_id).name
            local _num = self:GetAttrValue(_att_id,vvv)
            local _str = "再生属性：" .. name .."+" .. _num
            local one_t = {}
            one_t.type = _att_id
            one_t.bg = self.base_info[1].bg
            one_t.color = "4001"
            one_t.value = _str
            table.insert(self.base_info, one_t)
        end
    end

    local bottomDesc = SL:GetMetaValue(EMetaVarGetKey.ITEM_BOTTOM_DESC, self.args.cfgId)
    if not string.isNullOrEmpty(bottomDesc) and modelHeight == 0 then
        table.insert(self.all_info, { name = "", value = "" })
        GUI:Text_setString(self.view.tem_info, bottomDesc)
        local x_1, y_1 = GUI:getSizeDelta(self.view.tem_info)
        table.insert(self.all_info, { info = bottomDesc, value = "", height = y_1 })
    end
    local tab_item = SL:GetConfig("cfg_item", self.args.cfgId, "id")
    local recoveryGroup = tab_item.recoveryGroup
    
    if self.type == 2 and self.subType == E_ItemSubType_Equip.PriestHawk then
        table.insert(self.all_info, { name = "可召唤宠物一天鹰", value = "", color = "#FFFFFF" })
    end
    
    top_num = top_num + #self.need_career + #self.useAttLimit_list
    if top_num < 4 then
        top_num = 4
    end
    local top_add = (top_num - 4) * 23
    --local middle_height = #self.all_info * 25
    local middle_height = 0
    for i, v in ipairs(self.all_info) do
        if v.is_title then
            middle_height = middle_height + 31
        elseif v.height then
            middle_height = middle_height + v.height
        else
            middle_height = middle_height + 22
        end
    end
    if middle_height < 100 then
        middle_height = 100
    end
    if middle_height > 205 then
        middle_height = 205
    end
    local all_add_height = top_add + middle_height
    local max_h = 355
    if all_add_height > max_h then
        middle_height = middle_height - (all_add_height - max_h)
    end
    local change_y = (max_h - middle_height) / 2
    change_y = Mathf.Floor(change_y)
    local top_y = 227 - change_y + top_add + (modelHeight / 2)
    local bottom_y = change_y - 275 - (modelHeight / 2)
    local bg_height = middle_height + 295 + top_add + modelHeight
    local bg_y = Mathf.Floor(top_add / 2)
    --GUI:setContentSize(self.view.info_view, 360, middle_height)
    --GUI:setPositionY(self.view.equippaneltop_bottom, bottom_y)
    if table.isNullOrEmpty(self.all_info) or #self.all_info == 1 then
        bg_height = bg_height - 100
    end
    
    --GUI:setPositionY(self.view.panel_bg, bg_y)
    if modelHeight > 0 then
        --有模型的情况下调整一下属性栏位置
        -- local info_view_Y = GUI:getPositionY(self.view.info_view)
        -- GUI:setPositionY(self.view.info_view, info_view_Y + (modelHeight / 2))
    end
    
    --模型初始位置
    GUI:setPositionY(self.view.model1, -190)
    --守护处理
    if self.type == E_ItemType.Equip and self.subType == E_ItemSubType_Equip.ShouHu then
        
        GUI:setVisible(self.view.guardHp, false)
        GUI:setVisible(self.view.duanzaobtn, false)
    else
        GUI:setVisible(self.view.duanzaobtn, true)
        GUI:setVisible(self.view.guardHp, false)
    end
    if self.args.info and self.args.info.hideBtn then
        GUI:setVisible(self.view.bag_root, false)
        GUI:setVisible(self.view.equip_root, false)
    elseif self.args.equip_pos == "bag" or GUI:GetUI("dev/outui/Equip/Panel/KLEquipOverlay/KLEquipOverlayPanel") then
        GUI:setVisible(self.view.bag_root, true)
        GUI:setVisible(self.view.equip_root, false)
        GUI:setPositionX(self.view.root, 142)
        self:bagBtnUpdate()
    elseif self.args.equip_pos == "depots" then
        GUI:setVisible(self.view.bag_root, true)
        GUI:setVisible(self.view.equip_root, false)
        self:depotsBtnUpdate()
    elseif self.args.equip_pos == "equip" then
        GUI:setVisible(self.view.equip_root, true)
        GUI:setVisible(self.view.bag_root, false)
        local wearBarId = SL:GetEquipValue(EMetaVarGetKey.EQUIP_WEAR_BAR_ID, nil, self.args.cfgId)
        if wearBarId[1] and wearBarId[1] > 2 then
            GUI:setVisible(self.view.duanzaobtn, false)
        elseif self.subType == 14 then
            GUI:setVisible(self.view.duanzaobtn, false)
        else
            GUI:setVisible(self.view.duanzaobtn, true)
        end
        
        if self.subType == 10 or self.subType == 11 or self.subType == 12 then
            GUI:setVisible(self.view.tuoxiabtn, false)
            GUI:setVisible(self.view.shengjibtn, true)
        else
            GUI:setVisible(self.view.tuoxiabtn, true)
            GUI:setVisible(self.view.shengjibtn, false)
        end
        
        if SL:GetConfig("cfg_item", self.args.cfgId, "id").wearBarID[1] == EEquipWearBarType.Archange then
            GUI:setVisible(self.view.breakbtn, true)
        else
            GUI:setVisible(self.view.breakbtn, false)
        end
        local count = 0
        local activeTemp = nil
        for i, v in pairs(self.btnTempList) do
            if GUI:getVisible(v) then
                count = count + 1
                activeTemp = v
            end
            GUI:Image_loadTexture(v, "btn_tipsd", "Atlas/FG_Common.spriteatlas")
        end
        if count == 1 then
            ---设置成 长tips
            GUI:Image_loadTexture(activeTemp, "btn_tips", "Atlas/FG_Common.spriteatlas")
            GUI:SetImageNativeSize(activeTemp)
        end
    elseif self.args.equip_pos == "synthesis" or self.args.equip_pos == "looptask" then
        GUI:setVisible(self.view.right_btn, true)
        GUI:setVisible(self.view.left_btn, false)
        GUI:setVisible(self.view.equip_root, false)
        
        GUI:Button_setTitleText(self.view.right_btn, "拿出")
    else
        GUI:setVisible(self.view.equip_root, false)
        GUI:setVisible(self.view.bag_root, false)
        --没有下方二个按钮的模型位置（equip_pos不是bag）
        GUI:setPositionY(self.view.model1, -220)
    end
    -- SL:LogError("self.args.equip_pos", self.args.equip_pos)
    GUI:DataListUpdateData(self.view.equipzhiyeNeedData, true)
    GUI:DataListUpdateData(self.view.equipNeedData, true)
    GUI:DataListUpdateData(self.view.all_info_data, true)
    GUI:DataListUpdateData(self.view.base_info_data, true)
    
    --时间展示
    --if tab_item.timeStr and not string.isNullOrEmpty(tab_item.timeStr) then
    --    GUI:setVisible(self.view.timeShow_text,true)
    --    GUI:Text_setString(self.view.timeShow_text,tab_item.timeStr)
    --else
    --    GUI:setVisible(self.view.timeShow_text,false)
    --end
    
    -----物品来源
    self.origin_info = {}
    if itemInfo then
        local originData = EquipFunc.GetEquipOrigin(itemInfo)
        if originData then
            if originData.fromType == 1 then
                self.origin_info = {
                    { name = "", isTitle = false },
                    { name = "[物品来源]", isTitle = true },
                    { name = "来源：", isTitle = false, dec = originData.fromText },
                    { name = "地图：", isTitle = false, dec = originData.mapName },
                    { name = "", isTitle = false, dec = originData.owner },
                    { name = "时间：", isTitle = false, dec = originData.crateTime },
                }
            else
                self.origin_info = {
                    { name = "", isTitle = false },
                    { name = "[物品来源]", isTitle = true },
                    { name = "来源：", isTitle = false, dec = originData.fromText },
                    { name = "时间：", isTitle = false, dec = originData.crateTime },
                }
            end
        end
    end
    GUI:DataListUpdateData(self.view.origin_info_data, true)
    
    --if self.args.equip_pos ~= "equip" and not (self.args.info and self.args.info.hideComparsion) then
    --    local Comparsion_data = SL:GetCompareEquip(self.args.cfgId)
    --    if Comparsion_data and Comparsion_data.cfgId and Comparsion_data.id then
    --        --SL:OpenEquipTipsComparsion(Comparsion_data.cfgId, Comparsion_data.id)
    --        GUI:UIPanel_Open("dev/ui/Tips/Panel/KLUIEquipTipsComparsion/KLUIEquipTipsComparsionPanel", nil, nil, { equip_pos = "equip", cfgId = Comparsion_data.cfgId, id = Comparsion_data.id, last_height = bg_height,info ={hideBtn=true}  })
    --    end
    --end
    
    EquipFunc.tipsHeight = bg_height
    
    local bg_str = ""
    local item_bg_str = ""
    local bg_effect_id = 0
    local item_effect_id = 0
    if tab_item.itemTips and tab_item.itemTips ~= 0 then
        local style_tab = SL:GetConfig("cfg_tips_style", tab_item.itemTips)
        if not string.isNullOrEmpty(style_tab.background) then
            bg_str = style_tab.background
        end
        if not string.isNullOrEmpty(style_tab.itemBg) then
            item_bg_str = style_tab.itemBg
        end
        bg_effect_id = style_tab.borderEffect
        item_effect_id = style_tab.itemBorderEffect
    end
    
    if bg_effect_id and bg_effect_id ~= 0 then
        local effect_tbl = SL:GetConfig("cfg_model_effect", bg_effect_id)
        local m_y = 370 / 218 * bg_height
        m_y = math.floor(m_y)
        local mscale = "330," .. m_y .. ",1"
    else
    end
    
    if not self:IsSuitEquip(self.args.cfgId) then
        GUI:setVisible(self.view.equip_name_bg, false)
    else
        GUI:setVisible(self.view.equip_name_bg, true)
        GUI:ForceRebuildLayoutImmediate(self.view.equip_name)
    end
    self:ChangeMid()
    GUI:setVisible(self.view.equip_type, false)
    GUI:setVisible(self.view.equip_jie_root, false)
    GUI:setVisible(self.view.equip_type_titlt, false)
    
    GUI:setVisible(self.view.att_level_titlt, false)
    GUI:setVisible(self.view.equip_name, true)
    GUI:ForceRebuildLayoutImmediate(self.view.need_layout)
    GUI:ForceRebuildLayoutImmediate(self.view.all_list_layout)
    GUI:ForceRebuildLayoutImmediate(self.view.origin_list_layout)
    GUI:ForceRebuildLayoutImmediate(self.view.career_layout)
    GUI:ForceRebuildLayoutImmediate(self.view.base_list_layout)
    GUI:ForceRebuildLayoutImmediate(self.view.view_info)

    if GUI:GetHeight(self.view.need_layout) == 0 then
        GUI:setVisible(self.view.need_layout,false)
    end

    if GUI:GetHeight(self.view.career_layout) == 0 then
        GUI:setVisible(self.view.node_career_bottom,false)
    end

    if not GUI:getVisible(self.view.timeShow_text_node) then
        GUI:setVisible(self.view.node_career_top_1,true)
    else
        GUI:setVisible(self.view.node_career_top_1,false)
    end
    

    if GUI:getVisible(self.view.top_text) or GUI:getVisible(self.view.mid_text) or GUI:getVisible(self.view.bottom_text) then
        GUI:setVisible(self.view.view_info, true)
    else
        GUI:setVisible(self.view.view_info, false)
    end

    if self.args.info and self.args.info.title then
        GUI:setVisible(self.view.title_bg, true)
        GUI:Text_setText(self.view.text_title, self.args.info.title)
    end
    
    self:SetLimiteTime()

    GUI:ForceRebuildLayoutImmediate(self.view.jichu_layout)
    local hight = GUI:GetHeight(self.view.jichu_layout)
    if hideBtn or (self.args.info and self.args.info.hideBtn) then
        GUI:setContentSize(self.view.panel_bg, ETipsParameter.TipsWidth, hight +  ETipsParameter.EquipTipsHightNotBtnOffset)
    else
        GUI:setContentSize(self.view.panel_bg, ETipsParameter.TipsWidth, hight + ETipsParameter.EquipTipsHightOffset)
    end
    self:SetTipPosition()
end

---@param id number cfg_equip_tips的id
function this:AddTipsData(id,data)
    if id and data then
        self.tipsData[id] = data
    end
end

function this:SetLimiteTime()
    ---@type cfg_item_column
    local cfg = SL:GetConfig("cfg_item", self.args.cfgId, "id")
    GUI:setVisible(self.view.timeShow_text_node,false)
    local itemInfo = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    local endTime  = EquipFunc.GetEquipEndTime(itemInfo)
    if endTime ~= 0 then
        GUI:setVisible(self.view.timeShow_text_node,true)
        local time = endTime - Time.GetServerTime() // 1000
        if time > 0 then
            self.limiteTimer =  SL:Schedule(self.limiteTimer,0,1,-1,function()
                time = endTime- Time.GetServerTime() // 1000
                if time > 0 then
                    GUI:setVisible(self.view.timeShow_text_node,true)
                    time = SL:FormatTimeDHMNoShowDay(time)
                    GUI:Text_setTextColor(self.view.timeShow_text, "#FF1AFF")
                    GUI:Text_setText(self.view.timeShow_text,time)
                else
                    GUI:Text_setTextColor(self.view.timeShow_text, "#FF2424")
                    GUI:Text_setText(self.view.timeShow_text,"[已过期]")
                    --GUI:setVisible(self.view.timeShow_text_node,false)
                    self:CloseTimer()
                end
            end)
        else
            GUI:Text_setTextColor(self.view.timeShow_text, "#FF2424")
            GUI:Text_setText(self.view.timeShow_text,"[已过期]")
            --GUI:setVisible(self.view.timeShow_text_node,false)
        end
    else
        if cfg.useParam3 ~= 0 then
            GUI:setVisible(self.view.timeShow_text_node, true)
            GUI:Text_setText(self.view.timeShow_text, SL:FormatTimeDHMNoShowDay(cfg.useParam3))
        else
            GUI:setVisible(self.view.timeShow_text_node, false)
        end
    end
end

function this:CloseTimer()
    if self.limiteTimer then
        SL:UnSchedule(self.limiteTimer)
        self.limiteTimer = nil
    end
end

function this:SetTipPosition()
    self.isFixation = true
    if EquipFunc.SetTipsPos(self) then
        return
    end
    
    
    self.isFixation = false
    if self.args.equip_pos ~= "equip" and not (self.args.info and self.args.info.hideComparsion) then
        local Comparsion_data = SL:GetCompareEquip(self.args.cfgId)
        if Comparsion_data and Comparsion_data.cfgId and Comparsion_data.id then
            local clickControl = self.clickControl or (self.args.info and self.args.info.clickControl) or InfoManager.mainUIInfo.clickControl
            self.clickControl = clickControl
            if not clickControl then
                return
            end
            -- 获取屏幕宽度
            local screenWidth = SL:GetMetaValue(EMetaVarGetKey.SCREEN_WIDTH)
            
            local tipsWidth = GUI:GetWidth(self.view.panel_bg)
            local tipsHeight = GUI:GetHeight(self.view.panel_bg)
            -- 计算理想位置（右侧显示）
            local x,y = GUI:GetWorldPosition(clickControl)
            local scrPoint_ = SL:ConvertWorldPos2Screen(x, y)
            -- 如果左侧，则在左侧显示
            if scrPoint_.x <= screenWidth / 2 then
                GUI:setPositionX(self.view.root,  -tipsWidth / 2)
                self.isLeft = true
            else
                -- 否则在右侧显示
                GUI:setPositionX(self.view.root, tipsWidth / 2)
                self.isLeft = false
            end
        end
    end

end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.background_close, self, self.CloseEquipTips)
    GUI:AddOnClickEvent(self.view.left_btn, self, self.BtnLeftOnClick)
    GUI:AddOnClickEvent(self.view.right_btn, self, self.BtnRightOnClick)
    GUI:AddOnClickEvent(self.view.tuoxiabtn, self, self.TakeOffEquip)
    GUI:AddOnClickEvent(self.view.shengjibtn, self, self.ShengJi)
    GUI:AddOnClickEvent(self.view.duanzaobtn, self, self.ForgeOnClick)
    GUI:AddOnClickEvent(self.view.breakbtn, self, self.BreakOnClick)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ANGEL_EQUIPMENT_ATTR_INFO, self.RES_ANGEL_EQUIPMENT_ATTR_INFO, self) -- 大天使装备需要等一个回调
    SL:RegisterLUAEvent(LUA_EVENT_REFRESH_GEM_SLATE_INFO, self.LUA_EVENT_REFRESH_GEM_SLATE_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_OTHER_ANGE_EQUIP_INFO, self.RES_OTHER_ANGE_EQUIP_INFO, self) -- 其它角色大天使装备信息
    SL:RegisterLUAEvent(LUA_EVENT_PLAYER_EQUIP_CHANGE, self.EquipChange, self)
end
---@param data table {MakeIndex = 唯一ID, Where = 装备位置, opera = 操作类型 ( 0:初始化 1:增加 2:删除 3:改变), ItemData = 装备数据, WearBar = 穿戴栏id}
function this:EquipChange(_, data)
    if not table.isNullOrEmpty(data) then
        self.equips = SL:GetWearBarsData(data.wearBar)
        local pos = data.Where
        if pos == EEquipSlotType.Guard and data.opera == 2 then
            local endTime = data.ItemData.endTime
            if endTime ~= 0 then
                local time = endTime - Time.GetServerTime() // 1000
                if time <= 0 then
                    ---守护过期清除外观
                    self.CloseEquipTips()
                end
            end
        end
    end
end

function this:CloseEquipTips()
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTipsComparsion/KLUIEquipTipsComparsionPanel")
    local itemGetPathPanel = GUI:GetUI("dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel")
    if itemGetPathPanel then
        GUI:UIPanel_Close("dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel")
    end
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLSalesTips/KLSalesTipsPanel")
end

function this:Close()
    if self.Schedule1 then
        SL:UnSchedule(self.Schedule1)
    end
    self:CloseTimer()
end

function this:SetLiuGuang(equipInfo)

end

function this:GetCareer(job)
    local all_career = {}
    if job and table.count(job) > 0 then
        local i = 1
        
        while i <= table.count(job) do
            local isMeet = true
            local str = ""
            local t_str = ""
            local baseCareer = job[i][1]
            local careerLevel = job[i][2]
            local tbl = SL:GetConfigMultiKeys('cfg_career',
                    baseCareer,
                    careerLevel,
                    'baseCareer',
                    'careerRank'
            )
            
            str = tbl.name .. " 可以使用"
            if baseCareer == SL:MeData_GetCareer().baseCareer and SL:MeData_GetCareer().careerRank >= careerLevel then
            
            else
                isMeet = false
            end
            table.insert(all_career, { title = t_str, name = str, isMeet = isMeet })
            i = i + 1
        
        end
    end
    return all_career
end

function this:NeedCareerDataListItemCountFunc()
    return #self.need_career
end

function this:NeedCareerDataListItemGetFunc(realIndex)

end

function this:NeedCareerDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:NeedCareerDataListItemUpdateFunc(realIndex, kmlcontrol)
    local career = self.need_career[realIndex + 1]
    local title = GUI:GetChildControl(self.view.equipzhiyeNeedData, realIndex, "title")
    GUI:Text_setString(title, career.title)
    local name = GUI:GetChildControl(self.view.equipzhiyeNeedData, realIndex, "name")
    local jobBg = GUI:GetChildControl(self.view.equipzhiyeNeedData, realIndex, "jobBg")
    GUI:Text_setString(name, career.name)
    if career.isMeet then
        GUI:setVisible(jobBg, false)
    else
        GUI:setVisible(jobBg, true)
        GUI:ForceRebuildLayoutImmediate(name)
        local w = GUI:GetWidth(name)
        GUI:setContentSize(jobBg, ETipsParameter.TipsWidth, ETipsParameter.TipsJobBgHight)
    end
    
    self:ChangeMidOne(title, name)
end

function this:GetUseAttLimit(useAttLimit, strengthLevel)
    local useAttLimit_list = {}
    self.useAttLimit = {}
    local entryAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_ENTRY_ATTR, self.args.equip_pos, self.args.cfgId, self.args.id)
    local limitAttInfo = EquipFunc.GetEquipUseAttLimit(nil, self.args.cfgId, strengthLevel)
    for i, v in pairs(limitAttInfo) do
        self:OperUseAttLimit(useAttLimit_list, i, v, entryAttr)
    end
    
    return useAttLimit_list
end

---获取使用限制属性值
---@param attValue number 属性值
---@param itemCfg cfg_item_column 物品配置
---@param strengthLevel number 强化等级
function this.GetUseAttLimitValue(attValue, itemLevel, strengthLevel, addUseAttrLimit)
    return math.floor(3 * (3 * strengthLevel + itemLevel + addUseAttrLimit) * (attValue / 100) + 20)
end

function this:OperUseAttLimit(useAttLimit_list, attId, attValue, entryAttr)
    local my_attValue = SL:MeData_GetSpecialAttrValue(attId)
    local name = SL:GetConfig("cfg_att_info", attId).name
    
    local name_str = "所需" .. name .. "："
    local value_str = ""
    local offsetValue = EquipFunc.GetAttrValueOffset(attId, attValue, entryAttr)
    self.useAttLimit[attId] = -offsetValue
    attValue = attValue - offsetValue
    if my_attValue >= attValue then
        value_str = tostring(attValue)
        name_str = name_str .. attValue
    else
        local add_value = attValue - my_attValue
        name_str = "<color=#FF3319>" .. name_str .. attValue .. "</color>"
        value_str = "<color=#FF3319>" .. "（还需  " .. add_value .. "）" .. "</color>"
    end
    if attValue ~= 0 then
        table.insert(useAttLimit_list, { name = name_str })
        
        if my_attValue < attValue then
            table.insert(useAttLimit_list, { name = value_str })
        end
    end
end

function this:NeedDataListItemCountFunc()
    return #self.useAttLimit_list
end

function this:NeedDataListItemGetFunc(realIndex)

end

function this:NeedDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:NeedDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.useAttLimit_list[realIndex + 1]
    local name = GUI:GetChildControl(self.view.equipNeedData, realIndex, "name")
    GUI:Text_setString(name, data.name)
    local value = GUI:GetChildControl(self.view.equipNeedData, realIndex, "value")
    GUI:Text_setString(value, data.value)
    if data.name and data.value then
        self:ChangeMidOne(name, value)
    end
end

function this:GetBaseAttr(baseAttr, connectSign,isShowHead, showMinMaxAtt,params)
    if params == nil then
        params = {}
    end
    params.round = true
    local baseAttrList = EquipFunc.GetBaseAttr(baseAttr, self.args.equip_pos, self.args.cfgId, self.args.id, connectSign,isShowHead, showMinMaxAtt,params)
    return baseAttrList
end

function this:GetAttr(baseAttr)
    local baseAttrList = {}
    if not baseAttr then
        return baseAttrList
    end
    for i, one in pairs(baseAttr) do
        for j, v in ipairs(one) do
            local nameAttr = SL:GetConfig("cfg_att_info", v.attId).name
            
            local _value
            if self:chenckAttrShow(v.attId) then
                _value = EquipFunc.GetAttText(v.attId, v.attNum)
                if not self:chenckAttrValue(v.attId) then
                    _value = nameAttr
                end
                table.insert(baseAttrList, { name = "", value = _value, isActive = v.isActive })
            end
        end
    end
    return baseAttrList
end

function this:chenckAttrShow(attId)
    return true
end

function this:chenckAttrValue(attId)
    local attShow = SL:GetConfig("cfg_att_info", attId).attShow
    
    if attShow == 1 then
        return true
    end
    return false
end

function this:GetAttrValue(attId, attValue)
    local remarks = SL:GetConfig("cfg_att_info", attId).remarks
    
    if remarks == 1 then
        return tostring(attValue)
    else
        local value = attValue / 100
        local value_str = value .. "%"
        return value_str
    end
end

function this:EquipAttrDataListItemCountFunc()
    return #self.all_info
end

function this:EquipAttrDataListItemGetFunc(realIndex)

end

function this:EquipAttrDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:EquipAttrDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.all_info[realIndex + 1]
    local root = GUI:GetChildControl(self.view.all_info_data, realIndex, "root")
    local title = GUI:GetChildControl(self.view.all_info_data, realIndex, "title")
    local value = GUI:GetChildControl(self.view.all_info_data, realIndex, "value")
    local desc = GUI:GetChildControl(self.view.all_info_data, realIndex, "desc")
    local more_info = GUI:GetChildControl(self.view.all_info_data, realIndex, "more_info")
    local loading_name = GUI:GetChildControl(self.view.all_info_data, realIndex, "loading_name")
    local info_loadingbar = GUI:GetChildControl(self.view.all_info_data, realIndex, "info_loadingbar")
    local loadingbar_text = GUI:GetChildControl(self.view.all_info_data, realIndex, "loadingbar_text")
    local item = GUI:GetChildControl(self.view.all_info_data, realIndex, "item")
    local itemname = GUI:GetChildControl(self.view.all_info_data, realIndex, "itemname")
    
    if data.is_title then
        GUI:setContentSize(root, 350, 16)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        
        GUI:setVisible(desc, false)
        GUI:setVisible(more_info, false)
        GUI:setVisible(info_loadingbar, false)
        GUI:setVisible(loading_name, false)
        if not string.isNullOrEmpty(data.title) then
            GUI:setVisible(title, true)
            GUI:Image_loadTexture(title, data.title, "Atlas/TipsAttTitle.spriteatlas")
            GUI:setVisible(value, false)
        else
            GUI:setVisible(title, false)
            GUI:setVisible(value, true)
            local _name = nil
            if not string.isNullOrEmpty(data.name) then
                _name = data.name
            else
                _name = ""
            end
            local _value = nil
            if not string.isNullOrEmpty(data.value) then
                _value = data.value
            else
                _value = ""
            end
            local value_str = _name .. "  " .. _value
            
            if not string.isNullOrEmpty(_value) and not string.isNullOrEmpty(_name) then
                value_str = _name .. "  " .. _value
            else
                value_str = _name .. _value
            end
            
            GUI:Text_setString(value, value_str)
            if data.color then
                GUI:Text_setTextColor(value, data.color)
            end
        end
    elseif data.info then
        GUI:setContentSize(root, 350, data.height)
        GUI:setVisible(title, false)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(value, false)
        GUI:setVisible(more_info, true)
        GUI:setVisible(info_loadingbar, false)
        GUI:setVisible(loading_name, false)
        GUI:Text_setString(more_info, data.info)
    elseif data.loadingbar then
        GUI:setContentSize(root, 350, 25)
        GUI:setVisible(title, false)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(value, false)
        GUI:setVisible(more_info, false)
        GUI:setVisible(info_loadingbar, true)
        GUI:setVisible(loading_name, true)
        GUI:Text_setString(loading_name, data.loadingbar.name) -- 进度条前方文字
        GUI:Text_setString(loadingbar_text, data.loadingbar.valueInfo) -- 进度条上方文字
        GUI:SetLoadingbar_startper(info_loadingbar, data.loadingbar.value) -- 百分制
    elseif data.archenge then
        -- 大天使装备的特殊处理,已保证只执行一次!!!
        GUI:setContentSize(root, 350, 25)
        GUI:setVisible(title, false)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(value, false)
        GUI:setVisible(more_info, false)
        GUI:setVisible(info_loadingbar, true)
        GUI:setVisible(loading_name, true)
        self.archenge.loadingbar = info_loadingbar
        self.archenge.valueInfo = loadingbar_text
        self.archenge.loading_name = loading_name
        GUI:Text_setString(loading_name, data.archenge.name) -- 进度条前方文字
        GUI:Text_setString(loadingbar_text, data.archenge.valueInfo) -- 进度条上方文字
        GUI:SetLoadingbar_startper(info_loadingbar, data.archenge.value) -- 百分制
        --此协议为大天使装备的特殊处理，已保证只发送一次
        if (not self.args.info or not self.args.info.otherRid) and not self.archenge.isMaxLv then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ANGEL_EQUIP_ATTR, { itemId = self.args.id, itemConfigId = self.args.cfgId })
        end
    elseif data.itemInfo then
        GUI:setVisible(title, false)
        GUI:setVisible(item, true)
        GUI:setVisible(itemname, true)
        GUI:setVisible(value, false)
        GUI:setVisible(more_info, false)
        GUI:setVisible(info_loadingbar, false)
        GUI:setVisible(loading_name, false)
        GUI:Item_setItemId(item, data.itemInfo.itemId)
        GUI:Text_setTextColor(itemname, data.itemInfo.color)
        GUI:Text_setString(itemname, data.itemInfo.name)
    else
        
        GUI:setContentSize(root, 350, (string.isNullOrEmpty(data.name) and string.isNullOrEmpty(data.value)) and 8 or 16)
        GUI:setVisible(title, false)
        GUI:setVisible(value, true)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(more_info, false)
        GUI:setVisible(info_loadingbar, false)
        GUI:setVisible(loading_name, false)
        local _name = nil
        if data.gemBelong then
            local preText
            if string.isNullOrEmpty(data.name) then
                preText = ""
            else
                preText = data.name .. " "
            end
            local temp = string.format("镶宝 %s：%s（%s）", data.index, EElement[data.gemBelong], preText .. data.value)
            GUI:Text_setString(value, temp)
        
        elseif data.luck then
            if not string.isNullOrEmpty(data.name) then
                _name = data.name
            else
                _name = ""
            end
            local _value = nil
            if not string.isNullOrEmpty(data.value) then
                _value = data.value
            else
                _value = ""
            end
            local value_str = _name .. _value
            if string.isNullOrEmpty(data.name) then
                value_str = _value
            end
            local temp = string.format("幸运（%s）", value_str)
            GUI:Text_setString(value, temp)
        else
            if not string.isNullOrEmpty(data.name) then
                _name = data.name
            else
                _name = ""
            end
            local _value = nil
            if not string.isNullOrEmpty(data.value) then
                _value = data.value
            else
                _value = ""
            end
            local value_str = _name .. _value
            if string.isNullOrEmpty(data.name) then
                value_str = _value
            end
            GUI:Text_setString(value, value_str)
        end
        
        if data.color then
            GUI:Text_setTextColor(value, data.color)
        end
        if data.desc then
            GUI:setVisible(desc, true)
            GUI:Text_setString(desc, data.desc)
        end
        if data.descColor then
            GUI:Text_setTextColor(desc, data.descColor)
        end
    end
end
function this:EquipOriginListItemCountFunc()
    return #self.origin_info
end

function this:EquipOriginListItemGetFunc(realIndex)

end

function this:EquipOriginListItemInitFunc(realIndex, kmlcontrol)
end

function this:EquipOriginListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.origin_info[realIndex + 1]
    local origin_root = GUI:GetChildControl(self.view.origin_info_data, realIndex, "origin_root")
    local origin_text = GUI:GetChildControl(self.view.origin_info_data, realIndex, "origin_text")
    local h = (string.isNullOrEmpty(data.name) and string.isNullOrEmpty(data.dec)) and 8 or 16
    if data.isTitle then
        GUI:setColor(origin_text, "#B09366")
        GUI:setContentSize(origin_root,ETipsParameter.TipsWidth,h)
        GUI:Text_setText(origin_text, data.name)
    else
        GUI:setColor(origin_text, "#848484")
        GUI:setContentSize(origin_root,ETipsParameter.TipsWidth,h)
        if data.dec then
            GUI:Text_setText(origin_text, data.name .. data.dec)
        end
    end
end

function this:EquipBaseAttrDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.base_info[realIndex + 1]
    local root = GUI:GetChildControl(self.view.base_info_data, realIndex, "root")
    local title = GUI:GetChildControl(self.view.base_info_data, realIndex, "title")
    local value = GUI:GetChildControl(self.view.base_info_data, realIndex, "value")
    local desc = GUI:GetChildControl(self.view.base_info_data, realIndex, "desc")
    local more_info = GUI:GetChildControl(self.view.base_info_data, realIndex, "more_info")
    local loading_name = GUI:GetChildControl(self.view.base_info_data, realIndex, "loading_name")
    local info_loadingbar = GUI:GetChildControl(self.view.base_info_data, realIndex, "info_loadingbar")
    local loadingbar_text = GUI:GetChildControl(self.view.base_info_data, realIndex, "loadingbar_text")
    local item = GUI:GetChildControl(self.view.base_info_data, realIndex, "item")
    local itemname = GUI:GetChildControl(self.view.base_info_data, realIndex, "itemname")
    
    if data.is_title then
        GUI:setContentSize(root, 350, 25)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        
        GUI:setVisible(desc, false)
        GUI:setVisible(more_info, false)
        GUI:setVisible(info_loadingbar, false)
        GUI:setVisible(loading_name, false)
        if not string.isNullOrEmpty(data.title) then
            GUI:setVisible(title, true)
            GUI:Image_loadTexture(title, data.title, "Atlas/TipsAttTitle.spriteatlas")
            GUI:setVisible(value, false)
        else
            GUI:setVisible(title, false)
            GUI:setVisible(value, true)
            local _name = nil
            if not string.isNullOrEmpty(data.name) then
                _name = data.name
            else
                _name = ""
            end
            local _value = nil
            if not string.isNullOrEmpty(data.value) then
                _value = data.value
            else
                _value = ""
            end
            local value_str = _name .. " " .. _value
            if string.isNullOrEmpty(data.name) then
                value_str = _value
            end
            GUI:Text_setString(value, value_str)
            if data.color then
                GUI:Text_setTextColor(value, data.color)
            end
        end
    elseif data.info then
        GUI:setContentSize(root, 350, data.height)
        GUI:setVisible(title, false)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(value, false)
        GUI:setVisible(more_info, true)
        GUI:setVisible(info_loadingbar, false)
        GUI:setVisible(loading_name, false)
        GUI:Text_setString(more_info, data.info)
    elseif data.loadingbar then
        GUI:setContentSize(root, 350, 25)
        GUI:setVisible(title, false)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(value, false)
        GUI:setVisible(more_info, false)
        GUI:setVisible(info_loadingbar, true)
        GUI:setVisible(loading_name, true)
        GUI:Text_setString(loading_name, data.loadingbar.name) -- 进度条前方文字
        GUI:Text_setString(loadingbar_text, data.loadingbar.valueInfo) -- 进度条上方文字
        GUI:SetLoadingbar_startper(info_loadingbar, data.loadingbar.value) -- 百分制
    elseif data.archenge then
        -- 大天使装备的特殊处理,已保证只执行一次!!!
        GUI:setContentSize(root, 350, 25)
        GUI:setVisible(title, false)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(value, false)
        GUI:setVisible(more_info, false)
        GUI:setVisible(info_loadingbar, true)
        GUI:setVisible(loading_name, true)
        self.archenge.loadingbar = info_loadingbar
        self.archenge.valueInfo = loadingbar_text
        self.archenge.loading_name = loading_name
        GUI:Text_setString(loading_name, data.archenge.name) -- 进度条前方文字
        GUI:Text_setString(loadingbar_text, data.archenge.valueInfo) -- 进度条上方文字
        GUI:SetLoadingbar_startper(info_loadingbar, data.archenge.value) -- 百分制
        --此协议为大天使装备的特殊处理，已保证只发送一次
        if (not self.args.info or not self.args.info.otherRid) and not self.archenge.isMaxLv then
            SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ANGEL_EQUIP_ATTR, { itemId = self.args.id, itemConfigId = self.args.cfgId })
        end
    elseif data.itemInfo then
        GUI:setVisible(title, false)
        GUI:setVisible(item, true)
        GUI:setVisible(itemname, true)
        GUI:setVisible(value, false)
        GUI:setVisible(more_info, false)
        GUI:setVisible(info_loadingbar, false)
        GUI:setVisible(loading_name, false)
        GUI:Item_setItemId(item, data.itemInfo.itemId)
        GUI:Text_setTextColor(itemname, data.itemInfo.color)
        GUI:Text_setString(itemname, data.itemInfo.name)
    else
        GUI:setContentSize(root, 350, (string.isNullOrEmpty(data.name) and string.isNullOrEmpty(data.value)) and 8 or ETipsParameter.TipsElementHight)
        GUI:setVisible(title, false)
        GUI:setVisible(value, true)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(more_info, false)
        GUI:setVisible(info_loadingbar, false)
        GUI:setVisible(loading_name, false)
        
        local _name = nil
        if not data.gemBelong then
            if not string.isNullOrEmpty(data.name) then
                _name = data.name
            else
                _name = ""
            end
            local _value = nil
            if not string.isNullOrEmpty(data.value) then
                _value = data.value
            else
                _value = ""
            end
            local value_str = _name .. _value
            if string.isNullOrEmpty(data.name) then
                value_str = _value
            end
            GUI:Text_setString(value, value_str)
            --[[        else
                        local temp = string.format("镶宝 %s：%s（%s）", data.index, EElement[data.gemBelong], _name .. " " .. data.value)
                        GUI:Text_setString(value, temp)]]
        end
        
        if data.color then
            GUI:Text_setTextColor(value, data.color)
        end
        if data.desc then
            GUI:setVisible(desc, true)
            GUI:Text_setString(desc, data.desc)
        end
        if data.descColor then
            GUI:Text_setTextColor(desc, data.descColor)
        end
    end
end
function this:depotsBtnUpdate()
    GUI:setVisible(self.view.left_btn, true)
    GUI:Button_setTitleText(self.view.left_btn, "丢弃")
    
    GUI:setVisible(self.view.right_btn, true)
    GUI:Button_setTitleText(self.view.right_btn, "取出")

end
function this:bagBtnUpdate()
    local leftButton = SL:GetEquipValue(EMetaVarGetKey.EQUIP_TIPS_LEFT_BUTTON, self.args.equip_pos, self.args.cfgId, self.args.id)
    local rightButton = SL:GetEquipValue(EMetaVarGetKey.EQUIP_TIPS_RIGHT_BUTTON, self.args.equip_pos, self.args.cfgId, self.args.id)
    local isDelete = SL:GetConfig("cfg_item", self.args.cfgId).isDelete
    --合成炉只显示一个按钮
    local isSynthesis = GUI:GetUI("dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel") ~= nil
    if isSynthesis then
        leftButton = {}
        rightButton = {}
    end
    self.left_all = {}
    self.left_all_item = {}
    for i, v in ipairs(leftButton) do
        -- for j, btn_type in ipairs(v) do
        --     if btn_type == "9" and isDelete == 0 then
        --     else
        --         table.insert(self.left_all, btn_type)
        --     end
        -- end
        local btn_type = v[1]
        if btn_type == "9" and isDelete == 0 then
        else
            table.insert(self.left_all, v)
        end
    end
    self.right_all = {}
    self.right_all_item = {}
    for i, v in ipairs(rightButton) do
        -- for j, btn_type in ipairs(v) do
        --     if btn_type == "9" and isDelete == 0 then
        --     else
        --         table.insert(self.right_all, btn_type)
        --     end
        -- end
        local btn_type = v[1]
        if btn_type == "9" and isDelete == 0 then
        else
            table.insert(self.right_all, v)
        end
    end
    self.left_is_open = false
    GUI:Image_loadTexture(self.view.right_btn, "btn_tipsd", "Atlas/FG_Common.spriteatlas")
    if #self.left_all < 1 then
        ---设置成 长tips
        GUI:Image_loadTexture(self.view.right_btn, "btn_tips", "Atlas/FG_Common.spriteatlas")
        GUI:SetImageNativeSize(self.view.right_btn)
        GUI:setVisible(self.view.left_btn, false)
    elseif #self.left_all == 1 then
        GUI:setVisible(self.view.left_btn, true)
        local str = self:getBtnName(self.left_all[1])
        GUI:Button_setTitleText(self.view.left_btn, str)
    else
        GUI:setVisible(self.view.left_btn, true)
        GUI:Button_setTitleText(self.view.left_btn, "更多")
        GUI:DataListInitData(self.view.left_data_list, function()
            return self:LeftDataListItemCountFunc()
        end, function(realIndex)
            return self:LeftDataListItemGetFunc(realIndex)
        end, function(realIndex, kmlcontrol)
            return self:LeftDataListItemInitFunc(realIndex, kmlcontrol)
        end, function(realIndex, kmlcontrol)
            return self:LeftDataListItemUpdateFunc(realIndex, kmlcontrol)
        end)
    end
    self.right_is_open = false
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.right_btn, "放入")
        return
    end
    if GUI:GetUI("dev/outui/Equip/Panel/KLEquipOverlay/KLEquipOverlayPanel") then
        GUI:setVisible(self.view.left_btn, false)
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.right_btn, "放置")
        return
    end
    ---@type KLEquipRefinePanel
    local equipRefinePanel = GUI:GetUI("dev/outui/Equip/Panel/KLEquipRefine/KLEquipRefinePanel")
    if equipRefinePanel then
        if self.args.info and self.args.info.other then
            GUI:Button_setTitleText(self.view.right_btn, "卸下")
        else
            GUI:Button_setTitleText(self.view.right_btn, "放入")
        end
        GUI:setVisible(self.view.right_btn, true)
        return
    end
    GUI:Image_loadTexture(self.view.left_btn, "btn_tipsd", "Atlas/FG_Common.spriteatlas")
    if #self.right_all < 1 then
        ---设置成 长tips
        GUI:Image_loadTexture(self.view.left_btn, "btn_tips", "Atlas/FG_Common.spriteatlas")
        GUI:SetImageNativeSize(self.view.left_btn)
        GUI:setVisible(self.view.right_btn, false)
    elseif #self.right_all == 1 then
        GUI:setVisible(self.view.right_btn, true)
        local str = self:getBtnName(self.right_all[1])
        GUI:Button_setTitleText(self.view.right_btn, str)
    else
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.right_btn, "更多")
        GUI:DataListInitData(self.view.right_data_list, function()
            return self:RightDataListItemCountFunc()
        end, function(realIndex)
            return self:RightDataListItemGetFunc(realIndex)
        end, function(realIndex, kmlcontrol)
            return self:RightDataListItemInitFunc(realIndex, kmlcontrol)
        end, function(realIndex, kmlcontrol)
            return self:RightDataListItemUpdateFunc(realIndex, kmlcontrol)
        end)
    end
    if GUI:GetUI("dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel")
            or GUI:GetUI("dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel") then
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.right_btn, self.args.equip_pos == "bag" and "放入" or "拿出")
        if #self.left_all == 1 then
            GUI:Image_loadTexture(self.view.left_btn, "btn_tipsd", "Atlas/FG_Common.spriteatlas")
            GUI:SetImageNativeSize(self.view.left_btn)
        end
        return
    end
end

function this:BtnLeftOnClick()
    if self.args.equip_pos == "depots" then
        local storeIndex = SL:GetDepotsIndex(self.args.id)
        SL:ReqStoreGiveUpItemMessage(storeIndex)
        self:CloseEquipTips()
        return
    end
    --合成
    if self.args.equip_pos == "synthesis" or self.args.equip_pos == "looptask" then
        SL:onLUAEvent(LUA_EVENT_TIPS_ONCLICK_REPLACE)
        self:CloseEquipTips()
        return
    end
    if #self.left_all < 1 then
    
    elseif #self.left_all == 1 then
        local btnType = self.left_all[1][1]
        if not InfoManager.equipOrItemTipsInfo:IsCanOnClickButton(self.left_all[1]) then
            return
        end
        if btnType == "0" then
            self:CloseEquipTips()
        elseif btnType == "2" then
            self:CloseEquipTips()
        elseif btnType == "3" then
            self:PutOneEquip()
        elseif btnType == "9" then
            local name = SL:GetEquipValue(EMetaVarGetKey.EQUIP_NAME, self.args.equip_pos, self.args.cfgId, self.args.id)
            SL:CommonTipsMessage({ showTips = "是否摧毁" .. name,
                                   ui = self,
                                   sureBtnText = "确定",
                                   cancelBtnText = "取消",
                                   callback = self.DestroyItem
            })
        
        elseif btnType == "10" then
            self:JieFeng()
        elseif btnType == "11" then
            self:DiuQi()
        elseif btnType == "13" then
            self:Decompose()
        elseif btnType == "99" then
            self:OpenPanel(self.left_all[1])
        end
    
    else
        if not self.left_is_open then
            GUI:setVisible(self.view.left_btn_content, true)
            self.left_is_open = true
            GUI:DataListUpdateData(self.view.left_data_list)
        else
            GUI:setVisible(self.view.left_btn_content, false)
            self.left_is_open = false
        end
    end
end

function this:PutOneEquip()
    local ItemInfo = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    SL:SetMetaValue(EMetaVarSetKey.SET_ROLE_ATTR_VALUE_OFFSET, self.useAttLimit)
    EquipFunc.SetRoleAttrValueOffset(self.useAttLimit)
    ---@type cfg_item_column
    local cfg =  SL:GetConfig("cfg_item", self.args.cfgId)
    if cfg.subType == 10001 then
        local index = SL:GetBagIndex(self.args.id)
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RIDE_OR_DOWN_MOUNT,index)
    else
        if SL:CheckEquipWear(ItemInfo) == 1 then
            SL:PutOnEquip(ItemInfo)
        else
            SL:SetMetaValue(EMetaVarSetKey.SET_ROLE_ATTR_VALUE_OFFSET, self.useAttLimit)
            EquipFunc.SetRoleAttrValueOffset(self.useAttLimit)
            -- SL.Equip:ShowCantEquipTip(ItemInfo)
            --强化后穿戴要求变了，改成外置自己的逻辑
            SL.Equip:ShowCantEquipTip_Out(ItemInfo)
        end
    end
    self:CloseEquipTips()
end

function this.DestroyItem(returnData)
    local ui = returnData.ui
    local index = SL:GetBagIndex(ui.args.id)
    SL:ReqDestroyItemMessage(index)
    ui:CloseEquipTips()
end

function this:JieFeng()
    self:CloseEquipTips()
end

function this:DiuQi()
    if self.args.equip_pos == "depots" then
        local storeIndex = SL:GetDepotsIndex(self.args.id)
        SL:ReqStoreGiveUpItemMessage(storeIndex)
    else
        local index = SL:GetBagIndex(self.args.id)
        SL:ReqGiveUpItemMessage(index)
    end
    self:CloseEquipTips()
end

function this:Decompose()
    self:CloseEquipTips()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    SL:HideAllKmlPanel()
    SL:OpenForgeGroupUI(EForgeGroupType.Decompose)
end

function this:TakeOffEquip()
    if not self.args.id then
        return
    end
    local wearBarId, pos = SL:GetEquipWearBarIdPos(self.args.id)
    SL:TakeOffEquip(wearBarId, pos)
    self:CloseEquipTips()
end

function this:ShengJi()
    if not InfoManager.equipOrItemTipsInfo:IsCanOnClickButton("", 10407) then
        return
    end
    self:CloseEquipTips()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    SL:HideAllKmlPanel()
    SL:OpenForgeGroupUI(EForgeGroupType.Jewelry)
end

function this:ForgeOnClick()
    if not InfoManager.equipOrItemTipsInfo:IsCanOnClickButton("", 10401) then
        return
    end
    
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    local wearBarId, pos = SL:GetEquipWearBarIdPos(self.args.id)
    SL:HideAllKmlPanel()
    SL:OpenForgeGroupUI(EForgeGroupType.Strength, pos)
    self:CloseEquipTips()
end

function this:BreakOnClick()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    SL:HideAllKmlPanel()
    --GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel", nil, nil, { selectId = self.args.cfgId })
    self:CloseEquipTips()
end

function this:getBtnName(data)
    local btn_type = data[1]
    if btn_type == "0" then
        return "取消"
    elseif btn_type == "1" then
        return "使用"
    elseif btn_type == "2" then
        return "回收"
    elseif btn_type == "3" then
        return "穿戴"
    elseif btn_type == "4" then
        return "强化"
    elseif btn_type == "5" then
        return "上架"
    elseif btn_type == "6" then
        return "合并"
    elseif btn_type == "7" then
        return "拆分"
    elseif btn_type == "8" then
        return "批量使用"
    elseif btn_type == "9" then
        return "摧毁"
    elseif btn_type == "10" then
        return "解封"
    elseif btn_type == "11" then
        return "丢弃"
    elseif btn_type == "13" then
        return "分解"
    elseif btn_type == "14" then
        return "装备"
    elseif btn_type == "99" then
        return data[2]
    elseif btn_type == "100" then
        return "修理"
    end
    return ""
end

function this:LeftDataListItemCountFunc()
    return #self.left_all
end

function this:LeftDataListItemGetFunc(realIndex)
    local data = self.left_all[realIndex + 1]
    local str = self:getBtnName(data)
    local message = { equip_pos = self.args.equip_pos, cfgId = self.args.cfgId, id = self.args.id, btnType = data, nameStr = str }
    local item = GUI:UIPanel_Open("dev/ui/Tips/Item/KLUITips/KLTipBtntem", self.view.left_data_list, self, message, true)
    self.left_all_item[item.view.root] = item
    return item.view.root
end

function this:LeftDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:LeftDataListItemUpdateFunc(realIndex, kmlcontrol)
end

function this:BtnRightOnClick()
    if self.args.equip_pos == "depots" then
        local storeIndex = SL:GetDepotsIndex(self.args.id)
        SL.Equip:ReqStoreTakeButtonMessage(storeIndex)
        self:CloseEquipTips()
        return
    end
    local depotPanel = GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel")
    if depotPanel then
        local BagIndex = SL:GetBagIndex(self.args.id)
        if depotPanel.bagType == "privilege" then
            SL.Equip:ReqBagPutStoreButtonMessage(BagIndex, SL:GetDepotsCurPage() + depotPanel.maxDepotsPages)
        else
            SL.Equip:ReqBagPutStoreButtonMessage(BagIndex, SL:GetDepotsCurPage())
        end
        self:CloseEquipTips()
        return
    end
    
    --叠加
    local overlay = GUI:GetUI("dev/outui/Equip/Panel/KLEquipOverlay/KLEquipOverlayPanel")
    if overlay then
        overlay:SelectItem(self.args.equip_pos, self.args.cfgId, self.args.id)
        self:CloseEquipTips()
        return
    end
    --合成
    local synthesisPanel = GUI:GetUI("dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel")
    if synthesisPanel then
        if self.args.equip_pos == "synthesis" then
            synthesisPanel:SmelterToBagItem_Out(self.args.id)
        else
            synthesisPanel:BagToSmelterItem_Out(self.args.id, self.args.cfgId)
        end
        self:CloseEquipTips()
        return
    end
    local taskLoopPanel = GUI:GetUI("dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel")
    if taskLoopPanel then
        -- SL:LogError("SmelterToBagItem_Out", self.args.equip_pos, self.args.id)
        if self.args.equip_pos == "looptask" then
            -- SL:LogError("SmelterToBagItem_Out2", self.args.id)
            taskLoopPanel:SmelterToBagItem_Out(self.args.id)
        else
            taskLoopPanel:BagToSmelterItem_Out(self.args.id, self.args.cfgId)
        end
        self:CloseEquipTips()
        return
    end
    ---@type KLEquipRefinePanel
    local equipRefinePanel = GUI:GetUI("dev/outui/Equip/Panel/KLEquipRefine/KLEquipRefinePanel")
    if equipRefinePanel then
        if self.args.info and self.args.info.other then
            equipRefinePanel:EquipCancel(self.args.info.other)
        else
            equipRefinePanel:SelectItem(self.args.equip_pos, self.args.cfgId, self.args.id)
        end
        self:CloseEquipTips()
        return
    end
    if #self.right_all < 1 then
    
    elseif #self.right_all == 1 then
        local btnType = self.right_all[1][1]
        if not InfoManager.equipOrItemTipsInfo:IsCanOnClickButton(self.right_all[1]) then
            return
        end
        if btnType == "0" then
            self:CloseEquipTips()
        elseif btnType == "1" then
            self:UseItem()
        elseif btnType == "2" then
            self:CloseEquipTips()
        elseif btnType == "3" then
            self:PutOneEquip()
        elseif btnType == "9" then
            SL:CommonTipsMessage({ showTips = "是否摧毁" .. name,
                                   ui = self,
                                   sureBtnText = "确定",
                                   cancelBtnText = "取消",
                                   callback = self.DestroyItem
            })
        elseif btnType == "10" then
            self:JieFeng()
        elseif btnType == "11" then
            self:DiuQi()
        elseif btnType == "13" then
            self:Decompose()
        elseif btnType == "14" then
            --准备坐骑道具
        
        
        elseif btnType == "99" then
            self:OpenPanel(self.right_all[1])
        end
    
    else
        if not self.right_is_open then
            GUI:setVisible(self.view.right_btn_content, true)
            self.right_is_open = true
            GUI:DataListUpdateData(self.view.right_data_list)
        else
            GUI:setVisible(self.view.right_btn_content, false)
            self.right_is_open = false
        end
    end
end

function this:UseItem()
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item", self.args.cfgId)
    
    SL:UseItem(self.args.cfgId, self.args.id, self.args.count)
    local cfgId = self.args.cfgId
    if itemTbl.type == E_ItemType.TriggerItem and itemTbl.subType == E_OutTriggerItemType.TransferRing then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
        SL:HideAllKmlPanel()
        
        --守护处理，跳转到外观守护界面
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel", nil, nil, E_FashionType.TransferRing)
        
        SL:ScheduleOnce(0.3, function()
            SL:onLUAEvent(TRANSFER_RING_SELECT_ITEM, cfgId)
        end)
    
    elseif itemTbl.type == E_ItemType.TriggerItem and itemTbl.subType == E_OutTriggerItemType.GuardSkin then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
        SL:HideAllKmlPanel()
        
        --守护处理，跳转到外观守护界面
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel", nil, nil, E_FashionType.Appear)
        SL:ScheduleOnce(0.3, function()
            SL:onLUAEvent(APPEAR_SELECT_ITEM, cfgId)
        end)
    end
    self:CloseEquipTips()
end

function this:OpenPanel(btnType)
    if #btnType < 3 then
        return
    end
    self:CloseEquipTips()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    SL:HideAllKmlPanel()
    local panel = btnType[4]
    if #btnType == 4 then
        GUI:UIPanel_Open(panel)
    elseif #btnType == 5 then
        local num = btnType[5]
        if tonumber(num) then
            num = tonumber(num)
        end
        GUI:UIPanel_Open(panel, nil, nil, num)
    elseif #btnType >= 7 then
        local message = {}
        for i = 5, #btnType - 2, 3 do
            if btnType[i] and btnType[i + 1] and btnType[i + 2] then
                if btnType[i + 1] == "string" then
                    message[btnType[i]] = btnType[i + 2]
                else
                    message[btnType[i]] = tonumber(btnType[i + 2])
                end
            end
        end
        GUI:UIPanel_Open(panel, nil, nil, message)
    end
    SL.HideMainPanel()

end

function this:RightDataListItemCountFunc()
    return #self.right_all
end

function this:RightDataListItemGetFunc(realIndex)
    local data = self.right_all[realIndex + 1]
    local str = self:getBtnName(data)
    local message = { equip_pos = self.args.equip_pos, cfgId = self.args.cfgId, id = self.args.id, btnType = data, nameStr = str }
    local item = GUI:UIPanel_Open("dev/ui/Tips/Item/KLUITips/KLTipBtntem", self.view.right_data_list, self, message, true)
    self.right_all_item[item.view.root] = item
    return item.view.root
end

function this:RightDataListItemInitFunc(realIndex, kmlcontrol)

end

function this:RightDataListItemUpdateFunc(realIndex, kmlcontrol)
end

----------首饰特殊处理显示----------------------------------------------------------
---@return cfg_equip_ornaments_column
function this:GetJewelryTblInfoByLevel(cfgId, Level)
    local ornament_tbl = SL:GetConfig('cfg_equip_ornamentsMain', cfgId)
    local ornamentsTbl = SL:GetConfigTable('cfg_equip_ornaments')
    for _, v in pairs(ornamentsTbl) do
        if v.ornamentsGroup == ornament_tbl.ornamentsGroup and v.lv == Level then
            return v
        end
    end
    return nil
end

function this:SetJewelryTips()
    local jichu_list
    local jichu_index
    for i, v in ipairs(self.all_att_sort_list) do
        if v.attr_type == 1 then
            jichu_index = i
            jichu_list = v.data
            break
        end
    end
    if not jichu_list then
        jichu_list = {}
    end
    local jewelryEquip = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    if not jewelryEquip then
        jewelryEquip = {}
        jewelryEquip.luaExtData = "null"
    end
    ---@type RES_UPDATE_EQUIP_ORNAMENTS
    local OutEquipData = SL:JsonDecode(jewelryEquip.luaExtData, false)
    local preLevel = 0
    if OutEquipData == nil or (OutEquipData and not OutEquipData.ssuplv) then
        preLevel = 0
    else
        preLevel = OutEquipData.ssuplv
    end
    local PreOrnament_Tbl = self:GetJewelryTblInfoByLevel(self.args.cfgId, preLevel)
    local NextOrnament_Tbl = self:GetJewelryTblInfoByLevel(self.args.cfgId, preLevel + 1)
    local shoushi_att = {}
    if PreOrnament_Tbl then
        local nextLevel = ""
        ----基础属性标题
        if not self.IsHaveStrengthen then
            --table.insert(self.all_info, { title = "tips_attribute21" })
        end
        ----等级
        --table.insert(self.all_info, { name = "LV." .. preLevel, value = "" })
        table.insert(shoushi_att, { name = "LV." .. preLevel, value = "" })
        local one_att = self:JewelSpecialAttr(PreOrnament_Tbl, "#FFFFFF")
        if one_att then
            table.insert(shoushi_att, one_att)
        end
        for _, attrValue in pairs(PreOrnament_Tbl.basicAtt) do
            if not self:IsJewelSpecialAttr(attrValue[1]) then
                local preValue = 0
                local attrName = SL:GetConfig("cfg_att_info", tonumber(attrValue[1])).name
                local att_remark = SL:GetConfig("cfg_att_info", tonumber(attrValue[1])).remarks
                if att_remark == 1 then
                    preValue = attrValue[2]
                else
                    preValue = tonumber(attrValue[2]) / 100 .. '%'
                end
                --table.insert(self.all_info, { name = attrName .. ":", value = preValue, color = "#FFFFFF" })
                table.insert(shoushi_att, { name = attrName .. ":", value = preValue, color = "#FFFFFF" })
            end
        end
        if NextOrnament_Tbl then
            nextLevel = preLevel + 1
            ----下一等级
            --table.insert(self.all_info, { name = "下一级LV." .. nextLevel, value = "" })
            table.insert(shoushi_att, { name = "下一级LV." .. nextLevel, value = "", color = "#999999", color_not_change = true })
            local o_att = self:JewelSpecialAttr(NextOrnament_Tbl, "#B0B0B0")
            if o_att then
                o_att.color = "#999999"
                o_att.color_not_change = true
                table.insert(shoushi_att, o_att)
            end
            for _, attrValue in pairs(NextOrnament_Tbl.basicAtt) do
                if not self:IsJewelSpecialAttr(attrValue[1]) then
                    local NextValue = 0
                    local attrName = SL:GetConfig("cfg_att_info", tonumber(attrValue[1])).name
                    local att_remark = SL:GetConfig("cfg_att_info", tonumber(attrValue[1])).remarks
                    if att_remark == 1 then
                        NextValue = attrValue[2]
                    else
                        NextValue = tonumber(attrValue[2]) / 100 .. '%'
                    end
                    --table.insert(self.all_info, { name = attrName .. ":", value = NextValue, color = "#B0B0B0" })
                    table.insert(shoushi_att, { name = attrName .. ":", value = NextValue, color = "#999999", color_not_change = true })
                end
            end
        end
    end
    if jichu_index then
        self.all_att_sort_list[jichu_index].data = jichu_list
    else
        table.insert(self.all_att_sort_list, { attr_type = 1, data = jichu_list })
    end
    --if shoushi_att and #shoushi_att > 0 then
    --    table.insert(self.all_att_sort_list, { attr_type = 10, data = shoushi_att })
    --end
    ----------卓越属性
    ----卓越属性标题
    --table.insert(self.all_info, { title = "tips_attribute3" })
    local zhuoyue_list
    local zhuoyue_index
    for i, v in ipairs(self.all_att_sort_list) do
        if v.attr_type == 4 then
            zhuoyue_index = i
            zhuoyue_list = v.data
            break
        end
    end
    if not zhuoyue_list then
        zhuoyue_list = {}
    end
    
    --local ornament_tbl = SL:GetConfig('cfg_equip_ornamentsMain', self.args.cfgId)
    --local ornamentsTbl = SL:GetConfigTable('cfg_equip_ornaments')
    --for _, v in pairs(ornamentsTbl) do
    --    if v.ornamentsGroup == ornament_tbl.ornamentsGroup then
    --        if next(v.excellenceAtt) then
    --            for _, attrValue in pairs(v.excellenceAtt) do
    --                local preValue = 0
    --                local attrName = SL:GetConfig("cfg_att_info", tonumber(attrValue[1])).name
    --                local att_remark = SL:GetConfig("cfg_att_info", tonumber(attrValue[1])).remarks
    --                local desc = ""
    --                local descColor = "#FFFFFF"
    --                local color = "#B0B0B0"
    --                if preLevel < v.lv then
    --                    desc = v.lv .. "级可激活"
    --                    descColor = "#ff2323"
    --                    color = "#B0B0B0"
    --                else
    --                    desc = v.lv .. "级可激活"
    --                    descColor = "#00ff00"
    --                    color = "#B0B0B0"
    --                end
    --                if OutEquipData and OutEquipData.ssactlv then
    --                    for _, data in pairs(OutEquipData.ssactlv) do
    --                        if tonumber(data) == v.lv then
    --                            desc = "已激活"
    --                            descColor = "#4BA7E8"
    --                            color = "#4BA7E8"
    --                        end
    --                    end
    --                end
    --                if att_remark == 1 then
    --                    preValue = attrValue[2]
    --                else
    --                    preValue = tonumber(attrValue[2]) / 100 .. '%'
    --                end
    --                if self:chenckAttrShow(tonumber(attrValue[1])) then
    --                    local nameStr = nil
    --                    if not self:chenckAttrValue(tonumber(attrValue[1])) then
    --                        preValue = ""
    --                        nameStr = attrName
    --                    else
    --                        nameStr = attrName .. " +"
    --                    end
    --                    --table.insert(self.all_info, { name = nameStr, value = preValue, color = color, desc = desc, descColor = descColor })
    --                    table.insert(zhuoyue_list, { name = nameStr, value = preValue, color = color, desc = desc, descColor = descColor, color_not_change = true })
    --                end
    --            end
    --        end
    --    end
    --end
    if #zhuoyue_list > 0 then
        if zhuoyue_index then
            self.all_att_sort_list[zhuoyue_index].data = zhuoyue_list
        else
            table.insert(self.all_att_sort_list, { attr_type = 4, data = zhuoyue_list })
        end
    end
end

function this:JewelSpecialAttr(PreOrnament_Tbl, _Color)
    local max1
    local min1
    local max2
    local min2
    local max3
    local min3
    local max4
    local min4
    for i, v in ipairs(PreOrnament_Tbl.basicAtt) do
        if v[1] == 200021 then
            max1 = v
        elseif v[1] == 200011 then
            min1 = v
        elseif v[1] == 202011 then
            max2 = v
        elseif v[1] == 202021 then
            min2 = v
        elseif v[1] == 205021 then
            max3 = v
        elseif v[1] == 205011 then
            min3 = v
        elseif v[1] == 203021 then
            max4 = v
        elseif v[1] == 203011 then
            min4 = v
        end
    end
    if max1 and min1 then
        local _value = min1[2] .. "˜" .. max1[2]
        local twoHanded = SL:GetEquipValue(EMetaVarGetKey.EQUIP_TWO_HANDED, self.args.equip_pos, self.args.cfgId, self.args.id)
        return { name = twoHanded == 1 and "双手攻击力" or "单手攻击力", value = _value, color = _Color }
    end
    if max2 and min2 then
        local _value = min2[1] .. "˜" .. max2[2]
        return { name = "魔法攻击力", value = _value, color = _Color }
    end
    if max3 and min3 then
        local _value = min3[1] .. "˜" .. max3[2]
        return { name = "诅咒攻击力", value = _value, color = _Color }
    end
    if max4 and min4 then
        local _value = min4[1] .. "˜" .. max4[2]
        return { name = "天鹰攻击力", value = _value, color = _Color }
    end
    return
end
function this:IsJewelSpecialAttr(attrId)
    if attrId == 200021 or attrId == 200011 or attrId == 202011 or attrId == 202021 or attrId == 205021 or attrId == 205011 or attrId == 203021 or attrId == 203011 then
        return true
    end
    return false
end
----------首饰特殊处理显示end----------------------------------------------------------

----------大天使装备对进度条的特殊处理------------------------------------------
function this:RES_ANGEL_EQUIPMENT_ATTR_INFO(_, message)
    if message[tostring(self.args.id)] then
        GUI:SetLoadingbar_startper(self.archenge.loadingbar, (message[tostring(self.args.id)].exp / self.archenge.maxExp) * 100)
        GUI:Text_setString(self.archenge.valueInfo, tostring(message[tostring(self.args.id)].exp) .. "/" .. tostring(self.archenge.maxExp))
        GUI:Text_setString(self.archenge.loading_name, "<color='#00ff00'>Lv." .. tostring(message[tostring(self.args.id)].level) .. "</color>")
    end
end

function this:RES_OTHER_ANGE_EQUIP_INFO(_, message)
    self.otherArchange = message[tostring(self.args.id)]
    self:Refresh()
end

----------萤石属性-----------start----------------------------------------------------------------

function this:GetGemAtt()
    -- self.all_gem_att = {}
    -- local rid = SL:GetMetaValue(EMetaVarGetKey.USER_ID)
    -- local target_id = nil
    -- if self.args.info and self.args.info.otherRid then
    --     if tostring(self.args.info.otherRid) ~= rid then
    --         target_id = self.args.info.otherRid
    --     end
    -- end
    -- if not self.args.id then
    --     return
    -- end
    -- --显示的是自己装备的萤石属性
    -- if not target_id then
    --     if self.args.equip_pos ~= "equip" and self.args.equip_pos ~= "chat" then
    --         return
    --     end
    --     local index = SL.Equip:GetIndexBaseOnItemId(self.args.id)
    --     if not index then
    --         return
    --     end
    --     local wearBarId, pos = SL:GetEquipWearBarIdPos(self.args.id)
    --     local gem_data = InfoManager.gemSlateInfo:GetTargetEquipGem(pos)
    --     local pos = 0
    --     if gem_data then
    --         for index, gem_id in pairs(gem_data.gems) do
    --             local tab = SL:GetConfig("cfg_equip_gem", gem_id)
    --             pos = pos + 1
    --             for i, att in ipairs(tab.gemAtt) do
    --                 local target_index = nil
    --                 for j = 1, #self.all_gem_att, 1 do
    --                     if self.all_gem_att[j].type == att[1] then
    --                         target_index = j
    --                     end
    --                 end
    --                 if target_index then
    --                     local tar_value = self.all_gem_att[target_index].num
    --                     tar_value = tar_value + att[2]
    --                     self.all_gem_att[target_index].num = tar_value
    --                 else
    --                     table.insert(self.all_gem_att, { type = att[1], num = att[2], index = index, gemBelong = tab.gemBelong[1] })
    --                 end
                
    --             end
    --         end
    --     end
    
    -- else
    --     --显示别人装备的萤石属性
    --     if not self.gemOtherPlayerId then
    --         SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_OTHER_GEM_EQUIP_INFO, { rid = target_id })--请求一下别的玩家的萤石信息
    --     else
    --         if not EquipFunc.checkOtherEquips() then
    --             return
    --         end
    --         local wearBarId, pos = EquipFunc.OtherGetEquipWearBarIdPos(self.args.id)
    --         local gem_data = InfoManager.gemSlateInfo:GetOtherPlayerTargetEquipGem(pos)
    --         if gem_data then
    --             for k, gem_id in pairs(gem_data.gems) do
    --                 local tab = SL:GetConfig("cfg_equip_gem", gem_id)
    --                 for i, att in ipairs(tab.gemAtt) do
    --                     local target_index = nil
    --                     for j = 1, #self.all_gem_att, 1 do
    --                         if self.all_gem_att[j].type == att[1] then
    --                             target_index = j
    --                         end
    --                     end
    --                     if target_index then
    --                         local tar_value = self.all_gem_att[target_index].num
    --                         tar_value = tar_value + att[2]
    --                         self.all_gem_att[target_index].num = tar_value
    --                     else
    --                         table.insert(self.all_gem_att, { type = att[1], num = att[2] })
    --                     end
                    
    --                 end
    --             end
    --         end
    --     end
    -- end
    
    -- table.sort(self.all_gem_att, function(a, b)
    --     return a.index < b.index
    -- end)
end

function this:SetLuckyAtt()
    local all_luckyAtt = {}
    local itemInfo = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    if itemInfo then
        all_luckyAtt = EquipFunc.GetEquipLuckyAttr(itemInfo)
    end
    if not table.isNullOrEmpty(all_luckyAtt) then
        all_luckyAtt = self:GetBaseAttr(all_luckyAtt)
        table.insert(self.all_att_sort_list, { attr_type = 12, data = all_luckyAtt })
    end
end

function this:SetTaoZhuangEWaiAtt()
    local attr = {}
    local itemInfo = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    if itemInfo then
        attr = EquipFunc.GetEquipTaoZhuangEWai(itemInfo)
    end
    if not table.isNullOrEmpty(attr) then
        attr = self:GetBaseAttr(attr)
        table.insert(self.all_att_sort_list, { attr_type = 13, data = attr })
    end
end


function this:LUA_EVENT_REFRESH_GEM_SLATE_INFO(_id, message)
    if not self.args.info or not self.args.info.otherRid then
        return
    end
    if tostring(self.args.info.otherRid) ~= tostring(message) then
        return
    end
    self.gemOtherPlayerId = message
    self:Refresh()
end

function this:IsSuitEquip(cfgId)
    return EquipFunc.IsSuitEquip(cfgId)
end

function this:IsExcellentEquip(cfgId)
    return EquipFunc.IsExcellentEquip(cfgId)
end



----------萤石属性-----------end----------------------------------------------------------------

function this:ComparsionConfig()
    local itemInfo = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    if not itemInfo then
        return
    end
    local twoHanded = SL:GetEquipValue(EMetaVarGetKey.EQUIP_TWO_HANDED, self.args.equip_pos, self.args.cfgId, self.args.id)
    local two_handed = ""
    if self.subType and self.subType <= 3 then
        if twoHanded and twoHanded == 1 then
            two_handed = "双手武器"
        else
            two_handed = "单手武器"
        end
    end
    local equip_status = ""
    local equip_status_wear = ""
    GUI:setVisible(self.view.text_deal,true)
    
    if self.args.equip_pos == "equip" then
        equip_status_wear = "【已装备】"
    end
    local equip_status = ""
    local showBindTips = EquipFunc.ShowBindTips(self.args.cfgId)
    if showBindTips then
        GUI:setVisible(self.view.text_deal_node, true)
        if EquipFunc.GetItemIsBind(self.args.cfgId, itemInfo) or not showBindTips then
            equip_status = "<color=#ff2323>不可交易</color>" .. equip_status_wear
        else
            equip_status = "可交易" .. equip_status_wear
        end
        GUI:Text_setString(self.view.text_deal, equip_status)
    else
        GUI:setVisible(self.view.text_deal_node, false)
    end
end

function this:SetTipPosition()
    -- 计算获取装备的位置，使其更靠近按钮
    local tipsPanel = GUI:GetUI("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    if tipsPanel and tipsPanel.view.root then
        -- 获取当前tips面板的位置和尺寸
        local height = GUI:GetHeight(self.view.panel_bg)
        
        local tipsX, tipsY = GUI:getPosition(tipsPanel.view.root)
        local tipsWidth = GUI:GetWidth(tipsPanel.view.panel_bg)
        local tipsHeight = GUI:GetHeight(tipsPanel.view.panel_bg)
        if tipsPanel.isFixation then
            GUI:setPositionX(self.view.root, tipsX - tipsWidth)
        else
            -- 设置比较面板位置更远离按钮
            if tipsPanel.isLeft then
                local tipsPanelX = tipsX - (ETipsParameter.TipsWidth / 2 + tipsWidth / 2)
                GUI:setPositionX(self.view.root, tipsX)
                GUI:setPositionX(tipsPanel.view.root, tipsPanelX)
            else
                local tipsPanelX = tipsX + (ETipsParameter.TipsWidth / 2 + tipsWidth / 2)
                GUI:setPositionX(self.view.root, tipsX)
                GUI:setPositionX(tipsPanel.view.root, tipsPanelX)
            end
        
        end
        
        
        GUI:setPositionY(self.view.root, tipsY + (tipsHeight  - height) / 2)
    end

end

return this
