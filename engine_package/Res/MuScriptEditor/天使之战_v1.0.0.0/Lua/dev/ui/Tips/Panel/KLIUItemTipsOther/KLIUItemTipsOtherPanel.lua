---@class KLIUItemTipsOtherPanel:UIKmlLuaPanelBase
---@field view KLIUItemTipsOtherPanelView
local KLIUItemTipsOtherPanel = class(UIKmlLuaPanelBase)
local this = KLIUItemTipsOtherPanel
function this:InitList()
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
    GUI:DataListInitData(self.view.base_info_data, function()
        return #self.base_info
    end, function(realIndex)
        return self:EquipAttrDataListItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:EquipAttrDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:EquipBaseAttrDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    
    GUI:DataListInitData(self.view.yulan_data_list,function()
        return self:yulanDataListItemCountFunc()
    end,function(realIndex)
        return self:yulanDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:yulanDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:yulanDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:setVisible(self.view.left_btn_content,false)
    GUI:setVisible(self.view.right_btn_content,false)
    GUI:setVisible(self.view.num_select,false)
    GUI:setVisible(self.view.synthesisDesc, false)
end

function this:EquipAttrDataListItemCountFunc()
    return #self.all_info
end

function this:EquipAttrDataListItemGetFunc(realIndex)

end

function this:EquipAttrDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:EquipBaseAttrDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.base_info[realIndex + 1]
    local root = GUI:GetChildControl(self.view.base_info_data, realIndex, "root")
    local title = GUI:GetChildControl(self.view.base_info_data, realIndex, "title")
    local value = GUI:GetChildControl(self.view.base_info_data, realIndex, "value")
    local desc = GUI:GetChildControl(self.view.base_info_data, realIndex, "desc")
    local more_info = GUI:GetChildControl(self.view.base_info_data, realIndex, "more_info")
    local item = GUI:GetChildControl(self.view.base_info_data, realIndex, "item")
    local itemname = GUI:GetChildControl(self.view.base_info_data, realIndex, "itemname")
    
    if data.is_title then
        GUI:setContentSize(root, 350, 25)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)

        GUI:setVisible(desc, false)
        GUI:setVisible(more_info, false)

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


        GUI:Text_setString(more_info, data.info)
    elseif data.loadingbar then
        GUI:setContentSize(root, 350, 25)
        GUI:setVisible(title, false)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(value, false)
        GUI:setVisible(more_info, false)


    elseif data.archenge then
        -- 大天使装备的特殊处理,已保证只执行一次!!!
        GUI:setContentSize(root, 350, 25)
        GUI:setVisible(title, false)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(value, false)
        GUI:setVisible(more_info, false)

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


        GUI:Item_setItemId(item, data.itemInfo.itemId)
        GUI:Text_setTextColor(itemname, data.itemInfo.color)
        GUI:Text_setString(itemname, data.itemInfo.name)
    else
        GUI:setContentSize(root, 350, 16)
        GUI:setVisible(title, false)
        GUI:setVisible(value, true)
        GUI:setVisible(item, false)
        GUI:setVisible(itemname, false)
        GUI:setVisible(more_info, false)

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
        else
            local temp = string.format("镶宝 %s：%s（%s）", data.index, EElement[data.gemBelong], _name .. " " .. data.value)
            GUI:Text_setString(value, temp)
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
        GUI:setContentSize(jobBg, ETipsParameter.TipsWidth, ETipsParameter.TipsJobBgHight)
    end
    self:ChangeMidOne(title, name)
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

function this:InitControl()
    local alplValue = 90
    if SL:HasConfig("cfg_global", 290005, "id") then
        alplValue = tonumber(SL:GetConfig("cfg_global", 290005, "id").value)
    end
    GUI:Image_setAlpha(self.view.panel_bg, alplValue / 100)
end


function this:ChangeMid()
    self:ChangeMidOne(self.view.equip_need_level_titlt, self.view.equip_need_level)
    --self:ChangeMidOne(self.view.equip_jie_root, self.view.equip_jie)
    self:ChangeMidOne(self.view.att_level_titlt, self.view.att_need_level)
end

function this:ChangeMidOne(control_name, control_value)
    local levelDes = GUI:Text_getString(control_name)
    local level = GUI:Text_getString(control_value)
    GUI:Text_setString(control_name, levelDes .. level)
    GUI:setVisible(control_value, false)
end

function this:ShowUseLimit()
    local name_color = SL:GetConfig("cfg_item", self.args.cfgId).color
    local rank = SL:GetEquipValue(EMetaVarGetKey.EQUIP_RANK, self.args.equip_pos, self.args.cfgId, self.args.id)
    local useLevelLimit = SL:GetEquipValue(EMetaVarGetKey.EQUIP_USE_LEVEL_LIMIT, self.args.equip_pos, self.args.cfgId,self.args.id)
    
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
            GUI:setVisible(self.view.equip_need_level_titlt_node, true)
            GUI:setVisible(self.view.equip_need_level_titlt_node, true)
            GUI:setVisible(self.view.red_equip_need_level_titlt_node, true)
            GUI:Text_setString(self.view.equip_need_level, level_str)
            GUI:Text_setTextColor(self.view.equip_need_level_titlt, level_color)
            --top_num = top_num + 1
        else
            GUI:setVisible(self.view.equip_need_level, false)
            GUI:setVisible(self.view.equip_need_level_titlt_node, false)
            GUI:setVisible(self.view.equip_need_level_titlt_node, false)
        end

        if need_level ~= 0 then
            GUI:setVisible(self.view.red_equip_need_level_titlt, true)
            GUI:setVisible(self.view.red_equip_need_level_titlt_node, true)
            GUI:Text_setTextColor(self.view.red_equip_need_level_titlt, "#FF3319")
            GUI:Text_setString(self.view.red_equip_need_level_titlt, "（还需  " .. tostring(need_level) .. "）")
        else
            GUI:setVisible(self.view.red_equip_need_level_titlt, false)
            GUI:setVisible(self.view.red_equip_need_level_titlt_node, false)
        end
    end
    
    GUI:ForceRebuildLayoutImmediate(self.view.equip_need_level_titlt_node)
    GUI:ForceRebuildLayoutImmediate(self.view.red_equip_need_level_titlt_node)
    local job = SL:GetEquipValue(EMetaVarGetKey.EQUIP_NEED_CAREER, self.args.equip_pos, self.args.cfgId, self.args.id)
    self.need_career = self:GetCareer(job)
    
    local useAttLimit = SL:GetConfig("cfg_item",self.args.cfgId).useItemAtt
    self.useAttLimit_list = self:GetUseAttLimit(useAttLimit)
    
    if SL:HasConfig("cfg_equip_entryLib", self.args.cfgId) then
        local useAttLv = SL:GetConfig("cfg_equip_entryLib", self.args.cfgId).useAttLv
        if not useAttLv or useAttLv == 0 then
            GUI:setVisible(self.view.att_level_titlt_node, false)
        else
            GUI:setVisible(self.view.att_level_titlt_node, true)
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
    else
        GUI:setVisible(self.view.att_level_titlt_node, false)
        GUI:setVisible(self.view.att_need_level, false)
    end
end

--获取被属性衰减过的实际生效属性
---@param attrList CommonProtos.EquipEntryAttrVo[] 幸运属性
function this:GetAttrValueOffset(attrId, attrValue, attrList)
    if not attrList then
        return 0
    end
    local specialValue = 0
    ---@type cfg_att_special_column
    local specialTbl = SL:GetConfig("cfg_att_special", tostring(attrId), "param")
    if specialTbl and specialTbl.type[1] == 21 then
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
    end
    return specialValue
end

function this:GetUseAttLimit(useAttLimit)
    local useAttLimit_list = {}
    self.useAttLimit = {}
    if useAttLimit and table.count(useAttLimit) > 0 then
        for i, v in ipairs(useAttLimit) do
            local attId = v[1]
            local attValue = v[2]
            local my_attValue = SL:MeData_GetSpecialAttrValue(attId)
            local name = SL:GetConfig("cfg_att_info", attId).name
            
            local name_str = "所需" .. name .. "： "
            local value_str = ""
            local entryAttr = SL:GetEquipValue(EMetaVarGetKey.EQUIP_ENTRY_ATTR, self.args.equip_pos, self.args.cfgId, self.args.id)
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
    end
    return useAttLimit_list
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

            str = tbl.name .. "  可以使用"
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

---创建时调用一次
function this:Init()
    if self.args.info and self.args.info.hideMask then
        GUI:setVisible(self.view.background_close, false)
    else
        GUI:setVisible(self.view.background_close, true)
    end
    --if self.args.info and self.args.info.isRight then
    --    GUI:setAnchorPoint(self.view.root, 2, 0)
    --end
    if self.args.info and self.args.info.posX then
        GUI:setPositionX(self.view.root,self.args.info.posX)
    end
    if self.args.info and self.args.info.posY then
        GUI:setPositionY(self.view.root,self.args.info.posY)
    end
    self:InitList()
    self:InitControl()
    local itemInfo = SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)
    local name = SL:GetEquipValue(EMetaVarGetKey.EQUIP_NAME, self.args.equip_pos, self.args.cfgId, self.args.id)
    self.type = SL:GetMetaValue(EMetaVarGetKey.ITEMTYPE, self.args.cfgId)
    self.subType = SL:GetMetaValue(EMetaVarGetKey.ITEMSUBTYPE, self.args.cfgId)
    
    --是否是果实
    self.isFruit = SL:HasConfig("cfg_fruit",self.args.cfgId)
    if self.isFruit then
        ---是否是从果实界面打开
        self.isFruitUI = GUI:GetUI("dev/outui/UIFruit/Panel/KLUIFruit/KLUIFruitPanel")
    end
    self.IsSdFruit = false
    local conf = InfoManager.LianJiInfo.conf
    if conf then
        local rete_item_id = SL:GetConfigMultiKeys("cfg_item", conf.addLianJi.itemName,"name").id
        local sd_item_id = SL:GetConfigMultiKeys("cfg_item", conf.addSD.itemName,"name").id
        if self.args.cfgId == rete_item_id or self.args.cfgId == sd_item_id then
            self.IsSdFruit = true
        end
    end

    self.isGemBagUI= GUI:GetUI("dev/outui/Bag/Panel/KLGemSlateBag/KLGemSlateBagPanel")
    ---@type cfg_item_column
    local itemData = SL:GetConfig("cfg_item",self.args.cfgId)
    local name_color = SL:GetConfig("cfg_item",self.args.cfgId).color
    GUI:Text_setString(self.view.item_name, name)
    
    GUI:setVisible(self.view.task_text_node,false)
    name_color = SL:GetConfig("cfg_color",name_color).color
    GUI:Text_setTextColor(self.view.item_name, tostring(name_color))
    
    
    --时间展示
    if itemData.timeStr and not string.isNullOrEmpty(itemData.timeStr) then
        GUI:setVisible(self.view.timeShow_text_node,true)
        GUI:Text_setString(self.view.timeShow_text,itemData.timeStr)
    else
        GUI:setVisible(self.view.timeShow_text_node,false)
    end
    
    --使用
    if table.isNullOrEmpty(itemData.leftButton) and table.isNullOrEmpty(itemData.rightButton)  then
        GUI:setVisible(self.view.use_text,false)
    else
        GUI:Text_setString(self.view.use_text,"可以使用")
        GUI:setVisible(self.view.use_text,true)
    end
    local showBindTips = EquipFunc.ShowBindTips(self.args.cfgId)
    --道具限制
    if itemData.recoveryGroup == 0 and self.type ~= 1 and showBindTips then
        GUI:Text_setString(self.view.shop_deal,"不能卖给商店")
        GUI:setVisible(self.view.shop_deal_node,true)
    else
        GUI:setVisible(self.view.shop_deal_node,false)
    end
    
    local equip_status = ""
    GUI:setVisible(self.view.text_deal_node,true)
    if (self.type == 1 and self.subType == 7) or not showBindTips then
        equip_status = ""
        GUI:setVisible(self.view.text_deal,false)
    else
        if EquipFunc.GetItemIsBind(self.args.cfgId, itemInfo) then
            equip_status = "<color=#ff2323>不可交易</color>"
        else
            equip_status = "可交易"
        end
         GUI:Text_setString(self.view.text_deal,equip_status)
    end
    
    local typeStr = self:GetTypeStr(self.type)
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
        GUI:setVisible(self.view.mid_text, true)
        GUI:Text_setString(self.view.mid_text, midDesc)
    end
    
    if string.isNullOrEmpty(bottomDesc) then
        GUI:setVisible(self.view.bottom_text, false)
    else
        GUI:setVisible(self.view.bottom_text, true)
        GUI:Text_setString(self.view.bottom_text, bottomDesc)
    end
    
    --叠加数量(可分配属性点不显示数量)
    if self.type == 1 and self.subType ~= 7 then
        if not self.args.info or not self.args.info.isShowAll then
            local count = SL:GetBagItemCount(self.args.cfgId, false)
            GUI:setVisible(self.view.overlyingTxt_node, true)
            GUI:Text_setString(self.view.overlyingTxt,"数量：" .. count)
            GUI:setVisible(self.view.bindOverlyingTxt_node,false)
        else
            local count = SL:GetBagItemCount(self.args.cfgId, false)
            GUI:Text_setString(self.view.overlyingTxt,"非绑定数量：" .. count )
            GUI:setVisible(self.view.overlyingTxt_node,true)
            local bindCount = SL:GetBagBindItemCount(self.args.cfgId)
            GUI:Text_setString(self.view.bindOverlyingTxt,"绑定数量：" .. bindCount )
            GUI:setVisible(self.view.bindOverlyingTxt_node, true)
            GUI:setVisible(self.view.text_deal_node,false)
        end
    else
        GUI:setVisible(self.view.overlyingTxt_node,false)
        GUI:setVisible(self.view.bindOverlyingTxt_node,false)
    end
    
    local is_show_btn = true
    if self.args.info and self.args.info.hideBtn then
        GUI:setVisible(self.view.bag_root, false)
        GUI:setVisible(self.view.item_button, false)
        is_show_btn = false
    elseif self.args.equip_pos == "bag" or self.args.equip_pos == "synthesis" then
        GUI:setVisible(self.view.bag_root, true)
        GUI:setVisible(self.view.item_button, false)
        self:bagBtnUpdate()
    elseif self.args.equip_pos == "depots" then
        GUI:setVisible(self.view.bag_root, true)
        GUI:setVisible(self.view.item_button, false)
        self:depotsBtnUpdate()
    elseif self.args.equip_pos == "gems" then
        GUI:setVisible(self.view.bag_root, true)
        GUI:setVisible(self.view.item_button, false)
        self:gemSlateInlayBtnUpdate()
    elseif self.args.equip_pos == "looptask" then
        GUI:setVisible(self.view.bag_root, true)
        GUI:setVisible(self.view.item_button, false)
        self:bagBtnUpdate()
    else
        GUI:setVisible(self.view.bag_root, false)
        GUI:setVisible(self.view.item_button, true)
        is_show_btn = false
    end
    GUI:DataListInitData(self.view.yulan_data_list,function()
        return self:yulanDataListItemCountFunc()
    end,function(realIndex)
        return self:yulanDataListItemGetFunc(realIndex)
    end,function(realIndex, kmlcontrol)
        return self:yulanDataListItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:yulanDataListItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self.All_yulan = {}
    self.yulan_all_item = {}
   
    --属性
    self.base_info = self:GetGemAtt()
    
    self:ShowUseLimit()
    --计算高度
     self:ChangeMid()
    --计算宝箱无线滚动组件的高度
    self:CalScrollViewHeight(itemData)
    self:SetTipsSize()
    self:SetTipPosition()
    
    if self.args.info and self.args.info.title then
        GUI:setVisible(self.view.title_bg, true)
        GUI:Text_setText(self.view.text_title, self.args.info.title)
    end
end

---计算宝箱无线滚动组件的高度
function this:CalScrollViewHeight(itemData)
    if itemData.boxShow == 0 then
        GUI:setVisible(self.view.yulan_content_node,false)
        return
    end
    self.All_yulan = {}
    self.yulan_all_item = {}
    local yulan_height = 0
    --自选宝箱预览
    if itemData.type == 4 and itemData.subType == 2 and not string.isNullOrEmpty(itemData.useParam) then
        --local strList = string.split(itemData.useParam,'|')
        --for ii, one_str in ipairs(strList) do
        --    local id_yulan = string.split(one_str,'#')
        --    local one_id = tonumber(id_yulan[1])
        --    table.insert( self.All_yulan,one_id)
        --end
        --local yulan_hang = math.ceil(#self.All_yulan/4)   
        --yulan_height = yulan_hang *70
        --GUI:DataListUpdateData(self.view.yulan_data_list)
        --GUI:setVisible(self.view.yulan_content,true)
        --随机宝箱预览
        GUI:setVisible(self.view.yulan_content_node,false)
    elseif itemData.type == 4 and itemData.subType == 1 and not string.isNullOrEmpty(itemData.useParam) then
        local all_tab = SL:GetConfigTable(itemData.useParam)
        for i, v in ipairs(all_tab) do
            local count =  tonumber(string.split(v.num,"#")[1]) 
            table.insert( self.All_yulan,{id = v.item ,count = count })
        end
        local yulan_hang = math.ceil(#self.All_yulan/4)
        yulan_height = yulan_hang *70
        if yulan_height >=170 then
            yulan_height = 170
        end
        local w = GUI:GetWidth(self.view.yulan_content_node)
        GUI:setContentSize(self.view.yulan_content,264,yulan_height)
        GUI:setContentSize(self.view.yulan_content_node,w,yulan_height)
        GUI:setScale(self.view.yulan_content,0.9)
        GUI:DataListUpdateData(self.view.yulan_data_list)
        GUI:setVisible(self.view.yulan_content_node,true)
        
    else
        GUI:setVisible(self.view.yulan_content_node,false)
    end
    
end

function this:SetTipsSize()
    
    GUI:DataListUpdateData(self.view.equipNeedData, true)
    GUI:DataListUpdateData(self.view.equipzhiyeNeedData, true)
    GUI:DataListUpdateData(self.view.base_info_data, true)
    
    GUI:setVisible(self.view.att_level_titlt_node, false)
    GUI:ForceRebuildLayoutImmediate(self.view.need_layout)
    GUI:ForceRebuildLayoutImmediate(self.view.career_layout)
    GUI:ForceRebuildLayoutImmediate(self.view.base_list_layout)
    GUI:ForceRebuildLayoutImmediate(self.view.yulan_content)
    GUI:ForceRebuildLayoutImmediate(self.view.view_info)
    GUI:ForceRebuildLayoutImmediate(self.view.bag_root)
    GUI:ForceRebuildLayoutImmediate(self.view.item_button)
    
    if GUI:GetHeight(self.view.career_layout) == 0 then
        GUI:setVisible(self.view.node_career_bottom,false)
        GUI:setVisible(self.view.node_career_top,false)
    end
    if (GUI:getVisible(self.view.bag_root) == false or GUI:GetHeight(self.view.bag_root) == 0) and GUI:GetHeight(self.view.item_button) == 0  then
        GUI:setVisible(self.view.btn_offset_node,false)
    end
    
    if GUI:GetHeight(self.view.view_info) == 0 then
        GUI:setVisible(self.view.view_node_offset_1,false)
        GUI:setVisible(self.view.view_node_offset_2,false)
    end
    
    if GUI:getVisible(self.view.btn_offset_node) == false then
        GUI:setVisible(self.view.node_career_bottom,false)
    end
    
    --jichu_layout需要最后一行刷新
    GUI:ForceRebuildLayoutImmediate(self.view.jichu_layout)
    local hight = GUI:GetHeight(self.view.jichu_layout)
    GUI:setContentSize(self.view.panel_bg, ETipsParameter.TipsWidth, hight + ETipsParameter.ItemTipsHightOffset)
    if self.args and self.args.info and self.args.info.previewSize then
        local _height = hight + ETipsParameter.ItemTipsHightOffset
        local previewSize = self.args.info.previewSize
        -- 需要上边界对齐
        local a = previewSize.y / 2
        local b = _height / 2
        local offest = a - b
        local y = GUI:getPositionY(self.view.panel_bg)
        GUI:setPositionY(self.view.panel_bg, y + offest)
    end
end

function this:SetTipPosition(GainHeight)
    EquipFunc.SetTipsPos(self)
    
    if GainHeight then
        local clickControl = self.clickControl or (self.args.info and self.args.info.clickControl) or InfoManager.mainUIInfo.clickControl
        self.clickControl = clickControl
        if not clickControl then
            return
        end
        -- 获取屏幕宽度
        local screenWidth = SL:GetMetaValue(EMetaVarGetKey.SCREEN_WIDTH)
    
        local tipsWidth = GUI:GetWidth(self.view.panel_bg)
        local tipsHeight = GUI:GetHeight(self.view.panel_bg)
        local maxHeight = GainHeight or tipsHeight
        local maxWidth = GainHeight  and tipsWidth * 2 or tipsWidth
        -- 计算理想位置（右侧显示）
        local x,y = GUI:GetWorldPosition(clickControl)
        local scrPoint_ = SL:ConvertWorldPos2Screen(x, y)
        -- 如果左侧空间足够，则在左侧显示
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
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.type==6 and (self.subType==14 or self.subType==13) then--变身戒指or守护皮肤
        SL:OpenEquipTips(self.args.equip_pos, self.args.cfgId, self.args.id)
        return
    end
    if self.type==9 and self.subType==1 then--圣杯
        self.args.baseUI = self
        GUI:UIPanel_Open("dev/outui/Archangel/Panel/KLArchangelGrailTips/KLArchangelGrailTipsPanel",nil,nil,self.args)
        return
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.background_close,self,self.CloseItemTips)
    GUI:AddOnClickEvent(self.view.left_btn,self,self.BtnLeftOnClick)
    GUI:AddOnClickEvent(self.view.right_btn,self,self.BtnRightOnClick)
    GUI:Input_SetOnEndEdit(self.view.Input_PutNum, self, self.OnValueChange_Input_PutNum)
    GUI:AddOnClickEvent(self.view.Btn_NumberMinus, self, self.OnClick_Btn_NumberMinus)
    GUI:AddOnClickEvent(self.view.Btn_NumberAdd, self, self.OnClick_Btn_NumberAdd)
    GUI:SetSliderOnValueChange(self.view.Slider_PutNum, self, self.OnValueChange_Slider_PutNum)
end

---输入数量改变
function this:OnValueChange_Input_PutNum(_, args, data)
    local putCount = tonumber(data[1])
    if putCount == nil then
        putCount = 1
        GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
    else
        local maxCount = self.putItem.count
        if self.args.equip_pos == "bag" then
            local costCount = SL:onTriggerEvent(LUA_EVENT_BAG_ITEM_COUNT_VIRTUAL_COST, self.putItem.id)
            if costCount and costCount > 0 then
                maxCount = maxCount - costCount
            end
        end
        if putCount > maxCount then
            putCount = maxCount
            GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
        end
        if putCount < 1 then
            putCount = 1
            GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
        end
    end
    
    GUI:Slider_setPercent(self.view.Slider_PutNum, putCount)
end

---点击数量减按钮
function this:OnClick_Btn_NumberMinus()
    local putCount = tonumber(GUI:GetInputText(self.view.Input_PutNum)) - 1
    if putCount < 1 then
        return
    end
    GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
    GUI:Slider_setPercent(self.view.Slider_PutNum, putCount)
    GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
end

---点击数量加按钮
function this:OnClick_Btn_NumberAdd()
    local putCount = tonumber(GUI:GetInputText(self.view.Input_PutNum)) + 1
    if putCount > self.putItem.count then
        return
    end
    GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
    GUI:Slider_setPercent(self.view.Slider_PutNum, putCount)
    GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
end

---放入数量滑动条改变
function this:OnValueChange_Slider_PutNum(_, args, data)
    local putCount = math.floor(data[1])
    -- SL:LogError("putCount", putCount)
    if putCount > self.putItem.count then
        putCount = self.putItem.count
    end
    GUI:SetInputText(self.view.Input_PutNum, tostring(putCount))
end

function this:CloseItemTips()
   GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTipsOther/KLIUItemTipsOtherPanel")
    local itemGetPathPanel = GUI:GetUI("dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel")
    if itemGetPathPanel then
        GUI:UIPanel_Close("dev/ui/Common/Panel/KLItemGetPath/KLItemGetPathPanel")
    end
end

function this:Close()

end


function this:bagBtnUpdate()
    local leftButton = SL:GetEquipValue(EMetaVarGetKey.EQUIP_TIPS_LEFT_BUTTON,self.args.equip_pos,self.args.cfgId,self.args.id)
    local rightButton = SL:GetEquipValue(EMetaVarGetKey.EQUIP_TIPS_RIGHT_BUTTON,self.args.equip_pos,self.args.cfgId,self.args.id)
    local isDelete = SL:GetConfig("cfg_item",self.args.cfgId).isDelete
    --合成炉只显示一个按钮
    local isSynthesis = GUI:GetUI("dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel") ~= nil
    if isSynthesis then
        leftButton = {}
        rightButton = {}
    end
    ---当是果实并且从果实界面打开时需要变成  左：使用  右：使用x个
    if self.isFruit and self.isFruitUI then
        leftButton = {}
        rightButton = {}
        if self.args.count > 0 then
            leftButton = {{"1"}}
            rightButton = {{"8"}}
        end
    end
    if self.IsSdFruit then
        leftButton = {}
        rightButton = {}
        if self.args.count > 0 then
            leftButton = {{"1"}}
            rightButton = {{"8"}}
        end
    end
    if self.isGemBagUI then
        leftButton = {}
        rightButton = {{"15"}}
    end
    
    self.left_all = {}
    self.left_all_item = {}
    for i, v in ipairs(leftButton) do
        -- for j, btn_type in ipairs(v) do
        --     if btn_type == "9" and isDelete == 0 then
        --     else
        --         table.insert(self.left_all,btn_type)
        --     end
        -- end
        local btn_type = v[1]
        if btn_type == "9" and isDelete == 0 then
        elseif btn_type == "5" and EquipFunc.GetItemIsBind(self.args.cfgId, SL:GetPosItemInfo(self.args.equip_pos, self.args.cfgId, self.args.id)) then
        else
            table.insert(self.left_all, v)
        end
    end
    self.right_all = {}
    self.right_all_item = {}
    for i, vRight in ipairs(rightButton) do
        -- for j, btn_type in ipairs(v) do
        --     if btn_type == "9" and isDelete == 0 then
        --     else
        --         table.insert(self.right_all,btn_type)
        --     end
        -- end
        local btn_type = vRight[1]
        if btn_type == "9" and isDelete == 0 then
        else
            table.insert(self.right_all, vRight)
        end
    end
    -- SL:LogTable(self.right_all,true)
    -- SL:LogTable(self.right_all[1],true)
    self.left_is_open = false
    GUI:Image_loadTexture(self.view.right_btn, "btn_tipsd", "Atlas/FG_Common.spriteatlas")
    GUI:SetImageNativeSize(self.view.right_btn)
    if self.args.info and self.args.info.isConfirmTips then
        GUI:setVisible(self.view.left_btn,false)
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.right_btn, "确认")
        return
    end
    if #self.left_all < 1 then
        ---设置成 长tips
        GUI:Image_loadTexture(self.view.right_btn, "btn_tips", "Atlas/FG_Common.spriteatlas")
        GUI:SetImageNativeSize(self.view.right_btn)
        GUI:setVisible(self.view.left_btn,false)
    elseif #self.left_all == 1 then
        GUI:setVisible(self.view.left_btn,true)
        local str = self:getBtnName(self.left_all[1])
        GUI:Button_setTitleText(self.view.left_btn,str)
    else
        GUI:setVisible(self.view.left_btn,true)
        GUI:Button_setTitleText(self.view.left_btn,"更多")
        GUI:DataListInitData(self.view.left_data_list,function()
            return self:LeftDataListItemCountFunc()
        end,function(realIndex)
            return self:LeftDataListItemGetFunc(realIndex)
        end,function(realIndex, kmlcontrol)
            return self:LeftDataListItemInitFunc(realIndex, kmlcontrol)
        end, function(realIndex, kmlcontrol)
            return self:LeftDataListItemUpdateFunc(realIndex, kmlcontrol)
        end)
    end
    self.right_is_open = false
    GUI:Image_loadTexture(self.view.left_btn, "btn_tipsd", "Atlas/FG_Common.spriteatlas")
    GUI:SetImageNativeSize(self.view.left_btn)
    if #self.right_all < 1 then
        ---设置成 长tips
        GUI:Image_loadTexture(self.view.left_btn, "btn_tips", "Atlas/FG_Common.spriteatlas")
        GUI:SetImageNativeSize(self.view.left_btn)
        GUI:setVisible(self.view.right_btn,false)
    elseif #self.right_all == 1 then
        GUI:setVisible(self.view.right_btn,true)
        local str = self:getBtnName(self.right_all[1])
        GUI:Button_setTitleText(self.view.right_btn,str)
    else
        GUI:setVisible(self.view.right_btn,true)
        GUI:Button_setTitleText(self.view.right_btn,"更多")
        GUI:DataListInitData(self.view.right_data_list,function()
            return self:RightDataListItemCountFunc()
        end,function(realIndex)
            return self:RightDataListItemGetFunc(realIndex)
        end,function(realIndex, kmlcontrol)
            return self:RightDataListItemInitFunc(realIndex, kmlcontrol)
        end, function(realIndex, kmlcontrol)
            return self:RightDataListItemUpdateFunc(realIndex, kmlcontrol)
        end)
    end
    if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.right_btn, "放入")

        if #self.left_all == 1 then
            GUI:Image_loadTexture(self.view.left_btn, "btn_tipsd", "Atlas/FG_Common.spriteatlas")
            GUI:SetImageNativeSize(self.view.left_btn)
        end

        return
    end
    ---@type KLNewSynthesisPanel
    local synthesisPanel = GUI:GetUI("dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel")
    if synthesisPanel then
        if not synthesisPanel.isPreview then -- 不处于合成预览状态
            local limitCount = synthesisPanel:GetConsumeItemLimitCount(self.args.cfgId)
            GUI:setVisible(self.view.num_select, limitCount ~= 1)
            if self.args.equip_pos == "synthesis" then
                -- SL:LogError(self.args.equip_pos,type(synthesisPanel.smelter_putItem))
                self.putItem = synthesisPanel.smelter_putItem;
                if limitCount ~= 1 then
                    GUI:Slider_setMaxPercent(self.view.Slider_PutNum, self.putItem.count)
                end
            elseif self.args.equip_pos == "bag" then
                self.putItem = SL:GetPosItemInfo(self.args.equip_pos,self.args.cfgId,self.args.id)
                local costCount = SL:onTriggerEvent(LUA_EVENT_BAG_ITEM_COUNT_VIRTUAL_COST, self.putItem.id)
                -- SL:LogError("costCount", self.putItem.count,costCount)
                if limitCount ~= 1 then
                    GUI:Slider_setMaxPercent(self.view.Slider_PutNum, (self.putItem.count - costCount))    
                end
            end
        end
        local isBind = EquipFunc.GetItemIsBind(self.args.cfgId)
        if isBind then
            GUI:setVisible(self.view.synthesisDesc, true)
        end
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.right_btn, self.args.equip_pos == "bag" and "放入" or "拿出")
        -- self.left_all = {}
        -- if #self.left_all == 1 then
        --     GUI:Image_loadTexture(self.view.left_btn, "btn_tipsd", "Atlas/FG_Common.spriteatlas")
        --     GUI:SetImageNativeSize(self.view.left_btn)
        -- end
        return
    end
    if GUI:GetUI("dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel") then
        GUI:setVisible(self.view.right_btn, true)
        GUI:Button_setTitleText(self.view.right_btn, self.args.equip_pos == "bag" and "放入" or "拿出")
        if #self.left_all == 1 then
            GUI:Image_loadTexture(self.view.left_btn, "btn_tipsd", "Atlas/FG_Common.spriteatlas")
            GUI:SetImageNativeSize(self.view.left_btn)
        end
        return
    end
    
