---@class KLDescribeDetailPanel:UIKmlLuaPanelBase
---@field view KLDescribeDetailPanelView
local KLDescribeDetailPanel = class(UIKmlLuaPanelBase)
local this =KLDescribeDetailPanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
--[[    if SL:GetIsWebGL() then
        GUI:setPositionX(self.view.closeBtn,-292)
    end]]
    GUI:Button_setTitleText(self.view.title,self.args.title)
    GUI:Button_setTitleText(self.view.ContentTxt,self.args.content)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn,self,self.OnCliCkCloseBtn)
    GUI:AddOnClickEvent(self.view.bg1,self,self.OnCliCkCloseBtn)
end

function this:OnCliCkCloseBtn()
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLDescribeDetail/KLDescribeDetailPanel")
end

function this:Close()
end

return this
