---@class KLAttrPanel:UIKmlLuaPanelBase
---@field view KLAttrPanelView
local KLAttrPanel = class(UIKmlLuaPanelBase)
local this = KLAttrPanel
---创建时调用一次
function KLAttrPanel:Init()
    self.freePoint = SL:GetMetaValue("REMAIN_ATTR_POINT") or 0
    self.add_strength = 0
    self.add_agility = 0
    self.add_intelligence = 0
    self.add_spirit = 0
    self.add_lead = 0
    self.calcShowPoint = SL:GetConfig('cfg_global', 270) and tonumber(SL:GetConfig('cfg_global', 270).value) or 20

    --cfg_att_info_post.InitOnUse()
    self:InitFirstAttr()
    self.strength_item = {}
    self.agility_item = {}
    self.intelligence_item = {}
    self.spirit_item = {}
    self.lead_item = {}
    self.special_item = {}
    self:InitSecondAttr()

    self.attrNameTempList = {
        [1] = "攻击力（率）",
        [2] = "魔法攻击力 ",
        [3] = "诅咒攻击力 ",
    }
    -- 这个布局在webgl平台下会不正常，这里单独设置下
    --[[    if SL:GetIsWebGL() then
            local attrEffectRect = GUI:GetRectTransform(self.view.AttrEffect)
            attrEffectRect.sizeDelta = Vector2.New(attrEffectRect.sizeDelta.x, -44)
        end]]
    GUI:setContentSize(self.view.attrInfo_1, 375, 40)
    GUI:setContentSize(self.view.attrInfo_2, 375, 40)
    GUI:setContentSize(self.view.attrInfo_3, 375, 40)
    GUI:setContentSize(self.view.attrInfo_4, 375, 40)
    GUI:setContentSize(self.view.attrInfo_5, 375, 40)

    GUI:Image_setGrey(self.view.attrCloseButton, true)
    -- GUI:Image_setGrey(self.view.CloseButton,true)
    --GUI:SetActive(self.view.resetPointButton,false)
    GUI:SetActive(self.view.attrCloseButton, false)

    GUI:SetZIndex(self.view.AttrEffect, 201)


    self.LightList = {
        self.view.plusButton_a_Light,
        self.view.plusButton_i_Light,
        self.view.plusButton_d_Light,
        self.view.plusButton_s_Light,
        self.view.plusButton_c_Light,
    }
    self.animList = {}
    local speed = tonumber(SL:GetConfig("cfg_global",820001).value)
    for i=1,5,1 do
        self.animList[i] = GUI:DOAlphaImage(self.LightList[i],0,speed)
        GUI:TweenSetLoops( self.animList[i] ,-1)
        GUI:TweenSetEase( self.animList[i] ,ELeanTweenType.pingPong)
    end
end

function this:InitFirstAttr()
    local cfgTable = SL:GetConfigTable("cfg_att_info")

    for k, v in pairs(cfgTable) do
        if v.base == 1 then
            local isShow = this.CheckSpecialAttrIdIsShow(v.id)
            if v.id == EMUCharacterAttrType.strength then
                GUI:setVisible(self.view.attInfoContent_dc, isShow)
            elseif v.id == EMUCharacterAttrType.agility then
                GUI:setVisible(self.view.attInfoContent_agility, isShow)
            elseif v.id == EMUCharacterAttrType.lead then
                GUI:setVisible(self.view.attInfoContent_command, isShow)
            elseif v.id == EMUCharacterAttrType.intelligence then
                GUI:setVisible(self.view.attInfoContent_intelligence, isShow)
            elseif v.id == EMUCharacterAttrType.spirit then
                GUI:setVisible(self.view.attInfoContent_stamina, isShow)
            end
        end
    end
end

function this:InitSecondAttr()

    local secondAttrTbl = this.GetBaseTwoAttrById(EMUCharacterAttrType.strength)
    for _, second_info in pairs(secondAttrTbl) do
        ---最大攻击力和攻击率合成一条
        if second_info.id ~= EMUCharacterAttrType.maxDC and second_info.id ~= EMUCharacterAttrType.maxMC and second_info.id ~= EFGCharacterAttrType.hitRate and second_info.id ~= EFGCharacterAttrType.missRate then
            table.insert(self.strength_item, second_info.id)
        end
    end
    table.insert(self.strength_item, 0)
    GUI:DataListInitData(self.view.attInfoContent_dc_content, function()
        return self:DataListDcItemCountFunc()
    end, function(realIndex)
        return self:DataListDcItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListDcItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListDcItemUpdateFunc(realIndex, kmlcontrol)
    end)

    secondAttrTbl = this.GetBaseTwoAttrById(EMUCharacterAttrType.agility)
    for _, second_info in pairs(secondAttrTbl) do
        if second_info.id ~= EMUCharacterAttrType.maxDC and second_info.id ~= EMUCharacterAttrType.maxMC and second_info.id ~= EFGCharacterAttrType.hitRate and second_info.id ~= EFGCharacterAttrType.missRate then
            table.insert(self.agility_item, second_info.id)
        end
    end
    table.insert(self.agility_item, 0)
    GUI:DataListInitData(self.view.attInfoContent_agility_content, function()
        return self:DataListAgItemCountFunc()
    end, function(realIndex)
        return self:DataListAgItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListAgItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListAgItemUpdateFunc(realIndex, kmlcontrol)
    end)

    ---体力
    secondAttrTbl = this.GetBaseTwoAttrById(EMUCharacterAttrType.spirit)
    for _, second_info in pairs(secondAttrTbl) do
        if second_info.id ~= EMUCharacterAttrType.maxDC and second_info.id ~= EMUCharacterAttrType.maxMC and second_info.id ~= EFGCharacterAttrType.hitRate and second_info.id ~= EFGCharacterAttrType.missRate then
            table.insert(self.spirit_item, second_info.id)
        end
    end
    table.insert(self.spirit_item, 0)
    GUI:DataListInitData(self.view.attInfoContent_intelligence_content, function()
        return self:DataListStItemCountFunc()
    end, function(realIndex)
        return self:DataListStItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListStItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListStItemUpdateFunc(realIndex, kmlcontrol)
    end)
    ---智力
    secondAttrTbl = this.GetBaseTwoAttrById(EMUCharacterAttrType.intelligence)
    for _, second_info in pairs(secondAttrTbl) do
        if second_info.id ~= EMUCharacterAttrType.maxDC and second_info.id ~= EMUCharacterAttrType.maxMC and second_info.id ~= EMUCharacterAttrType.maxMC and second_info.id ~= EMUCharacterAttrType.maxZuZhou and second_info.id ~= EFGCharacterAttrType.hitRate and second_info.id ~= EFGCharacterAttrType.missRate then
            table.insert(self.intelligence_item, second_info.id)
        end
    end
    table.insert(self.intelligence_item, 0)
    GUI:DataListInitData(self.view.attInfoContent_stamina_content, function()
        return self:DataListInItemCountFunc()
    end, function(realIndex)
        return self:DataListInItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListInItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListInItemUpdateFunc(realIndex, kmlcontrol)
    end)

    secondAttrTbl = this.GetBaseTwoAttrById(EMUCharacterAttrType.lead)
    for _, second_info in pairs(secondAttrTbl) do
        if second_info.id ~= EMUCharacterAttrType.maxDC and second_info.id ~= EMUCharacterAttrType.maxMC and second_info.id ~= EFGCharacterAttrType.hitRate and second_info.id ~= EFGCharacterAttrType.missRate then
            table.insert(self.lead_item, second_info.id)
        end
    end
    table.insert(self.lead_item, 0)
    GUI:DataListInitData(self.view.attInfoContent_command_content, function()
        return self:DataListLeItemCountFunc()
    end, function(realIndex)
        return self:DataListLeItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListLeItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListLeItemUpdateFunc(realIndex, kmlcontrol)
    end)