end

function this:depotsBtnUpdate()
    GUI:setVisible(self.view.left_btn, true)
    GUI:Button_setTitleText(self.view.left_btn, "丢弃")

    GUI:setVisible(self.view.right_btn, true)
    GUI:Button_setTitleText(self.view.right_btn, "取出")

end

function this:gemSlateInlayBtnUpdate()
    GUI:setVisible(self.view.left_btn, false)

    GUI:setVisible(self.view.right_btn, true)
    GUI:Button_setTitleText(self.view.right_btn, "卸下")

end

function this:BtnLeftOnClick()
    if self.args.equip_pos == "depots" then
        local storeIndex = SL:GetDepotsIndex(self.args.id)
        SL:ReqStoreGiveUpItemMessage(storeIndex)
        self:CloseItemTips()
        return
    end
    if #self.left_all < 1 then

    elseif #self.left_all == 1 then
        local btnType = self.left_all[1][1]
        if not InfoManager.equipOrItemTipsInfo:IsCanOnClickButton(self.left_all[1]) then
            return
        end
        if btnType == "0" then
            self:CloseItemTips()
        elseif btnType == "1" then
            self:UseItem()
        elseif btnType == "2" then
            self:RecycleItem()
        elseif btnType == "9" then
            local name = SL:GetEquipValue(EMetaVarGetKey.EQUIP_NAME, self.args.equip_pos, self.args.cfgId, self.args.id)
            SL:CommonTipsMessage({   showTips = "是否摧毁"..name ,
                                     ui = self,
                                     sureBtnText = "确定",
                                     cancelBtnText = "取消",
                                     callback = self.DestroyItem
            })
        elseif btnType == "10" then
            self:JieFeng()
        elseif btnType == "11" then
            self:DiuQi()
        elseif btnType == "99" then
            self:OpenPanel(self.left_all[1])
        end
        
    else
        if not self.left_is_open then
            GUI:setVisible(self.view.left_btn_content,true)
            self.left_is_open = true
            GUI:DataListUpdateData(self.view.left_data_list)
        else
            GUI:setVisible(self.view.left_btn_content,false)
            self.left_is_open = false
        end
    end
