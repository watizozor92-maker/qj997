---@class KLUISkillSettingPanel:UIKmlLuaPanelBase
---@field view KLUISkillSettingPanelView
---@field args {settingType:ESkillSettingType,curSelectId:number}
---@field curSelectSkillId number @当前选中的技能id
---@field curShowType ESkillType
---@field curSelectIndex number @选技能的序号（全部模式或者转盘模式）
---@field fastItemIds number[]
---@field curSelectItemId number
---@field curSelectItemIndex number
---@field curSettingType ESkillSettingType
local KLUISkillSettingPanel = class(UIKmlLuaPanelBase)
local this = KLUISkillSettingPanel
---创建时调用一次
function this:Init()
    self.curSelectIndex = 0
    self.curSelectSkillId = 0

    self.curSelectItemId = 0
    self.curSelectItemIndex = 0
    GUI:SetActive(self.view.SkillBtnA,true)
    GUI:SetActive(self.view.SkillBtnB,false)
    GUI:DataListInitData(self.view.FastItemDataList,
            function()
                return self:ItemCountFunc()
            end,
            nil,
            nil,
            function(realIndex, kmlCtrl)
                return self:ItemUpdateFunc(realIndex, kmlCtrl)
            end)
    GUI:SetActive(self.view.btnTurnMask,true)
    GUI:SetActive(self.view.btnAllMask,true)

end

function this:ItemCountFunc()
    return #self.fastItemIds
end

function this:ItemUpdateFunc(realIndex)
    local item = GUI:GetChildControl(self.view.FastItemDataList, realIndex, 'bagItem')
    local luaIdx = realIndex + 1
    local cfgId = self.fastItemIds[luaIdx]
    local count = 0
    if cfgId and cfgId ~= 0 then
        count = SL:GetBagItemCount(cfgId)
    end

    GUI:Item_setItemId(item, cfgId)
    local togItem = GUI:GetChildControl(self.view.FastItemDataList, realIndex, 'bagItemBg_')
    GUI:SetToggleOnValueChange(togItem, self, self.FastItemSelectValueChange, luaIdx)
end

function this:SetFastItemId()
    ---@type number[]
    local fastItems = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    if self.curSelectItemId > 0 and fastItems[self.curSelectItemIndex] ~= self.curSelectItemId then
        ---@type cfg_item_column
        local itemTbl = SL:GetConfig("cfg_item", self.curSelectItemId)
        local real_curSelectItemIndex = self.curSelectItemIndex

        local isPill = false
        if itemTbl.type == InfoManager.mainUIInfo.mpType and itemTbl.subType == InfoManager.mainUIInfo.mpSubType and InfoManager.mainUIInfo.mpPillIdList[itemTbl.id] then
            self.curSelectItemIndex = 1
            isPill = true
        elseif itemTbl.type == InfoManager.mainUIInfo.hpType and itemTbl.subType == InfoManager.mainUIInfo.hpSubType and InfoManager.mainUIInfo.hpPillIdList[itemTbl.id] then
            self.curSelectItemIndex = 2
            isPill = true
        end

        if self.curSelectItemIndex <= 2 and not isPill then
            return
        end

        if SL:HasConfig("cfg_item", fastItems[self.curSelectItemIndex]) then
            ---@type cfg_item_column
            local itemTbl1 = SL:GetConfig("cfg_item", fastItems[self.curSelectItemIndex])
            --蓝药/血药
            if isPill and itemTbl.rank < itemTbl1.rank and real_curSelectItemIndex ~= self.curSelectItemIndex then
                return
            end
        end

        fastItems[self.curSelectItemIndex] = self.curSelectItemId
        self.fastItemIds[self.curSelectItemIndex] = self.curSelectItemId
        for i = 1, #fastItems do
            if i ~= self.curSelectItemIndex and fastItems[i] == self.curSelectItemId then
                fastItems[i] = 0
            end
        end
        self.curSelectItemId = 0
        self.curSelectItemIndex = 0
        GUI:DataListUpdateData(self.view.FastItemDataList)
    end

end

