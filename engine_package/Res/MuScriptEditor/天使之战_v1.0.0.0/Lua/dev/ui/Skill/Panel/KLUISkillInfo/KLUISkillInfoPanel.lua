---@class KLUISkillInfoPanel:UIKmlLuaPanelBase
---@field skillData number[][]
---@field curSelectId number @当前选中的技能id
---@field isOpenSetting boolean
local KLUISkillInfoPanel = class(UIKmlLuaPanelBase)
local this = KLUISkillInfoPanel
local onePageCount = 12
---创建时调用一次
function this:Init()
    GUI:DataListInitData(self.view.loopscrollviewData,
            function()
                return #self.skillData
            end,
            function(realIndex)
                return self:ItemGetFunc(realIndex)
            end,
            nil,
            function(realIndex, kmlCtrl)
                return self:ItemUpdateFunc(realIndex, kmlCtrl)
            end)

    GUI:DataListInitData(self.view.pageData,
            function()
                return #self.skillData
            end,
            nil,
            nil,
            function(realIndex, kmlCtrl)
                return self:PageItemUpdateFunc(realIndex, kmlCtrl)
            end)

    GUI:DataListInitData(self.view.transfer_datalist,
            function()
                return #self.tranferSkill
            end,
            nil,
            nil,
            function(realIndex, kmlCtrl)
                return self:TransferSkillsUpdateFunc(realIndex, kmlCtrl)
            end)

    self.skillData = {}
    ---@type table<KingML.KmlControl,KLUISkillPageItem>
    self.skillItems = {}
    self.tranferSkill = {}
    GUI:setScale(self.view.listMask,1)
end

function this:ItemGetFunc()
    ---@type KLUISkillPageItem
    local item = GUI:UIPanel_Open("dev/ui/Skill/Item/KLUISkillPage/KLUISkillPageItem", self.view.loopscrollviewData, self, nil, true)

    local kmlCtrl = item.view.root
    self.skillItems[kmlCtrl] = item
    return kmlCtrl
end

---@param kmlCtrl KingML.KmlControl
function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local item = self.skillItems[kmlCtrl]

    local luaIndex = realIndex + 1
    item:UpdateUI(self.skillData[luaIndex])

end

function this:PageItemUpdateFunc(realIndex)
    local pageLuaCtrl = GUI:GetChildControl(self.view.pageData, realIndex, 'pageImg')

    if realIndex == self.curPage then
        if self.lastLuaCtrl then
            GUI:Image_loadTexture(self.lastLuaCtrl, "img_page", "Atlas/UISkillPanel.spriteatlas")
        end

        GUI:Image_loadTexture(pageLuaCtrl, "img_page_select", "Atlas/UISkillPanel.spriteatlas")
        self.lastLuaCtrl = pageLuaCtrl
    end
end

function this:TransferSkillsUpdateFunc(realIndex)
    local info = self.tranferSkill[realIndex + 1]
    local btn = GUI:GetChildControl(self.view.transfer_datalist, realIndex, "btn_shift")
    local img = GUI:GetChildControl(self.view.transfer_datalist, realIndex, "img_shift_icon")
    local icon = InfoManager.shapeShiftCardInfo:GetMonsterIcon(info.group)
    GUI:Image_loadTexture(img, icon, "Atlas/UIbianshentb.spriteatlas")
    GUI:AddOnClickEvent(btn, self, self.OnClickTransferSkill, realIndex + 1)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    SL.HideMainPanel()
    self.skillShowType = E_SkillShowType.Normal
    ---@type UnityEngine.UI.Mask
    local maskComp = GUI:AddMask(self.view.listMask)
    maskComp.showMaskGraphic = false
    GUI:AddUIEmpty4Raycast(self.view.loopscrollview)

    local rPage = self.args or ESkillUIShowPage.Describe

    if rPage == ESkillUIShowPage.Describe then
        self.isOpenSetting = true
    elseif rPage == ESkillUIShowPage.Setting then
        self.isOpenSetting = false
    end
    
    table.clear(self.skillData)
    local skillList = SL:GetMetaValue(EMetaVarGetKey.SKILL_ID_LIST_DATA)

    for i = 1, #skillList do
        local pageIdx = math.ceil(i / onePageCount)
        if not self.skillData[pageIdx] then
            self.skillData[pageIdx] = {}
        end

        table.insert(self.skillData[pageIdx], skillList[i])
    end
    
    self.curSelectId = self.curSelectId or self.skillData[1][1]
    self:SettingOnClick()
    GUI:DataListUpdateData(self.view.loopscrollviewData)
    self.curPage = 0
    GUI:DataListUpdateData(self.view.pageData)
    self:RefreshTransferSkill()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.BtnSkillSetting, self, self.BtnSettingOnClick)
    GUI:AddOnClickEvent(self.view.btn_shift, self, self.BtnShapeShiftOnClick)

    SL:RegisterLUAEvent(LUA_EVENT_SELECT_SKILL_UI, self.SelectSkill, self)
    GUI:AddOnTouchEvent(self.view.loopscrollview, self, self.OnTouchEvent)
end