end


function this:PutOneEquip()
    local ItemInfo = SL:GetPosItemInfo(self.args.equip_pos,self.args.cfgId,self.args.id)
    if SL:CheckEquipWear(ItemInfo) == 1 then
        SL:PutOnEquip(ItemInfo) 
    else
        SL:ShowCantEquipTip(ItemInfo)
    end 
    self:CloseItemTips()
end

function this.DestroyItem(returnData)
    local ui = returnData.ui
    local index = SL:GetBagIndex(ui.args.id)
    SL:ReqDestroyItemMessage(index)
    ui:CloseItemTips()
end

function this:JieFeng()
    self:CloseItemTips()
end

function this:DiuQi()
    local index = SL:GetBagIndex(self.args.id)
    SL:ReqGiveUpItemMessage(index)
    self:CloseItemTips()
end

function this:TakeOffEquip()
    if not self.args.id then
        return
    end
    local wearBarId, pos = SL:GetEquipWearBarIdPos(self.args.id)
    SL:TakeOffEquip(wearBarId, pos)
    self:CloseItemTips()
end

function this:ForgeOnClick()
    if not InfoManager.equipOrItemTipsInfo:IsCanOnClickButton("",10401) then
        return
    end
    self:CloseItemTips()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    SL:HideAllKmlPanel()
    SL:OpenForgeGroupUI()