end

function this.GetRightTwoAttr()
    local secondAttrTbl = {}
    local cfgTable = SL:GetConfigTable('cfg_att_info')

    for k, v in pairs(cfgTable) do
        if v.base == 3 or v.base == 5 or v.id == EFGCharacterAttrType.pvpattackRate or v.id == EFGCharacterAttrType.eraRate then
            local isShow = this.CheckSpecialAttrIdIsShow(v.id)
            if isShow then
                table.insert(secondAttrTbl, v)
            end
        end
    end

    -- 同级属性排列顺序读表cfg_att_info的sort字段
    table.sort(secondAttrTbl, function(a, b)
        return a.sort < b.sort
    end)
    return secondAttrTbl
end

function this.GetBaseTwoAttrById(id)
    local attInfo = SL:GetConfig('cfg_att_info', id)
    local attributeName = attInfo.attribute
    local showSecondAttrTbl = {}
    --for _, baseTwoInfo in pairs(cfg_att_info_post.cfgBaseTbl[2]) do
    for _, baseTwoInfo in pairs(SL:CfgAttInfoPost_GetCfgBaseTbl()[2]) do
        if this.CheckSpecialAttrIdIsShow(baseTwoInfo.id) then
            local baseTwoName = baseTwoInfo.attribute

            ---@type cfg_att_conversion_column
            --local conversionInfo = MeData.GetAttConversionInfoByCareer(SL:MeData_GetCareer())[baseTwoName]
            local conversionInfo = SL.RoleAtt:GetAttConversionInfoByCareer(SL:MeData_GetCareer())[baseTwoName]
            -- 如果该1级属性加点后会影响该2级属性， 则表示它们是关联的， 需要显示在一级属性下面
            --if conversionInfo ~= nil and conversionInfo[attributeName] ~= 0 then
            if conversionInfo then
                if conversionInfo.display == id then

                    -- 该1级属性影响到的2级属性， 先放table里， 后面还要按sort排序显示出来
                    table.insert(showSecondAttrTbl, baseTwoInfo)
                end
            end
        end
    end
    table.sort(showSecondAttrTbl, function(a, b)
        return a.sort < b.sort
    end)
    return showSecondAttrTbl
end

function this.CheckSpecialAttrIdIsShow(attrId)
    local cfgInfo = SL:GetConfig("cfg_att_info", attrId)

    if cfgInfo == nil then
        logError("cfg_att_info id:" .. attrId .. "not exist!!!")
        return false
    else
        local isShow = cfgInfo.isshow

        if isShow[1] == 0 then
            return false
        elseif isShow[1] == 1 then
            return true
        elseif isShow[1] == 2 then
            for index = 2, #isShow do
                local baseCareer = isShow[index]
                if baseCareer == SL:MeData_GetCareer().baseCareer then
                    return true
                end
            end
            return false
        end
    end
end

function this:DataListDcItemCountFunc()
    return table.count(self.strength_item)
end

function this:DataListDcItemGetFunc(realIndex)

end

function this:DataListDcItemInitFunc(realIndex, kmlcontrol)
    --local strength_info = GUI:GetChildControl(self.view.attInfoContent_dc_content,realIndex,'strength_info')
    --GUI:Text_setString(strength_info,"攻击力：100~1000")
end

function this:DataListDcItemUpdateFunc(realIndex, kmlcontrol)
    local strength_info = GUI:GetChildControl(self.view.attInfoContent_dc_content, realIndex, 'strength_info')
    local strength_add = GUI:GetChildControl(self.view.attInfoContent_dc_content, realIndex, 'dc_add')
    local panel_703 = GUI:GetChildControl(self.view.attInfoContent_dc_content, realIndex, 'panel_703')
    local attr_id = self.strength_item[realIndex + 1]
    -- GUI:Text_enableOutline(strength_info, "#000000",1)
    if attr_id == 0 then
        GUI:Text_setString(strength_info,"")
        GUI:Text_setString(strength_add, "")
        GUI:setContentSize(panel_703,15,8)
    else
        local attrName, attrValue, attrAddText = self:getAttrAddTextByAttrId(attr_id)
        GUI:Text_setString(strength_info, string.format("%s：%s", attrName, attrValue))
        GUI:Text_setString(strength_add, string.format("%s", attrAddText))
    end

end

--敏捷
function this:DataListAgItemCountFunc()
    return table.count(self.agility_item)
end

function this:DataListAgItemGetFunc(realIndex)

end

function this:DataListAgItemInitFunc(realIndex, kmlcontrol)
    --local strength_info = GUI:GetChildControl(self.view.attInfoContent_dc_content,realIndex,'strength_info')
    --GUI:Text_setString(strength_info,"攻击力：100~1000")
end

function this:DataListAgItemUpdateFunc(realIndex, kmlcontrol)
    local ag_info = GUI:GetChildControl(self.view.attInfoContent_agility_content, realIndex, 'ag_info')
    --local strength_info_text = GUI:GetChildControl(self.view.attInfoContent_agility_content,realIndex,'ag_info_text')
    local ag_add = GUI:GetChildControl(self.view.attInfoContent_agility_content, realIndex, 'ag_add')
    local panel_711 = GUI:GetChildControl(self.view.attInfoContent_agility_content, realIndex, 'panel_711')
    local attr_id = self.agility_item[realIndex + 1]
    -- GUI:Text_enableOutline(ag_info, "#000000",1)
    if attr_id == 0 then
        GUI:Text_setString(ag_info,"")
        GUI:Text_setString(ag_add, "")
        GUI:setContentSize(panel_711,15,8)
    else
        local attrName, attrValue, attrAddText = self:getAttrAddTextByAttrId(attr_id)
        GUI:Text_setString(ag_info, string.format("%s：%s", attrName, attrValue))
        GUI:Text_setString(ag_add, string.format("%s", attrAddText))
    end
    

end

-- 智力
function this:DataListInItemCountFunc()
    return table.count(self.intelligence_item)
end

function this:DataListInItemGetFunc(realIndex)

end

function this:DataListInItemInitFunc(realIndex, kmlcontrol)
    --local strength_info = GUI:GetChildControl(self.view.attInfoContent_dc_content,realIndex,'strength_info')
    --GUI:Text_setString(strength_info,"攻击力：100~1000")
end

function this:DataListInItemUpdateFunc(realIndex, kmlcontrol)
    local strength_info = GUI:GetChildControl(self.view.attInfoContent_stamina_content, realIndex, 'st_info')
    local in_add = GUI:GetChildControl(self.view.attInfoContent_stamina_content, realIndex, 'st_add')
    local panel_719 = GUI:GetChildControl(self.view.attInfoContent_stamina_content, realIndex, 'panel_727')
    local attr_id = self.intelligence_item[realIndex + 1]
    -- GUI:Text_enableOutline(strength_info, "#000000",1)
    if attr_id == 0 then
        GUI:Text_setString(strength_info,"")
        GUI:Text_setString(in_add, "")
        GUI:setContentSize(panel_719,15,8)
    else
        local attrName, attrValue, attrAddText = self:getAttrAddTextByAttrId(attr_id)
        GUI:Text_setString(strength_info, string.format("%s：%s", attrName, attrValue))
        GUI:Text_setString(in_add, string.format("%s", attrAddText))
    end