---@param eventType string
function this:OnTouchEvent(_, eventType, args)
    if not self.view then
        return
    end
    if eventType == EUIEventName.OnBeginDrag then
        self.beginPosX = GUI:getPositionX(self.view.loopscrollview)
    elseif eventType == EUIEventName.OnDrag then
        if not self.beginPosX then
            self.beginPosX = GUI:getPositionX(self.view.loopscrollview)
        end
        self.beginPosX = self.beginPosX + args.delta.x
        local minX = (#self.skillData - 1) * 360
        self.beginPosX = Mathf.Clamp(self.beginPosX, -minX, 0)

        GUI:setPositionX(self.view.loopscrollview, self.beginPosX)
        self.isToUpper = args.delta.x < 0
    elseif eventType == EUIEventName.OnEndDrag then
        if self.isToUpper then
            self.curPage = math.ceil(-self.beginPosX / 360)
        else
            self.curPage = math.floor(-self.beginPosX / 360)
        end

        self.curPage = Mathf.Clamp(self.curPage, 0, #self.skillData - 1)
        local targetX = -360 * self.curPage
        if self.doAnchor then
            GUI:DOKill(self.doAnchor)
            self.doAnchor = nil
        end

        self.doAnchor = GUI:DOAnchorPosX(self.view.loopscrollview, targetX, 0.3)
        GUI:TweenSetOnComplete(self.doAnchor,function()
            self.doAnchor = nil
        end)
        GUI:DataListUpdateData(self.view.pageData)

    end
end

---@param skillItem KLUISkillItem
function this:SelectSkill(_, skillItem)
    self.skillItem = skillItem
    self.curSelectId = skillItem.skillId
    self.curSelectIndex = skillItem.luaIndex
end

function this:RefreshTransferSkill()
    self.isTransferShow = false
    local info = InfoManager.shapeShiftCardInfo.shiftSkill
    if table.count(info) == 0 then
        GUI:setVisible(self.view.shapeShiftRoot, false)
    else
        self.tranferSkill = {}
        GUI:setVisible(self.view.shapeShiftRoot, true)
        for _, v in pairs(info) do
            self.tranferSkill[#self.tranferSkill + 1] = v
        end
        GUI:DataListUpdateData(self.view.transfer_datalist)
        GUI:setVisible(self.view.layout_transfer_skill, false)
    end
end

function this:OnClickTransferSkill(_, eventData)
    self.curSelectIndex = nil
    self.skillShowType = E_SkillShowType.Transfer
    local info = self.tranferSkill[eventData]
    table.clear(self.skillData)
    local allSkill = {}
    for i, v in pairs(info.allSkill) do
        ---策划需求排除普攻
        if v.group ~= 4 then
            allSkill[i] = v
        end
    end
    local index = 1
    for i, _ in pairs(allSkill) do
        local pageIdx = math.ceil(index / 9)
        if not self.skillData[pageIdx] then
            self.skillData[pageIdx] = {}
        end

        table.insert(self.skillData[pageIdx], i)
        index = index + 1
    end

    GUI:SetActive(self.view.BtnSkillSetting, false)
    if self.isOpenSetting then
        self.isOpenSetting = false
        GUI:ToggleGroup_AllowSwitChoff(self.view.SkillTogGroup,false)
        GUI:UIPanel_Open("dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanel")
        GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanel")
    end
    GUI:DataListUpdateData(self.view.loopscrollviewData)
    GUI:setPositionX(self.view.loopscrollview, 0)
    self.curPage = 0
    GUI:DataListUpdateData(self.view.pageData)
end

function this:BtnSettingOnClick()
    return self:SettingOnClick(true)
end

function this:BtnShapeShiftOnClick()
    if self.isTransferShow then
        GUI:setVisible(self.view.img_shift_bg, false)
        GUI:setVisible(self.view.layout_transfer_skill, false)
        self.isTransferShow = false
        if self.skillShowType == E_SkillShowType.Normal then
            return
        end
        self.curSelectIndex = nil
        self.skillShowType = E_SkillShowType.Normal
        --self:SettingOnClick()
        table.clear(self.skillData)
        local skillList = SL:GetMetaValue(EMetaVarGetKey.SKILL_ID_LIST_DATA)

        for i = 1, #skillList do
            local pageIdx = math.ceil(i / onePageCount)
            if not self.skillData[pageIdx] then
                self.skillData[pageIdx] = {}
            end

            table.insert(self.skillData[pageIdx], skillList[i])
        end

        GUI:DataListUpdateData(self.view.loopscrollviewData)
        self.curPage = 0
        GUI:DataListUpdateData(self.view.pageData)
    else
        GUI:setVisible(self.view.img_shift_bg, true)
        GUI:setVisible(self.view.layout_transfer_skill, true)
        self.isTransferShow = true
    end
end

function this:RefreshNormalSkillPanel()
    if self.skillShowType ~= E_SkillShowType.Normal then
        self:BtnShapeShiftOnClick()
    end
    self:RefreshTransferSkill()
end

function this:SettingOnClick(isClick)
    if self.isOpenSetting then
        self.isOpenSetting = false
        GUI:ToggleGroup_AllowSwitChoff(self.view.SkillTogGroup, false)
        GUI:UIPanel_Open("dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanel", nil, nil, { skillId = self.curSelectId, baseUI = self })
        GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanel")
        if self.skillItem then
            self.skillItem:SetTogDefaultThis()
        elseif isClick then
            self.curSelectIndex = nil
            GUI:DataListUpdateData(self.view.loopscrollviewData)
        end
    else
        self.isOpenSetting = true
        GUI:ToggleGroup_AllowSwitChoff(self.view.SkillTogGroup, true)
        if self.skillItem then
            self.skillItem:SetTogIsOn(false)
        end
        GUI:UIPanel_Open("dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanel", nil, nil, { curSelectId = self.curSelectId })
        GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanel")
    end

end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanel")
    SL.ShowMainPanel()
end

function this:Close()
    SL:onLUAEvent(LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE)
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanel")
    GUI:UIPanel_Close("dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanel")
    SL.ShowMainPanel()
    self.skillItem = nil
    self.curSelectIndex = nil
    self.curSelectId = nil
    if self.doAnchor then
        GUI:DOKill(self.doAnchor)
        self.doAnchor = nil
    end
end

return this