end

function this:UseItem()
    if self.isFruit then--跳转到果实界面
        ---@type cfg_global_column
        local switchCfg = SL:GetConfig("cfg_global",3003)
        if SL:MeData_GetLevel() < tonumber(switchCfg.value) then
            SL:TipMessage(SL:GetConfig('cfg_string',117).text,1, NoticeType.NoticeMid )-- "等级不足！", 
            self:CloseItemTips()
            return
        end
        if self.isFruitUI then
            SL:UseItem(self.args.cfgId, self.args.id, 1)
            self:CloseItemTips()
        else
            self:CloseItemTips()
            GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
            GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
            GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTipsComparsion/KLUIEquipTipsComparsionPanel")
            GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
            GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
            SL:HideAllKmlPanel()
            GUI:UIPanel_Open("dev/ui/Role/Panel/KLAttr/KLAttrPanel",_,_,{isShowFruit = true})
        end
       
        return
    end
    if self.IsSdFruit then
        SL:SendLuaNetMsg(LuaMessageIdToSever.LianJi_MsgID, {3,1})
    end
    ---@type cfg_item_column
    local itemTbl = SL:GetConfig("cfg_item",self.args.cfgId)
    if itemTbl.type == E_ItemType.TriggerItem and itemTbl.subType == 10 and (self.args.cfgId == 60090002 or self.args.cfgId == 1269000299)  then --角色改名卡
        GUI:UIPanel_Open("dev/outui/ReName/Panel/KLRoleReName/KLRoleReNamePanel", nil, nil, {title="role_rename",des="请输入新的角色名称：",cfgId=self.args.cfgId})
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
        return
    elseif itemTbl.type == E_ItemType.TriggerItem and itemTbl.subType == 10 and (self.args.cfgId == 60090003 or self.args.cfgId == 1269000399)  then --战盟改名卡
        local isJoinUnion = SL:GetMetaValue(EMetaVarGetKey.ACTOR_HAVE_GUIDE)
        if isJoinUnion then
            GUI:UIPanel_Open("dev/outui/ReName/Panel/KLRoleReName/KLRoleReNamePanel", nil, nil, {title="rename",des="请输入新的战盟名称：",cfgId=self.args.cfgId})
            GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
        else
            SL:TipMessage("未加入战盟",1,NoticeType.NoticeMid)
        end
        return
    elseif itemTbl.type == E_ItemType.TriggerItem and itemTbl.subType == 15 then --职业转换道具
        GUI:UIPanel_Open("dev/outui/CareerSwitch/Panel/KLUICareerSwitch/KLUICareerSwitchPanel", nil, nil, self.args.cfgId)
        GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
        return
    end

    --背包石特殊处理
    if self.args.cfgId == 50040001 then
        self:forbidClick()
        return
    end

    SL:UseItem(self.args.cfgId, self.args.id, self.args.count)
    self:CloseItemTips()

    if itemTbl.type == E_ItemType.TriggerItem and itemTbl.subType == E_OutTriggerItemType.TransferRing then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
        SL:HideAllKmlPanel()

        --守护处理，跳转到外观守护界面
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel", nil, nil, E_FashionType.TransferRing)

        SL:ScheduleOnce(0.3,function()
            SL:onLUAEvent(TRANSFER_RING_SELECT_ITEM, self.args.cfgId)
        end)

    elseif itemTbl.type == E_ItemType.TriggerItem and itemTbl.subType == E_OutTriggerItemType.GuardSkin then
        GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
        SL:HideAllKmlPanel()

        --守护处理，跳转到外观守护界面
        GUI:UIPanel_Open("dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel", nil, nil, E_FashionType.Appear)
        SL:ScheduleOnce(0.3,function()
            SL:onLUAEvent(APPEAR_SELECT_ITEM, self.args.cfgId)
        end)
    end