end

-- 体力
function this:DataListStItemCountFunc()
    return table.count(self.spirit_item)
end

function this:DataListStItemGetFunc(realIndex)

end

function this:DataListStItemInitFunc(realIndex, kmlcontrol)
    --local strength_info = GUI:GetChildControl(self.view.attInfoContent_dc_content,realIndex,'strength_info')
    --GUI:Text_setString(strength_info,"攻击力：100~1000")
end

function this:DataListStItemUpdateFunc(realIndex, kmlcontrol)
    local strength_info = GUI:GetChildControl(self.view.attInfoContent_intelligence_content, realIndex, 'in_info')
    local st_add = GUI:GetChildControl(self.view.attInfoContent_intelligence_content, realIndex, 'in_add')
    local panel_727 = GUI:GetChildControl(self.view.attInfoContent_intelligence_content, realIndex, 'panel_719')
    local attr_id = self.spirit_item[realIndex + 1]
    -- GUI:Text_enableOutline(strength_info, "#000000",1)
    if attr_id == 0 then
        GUI:Text_setString(strength_info,"")
        GUI:Text_setString(st_add, "")
        GUI:setContentSize(panel_727,15,8)
    else
        local attrName, attrValue, attrAddText = self:getAttrAddTextByAttrId(attr_id)
        GUI:Text_setString(strength_info, string.format("%s：%s", attrName, attrValue))
        GUI:Text_setString(st_add, string.format("%s", attrAddText))
    end

end

-- 统帅
function this:DataListLeItemCountFunc()
    return table.count(self.lead_item)
end

function this:DataListLeItemGetFunc(realIndex)

end

function this:DataListLeItemInitFunc(realIndex, kmlcontrol)
    --local strength_info = GUI:GetChildControl(self.view.attInfoContent_dc_content,realIndex,'strength_info')
    --GUI:Text_setString(strength_info,"攻击力：100~1000")
end

function this:DataListLeItemUpdateFunc(realIndex, kmlcontrol)
    local strength_info = GUI:GetChildControl(self.view.attInfoContent_command_content, realIndex, 'le_info')
    local le_add = GUI:GetChildControl(self.view.attInfoContent_command_content, realIndex, 'le_add')
    local panel_735 = GUI:GetChildControl(self.view.attInfoContent_command_content, realIndex, 'panel_735')
    local attr_id = self.lead_item[realIndex + 1]
    -- GUI:Text_enableOutline(strength_info, "#000000",1)
    if attr_id == 0 then
        GUI:Text_setString(strength_info,"")
        GUI:Text_setString(le_add, "")
        GUI:setContentSize(panel_735,15,8)
    else
        local attrName, attrValue, attrAddText = self:getAttrAddTextByAttrId(attr_id)
        GUI:Text_setString(strength_info, string.format("%s：%s", attrName, attrValue))
        GUI:Text_setString(le_add, string.format("%s", attrAddText))
    end

end

-- 特殊
function this:DataListSpItemCountFunc()
    return table.count(self.special_item)
end

function this:DataListSpItemGetFunc(realIndex)

end
function this:getAttrAddTextByAttrId(attr_id)
    local attrName
    local attrValue
    local attrAddText = ""
    local attrAddValue
    if attr_id == EMUCharacterAttrType.minDC then
        attrName = self.attrNameTempList[1]
        attrValue = string.format("%s~%s（%s）", SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.minDC), SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.maxDC), SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EFGCharacterAttrType.hitRate))
        local minValue = self:GetSpecialAttrAdd(EMUCharacterAttrType.minDC)
        local maxValue = self:GetSpecialAttrAdd(EMUCharacterAttrType.maxDC)
        local hitRateValue = self:GetSpecialAttrAdd(EFGCharacterAttrType.hitRate)
        --[[        if minValue > 0 or maxValue > 0 or hitRateValue > 0 then
                    attrAddText = string.format("+ %s ~ %s（%s）", minValue, maxValue,hitRateValue)
                end]]
    elseif attr_id == EFGCharacterAttrType.maxHp then
        attrName = SL:GetConfig('cfg_att_info', attr_id).showname .. "（HP）"
        attrValue = string.format("%s/%s", SL:GetMetaValue("HP"), SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EFGCharacterAttrType.maxHp))
        local Hp = SL:GetMetaValue("HP")
        local MaxHp = self:GetSpecialAttrAdd(EFGCharacterAttrType.maxHp)
        --[[        if MaxHp > 0 then
                    attrAddText = string.format("+ %s/%s",Hp, MaxHp)
                end]]
    elseif attr_id == EFGCharacterAttrType.maxMp then
        attrName = SL:GetConfig('cfg_att_info', attr_id).showname .. "（MP）"
        attrValue = string.format("%s/%s", SL:GetMetaValue("MP"), SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EFGCharacterAttrType.maxMp))
        local MP = SL:GetMetaValue("MP")
        local maxMp = self:GetSpecialAttrAdd(EFGCharacterAttrType.maxMp)
        --[[        if maxMp > 0 then
                    attrAddText = string.format("+ %s/%s",MP, maxMp)
                end]]

    elseif attr_id == EFGCharacterAttrType.armor then
        attrName = SL:GetConfig('cfg_att_info', attr_id).showname .. "（率）"
        attrValue = string.format("%s（%s）", SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EFGCharacterAttrType.armor), SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EFGCharacterAttrType.missRate))
        local minValue = self:GetSpecialAttrAdd(EFGCharacterAttrType.armor)
        local missRateValue = self:GetSpecialAttrAdd(EFGCharacterAttrType.missRate)
        --[[        if minValue > 0 or missRateValue > 0 then
                    attrAddText = string.format("+ %s（%s）",minValue, missRateValue)
                end]]
    elseif attr_id == EMUCharacterAttrType.minMC then
        attrName = self.attrNameTempList[2]
        attrValue = string.format("%s~%s", SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.minMC), SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.maxMC))
        local minValue = self:GetSpecialAttrAdd(EMUCharacterAttrType.minMC)
        local maxValue = self:GetSpecialAttrAdd(EMUCharacterAttrType.maxMC)
        --[[        if minValue > 0 or maxValue > 0 then
                    attrAddText = string.format("+ %s ~ %s",minValue, maxValue)
                end]]
    elseif attr_id == EMUCharacterAttrType.minZuZhou then
        attrName = self.attrNameTempList[3]
        attrValue = string.format("%s~%s", SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.minZuZhou), SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.maxZuZhou))
        local minValue = self:GetSpecialAttrAdd(EMUCharacterAttrType.minZuZhou)
        local maxValue = self:GetSpecialAttrAdd(EMUCharacterAttrType.maxZuZhou)
        --[[        if minValue > 0 or maxValue > 0 then
                    attrAddText = string.format("+ %s ~ %s",minValue, maxValue)
                end]]
    else
        attrName = SL:GetConfig('cfg_att_info', attr_id).showname
        local attrRemark = SL:GetConfig('cfg_att_info', attr_id).remarks
        if attrRemark == EAttrRemarkType.Number then
            attrValue = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", attr_id)
            attrAddValue = self:GetSpecialAttrAdd(attr_id)
            --[[            if attrAddValue > 0 then
                            attrAddText = string.format("+%s", attrAddValue)
                        end]]
        else
            attrValue = string.format("%0.2f%%", SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", attr_id) / 100)
            attrAddValue = self:GetSpecialAttrAdd(attr_id)
            --[[            if attrAddValue > 0 then
                            attrAddText = string.format("+%s%%", self:GetSpecialAttrAdd(attr_id))
                        end]]
        end
    end

    return attrName, attrValue, attrAddText
end
function this:DataListSpItemInitFunc(realIndex, kmlcontrol)
    --local strength_info = GUI:GetChildControl(self.view.attInfoContent_dc_content,realIndex,'strength_info')
    --GUI:Text_setString(strength_info,"攻击力：100~1000")
end

function this:DataListSpItemUpdateFunc(realIndex, kmlcontrol)

    local strength_panel = GUI:GetChildControl(self.view.attr_data_list, realIndex, 'special_panel')
    local strength_info = GUI:GetChildControl(self.view.attr_data_list, realIndex, 'special_attr_name')
    local strength_value = GUI:GetChildControl(self.view.attr_data_list, realIndex, 'special_value')
    local attr_id = self.special_item[realIndex + 1]
    local attrName = SL:GetConfig('cfg_att_info', attr_id).name
    local attrRemark = SL:GetConfig('cfg_att_info', attr_id).remarks
    local attrValue = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", attr_id)

    if attrValue == nil or attrValue == 0 then
        GUI:setVisible(strength_panel, false)
        return
    end
    GUI:setVisible(strength_panel, true)

    if attrRemark == EAttrRemarkType.Dimi then
        attrValue = string.format("%0.2f%%", SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", attr_id) / 100)
    end

    GUI:Text_setString(strength_info, attrName)
    GUI:Text_setString(strength_value, tostring(attrValue))
end

function this:RefreshRightAttr()
    self.special_item = {}
    local secondAttrTbl = this.GetRightTwoAttr()
    for _, second_info in pairs(secondAttrTbl) do
        local attrValue = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", second_info.id)
        if attrValue ~= nil and attrValue ~= 0 then
            table.insert(self.special_item, second_info.id)
        end

    end
    GUI:DataListInitData(self.view.attr_data_list, function()
        return self:DataListSpItemCountFunc()
    end, function(realIndex)
        return self:DataListSpItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:DataListSpItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListSpItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.attr_data_list)
end
---创建或者刷新界面数据时调用
function KLAttrPanel:Refresh()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_ROLE_ATT_ADD_WAY)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_ROLE_ATTR_POINT_PROGRAMME)
    --GUI:DataListUpdateData(self.view.attInfoContent_dc_content)
    --GUI:DataListUpdateData(self.view.attInfoContent_intelligence_content)
    --GUI:DataListUpdateData(self.view.attInfoContent_command_content)
    --GUI:DataListUpdateData(self.view.attInfoContent_stamina_content)
    --GUI:DataListUpdateData(self.view.attInfoContent_agility_content)
    self:RefreshRightAttr()
    --设置名字
    GUI:Text_setString(self.view.name, SL:GetMetaValue(EMetaVarGetKey.USER_NAME))

    --设置职业
    --local careerId = cfg_career_post.Get_cfg_career_id(SL:MeData_GetCareer())
    local careerId = SL:CfgCareerPost_GetCfgCareerId(SL:MeData_GetCareer())
    --local careerName = cfg_career_post.Get_cfg_career_name(careerId) or "未定义职业"
    local careerName = SL:CfgCareerPost_GetCfgCareerName(careerId) or "未定义职业"
    local serverName = SL:GetCurServerName()
    GUI:Text_setString(self.view.regionAndCareer, string.format("[%s-%s]", serverName, careerName))

    --等级
    local level = SL:MeData_GetLevel()
    GUI:Text_setString(self.view.levelText, "等级：" .. level)

    --剩余点数
    self:SetFreePoint()

    --经验
    self:RefreshExpText()

    --力量等属性
    self:SetAddNumInfo()

    self:SetAddSubBtnState()

    self:ShowFruitButton()
    self:ShowFruitPanel(self.args and self.args.isShowFruit)

    SL.HideMainPanel()

    self:SetFreeSwitchAttrPoint(true)
