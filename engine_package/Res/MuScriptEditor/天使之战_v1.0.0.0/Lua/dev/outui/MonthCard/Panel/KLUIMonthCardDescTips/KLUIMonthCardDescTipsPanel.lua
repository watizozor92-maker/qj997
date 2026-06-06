---@class KLUIMonthCardDescTipsPanel:UIKmlLuaPanelBase
---@field view KLUIMonthCardDescTipsPanelView
local KLUIMonthCardDescTipsPanel = class(UIKmlLuaPanelBase)
local this =KLUIMonthCardDescTipsPanel
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseBtn, self, self.CloseBtnOnClick)
    GUI:AddOnClickEvent(self.view.bgBth, self, self.CloseBtnOnClick)
end
function this:CloseBtnOnClick()
    GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardDescTips/KLUIMonthCardDescTipsPanel")
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        if self.args.Content then
            GUI:Text_setString(self.view.contentText, self.args.Content)
        end
    end
end

function this:Close()
end

return this