end

---使用多个item（self.args.count的数量）
function this:UseMultipleItem()
    if self.IsSdFruit then
        SL:SendLuaNetMsg(LuaMessageIdToSever.LianJi_MsgID, {3,self.args.count})
    end
    SL:UseItem(self.args.cfgId, self.args.id, self.args.count)
    self:CloseItemTips()
end

function this:forbidClick()
    local bag_unlock_info = SL:GetConfig('cfg_global', 107).value
    local bag_unlock_split = string.split(bag_unlock_info, '#')
    local itemId = tonumber(bag_unlock_split[1])
    local needCount = tonumber(bag_unlock_split[2])
    SL:CommonTipsMessage({ stringTblID = 207,
                           ui = self, cfgId = itemId, needCount = needCount, callback = self.UnlockGrid, callbackData = nil })
    --GUI:UIPanel_Open("dev/ui/Common/Panel/KLCommonItemTips/KLCommonItemTipsPanel", nil, nil, { showTips = string.format("是否消耗%s扩充背包空间？", "背包石"), ui = self, cfgId = itemId, needCount = needCount, callback = self.UnlockGrid, callbackData = nil })
    self:CloseItemTips()
end

function this:UnlockGrid()
    SL:ReqBagAddCapacityMessage(1)
end

function this:getBtnName(data)
    local btn_type = data[1]
    --SL:LogTable(data,true)
    if btn_type == "0" then
        return "取消"
    elseif btn_type == "1" then
        if GUI:GetUI("dev/ui/Bag/Panel/KLDepots/KLDepotsPanel") then
            return "放置"
        else
            return "使用"
        end
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
        if self.IsSdFruit then
            return "使用"..self.args.count.."个"
        end
        if self.isFruitUI and self.isFruit then
            return "使用"..self.args.count.."个"
        end
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
    elseif btn_type == "15" then
        return "镶嵌"
    elseif btn_type == "16" then
        return "卸下"
    elseif btn_type == "99" then
        return data[2]
    end
    return ""
