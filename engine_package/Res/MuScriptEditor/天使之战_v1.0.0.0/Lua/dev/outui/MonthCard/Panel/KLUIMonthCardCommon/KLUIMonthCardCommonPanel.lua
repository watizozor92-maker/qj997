---@class KLUIMonthCardCommonPanel:UIKmlLuaPanelBase
---@field view KLUIMonthCardCommonPanelView
local KLUIMonthCardCommonPanel = class(UIKmlLuaPanelBase)
local this =KLUIMonthCardCommonPanel
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.closeBtn, self, self.CloseBtnOnClick)
    GUI:AddOnClickEvent(self.view.GoBtn, self, self.GoBtnOnClick)
end
function this:CloseBtnOnClick()
    GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLUIMonthCardCommon/KLUIMonthCardCommonPanel")
end
function this:GoBtnOnClick()
    if self.args and  self.args.GoBtnBack then
        self.args.GoBtnBack(self)
    end
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.args then
        if self.args.TitleText then
            GUI:Text_setString(self.view.TitleText,self.args.TitleText)
        end
        if self.args.Content then
            GUI:Text_setString(self.view.contentText,self.args.Content)
        end
    end
end

function this:Close()
end

return this
