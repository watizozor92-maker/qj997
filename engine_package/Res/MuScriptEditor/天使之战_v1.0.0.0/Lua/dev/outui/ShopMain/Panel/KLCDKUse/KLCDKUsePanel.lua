---@class KLCDKUsePanel:UIKmlLuaPanelBase
---@field view KLCDKUsePanelView
local KLCDKUsePanel = class(UIKmlLuaPanelBase)
local this =KLCDKUsePanel

---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Btn_Close, self, self.OnClick_Btn_Close)
    GUI:AddOnClickEvent(self.view.CloseBtn, self, self.OnClick_Btn_Close)
    GUI:AddOnClickEvent(self.view.Btn_Confirm, self, self.OnClick_Btn_Confirm)
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
    SL.ShowMainPanel()
end

---关闭按钮
function this:OnClick_Btn_Close()
    GUI:UIPanel_Close("dev/outui/ShopMain/Panel/KLCDKUse/KLCDKUsePanel")
end

---点击确认按钮
function this:OnClick_Btn_Confirm()
    local cdk = GUI:GetInputText(self.view.Input_CDK)
    if string.isNullOrEmpty(cdk) then
        SL:TipMessage("请输入兑换码", 1, NoticeType.NoticeMid)
        return
    end
    SL:ReqCdKeyMessage(cdk)
end

return this
