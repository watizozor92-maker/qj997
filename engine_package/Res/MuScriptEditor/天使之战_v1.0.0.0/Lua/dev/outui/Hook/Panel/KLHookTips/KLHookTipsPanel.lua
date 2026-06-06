---@class KLHookTipsPanel:UIKmlLuaPanelBase
---@field view KLHookTipsPanelView
local KLHookTipsPanel = class(UIKmlLuaPanelBase)
local this = KLHookTipsPanel

---创建时调用一次
function this:Init()

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseSelf)
    GUI:AddOnClickEvent(self.view.MaskCloseButton, self, self.CloseSelf)
end

---界面显示时调用一次
function this:Show()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setString(self.view.tipContent, (self.args and self.args.str) or "")
    GUI:Text_setString(self.view.txt_title, (self.args and self.args.title) or "")
end

function this:CloseSelf()
    GUI:UIPanel_Close('dev/outui/Hook/Panel/KLHookTips/KLHookTipsPanel')
end

function this:Hide()
end

function this:Close()
end

return this