end

function this:SetFreeSwitchAttrPoint(isShow)
    if isShow then
        GUI:setVisible(self.view.btn_exchange_point, PrivilegeCardManager.GetFreeSwitchAttrPoint())
    else
        GUI:setVisible(self.view.btn_exchange_point, false)
    end
end

function this:ShowFruitButton()
    ---@type cfg_global_column
    local cfg = SL:GetConfig("cfg_global", 3003)
    ---果实是否开放
    self.isFruitOpen = SL:MeData_GetLevel() >= tonumber(cfg.value)
    GUI:SetActive(self.view.appleButton, self.isFruitOpen)

    SL:RefreshPanelALLRedPoint("KLAttrPanel")
end

---注册UI事件和服务器消息
function KLAttrPanel:RegistEvents()
    SL:RegisterLUAEvent(LUA_EVENT_EXPCHANGE, self.LUA_EVENT_EXPCHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_PROPERTY_CHANGE, self.LUA_EVENT_ROLE_PROPERTY_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_SURE_ATTR_PLAN, self.LUA_EVENT_SURE_ATTR_PLAN, self)
    SL:RegisterLUAEvent(LUA_EVENT_RESET_POINT, self.LUA_EVENT_RESET_POINT, self)
    SL:RegisterLUAEvent(LUA_EVENT_FRUIT_PANEL_CLOSE, self.CloseFruitPanel, self)
    --SL:RegisterLuaNetMsg(MessageDef.ResRoleDeployAttrPointMessage,self.ResRoleDeployAttrPointMessage,self)
    --SL:RegisterLuaNetMsg(MessageDef.ResAttAddWayMessage,self.ResAttAddWayMessage,self)

    GUI:AddOnClickEvent(self.view.attrCloseButton, self, self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.CloseButton2, self, self.OnClickCloseButton)

    GUI:AddOnClickEvent(self.view.plusButton_dc, self, self.plusButton_dc)
    GUI:AddOnClickEvent(self.view.plusButton_stamina, self, self.plusButton_intelligence)
    GUI:AddOnClickEvent(self.view.plusButton_intelligence, self, self.plusButton_stamina)
    GUI:AddOnClickEvent(self.view.plusButton_command, self, self.plusButton_command)
    GUI:AddOnClickEvent(self.view.plusButton_agility, self, self.plusButton_agility)

    GUI:AddOnClickEvent(self.view.minusButton_dc, self, self.minusButton_dc)
    GUI:AddOnClickEvent(self.view.minusButton_stamina, self, self.minusButton_intelligence)
    GUI:AddOnClickEvent(self.view.minusButton_intelligence, self, self.minusButton_stamina)
    GUI:AddOnClickEvent(self.view.minusButton_command, self, self.minusButton_command)
    GUI:AddOnClickEvent(self.view.minusButton_agility, self, self.minusButton_agility)

    GUI:AddOnClickEvent(self.view.sureButton, self, self.sureButton)

    GUI:AddOnClickEvent(self.view.commandButton, self, self.commandButton)

    GUI:AddOnClickEvent(self.view.resetPointButton, self, self.resetPointButton)
    GUI:AddOnClickEvent(self.view.appleButton, self, self.OnClickApple)

    GUI:AddOnClickEvent(self.view.btn_exchange_point, self, self.btn_exchange_point)

end

---果实按钮
function this:OnClickApple()
    self:ShowFruitPanel(not self.isShowFruitUI)
end

function this:CloseFruitPanel()
    self:ShowFruitPanel(false)
end