end


function this:LeftDataListItemCountFunc()
    return #self.left_all
end

function this:LeftDataListItemGetFunc(realIndex)
    local data = self.left_all[realIndex + 1]
    local str = self:getBtnName(data)
    local message = {equip_pos=self.args.equip_pos,cfgId=self.args.cfgId,id=self.args.id,btnType=data,nameStr=str}
    local item = GUI:UIPanel_Open("dev/ui/Tips/Item/KLUITips/KLTipBtntem",self.view.left_data_list,self,message,true)
    self.left_all_item[item.view.root] = item
    return item.view.root
end

function this:LeftDataListItemInitFunc(realIndex, kmlcontrol)
    
end

function this:LeftDataListItemUpdateFunc(realIndex, kmlcontrol)
end


function this:BtnRightOnClick()
    if self.args.info and self.args.info.isConfirmTips then
        self:CloseItemTips()
        return
    end
    if self.args.equip_pos == "depots" then
        local storeIndex = SL:GetDepotsIndex(self.args.id)
        SL.Equip:ReqStoreTakeButtonMessage(storeIndex)
        self:CloseItemTips()
        return
    end
    if self.args.equip_pos == "gems" then
        InfoManager.gemSlateInfo:ReqUnloadGem()
        self:CloseItemTips()
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
        self:CloseItemTips()
        return
    end
    -- 合成
    local synthesisPanel = GUI:GetUI("dev/outui/Synthesis/Panel/KLNewSynthesis/KLNewSynthesisPanel")
    if synthesisPanel then
        local putCount = tonumber(GUI:GetInputText(self.view.Input_PutNum)) or 1
        if self.args.equip_pos == "synthesis" then
            -- SL:LogError("SmelterToBagItem_Out", self.args.id, putCount)
            synthesisPanel:SmelterToBagItem_Out(self.args.id,putCount)
        else
            synthesisPanel:BagToSmelterItem_Out(self.args.id, self.args.cfgId, putCount)
        end
        self:CloseItemTips()
        return
    end
    local taskLoopPanel = GUI:GetUI("dev/outui/Task/Panel/KLTaskLoop/KLTaskLoopPanel")
    if taskLoopPanel then
        if self.args.equip_pos == "looptask" then
            taskLoopPanel:SmelterToBagItem_Out(self.args.id)
        else
            taskLoopPanel:BagToSmelterItem_Out(self.args.id, self.args.cfgId)
        end
        self:CloseItemTips()
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
            self:RecycleItem()
        elseif btnType == "9" then
            local name = SL:GetConfig("cfg_item",self.args.cfgId).name
            SL:CommonTipsMessage({   showTips = "是否摧毁"..name ,
                                     ui = self,
                                     sureBtnText = "确定",
                                     cancelBtnText = "取消",
                                     callback = self.DestroyItem
            })
        elseif btnType == "8" then
            self:UseMultipleItem()
        elseif btnType == "10" then
            self:JieFeng()
        elseif btnType == "11" then
            self:DiuQi()
        elseif btnType == "15" then
            self:InlayGem()
        elseif btnType == "99" then
            self:OpenPanel(self.right_all[1])
        end

    else
        if not self.right_is_open then
            GUI:setVisible(self.view.right_btn_content,true)
            self.right_is_open = true
            GUI:DataListUpdateData(self.view.right_data_list)
        else
            GUI:setVisible(self.view.right_btn_content,false)
            self.right_is_open = false
        end
    end
