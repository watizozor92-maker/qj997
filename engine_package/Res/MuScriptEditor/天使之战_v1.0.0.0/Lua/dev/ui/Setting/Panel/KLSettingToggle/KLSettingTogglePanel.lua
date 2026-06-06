---@class KLSettingTogglePanel:UIKmlLuaPanelBase
---@field view KLSettingTogglePanelView
local KLSettingTogglePanel = class(UIKmlLuaPanelBase)
local this = KLSettingTogglePanel
---创建时调用一次
function this:Init()
    this.BasicPanelPath = ""
    this.BasicPanelPath = "dev/ui/Setting/Panel/KLBasic/KLBasicPanel"   
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if not self.args or (self.args == ESettingType.BasicTog) then
        GUI:SetIsOnWithoutNotify(self.view.basicSettingToggle, true)
        GUI:UIPanel_Open(this.BasicPanelPath)
    elseif self.args == ESettingType.OnHookTog then
        GUI:SetIsOnWithoutNotify(self.view.hookSettingToggle, true)
        GUI:UIPanel_Open("dev/ui/Setting/Panel/KLHook/KLHookPanel")
    elseif self.args == ESettingType.DiaplayTog then
        GUI:SetIsOnWithoutNotify(self.view.showSettingToggle, true)
        GUI:UIPanel_Open("dev/ui/Setting/Panel/KLDisplay/KLDisplayPanel")
    elseif self.args == ESettingType.PickUpTog then
        GUI:SetIsOnWithoutNotify(self.view.pickUpSettingToggle, true)
        GUI:UIPanel_Open("dev/ui/Setting/Panel/KLPickUp/KLPickUpPanel")
    end
    if SL:GetIsWebGL() then
        GUI:setPositionX(self.view.closeBtn,-39)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.basicSettingToggle, self, self.BasicSettingOnValueChange)
    --GUI:SetToggleOnValueChange(self.view.hookSettingToggle, self, self.HookSettingOnValueChange)
    --GUI:SetToggleOnValueChange(self.view.pickUpSettingToggle, self, self.PickUpSettingOnValueChange)
    GUI:SetToggleOnValueChange(self.view.showSettingToggle, self, self.ShowSettingOnValueChange)
    --GUI:SetToggleOnValueChange(self.view.codeToggle, self, self.CodeOnValueChange)
    GUI:SetToggleOnValueChange(self.view.inviteFriendToggle, self, self.InviteFriendOnValueChange)
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseOnClick)
    GUI:AddOnClickEvent(self.view.btn_changeRole, self, self.BtnRoleChoseOnClick)
    GUI:AddOnClickEvent(self.view.btn_exitGame, self, self.BtnExitGameOnClick)
    GUI:AddOnTouchEvent(self.view.text3 , self, self.OnTouchEvent)
end

local clickCounter = 0
local lastClickTime = 0
local clickDelta = 2

---@param kmlCtrl UIKmlLuaControl
---@param eventType EUIEventName
function this:OnTouchEvent(kmlCtrl, eventType, args)
    if eventType == EUIEventName.onDoublePointerClick then
        if Time.time - lastClickTime > clickDelta then
            clickCounter = 0
        end
        lastClickTime = Time.time
        clickCounter = clickCounter + 1

        if clickCounter == 3 then
            clickCounter = 0
            self:CloseOnClick()
            SL.UIManager:ShowNotHideUI("UIGMPanel")
        end
    end
end

function this:BasicSettingOnValueChange(control, _, data)
    local isToggle = data[1]
    if isToggle then
        GUI:UIPanel_Open(this.BasicPanelPath)
    else
        GUI:UIPanel_Close(this.BasicPanelPath)
    end
end

function this:HookSettingOnValueChange(control, _, data)
    local isToggle = data[1]
    if isToggle then
        GUI:UIPanel_Open("dev/ui/Setting/Panel/KLHook/KLHookPanel")
    else
        GUI:UIPanel_Close("dev/ui/Setting/Panel/KLHook/KLHookPanel")
    end
end

function this:PickUpSettingOnValueChange(control, _, data)
    local isToggle = data[1]
    if isToggle then
        GUI:UIPanel_Open("dev/ui/Setting/Panel/KLPickUp/KLPickUpPanel")
    else
        GUI:UIPanel_Close("dev/ui/Setting/Panel/KLPickUp/KLPickUpPanel")
    end
end

function this:ShowSettingOnValueChange(control, _, data)
    local isToggle = data[1]
    if isToggle then
        GUI:UIPanel_Open("dev/ui/Setting/Panel/KLDisplay/KLDisplayPanel")
    else
        GUI:UIPanel_Close("dev/ui/Setting/Panel/KLDisplay/KLDisplayPanel")
    end
end

function this:CodeOnValueChange(control, _, data)
    local isToggle = data[1]
    if isToggle then
        GUI:UIPanel_Open("dev/ui/Setting/Panel/KLCode/KLCodePanel")
    else
        GUI:UIPanel_Close("dev/ui/Setting/Panel/KLCode/KLCodePanel")
    end
end

function this:InviteFriendOnValueChange(control, _, data)
    local isToggle = data[1]
    if isToggle then
        GUI:UIPanel_Open("dev/ui/Setting/Panel/KLInViteFriend/KLInViteFriendPanel")
    else
        GUI:UIPanel_Close("dev/ui/Setting/Panel/KLInViteFriend/KLInViteFriendPanel")
    end
end

function this:CloseOnClick()
    
    GUI:UIPanel_Close(this.BasicPanelPath)

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLHook/KLHookPanel")

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLPickUp/KLPickUpPanel")

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLDisplay/KLDisplayPanel")

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLCode/KLCodePanel")

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLInViteFriend/KLInViteFriendPanel")

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLSettingToggle/KLSettingTogglePanel")
end

function this:Close()
    SL:onLUAEvent(LUA_EVENT_MAIN_UI_BOTTOM_SYSTEM_CLOSE)
    GUI:UIPanel_Close(this.BasicPanelPath)

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLHook/KLHookPanel")

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLPickUp/KLPickUpPanel")

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLDisplay/KLDisplayPanel")

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLCode/KLCodePanel")

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLInViteFriend/KLInViteFriendPanel")

    GUI:UIPanel_Close("dev/ui/Setting/Panel/KLSettingToggle/KLSettingTogglePanel")
end

function this:BtnRoleChoseOnClick()
    SL:QuitSelectRoleUI()
end

function this:BtnExitGameOnClick()
    if SL.LoginInfo:IsSDK()then
        if SL.Main.IsWindows() then
            SL:QuitGame()
        else
            if SL.LoginInfo:IsOutSDK() then
                MuInterface.Instance:LogoutAccount()
            else
                SL:QuitGame()
            end
        end
    else
        SL:QuitGame()
    end
end


return this
