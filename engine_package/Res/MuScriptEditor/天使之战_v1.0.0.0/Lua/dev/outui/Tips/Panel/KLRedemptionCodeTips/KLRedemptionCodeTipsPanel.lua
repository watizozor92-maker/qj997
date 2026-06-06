---@class KLRedemptionCodeTipsPanel:UIKmlLuaPanelBase
---@field view KLRedemptionCodeTipsPanelView
local KLRedemptionCodeTipsPanel = class(UIKmlLuaPanelBase)
local this =KLRedemptionCodeTipsPanel -- 兑换码弹窗面板

---创建时调用一次
function this:Init()
    SL:HideMainPanel()
    self.isInputPlaceCleared = false
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
    GUI:AddOnTouchEvent(self.view.input, self, self.OnInputClick)
    GUI:Input_SetOnEndEdit(self.view.input, self, self.UseCDK)
    GUI:Input_SetOnValueChange(self.view.input, self, self.UseCDKOnValue)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Hide()
end

function this:Close()
    SL:ShowMainPanel()
end

function this:UseCDKOnValue(_, _, eventData)
    local messageStr = eventData[1]
    if string.contains(messageStr, '\n') then
        GUI:SetInputText(self.view.input, string.replace(messageStr, '\n'))
        self:UseCDK()
    end
end

function this:OnInputClick(_, eventType, systemData)
    if eventType ~= EUIEventName.OnPointerDown then
        return
    end

    if systemData and systemData.button and systemData.button ~= InputButton.Left then
        return
    end

    if self.isInputPlaceCleared then
        return
    end
    self.isInputPlaceCleared = true
    GUI:SetAttr(self.view.input, "place", "")
end

function this:UseCDK()
    local cdk = GUI:GetInputText(self.view.input)
    if string.isNullOrEmpty(cdk) then
        SL:TipMessage("请输入兑换码", 1, NoticeType.NoticeMid)
        return
    end
    SL:ReqCdKeyMessage(cdk)
end

function this:CloseSelf()
    GUI:UIPanel_Close(self.filePath)
end

return this
