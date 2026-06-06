---@class KLUIMonthCardMainPanel:UIKmlLuaPanelBase
---@field view KLUIMonthCardMainPanelView
local KLUIMonthCardMainPanel = class(UIKmlLuaPanelBase)
local this =KLUIMonthCardMainPanel
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    local isHaveMonthCard = InfoManager.monthCardInfo:IsHaveMonthCardRights("privilege")
    if isHaveMonthCard then
        if self.args and self.args.type == "privilege" then
            GUI:Toggle_setIsOn(self.view.PrivilegeToggle,true)
        else
            GUI:Toggle_setIsOn(self.view.MonthCardToggle,true)
        end
    else
        GUI:Toggle_setIsOn(self.view.MonthCardToggle,true)
    end
  
    if not InfoManager.monthCardInfo:IsHaveMonthCardRights("privilege") then ---未开通月卡不显示特权按钮
        GUI:SetActive(self.view.PrivilegeToggle,false)
    else
        GUI:SetActive(self.view.PrivilegeToggle,true)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.MonthCardToggle, self, self.MonthCardToggle)
    GUI:SetToggleOnValueChange(self.view.PrivilegeToggle, self, self.PrivilegeToggle)
    GUI:AddOnClickEvent(self.view.CloseBtn, self, self.CloseBtnOnClick)
end
function this:MonthCardToggle(control, eventData)
    if GUI:Toggle_getIsOn(control) == "1" then
        GUI:SetActive(self.view.monthCardBg,true)
        GUI:SetActive(self.view.PrivigeBg,false)
        GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLUIMonthCard/KLUIMonthCardPanel")
        GUI:UIPanel_Close("dev/outui/Privilege/Panel/KLUIPrivilege/KLUIPrivilegePanel")
        GUI:Image_loadTexture(self.view.img_toggle_month_card, "img_yk_text_2", "Atlas/KLUIPrivilegePanel.spriteatlas")
    else
        GUI:Image_loadTexture(self.view.img_toggle_month_card, "img_yk_text_1", "Atlas/KLUIPrivilegePanel.spriteatlas")
    end
end
function this:PrivilegeToggle(control, eventData)
    if GUI:Toggle_getIsOn(control) == "1" then
        GUI:SetActive(self.view.monthCardBg,false)
        GUI:SetActive(self.view.PrivigeBg,true)
        GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCard/KLUIMonthCardPanel")
        GUI:UIPanel_Open("dev/outui/Privilege/Panel/KLUIPrivilege/KLUIPrivilegePanel")
        GUI:Image_loadTexture(self.view.img_toggle_privilege, "img_tq_text_2", "Atlas/KLUIPrivilegePanel.spriteatlas")
    else
        GUI:Image_loadTexture(self.view.img_toggle_privilege, "img_tq_text_1", "Atlas/KLUIPrivilegePanel.spriteatlas")
    end
end
function this:CloseBtnOnClick()
    GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
end
function this:CloseAllSubPanel()
    GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel")
    GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCard/KLUIMonthCardPanel")
    GUI:UIPanel_Close("dev/outui/Privilege/Panel/KLUIPrivilege/KLUIPrivilegePanel")
end
function this:Close()
    SL:ShowMainPanel()
    self:CloseAllSubPanel()
end

return this