---@param kmlLuaCtrl UIKmlLuaControl
---@param luaIdx number
function this:FastItemSelectValueChange(kmlLuaCtrl, luaIdx, args)
    local isOn = false
    if args[1] then
        self.curSelectItemIndex = luaIdx
        self.curSelectItemId = 0
        self:SetFastItemId()
        self.selectToggle = kmlLuaCtrl
        isOn = true
    else
        self.curSelectItemIndex = 0
        if not self.is_set_update and luaIdx > 2 then
            SL:SetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST, luaIdx, 0, 0)
            self:SetFastItemId()
        end
    end

    for realIndex in pairs(self.fastItemIds) do
        local togItem = GUI:GetChildControl(self.view.FastItemDataList, realIndex - 1, 'bagItemBg_')
        if togItem and ((isOn and realIndex ~= luaIdx) or not isOn) then
            GUI:SetIsOnWithoutNotify(togItem, false)
        end
    end

    self.is_set_update = false
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:setVisible(self.view.togPattern,false)
    if self.args.curSelectId and SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_IS_LEARNED, self.args.curSelectId) then
        self.curSelectSkillId = self.args.curSelectId
    else
        self.curSelectSkillId = 0
    end
    
    self:TogPatternChange(nil,nil,{false})
    
    --GUI:SetTogDefaultThis(self.view.togPattern)

    local fastItemList = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    self.fastItemIds = table.copyFrom({}, fastItemList)
    if not SL:HasConfig("cfg_item", self.fastItemIds[1]) then
        self.fastItemIds[1] = InfoManager.mainUIInfo.mpShowModeItemId
    end
    if not SL:HasConfig("cfg_item", self.fastItemIds[2]) then
        self.fastItemIds[2] = InfoManager.mainUIInfo.hpShowModeItemId
    end
    table.remove(self.fastItemIds,5)
    
    local settingType = self.args.settingType or ESkillSettingType.Skill

    GUI:DataListUpdateData(self.view.FastItemDataList)

    if settingType == ESkillSettingType.FastItem then
        GUI:Toggle_setIsOn(self.view.BagItemBtnSetting, true)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.SkillBtnSetting, self, self.TogSkillSettingValueChange)
    GUI:SetToggleOnValueChange(self.view.BagItemBtnSetting, self, self.TogBagItemValueChange)
    GUI:SetToggleOnValueChange(self.view.togPattern, self, self.TogPatternChange)
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.ClosetOnClick)
    for i = 1, 7 do
        GUI:SetToggleOnValueChange(self.view["TogAllSkill" .. i], self, self.TogAllSkillValueChange, i)
    end

    for i = 1, 8 do
        GUI:SetToggleOnValueChange(self.view["TogTurnSkill" .. i], self, self.TogTurnSkillValueChange, i)
    end

    SL:RegisterLUAEvent(LUA_EVENT_SELECT_SKILL_UI, self.SelectSkill, self)
    SL:RegisterLUAEvent(LUA_EVENT_CLOSEWIN, self.OnPanelClose, self)

    SL:RegisterLUAEvent(LUA_EVENT_FASTITEM_SET_SELECT, self.OnFastItemSetSelect, self)

    GUI:AddOnClickEvent(self.view.BtnReset, self, self.BtnResetOnClick)

    SL:RegisterLUAEvent(LUA_EVENT_INIT_SHORT_CUT, self.InitShortcutAfter, self)

end

function this:ClosetOnClick(_, cfgId)
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanel")
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLSkillBag/KLSkillBagPanel")
   
    SL.ShowMainPanel()
end

function this:OnFastItemSetSelect(_, cfgId)
    self.curSelectItemId = cfgId or 0

    if not self.curSelectItemIndex or self.curSelectItemIndex == 0 then
        SL:TipMessage(SL:GetConfig('cfg_string', 294).text, 1, NoticeType.NoticeMid)
        ---请选择快捷栏
        return
    end
    ---@type number[]
    local fastItems = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    if fastItems[self.curSelectItemIndex] ~= self.curSelectItemId and not self:IsExistFastItem(cfgId) then
        self:SetFastItemId()
        self.is_set_update = true
    end
    GUI:Toggle_setIsOn(self.selectToggle, false)
end

function this:OnPanelClose(_, panelName)
    if panelName ~= "KLSkillBagPanel" then
        return
    end
    GUI:SetTogDefaultThis(self.view.SkillBtnSetting)
end

function this:BtnResetOnClick()
    ---@type number[]
    local showSkills = SL:GetMetaValue(EMetaVarGetKey.SKILL_SHOW_LIST)
    for i = 1, 8 do
        showSkills[i] = 0
    end

    SL:SetMetaValue(EMetaVarSetKey.SKILL_SHOW_LIST, showSkills)

    self:ShowSkillIcon()