---显示果实界面
function this:ShowFruitPanel(isShow)
    self.isShowFruitUI = isShow
    GUI:SetActive(self.view.AttrEffect, not isShow)
    if isShow then
        --GUI:setPosition(self.view.root,-90,0)
        GUI:UIPanel_Open("dev/outui/UIFruit/Panel/KLUIFruit/KLUIFruitPanel")
    else
        --GUI:setPosition(self.view.root,5,0)
        GUI:UIPanel_Close("dev/outui/UIFruit/Panel/KLUIFruit/KLUIFruitPanel")
    end
end

function this:btn_exchange_point()
    GUI:UIPanel_Open("dev/outui/Role/Panel/KLChangeAttrScheme/KLChangeAttrSchemePanel")
end

function this:resetPointButton()
    GUI:UIPanel_Open("dev/ui/Role/Item/KLResetPoint/KLResetPointItem", nil, self)
end

function this:commandButton()

    local attAddWay = SL:MeData_GetRoleExtInfo().attAddWay
    --local attAddWay = 0
    if attAddWay == -1 then
        ---@type cfg_career_column
        local tbl = SL:GetMetaValue(EMetaVarGetKey.ME_CAREER_TAB_COLUMN)
        GUI:UIPanel_Open("dev/outui/Role/Panel/KLAttPointSuitChoice/KLAttPointSuitChoicePanel", nil, nil, { curCareer = tbl.id })
        return
    end
    local AllPoint = self.freePoint
    ---力量+敏捷+体力+智力+统帅
    local needPoint={}
    local maxReduceAttr = 0 --最大差值
    local recAddRecommend = SL:GetConfigMultiKeys("cfg_addRecommend",SL:MeData_GetCareer().baseCareer, SL:MeData_GetLevel(), 'career', 'level')
    if recAddRecommend then
        if recAddRecommend.force then
            needPoint[1] = 0
            local curNum = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.strength)
            if recAddRecommend.force - curNum > 0 then
                needPoint[1] = recAddRecommend.force - curNum
            end
        end
        if recAddRecommend.agility then
            needPoint[2] = 0
            local curNum = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.agility)
            if recAddRecommend.agility - curNum > 0 then
                needPoint[2] = recAddRecommend.agility - curNum
            end
        end
        if recAddRecommend.physicalPower then
            needPoint[3] = 0
            local curNum = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.spirit)
            if recAddRecommend.physicalPower - curNum > 0 then
                needPoint[3] = recAddRecommend.physicalPower - curNum
            end
        end
        if recAddRecommend.intelligence then
            needPoint[4] = 0
            local curNum = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.intelligence)
            if recAddRecommend.intelligence - curNum > 0 then
                needPoint[4] = recAddRecommend.intelligence - curNum
            end
        end
        if recAddRecommend.commander then
            needPoint[5] = 0
            local curNum = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.command)
            if recAddRecommend.commander - curNum > 0 then
                needPoint[5] = recAddRecommend.commander - curNum
            end
        end
    end
    local AddRecCount = 0
    for _, attrCount in pairs(needPoint) do
        AddRecCount = AddRecCount + attrCount
    end

    ---足够
    local tbl = SL:GetConfigMultiKeys('cfg_career', SL:MeData_GetCareer().baseCareer, SL:MeData_GetCareer().careerRank, 'baseCareer', 'careerRank')
    local commandAdd = tbl.careerRec
    if commandAdd == nil or not next(commandAdd) then
        logError("推荐加点方案为空")
        return
    end
    commandAdd = commandAdd[attAddWay + 1]
    local remainPoint = AllPoint - AddRecCount
    if remainPoint > 0 then
        -- 每个属性分配点数： 可用点数/（力量+敏捷+体力+智力+统帅） 除后的商 乘以具体的属性值 余数加到职业对应优势属性上
        local totalCount = 0
        for _, attrCount in pairs(commandAdd) do
            totalCount = totalCount + attrCount
        end

        -- 除数为0， 不执行推荐加点逻辑。
        if totalCount == 0 then
            return
        end
        
        local addCount = remainPoint // totalCount
        self.add_strength = self.add_strength + commandAdd[1] * addCount + needPoint[1]
        self.add_spirit = self.add_spirit + commandAdd[3] * addCount + needPoint[3]
        self.add_intelligence = self.add_intelligence + commandAdd[4] * addCount + needPoint[4]
        self.add_lead = self.add_lead + commandAdd[5] * addCount + needPoint[5]
        self.add_agility = self.add_agility + commandAdd[2] * addCount + needPoint[2]

        self.freePoint = self.freePoint - addCount * totalCount - AddRecCount
    else
        ---不足够
        local addCount = AllPoint / AddRecCount
        self.add_strength = self.add_strength + math.floor(needPoint[1] * addCount)
        self.add_spirit = self.add_spirit + math.floor(needPoint[3] * addCount)
        self.add_intelligence = self.add_intelligence +math.floor(needPoint[4] * addCount)
        self.add_lead = self.add_lead + math.floor(needPoint[5] * addCount)
        self.add_agility = self.add_agility + math.floor(needPoint[2] * addCount)
        local needPointNumSmall= {}---小数点
        needPointNumSmall[1] = { id = 1,num = needPoint[1] * addCount - math.floor(needPoint[1] * addCount) }
        needPointNumSmall[2] = { id = 2,num = needPoint[2] * addCount - math.floor(needPoint[2] * addCount) }
        needPointNumSmall[3] = { id = 3,num = needPoint[3] * addCount - math.floor(needPoint[3] * addCount) }
        needPointNumSmall[4] = { id = 4,num = needPoint[4] * addCount - math.floor(needPoint[4] * addCount) }
        needPointNumSmall[5] = { id = 5,num = needPoint[5] * addCount - math.floor(needPoint[5] * addCount) }
        table.sort(needPointNumSmall,function(a, b) 
            return a.num > b.num
        end)
        local rePoint = self.freePoint - math.floor(needPoint[1] * addCount) - math.floor(needPoint[3] * addCount) -math.floor(needPoint[4] * addCount) -math.floor(needPoint[5] * addCount) -math.floor(needPoint[2] * addCount)
        for i= 1,rePoint,1 do
            if needPointNumSmall[i] then
                if needPointNumSmall[i].id == 2 then
                    self.add_agility = self.add_agility + 1 
                elseif needPointNumSmall[i].id == 5 then
                    self.add_lead = self.add_lead + 1
                elseif needPointNumSmall[i].id == 4 then
                    self.add_intelligence = self.add_intelligence + 1
                elseif needPointNumSmall[i].id == 3 then
                    self.add_spirit = self.add_spirit + 1
                elseif needPointNumSmall[i].id == 1 then
                    self.add_strength = self.add_strength + 1
                end
            end
        end