end

function this:RecycleItem()
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    SL:HideAllKmlPanel()
    GUI:UIPanel_Open("dev/ui/Recover/Panel/KLRecover/KLRecoverPanel")
    self:CloseItemTips()
end

function this:OpenPanel(btnType)
    if #btnType < 3 then
        return
    end
    self:CloseItemTips()
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    GUI:UIPanel_Close("dev/ui/Equip/Panel/KLEquipUI/KLEquipUIPanel")
    SL:HideAllKmlPanel()
    local panel = btnType[4]
    if #btnType == 4 then
        GUI:UIPanel_Open(panel)
    elseif #btnType == 5 then
        local num  = btnType[5]
        if tonumber(num) then
            num = tonumber(num)
        end
        GUI:UIPanel_Open(panel,nil,nil,num)
    elseif #btnType >=7 then
        local message = {}
        for i=5,#btnType-2,3 do
            if btnType[i] and btnType[i+1] and btnType[i+2] then
                if btnType[i+1] == "string" then
                    message[btnType[i]] = btnType[i+2]
                else
                    message[btnType[i]] = tonumber(btnType[i+2])
                end
            end
        end
        GUI:UIPanel_Open(panel,nil,nil,message)
    end
    SL.HideMainPanel()

end

function this:RightDataListItemCountFunc()
    return #self.right_all
