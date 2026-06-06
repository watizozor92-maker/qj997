---@class KLMonthCardBuyTipPanel:UIKmlLuaPanelBase
---@field view KLMonthCardBuyTipPanelView
local KLMonthCardBuyTipPanel = class(UIKmlLuaPanelBase)
local this =KLMonthCardBuyTipPanel
function this:AsyncLoadUI()
end
---创建时调用一次
function this:Init()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close,self,self.BtnCloseClick)
end

function this:BtnCloseClick()
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLMonthCardBuyTip/KLMonthCardBuyTipPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTipsComparsion/KLUIEquipTipsComparsionPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
end

return this
