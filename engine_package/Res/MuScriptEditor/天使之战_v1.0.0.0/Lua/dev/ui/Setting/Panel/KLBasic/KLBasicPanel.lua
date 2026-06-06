---@class KLBasicPanel:UIKmlLuaPanelBase
---@field view KLBasicPanelView
local KLBasicPanel = class(UIKmlLuaPanelBase)
local this = KLBasicPanel
---创建时调用一次
function this:Init()

end

---创建或者刷新界面数据时调用
function this:Refresh()
    local bgSound = SL:GetMetaValue(EMetaVarGetKey.GET_BACKGROUND_SOUND)
    local soundEffect = SL:GetMetaValue(EMetaVarGetKey.GET_SOUND_EFFECT)
    local voice = SL:GetMetaValue(EMetaVarGetKey.GET_VOICE)
    local rockerType = SL:GetMetaValue(EMetaVarGetKey.GET_ROCKER_TYPE)
    --第一次进游戏没有设置默认勾选
    local clickFloorMove = SL:GetMetaValue(EMetaVarGetKey.GET_CLICK_FLOOR_IS_SELECT)
    GUI:Slider_setPercent(self.view.bgSlider, bgSound)
    GUI:Slider_setPercent(self.view.soundSlider, soundEffect)
    --GUI:Slider_setPercent(self.view.voiceSlider,voice)
    GUI:SetIsOnWithoutNotify(self.view.fixedJoyStick, rockerType == ETickModel.fixed)
    GUI:SetIsOnWithoutNotify(self.view.moveJoyStick, rockerType == ETickModel.Move)
    GUI:SetIsOnWithoutNotify(self.view.clickFloor, clickFloorMove == EScreen.True)
    GUI:setVisible(self.view.icon_autoFix, PrivilegeCardManager.AutoRepair)
    self.barWidth = GUI:GetControlWidth(self.view.bgSlider)
    self.bgBarPointerStartPosX = - (self.barWidth / 2)
    self.soundBarPointerStartPosX = - (self.barWidth / 2)
    local bgBarPointerPosX = self.bgBarPointerStartPosX + self.barWidth * bgSound / 100
    local soundBarPointerPosX = self.soundBarPointerStartPosX + self.barWidth * soundEffect / 100
    GUI:setPositionX(self.view.bgBarPointer, bgBarPointerPosX)
    GUI:setPositionX(self.view.soundBarPointer, soundBarPointerPosX)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.fixedJoyStick, self, self.FixedJoyStickOnValueChange)
    GUI:SetToggleOnValueChange(self.view.moveJoyStick, self, self.MoveJoyStickOnValueChange)
    GUI:SetToggleOnValueChange(self.view.clickFloor, self, self.ClickFloorValueChange)
    GUI:AddOnClickEvent(self.view.BtnLock, self, self.BtnLockOnClick)
    GUI:AddOnClickEvent(self.view.BtnRoleChose, self, self.BtnRoleChoseOnClick)
    GUI:AddOnClickEvent(self.view.BtnExitGame, self, self.BtnExitGameOnClick)
    GUI:AddOnClickEvent(self.view.BtnReDefault, self, self.BtnReDefaultOnClick)
    GUI:SetSliderOnValueChange(self.view.bgSlider, self, self.BgSliderOnValueChange)
    GUI:SetSliderOnValueChange(self.view.soundSlider, self, self.SoundSliderOnValueChange)
    GUI:AddOnClickEvent(self.view.tog_autoFix, self, self.AutoFixOnClick)
    --GUI:SetSliderOnValueChange(self.view.voiceSlider,self,self.VoiceSliderOnValueChange)
    SL:RegisterLUAEvent(LUA_EVENT_AUTO_PAIR_STATE_CHANGE, self.LUA_EVENT_AUTO_PAIR_STATE_CHANGE, self)
end

function this:AutoFixOnClick()
    if PrivilegeCardManager.isAutoRepairOpen() then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_EQUIP_AUTO_REPAIR)
    else
        if not PrivilegeCardManager.AutoRepair then
            SL:OpenCommonTipPanelById(25)
        end
    end
end

function this:LUA_EVENT_AUTO_PAIR_STATE_CHANGE()
    GUI:SetActive(self.view.icon_autoFix, PrivilegeCardManager.AutoRepair)
end


function this:ClickFloorValueChange(control, _, data)
    local isToggle = data[1]
    if isToggle then
        SL:SetMetaValue(EMetaVarSetKey.SET_IS_CLICK_FLOOR_MOVE, EScreen.True)
    else
        SL:SetMetaValue(EMetaVarSetKey.SET_IS_CLICK_FLOOR_MOVE, EScreen.False)
    end
end

function this:FixedJoyStickOnValueChange(control, _, data)
    local isToggle = data[1]
    if isToggle then
        SL:SetMetaValue(EMetaVarSetKey.SET_ROCKER_TYPE, ETickModel.fixed)
    end
end

function this:MoveJoyStickOnValueChange(control, _, data)
    local isToggle = data[1]
    if isToggle then
        SL:SetMetaValue(EMetaVarSetKey.SET_ROCKER_TYPE, ETickModel.Move)
    end
end

function this:BtnLockOnClick()
    GUI:UIPanel_Open("dev/ui/Setting/Panel/KLLock/KLLockPanel")
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

function this:BtnReDefaultOnClick()
    local defaultData = SL:GetDefaultSettingData()
    local defaultClickFloor = defaultData.isSelectClickFloorMove
    local isOn = tonumber(GUI:Toggle_getIsOn(self.view.clickFloor))
    if isOn ~= defaultClickFloor then
        GUI:Toggle_setIsOn(self.view.clickFloor, defaultClickFloor == 1)
    end
    SL:ReplyDefaultBaseSetting()
    self:Refresh()
end

function this:BgSliderOnValueChange(control, _, data)
    local value = math.ceil(data[1])
    SL:SetMetaValue(EMetaVarSetKey.SET_BACKGROUND_SOUND, value)
    local barPointerPosX = self.bgBarPointerStartPosX + self.barWidth * value / 100
    GUI:setPositionX(self.view.bgBarPointer, barPointerPosX)
end

function this:SoundSliderOnValueChange(control, _, data)
    local value = math.ceil(data[1])
    SL:SetMetaValue(EMetaVarSetKey.SET_SOUND_EFFECT, value)
    local barPointerPosX = self.soundBarPointerStartPosX + self.barWidth * value / 100
    GUI:setPositionX(self.view.soundBarPointer, barPointerPosX)
end

function this:VoiceSliderOnValueChange(control, _, data)
    local value = math.ceil(data[1])
    SL:SetMetaValue(EMetaVarSetKey.SET_VOICE, value)
end

function this:Close()
end

return this