end

function this:RightDataListItemGetFunc(realIndex)
    local data = self.right_all[realIndex + 1]
    local str = self:getBtnName(data)
    local message = {equip_pos=self.args.equip_pos,cfgId=self.args.cfgId,id=self.args.id,btnType=data,nameStr=str}
    local item = GUI:UIPanel_Open("dev/ui/Tips/Item/KLUITips/KLTipBtntem",self.view.right_data_list,self,message,true)
    self.right_all_item[item.view.root] = item
    return item.view.root
end

function this:RightDataListItemInitFunc(realIndex, kmlcontrol)
    
end

function this:RightDataListItemUpdateFunc(realIndex, kmlcontrol)
end

function this:GetTypeStr(type)
    if type == 1 then
        return "货币"
    elseif type == 2 then
        return "装备"
    elseif type == 3 then
        return "消耗品"
    elseif type == 4 then
        return "宝箱"
    elseif type == 5 then
        return "材料"
    elseif type == 6 then
        return "道具"
    end
    return ""
end

function this:InlayGem()
    InfoManager.gemSlateInfo:ReqInlayGem(self.args.cfgId, self.args.id)
    self:CloseItemTips()
end

----自选宝箱预览
function this:yulanDataListItemCountFunc()
    return #self.All_yulan
end

function this:yulanDataListItemGetFunc(realIndex)
    local item = GUI:UIPanel_Open("dev/ui/Tips/Item/KLUIItemPreviewItem/KLUIItemPreviewItem",self.view.yulan_data_list,self,{},true)
    self.yulan_all_item[item.view.root] = item
    return item.view.root
end

function this:yulanDataListItemInitFunc(realIndex, kmlcontrol)
end

function this:yulanDataListItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.All_yulan[realIndex + 1]
    self.yulan_all_item[kmlcontrol]:RefreshItem({cfgId=data.id,count =data.count,equip_pos=self.args.equip_pos},self.select_Secret_level,self)
end

----------萤石属性-----------start----------------------------------------------------------------

function this:GetGemAtt()
    local all_gem_att = {}
    if SL:HasConfig("cfg_equip_gem", self.args.cfgId) then
        local tab = SL:GetConfig("cfg_equip_gem", self.args.cfgId)
        for i, att in ipairs(tab.gemAtt) do
            local target_index = nil
            for j = 1, #all_gem_att, 1 do
                if all_gem_att[j].type == att[1] then
                    target_index = j
                end
            end
            if target_index then
                local tar_value = all_gem_att[target_index].num
                tar_value = tar_value + att[2]
                all_gem_att[target_index].num = tar_value
            else
                table.insert(all_gem_att, { type = att[1], num = att[2] , color= "#7CA7FF" })
            end
        end
        
        GUI:setVisible(self.view.text_gem_node,true)
        GUI:Text_setText(self.view.text_gem,"属性：" .. EElement[tab.gemBelong[1]])
    else
        GUI:setVisible(self.view.text_gem_node,false)
    end
    
    return self:GetBaseAttr(all_gem_att)
end

function this:GetBaseAttr(baseAttr, connectSign)
    local baseAttrList = EquipFunc.GetBaseAttr(baseAttr, self.args.equip_pos, self.args.cfgId, self.args.id, connectSign)
    return baseAttrList
end
    
return this
