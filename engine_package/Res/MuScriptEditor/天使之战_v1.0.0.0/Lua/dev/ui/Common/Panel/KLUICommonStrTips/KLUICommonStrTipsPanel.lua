---@class KLUICommonStrTipsPanel:UIKmlLuaPanelBase
---@field view KLUICommonTipsPanelView
local KLUICommonStrTipsPanel = class(UIKmlLuaPanelBase)
local this =KLUICommonStrTipsPanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setString(self.view.tipContent,(self.args and self.args.str) or "")
    GUI:Text_setString(self.view.txt_title,(self.args and self.args.title) or "")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.CloseSelf)
    GUI:AddOnClickEvent(self.view.MaskCloseButton,self,self.CloseSelf)
end

function this:CloseSelf()
    GUI:UIPanel_Close('dev/ui/Common/Panel/KLUICommonStrTips/KLUICommonStrTipsPanel')
end


function this:Close()
end

return this
