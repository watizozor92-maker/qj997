---@class KLUIMasterTalentMainPanel:UIKmlLuaPanelBase
---@field view KLUIMasterTalentMainPanelView
---@field togList table<number,{cfg:cfg_system_switch_column,type:number}>
local KLUIMasterTalentMainPanel = class(UIKmlLuaPanelBase)
local this = KLUIMasterTalentMainPanel
---创建时调用一次
function this:Init()

    ---是否是第一次打开界面
    self.isFirstOpen = true

    GUI:DataListInitData(self.view.TitleDatalist, function()
        return self:TitleDatalistItemCountFunc()
    end, function(realIndex)
        return self:TitleDatalistItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        return self:TitleDatalistItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:TitleDatalistItemUpdateFunc(realIndex, kmlcontrol)
    end)
    self:GetTogList()
end

---获取页签
function this:GetTogList()
    self.togList = {}
    for i, v in pairs(EMasterTalentType) do
        ---@type cfg_system_switch_column
        local cfg = SL:GetConfig("cfg_system_switch", EMasterTalentSystemSwitchID[v])
        if SL:GetMetaValue(EMetaVarGetKey.IS_OPEN_SYSTEMFUNCTION, cfg.systemName) then
            table.insert(self.togList, { cfg = cfg, type = v })
        end
    end
    table.sort(self.togList, function(a, b)
        return EMasterTalentSortType[a.type] < EMasterTalentSortType[b.type]
    end)
    GUI:DataListUpdateData(self.view.TitleDatalist)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.OnClickCloseButton)
    GUI:AddOnClickEvent(self.view.Mask, self, self.OnClickCloseButton)

    SL:RegisterLUAEvent(LUA_EVENT_MASTER_RED_DOT_CHANGE, self.LUA_EVENT_MASTER_RED_DOT_CHANGE, self)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:OnClickCloseButton()
    ---判断一下职业天赋是否启用
    if self.openPanel
            and self.openPanel == EMasterTalentPanelPath[EMasterTalentType.CAREER]
            and InfoManager.masterTalentInfo:GetNowTypeSelectSeries(EMasterTalentType.CAREER) == 0 then
        SL:CommonTipsMessage({ stringTblID = 215,
                               ui = self,
                               sureBtnText = "确定",
                               cancelBtnText = "取消",
                               cancelCallBack = self.CloseMainPanel })
        return
    end
    self:CloseMainPanel()
end

function this:CloseMainPanel()
    GUI:UIPanel_Close("dev/outui/MasterTalent/Panel/KLUIMasterTalentMain/KLUIMasterTalentMainPanel")
    SL.ShowMainPanel()
end

function this:LUA_EVENT_MASTER_RED_DOT_CHANGE()
    GUI:DataListUpdateData(self.view.TitleDatalist)
end

--------------------------------顶部复选框-------------------------------------------------------
function this:TitleDatalistItemCountFunc()
    return #self.togList
end

function this:TitleDatalistItemGetFunc(realIndex)

end

function this:TitleDatalistItemInitFunc(realIndex, kmlcontrol)

end

function this:TitleDatalistItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.togList[realIndex + 1]
    local _toggle = GUI:GetChildControl(self.view.TitleDatalist, realIndex, 'TitleToggle')
    local _toggleText = GUI:GetChildControl(self.view.TitleDatalist, realIndex, 'TitleToggleText')
    local _toggleRedDot = GUI:GetChildControl(self.view.TitleDatalist, realIndex, 'TitleToggleRedDot')
    GUI:Text_setString(_toggleText, EMasterTalentName[data.type])
    GUI:SetToggleOnValueChange(_toggle, self, self.TitleOnToggle, data)
    GUI:SetActive(_toggleRedDot, InfoManager.masterTalentInfo.RedDataList[data.type])
    if self.isFirstOpen and realIndex == 0 then
        self.isFirstOpen = false
        if GUI:Toggle_getIsOn(_toggle) == "1" then
            self:TitleOnToggle(_toggle, data)
        else
            GUI:Toggle_setIsOn(_toggle, true)
        end
    end
end

---@param control UIKmlLuaControl
---@param eventData {cfg:cfg_system_switch_column,type:number}
function this:TitleOnToggle(control, eventData)
    if GUI:Toggle_getIsOn(control) == "1" then
        GUI:Image_loadTexture(self.view.TalentBG, EMasterTalentPanelBGStr[eventData.type], "")
        self.openPanel = EMasterTalentPanelPath[eventData.type]
        GUI:UIPanel_Open(EMasterTalentPanelPath[eventData.type])
        return
    end
    GUI:UIPanel_Close(EMasterTalentPanelPath[eventData.type])
end

function this:BGChange(src, atlas)
    GUI:Image_loadTexture(self.view.TalentBG, src, atlas)
end

------------------------------------------------------------------------------------------------

function this:Close()
    if self.openPanel and self.openPanel ~= "" then
        GUI:UIPanel_Close(self.openPanel)
    end
end

return this
