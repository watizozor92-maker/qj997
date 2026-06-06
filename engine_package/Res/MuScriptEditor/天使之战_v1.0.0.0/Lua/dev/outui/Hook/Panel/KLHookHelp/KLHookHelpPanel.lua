---@class KLHookHelpPanel:UIKmlLuaPanelBase
---@field view KLHookHelpPanelView
local KLHookHelpPanel = class(UIKmlLuaPanelBase)
local this =KLHookHelpPanel

EToggleType = {
    KillMonster = 1,
    PickUp = 2,
}
---创建时调用一次
function this:Init()
    SL.HideMainPanel()
    self.type = EToggleType.KillMonster
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.KillMonsterToggle,self,self.KillMonsterToggleOnValueChange)
    GUI:SetToggleOnValueChange(self.view.PickUpToggle,self,self.PickUpToggleOnValueChange)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.ClosePanel)
    GUI:AddOnClickEvent(self.view.btn_save,self,self.Save)
    GUI:AddOnClickEvent(self.view.btn_cancel,self,self.Cancel)
end

function this:ClosePanel()
    GUI:UIPanel_Close(self.filePath)
end
function this:Save()
    if self.type == EToggleType.KillMonster then
        ---@type KLKillMonsterSettingPanel
        local panel = GUI:GetUI("dev/outui/Hook/Panel/KLKillMonsterSetting/KLKillMonsterSettingPanel")
        panel:Save()
    elseif self.type == EToggleType.PickUp then
        ---@type KLPickUpPanel
        local panel = GUI:GetUI("dev/outui/Hook/Panel/KLPickupSetting/KLPickupSettingPanel")
        panel:Save()
    end
end

function this:Cancel()
    self:ClosePanel()
end

function this:KillMonsterToggleOnValueChange(control,data,eventData)
    local isOn = eventData[1]
    if isOn then
        self.type = EToggleType.KillMonster
        GUI:UIPanel_Close("dev/outui/Hook/Panel/KLPickupSetting/KLPickupSettingPanel")
        GUI:UIPanel_Open("dev/outui/Hook/Panel/KLKillMonsterSetting/KLKillMonsterSettingPanel",self.view.TempRoot)
    end
end

function this:PickUpToggleOnValueChange(control,data,eventData)
    local isOn = eventData[1]
    if isOn then
        self.type = EToggleType.PickUp
        GUI:UIPanel_Close("dev/outui/Hook/Panel/KLKillMonsterSetting/KLKillMonsterSettingPanel")
        GUI:UIPanel_Open("dev/outui/Hook/Panel/KLPickupSetting/KLPickupSettingPanel",self.view.TempRoot)
    end
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:SetTogDefaultThis(self.view.KillMonsterToggle)
end

function this:Hide()
end

function this:Close()
    GUI:UIPanel_Close("dev/outui/Hook/Panel/KLKillMonsterSetting/KLKillMonsterSettingPanel")
    GUI:UIPanel_Close("dev/outui/Hook/Panel/KLPickupSetting/KLPickupSettingPanel")
    SL.ShowMainPanel()
end

return this