--[[        local maxNum = 0
        for _,v in pairs(needPoint) do
            if v > maxNum then
                maxNum = v
            end
        end
        if needPoint[2] == maxNum then
            self.add_agility = self.add_agility + rePoint
        elseif needPoint[5] == maxNum then
            self.add_lead = self.add_lead + rePoint
        elseif needPoint[4] == maxNum then
            self.add_intelligence = self.add_intelligence + rePoint
        elseif needPoint[3] == maxNum then
            self.add_spirit = self.add_spirit + rePoint
        elseif needPoint[1] == maxNum then
            self.add_strength = self.add_strength + rePoint
        end]]
        self.freePoint = 0
    end
    
    
   
    -- 余数加到职业对应优势属性上
    -- 优势属性：推荐加点中比例最大的属性，如果存在同比例的属性，则按照力量＞敏捷＞体力＞智力＞统帅来(按照commandAdd的最先最大的.)
    if self.freePoint > 0 then

        local maxCount = -1
        local selectIndex = -1
        for attrIndex, count in pairs(commandAdd) do
            if maxCount < count then
                maxCount = count
                selectIndex = attrIndex
            end
        end

        if selectIndex == 1 then
            self.add_strength = self.add_strength + self.freePoint
        elseif selectIndex == 2 then
            self.add_agility = self.add_agility + self.freePoint
        elseif selectIndex == 3 then
            self.add_spirit = self.add_spirit + self.freePoint
        elseif selectIndex == 4 then
            self.add_intelligence = self.add_intelligence + self.freePoint
        elseif selectIndex == 5 then
            self.add_lead = self.add_lead + self.freePoint
        end

        self.freePoint = 0
    end

    self:SetFreePoint()
    self:SetAddNumInfo()
    self:SetAddSubBtnState()
end

function this:ResRoleDeployAttrPointMessage()

    --剩余点数
    --local freePoint = SL:MeData_GetRoleExtInfo().remainAttrPoint or 0
    --GUI:Text_setString(self.view.remainPointText, tostring(freePoint))

    --力量等属性
    self:SetAddNumInfo()

end

function this:sureButton()
    local sendData = {}
    if self.add_strength > 0 then
        table.insert(sendData, { type = EMUCharacterAttrType.strength, num = self.add_strength })
    end

    if self.add_agility > 0 then
        table.insert(sendData, { type = EMUCharacterAttrType.agility, num = self.add_agility })
    end

    if self.add_lead > 0 then
        table.insert(sendData, { type = EMUCharacterAttrType.lead, num = self.add_lead })
    end

    if self.add_intelligence > 0 then
        table.insert(sendData, { type = EMUCharacterAttrType.intelligence, num = self.add_intelligence })
    end

    if self.add_spirit > 0 then
        table.insert(sendData, { type = EMUCharacterAttrType.spirit, num = self.add_spirit })
    end

    SL.RoleAtt:ReqDeployAttrPoint(sendData, 1)
    self:SaveEachPlanAttrPoint(sendData)
    self:Reset()
end

function this:SaveEachPlanAttrPoint(data)
    local sendData = {}
    local tempData = {}
    local oldData = PrivilegeCardManager.GetCurrentAttrPointPlan()
    if oldData then
        for i, v in pairs(oldData) do
            tempData[v.type] = v.num
        end
        for i, v in pairs(data) do
            if tempData[v.type] then
                tempData[v.type] = tempData[v.type] + v.num
            else
                tempData[v.type] = v.num
            end
        end
        for i, v in pairs(tempData) do
            local tbl = {}
            tbl.type = i
            tbl.num = v
            sendData[#sendData + 1] = tbl
        end
    else
        sendData = data
    end
    PrivilegeCardManager.SendMessageSetFreeAttrInfo(nil, sendData, nil)
end

function this:Reset()
    self.add_strength = 0
    self.add_agility = 0
    self.add_lead = 0
    self.add_intelligence = 0
    self.add_spirit = 0
    self:SetAddNumInfo()
    self:SetAddSubBtnState()
end

function this:plusButton_dc()
    if SL:MeData_GetRoleExtInfo().RemainAttrPoint > self.calcShowPoint then
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel", nil, nil, { maxNum = self.freePoint, callback = self.plus_dc, ins = self, intro = "增加点数" })
        return
    end

    if self.freePoint > 0 then
        self.freePoint = self.freePoint - 1
        self.add_strength = self.add_strength + 1
        self:SetAddSubBtnState()
        self:SetFreePoint()
        self:SetAddNumInfo()
    end
end

function this:plus_dc(addValue)
    self.freePoint = self.freePoint - addValue
    self.add_strength = self.add_strength + addValue
    self:SetAddSubBtnState()
    self:SetFreePoint()
    self:SetAddNumInfo()
end

function this:plusButton_stamina()
    if SL:MeData_GetRoleExtInfo().RemainAttrPoint > self.calcShowPoint then
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel", nil, nil, { maxNum = self.freePoint, callback = self.plus_sta, ins = self, intro = "增加点数" })
        return
    end

    if self.freePoint > 0 then
        self.freePoint = self.freePoint - 1
        self.add_spirit = self.add_spirit + 1
        self:SetAddSubBtnState()
        self:SetFreePoint()
        self:SetAddNumInfo()
    end
end

function this:plus_sta(addValue)
    self.freePoint = self.freePoint - addValue
    self.add_spirit = self.add_spirit + addValue
    self:SetAddSubBtnState()
    self:SetFreePoint()
    self:SetAddNumInfo()
end

function this:plusButton_intelligence()
    if SL:MeData_GetRoleExtInfo().RemainAttrPoint > self.calcShowPoint then
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel", nil, nil, { maxNum = self.freePoint, callback = self.plus_intel, ins = self, intro = "增加点数" })
        return
    end

    if self.freePoint > 0 then
        self.freePoint = self.freePoint - 1
        self.add_intelligence = self.add_intelligence + 1
        self:SetAddSubBtnState()
        self:SetFreePoint()
        self:SetAddNumInfo()
    end
end

function this:plus_intel(addValue)
    self.freePoint = self.freePoint - addValue
    self.add_intelligence = self.add_intelligence + addValue
    self:SetAddSubBtnState()
    self:SetFreePoint()
    self:SetAddNumInfo()
end

function this:plusButton_command()
    if SL:MeData_GetRoleExtInfo().RemainAttrPoint > self.calcShowPoint then
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel", nil, nil, { maxNum = self.freePoint, callback = self.plus_lead, ins = self, intro = "增加点数" })
        return
    end
    if self.freePoint > 0 then
        self.freePoint = self.freePoint - 1
        self.add_lead = self.add_lead + 1
        self:SetAddSubBtnState()
        self:SetFreePoint()
        self:SetAddNumInfo()
    end
end

function this:plus_lead(addValue)
    self.freePoint = self.freePoint - addValue
    self.add_lead = self.add_lead + addValue
    self:SetAddSubBtnState()
    self:SetFreePoint()
    self:SetAddNumInfo()
end

function this:plusButton_agility()
    if SL:MeData_GetRoleExtInfo().RemainAttrPoint > self.calcShowPoint then
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel", nil, nil, { maxNum = self.freePoint, callback = self.plus_ag, ins = self, intro = "增加点数" })
        return
    end
    if self.freePoint > 0 then
        self.freePoint = self.freePoint - 1
        self.add_agility = self.add_agility + 1
        self:SetAddSubBtnState()
        self:SetFreePoint()
        self:SetAddNumInfo()
    end
end

function this:plus_ag(addValue)
    self.freePoint = self.freePoint - addValue
    self.add_agility = self.add_agility + addValue
    self:SetAddSubBtnState()
    self:SetFreePoint()
    self:SetAddNumInfo()
end

function this:minusButton_agility()
    if SL:MeData_GetRoleExtInfo().RemainAttrPoint > self.calcShowPoint then
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel", nil, nil, { maxNum = self.add_agility, callback = self.minus_ag, ins = self, intro = "减少点数" })
        return
    end
    if self.add_agility > 0 then
        self.freePoint = self.freePoint + 1
        self.add_agility = self.add_agility - 1
        self:SetAddSubBtnState()
        self:SetFreePoint()
        self:SetAddNumInfo()
    end
end

function this:minus_ag(addValue)
    self.freePoint = self.freePoint + addValue
    self.add_agility = self.add_agility - addValue
    self:SetAddSubBtnState()
    self:SetFreePoint()
    self:SetAddNumInfo()
end

function this:minusButton_dc()
    if SL:MeData_GetRoleExtInfo().RemainAttrPoint > self.calcShowPoint then
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel", nil, nil, { maxNum = self.add_strength, callback = self.minus_dc, ins = self, intro = "减少点数" })
        return
    end
    if self.add_strength > 0 then
        self.freePoint = self.freePoint + 1
        self.add_strength = self.add_strength - 1
        self:SetAddSubBtnState()
        self:SetFreePoint()
        self:SetAddNumInfo()
    end
end

function this:minus_dc(addValue)
    self.freePoint = self.freePoint + addValue
    self.add_strength = self.add_strength - addValue
    self:SetAddSubBtnState()
    self:SetFreePoint()
    self:SetAddNumInfo()
end

function this:minusButton_stamina()
    if SL:MeData_GetRoleExtInfo().RemainAttrPoint > self.calcShowPoint then
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel", nil, nil, { maxNum = self.add_spirit, callback = self.minus_sta, ins = self, intro = "减少点数" })
        return
    end
    if self.add_spirit > 0 then
        self.freePoint = self.freePoint + 1
        self.add_spirit = self.add_spirit - 1
        self:SetAddSubBtnState()
        self:SetFreePoint()
        self:SetAddNumInfo()
    end
end

function this:minus_sta(addValue)
    self.freePoint = self.freePoint + addValue
    self.add_spirit = self.add_spirit - addValue
    self:SetAddSubBtnState()
    self:SetFreePoint()
    self:SetAddNumInfo()
end

function this:minusButton_intelligence()
    if SL:MeData_GetRoleExtInfo().RemainAttrPoint > self.calcShowPoint then
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel", nil, nil, { maxNum = self.add_intelligence, callback = self.minus_intel, ins = self, intro = "减少点数" })
        return
    end

    if self.add_intelligence > 0 then
        self.freePoint = self.freePoint + 1
        self.add_intelligence = self.add_intelligence - 1
        self:SetAddSubBtnState()
        self:SetFreePoint()
        self:SetAddNumInfo()
    end
end

function this:minus_intel(addValue)
    self.freePoint = self.freePoint + addValue
    self.add_intelligence = self.add_intelligence - addValue
    self:SetAddSubBtnState()
    self:SetFreePoint()
    self:SetAddNumInfo()
end

function this:minusButton_command()
    if SL:MeData_GetRoleExtInfo().RemainAttrPoint > self.calcShowPoint then
        GUI:UIPanel_Open("dev/ui/Common/Panel/KLCalc/KLCalcPanel", nil, nil, { maxNum = self.add_lead, callback = self.minus_le, ins = self, intro = "减少点数" })
        return
    end
    if self.add_lead > 0 then
        self.freePoint = self.freePoint + 1
        self.add_lead = self.add_lead - 1
        self:SetAddSubBtnState()
        self:SetFreePoint()
        self:SetAddNumInfo()
    end
end

function this:minus_le(addValue)
    self.freePoint = self.freePoint + addValue
    self.add_lead = self.add_lead - addValue
    self:SetAddSubBtnState()
    self:SetFreePoint()
    self:SetAddNumInfo()
end

function this:OnClickCloseButton()
    GUI:UIPanel_Close("dev/ui/Role/Panel/KLAttr/KLAttrPanel")
    GUI:UIPanel_Close("dev/ui/Common/Panel/KLCalc/KLCalcPanel")
    SL.ShowMainPanel()
end

function this:Close()
    for _,v in pairs(self.animList) do
        if v then
            GUI:DOKill(v)
        end
    end
    GUI:UIPanel_Close("dev/ui/Common/Panel/KLCalc/KLCalcPanel")
    SL:onLUAEvent(LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE)
    self:ShowFruitPanel(false)
end

function this:LUA_EVENT_EXPCHANGE()
    self:RefreshExpText()
end

function this:LUA_EVENT_ROLE_PROPERTY_CHANGE()
    SL:RefreshPanelALLRedStateKmlByCondition("checkUnusedAbility")
    self:SetAddNumInfo()
    self:RefreshRightAttr()
    if PrivilegeCardManager.attrNeedRefresh then
        SL:ScheduleOnce(0.1, function()
            PrivilegeCardManager.attrNeedRefresh = false
            self:ResetUi()
        end)
    end
end

---@param message RoleProtos.DeployResult
function this:LUA_EVENT_RESET_POINT(id, message)
    self:ResetUi()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_ROLE_ATT_ADD_WAY)