end

---@param skillItem KLUISkillItem
function this:SelectSkill(_, skillItem)
    self.skillItem = skillItem
    self.skillId = skillItem.skillId
    self.skillItem:SetTogIsOn(false)
    if SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_IS_LEARNED, self.skillId) and SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_IS_UNLOCK, self.skillId) then
        self.curSelectSkillId = self.skillId
    else
        self.curSelectSkillId = 0
    end

    ---@type cfg_skill_column
    local skillTbl = SL:GetConfig("cfg_skill", self.skillId)
    if self.curSelectSkillId == 0 then
        return SL:TipMessage("技能未解锁", 1, NoticeType.NoticeMid)
    end
    
    if skillTbl.type ~= ECfgSkillType.Normal then
        return SL:TipMessage(SL:GetConfig('cfg_string', 295).text, 1, NoticeType.NoticeMid)--被动技能无法放置
    end
    
    if skillTbl.isroulette == 1 then
        return SL:TipMessage(SL:GetConfig('cfg_string', 295).text, 1, NoticeType.NoticeMid)
    end
    
    if not self.curSelectIndex or self.curSelectIndex == 0 then
        return SL:TipMessage(SL:GetConfig('cfg_string', 296).text, 1, NoticeType.NoticeMid)--请选择技能栏
    end
    self:SetSkillId()
    GUI:Toggle_setIsOn(self.selectSkillTog, false)
end

function this:SetSkillId()
    ---@type number[]
    local showSkills = SL:GetMetaValue(EMetaVarGetKey.SKILL_SHOW_LIST)

    if self.curSelectSkillId > 0 and showSkills[self.curSelectIndex] ~= self.curSelectSkillId and SL:GetMetaValue(EMetaVarGetKey.SKILL_CHECK_IS_LEARNED, self.curSelectSkillId) then
        showSkills[self.curSelectIndex] = self.curSelectSkillId

        for i = 1, 8 do
            if i ~= self.curSelectIndex and showSkills[i] == self.curSelectSkillId then
                showSkills[i] = 0
            end
        end
        SL:SetMetaValue(EMetaVarSetKey.SKILL_SHOW_LIST, showSkills)
        self:ShowSkillIcon()
    end

end



--转盘模式
function this:TogTurnSkillValueChange(kmlCtrl, index, args)
    if args[1] then
        self.curSelectIndex = index
        self.curSelectSkillId = 0
        self:SetSkillId()
        self.selectSkillTog = kmlCtrl
    else
        self.curSelectIndex = 0
    end
end

--全部模式
function this:TogAllSkillValueChange(kmlCtrl, index, args)
    if args[1] then
        self.curSelectIndex = index
        self.curSelectSkillId = 0
        self:SetSkillId()
        self.selectSkillTog = kmlCtrl
    else
        self.curSelectIndex = 0
    end
end

function this:TogBagItemValueChange(_, _, args)
    if not args[1] then
        return
    end
    if self.curSettingType == ESkillSettingType.FastItem then
        return
    end
    self.curSettingType = ESkillSettingType.FastItem
    GUI:SetActive(self.view.SkillBtnA,false)
    GUI:SetActive(self.view.SkillBtnB,true)
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLSkillBag/KLSkillBagPanel")
    --关闭技能界面
    --GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel")
    SL.HideMainPanel()

end

function this:TogSkillSettingValueChange(_, _, args)
    if not args[1] then
        return
    end
    if self.curSettingType == ESkillSettingType.Skill then
        return
    end
    self.curSettingType = ESkillSettingType.Skill

    GUI:UIPanel_Open("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel", nil, nil, ESkillUIShowPage.Setting)
    --关闭背包
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLSkillBag/KLSkillBagPanel")
    GUI:SetActive(self.view.SkillBtnA,true)
    GUI:SetActive(self.view.SkillBtnB,false)
end

