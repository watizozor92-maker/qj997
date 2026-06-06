---@class KLNPCShopTipPanel:UIKmlLuaPanelBase
---@field view KLNPCShopTipPanelView
local KLNPCShopTipPanel = class(UIKmlLuaPanelBase)
local this =KLNPCShopTipPanel
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.bg,self,function()
        GUI:UIPanel_Close("dev/ui/NPC/Panel/KLNPCShopTip/KLNPCShopTipPanel")
    end )
    GUI:AddOnClickEvent(self.view.close_btn,self,function()
        GUI:UIPanel_Close("dev/ui/NPC/Panel/KLNPCShopTip/KLNPCShopTipPanel")
    end )
end

function this:Close()
end

return this