end

---@param message UserProtos.SetRoleAttAddWay
function this:LUA_EVENT_SURE_ATTR_PLAN(id, message)
    self:SetFreePoint()
    --self:commandButton()
end

function this:ResetUi()
    self.freePoint = SL:MeData_GetRoleExtInfo().RemainAttrPoint
    self:SetFreePoint()
    self.add_strength = 0
    self.add_agility = 0
    self.add_intelligence = 0
    self.add_spirit = 0
    self.add_lead = 0

    self:SetAddNumInfo()
    self:SetAddSubBtnState()
end

function this:RefreshExpText()
    GUI:SetActive(self.view.expText,true)
    local nowExp = SL:MeData_GetRoleExtInfo().exp + SL:MeData_GetRoleExtInfo().expandExp
    local needExp = SL:GetConfig("cfg_level", SL:MeData_GetLevel()).exp

    if needExp == 0 then
        if SL:HasConfig("cfg_level", SL:MeData_GetLevel() + 1) then
            needExp = SL:GetConfig("cfg_level", SL:MeData_GetLevel() + 1).exp
        end
        GUI:SetActive(self.view.expText,false)
    else
        GUI:Text_setString(self.view.expText, string.format("经验值:%s/%s", Misc.GetSampleNumberString(nowExp), Misc.GetSampleNumberString(needExp)))  
    end
    

end

-- 分配点数按钮显隐
function this:SetAddSubBtnState()
    if self.freePoint == 0 then
        GUI:setVisible(self.view.plusButton_dc, false)
        GUI:setVisible(self.view.plusButton_agility, false)
        GUI:setVisible(self.view.plusButton_command, false)
        GUI:setVisible(self.view.plusButton_intelligence, false)
        GUI:setVisible(self.view.plusButton_stamina, false)
    else
        GUI:setVisible(self.view.plusButton_dc, true)
        GUI:setVisible(self.view.plusButton_agility, true)
        GUI:setVisible(self.view.plusButton_command, true)
        GUI:setVisible(self.view.plusButton_intelligence, true)
        GUI:setVisible(self.view.plusButton_stamina, true)
    end

    GUI:setVisible(self.view.minusButton_agility, self.add_agility > 0 and true or false)
    GUI:setVisible(self.view.minusButton_intelligence, self.add_spirit > 0 and true or false)
    GUI:setVisible(self.view.minusButton_command, self.add_lead > 0 and true or false)
    GUI:setVisible(self.view.minusButton_stamina, self.add_intelligence > 0 and true or false)
    GUI:setVisible(self.view.minusButton_dc, self.add_strength > 0 and true or false)

    if self.add_spirit | self.add_intelligence | self.add_lead + self.add_agility | self.add_strength > 0 then
        GUI:setVisible(self.view.sureButton, true)
        GUI:setVisible(self.view.light_btn1, true)

        GUI:SetActive(self.view.appleButton, false)
        self:SetFreeSwitchAttrPoint(false)
    else
        GUI:setVisible(self.view.sureButton, false)
        GUI:setVisible(self.view.light_btn1, false)
        if self.isFruitOpen then
            GUI:SetActive(self.view.appleButton, true)
        end
        self:SetFreeSwitchAttrPoint(true)
    end