function this:ShowSkillIcon()
    ---@type number[]
    local showSkills = SL:GetMetaValue(EMetaVarGetKey.SKILL_SHOW_LIST)

    local maxIdx = self.curShowType == ESkillType.All and 7 or 8

    for i = 1, maxIdx do
        local spriteName = ""
        local skillId = showSkills[i]
        if skillId > 0 then
            ---@type Skill
            local skill = SL:GetMetaValue(EMetaVarGetKey.SKILL_DATA, skillId)

            if skill then
                ---@type cfg_skill_info_column
                local tbl = SL:GetConfigMultiKeys('cfg_skill_info', skillId, skill.level, 'skillID', 'skillLevel')
                spriteName = string.isNullOrEmpty(tbl.icon) and "" or tbl.icon
            end
            GUI:setVisible(self.view["addIcon" ..i],false)
        else
            GUI:setVisible(self.view["addIcon" ..i],true)
        end

        local key = self.curShowType == ESkillType.All and "AllSkillIcon" or "TurnSkillIcon"
        GUI:Image_loadTexture(self.view[key .. i], spriteName, "Atlas/UIOutSkillIcon.spriteatlas")
        
        --key = self.curShowType == ESkillType.All and "TogAllSkill" or "TogTurnSkill"
        --self.view["TogTurnSkill" .. i]:SetTogIsOn(false)
    end

end

function this:TogShowAllValueChange(_, _, args)
    if args[1] then
        GUI:setVisible(self.view.BodyAllSkill, true)
        GUI:setVisible(self.view.BodyTurnSkill, false)
        self.curShowType = ESkillType.All
        SL:SetMetaValue(EMetaVarSetKey.SKILL_SETTING_SHOW_TYPE, self.curShowType)
        self.curSelectIndex = nil
        self:ShowSkillIcon()
    end

end

function this:TogTurnValueChange(_, _, args)
    if args[1] then
        GUI:setVisible(self.view.BodyAllSkill, false)
        GUI:setVisible(self.view.BodyTurnSkill, true)
        self.curShowType = ESkillType.Turn
        SL:SetMetaValue(EMetaVarSetKey.SKILL_SETTING_SHOW_TYPE, self.curShowType)
        self.curSelectIndex = nil
        self:ShowSkillIcon()
    end
end

function this:TogPatternChange(_, _, args)
    if args[1] then
        GUI:setVisible(self.view.BodyAllSkill, false)
     
        GUI:setVisible(self.view.BodyTurnSkill, true)
        GUI:Text_setTextColor(self.view.BtnTurnTxt, "#FFFFFF")
        GUI:Text_setTextColor(self.view.BtnAllTxt, "#AEAFB0")
        GUI:SetActive(self.view.btnTurnMask,true)
        GUI:SetActive(self.view.btnAllMask,true)
        self.curShowType = ESkillType.Turn
        SL:SetMetaValue(EMetaVarSetKey.SKILL_SETTING_SHOW_TYPE, self.curShowType)
        self.curSelectIndex = nil
        self:ShowSkillIcon()
    else
        GUI:SetActive(self.view.btnTurnMask,true)
        GUI:SetActive(self.view.btnAllMask,true)
        GUI:setVisible(self.view.BodyAllSkill, true)
        GUI:setVisible(self.view.BodyTurnSkill, false)
        GUI:Text_setTextColor(self.view.BtnAllTxt, "#FFFFFF")
        GUI:Text_setTextColor(self.view.BtnTurnTxt, "#AEAFB0")
        self.curShowType = ESkillType.All
        SL:SetMetaValue(EMetaVarSetKey.SKILL_SETTING_SHOW_TYPE, self.curShowType)
        self.curSelectIndex = nil
        self:ShowSkillIcon()
    end
end

function this:InitShortcutAfter()
    local fastItemList = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    self.fastItemIds = table.copyFrom({}, fastItemList)
    if not SL:HasConfig("cfg_item", self.fastItemIds[1]) then
        self.fastItemIds[1] = InfoManager.mainUIInfo.mpShowModeItemId
    end
    if not SL:HasConfig("cfg_item", self.fastItemIds[2]) then
        self.fastItemIds[2] = InfoManager.mainUIInfo.hpShowModeItemId
    end
    table.remove(self.fastItemIds,5)
    GUI:DataListUpdateData(self.view.FastItemDataList)
end

function this:IsExistFastItem(cfgId)
    ---@type number[]
    local fastItems = SL:GetMetaValue(EMetaVarGetKey.FAST_ITEM_ID_LIST)
    return table.contains(fastItems, cfgId)
end

function this:Close()
    self.curSettingType = nil
    SL:SetMetaValue(EMetaVarSetKey.SKILL_SETTING_SHOW_TYPE, self.curShowType)
    SL.UploadSkillSettingData()
    SL:onLUAEvent(LUA_EVENT_REFRESH_ATTACK_SKILL)    
end

return this
