---@class KLSurePanel:UIKmlLuaPanelBase
---@field view KLSurePanelView
local KLSurePanel = class(UIKmlLuaPanelBase)
local this =KLSurePanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:Text_setString(self.view.ContentTxt,self.args.content or "")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.okBtn,self,self.OnClickOkBtn)
    GUI:AddOnClickEvent(self.view.cancelBtn,self,self.OnClickCloseBtn)
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnClickCloseBtn)
end

function this:OnClickOkBtn()
    if self.args.okFunc then
        self.args.okFunc()
    end
end

function this:OnClickCloseBtn()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLSure/KLSurePanel")
end

function this:Close()
end

return this