end

function this:SetFreePoint()
    GUI:Text_setString(self.view.remainPointText, tostring(self.freePoint))
    local levelCondition = SL:GetConfig("cfg_global",750001).value
    if self.freePoint > 0 and SL:GetMetaValue(EMetaVarGetKey.LEVEL) >= tonumber(levelCondition) then
        --GUI:setVisible(self.view.commandButton, true)
        --GUI:setVisible(self.view.light_btn, true)
    else
        GUI:setVisible(self.view.commandButton, false)
        GUI:setVisible(self.view.light_btn, false)
    end
    if SL:MeData_GetRoleExtInfo().attAddWay == -1 then
        GUI:Text_setString(self.view.commandButton_text, "职业切换")
    else
        GUI:Text_setString(self.view.commandButton_text, "推荐加点")
    end
    --GUI:Text_setString(self.view.commandButton_text, "推荐加点")
end

function this:SetAddNumInfo()
    local strength = SL:GetMetaValue("GET_ATTR_VALUE_BY_ID", EMUCharacterAttrType.strength)
    if self.add_strength > 0 then
        GUI:Text_setString(self.view.num_dc, string.format("%s<color=\"#4CC5FE\"> + %s</color>", strength, self.add_strength))
    else
        GUI:Text_setString(self.view.num_dc, tostring(strength))
    end

    local agility = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.agility)
    if self.add_agility > 0 then
        GUI:Text_setString(self.view.num_agility, string.format("%s<color=\"#4CC5FE\"> + %s</color>", agility, self.add_agility))
    else
        GUI:Text_setString(self.view.num_agility, tostring(agility))
    end

    local intelligence = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.intelligence)
    if self.add_intelligence > 0 then
        GUI:Text_setString(self.view.num_stamina, string.format("%s<color=\"#4CC5FE\"> + %s</color>", intelligence, self.add_intelligence))
        --GUI:Text_setString(self.view.num_intelligence, string.format("%s<color=\"#4CC5FE\"> + %s</color>", intelligence, self.add_intelligence))
    else
        --GUI:Text_setString(self.view.num_intelligence, tostring(intelligence))
        GUI:Text_setString(self.view.num_stamina, tostring(intelligence))
    end

    local spirit = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.spirit)
    if self.add_spirit > 0 then
        GUI:Text_setString(self.view.num_intelligence, string.format("%s<color=\"#4CC5FE\"> + %s</color>", spirit, self.add_spirit))
        --GUI:Text_setString(self.view.num_stamina, string.format("%s<color=\"#4CC5FE\"> + %s</color>", spirit, self.add_spirit))
    else
        --GUI:Text_setString(self.view.num_stamina, tostring(spirit))
        GUI:Text_setString(self.view.num_intelligence, tostring(spirit))
    end

    local lead = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.lead)
    if self.add_lead > 0 then
        GUI:Text_setString(self.view.num_command, string.format("%s<color=\"#4CC5FE\"> + %s</color>", lead, self.add_lead))
    else
        GUI:Text_setString(self.view.num_command, tostring(lead))
    end

    GUI:DataListUpdateData(self.view.attInfoContent_dc_content)
    GUI:DataListUpdateData(self.view.attInfoContent_intelligence_content)
    GUI:DataListUpdateData(self.view.attInfoContent_command_content)
    GUI:DataListUpdateData(self.view.attInfoContent_stamina_content)
    GUI:DataListUpdateData(self.view.attInfoContent_agility_content)
end

function this:GetSpecialAttrAdd(addAttrId)
    if not SL:HasConfig("cfg_att_info", addAttrId) then

        logError("改属性id不存在")
        return 0
    end

    local cfgInfo = SL:GetConfig("cfg_att_info", addAttrId)
    local addInfo = SL:GetMetaValue(EMetaVarGetKey.GET_ADD_PER, cfgInfo.attribute)

    -- 获取当前二级属性的属性值， 因为服务端发的是整数(抹去小数点)， 数值减差值前要对差值/10000进行处理.
    -- 属性类型是数值的处理：1.5+1.6=3.1 要显示+2， 因为是从1->3， 所以计算方式为抹小数点的结果减去抹小数点的起始值 3-1=2
    -- 是万分比的话 15.25%-> 20.00%， (2000-1525) / 100 = 4.75 

    local nowAttr = 0
    local attrName = SL:GetConfig("cfg_att_info", EMUCharacterAttrType.strength).attribute
    local nowAttrPoint = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.strength)
    nowAttr = nowAttr + addInfo[attrName] * nowAttrPoint

    attrName = SL:GetConfig("cfg_att_info", EMUCharacterAttrType.agility).attribute
    nowAttrPoint = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.agility)
    nowAttr = nowAttr + addInfo[attrName] * nowAttrPoint

    attrName = SL:GetConfig("cfg_att_info", EMUCharacterAttrType.spirit).attribute
    nowAttrPoint = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.spirit)
    nowAttr = nowAttr + addInfo[attrName] * nowAttrPoint

    attrName = SL:GetConfig("cfg_att_info", EMUCharacterAttrType.intelligence).attribute
    nowAttrPoint = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.intelligence)
    nowAttr = nowAttr + addInfo[attrName] * nowAttrPoint

    attrName = SL:GetConfig("cfg_att_info", EMUCharacterAttrType.lead).attribute
    nowAttrPoint = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.lead)
    nowAttr = nowAttr + addInfo[attrName] * nowAttrPoint

    local addTotalAttr = 0

    attrName = SL:GetConfig("cfg_att_info", EMUCharacterAttrType.strength).attribute
    nowAttrPoint = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.strength)
    addTotalAttr = addTotalAttr + addInfo[attrName] * (nowAttrPoint + self.add_strength)

    attrName = SL:GetConfig("cfg_att_info", EMUCharacterAttrType.agility).attribute
    nowAttrPoint = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.agility)
    addTotalAttr = addTotalAttr + addInfo[attrName] * (nowAttrPoint + self.add_agility)

    attrName = SL:GetConfig("cfg_att_info", EMUCharacterAttrType.spirit).attribute
    nowAttrPoint = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.spirit)
    addTotalAttr = addTotalAttr + addInfo[attrName] * (nowAttrPoint + self.add_spirit)

    attrName = SL:GetConfig("cfg_att_info", EMUCharacterAttrType.intelligence).attribute
    nowAttrPoint = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.intelligence)
    addTotalAttr = addTotalAttr + addInfo[attrName] * (nowAttrPoint + self.add_intelligence)

    attrName = SL:GetConfig("cfg_att_info", EMUCharacterAttrType.lead).attribute
    nowAttrPoint = SL:MeData_GetSpecialAttrValue(EMUCharacterAttrType.lead)
    addTotalAttr = addTotalAttr + addInfo[attrName] * (nowAttrPoint + self.add_lead)

    -- 数值的
    if cfgInfo.remarks == EAttrRemarkType.Number then
        return addTotalAttr // 10000 - nowAttr // 10000
    elseif cfgInfo.remarks == EAttrRemarkType.Dimi then
        return (addTotalAttr - nowAttr) / 100
    else
        logError("属性数值类型非数值或万分比，需要策划告知处理规则， attrId = " .. addAttrId)
        return 0
    end
end

return KLAttrPanel
