---@class KLDailyGoalMainPanel:UIKmlLuaPanelBase
---@field view KLDailyGoalMainPanelView
local KLDailyGoalMainPanel = class(UIKmlLuaPanelBase)
local this =KLDailyGoalMainPanel
---创建时调用一次
function this:Init()
    
end



---创建或者刷新界面数据时调用
function this:Refresh()
    GUI:UIPanel_Open("dev/outui/DailyGoal/Panel/KLDailyActive/KLDailyActivePanel")
    SL.HideMainPanel()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close,self,self.BtnCloseOnClick)
    GUI:SetToggleOnValueChange(self.view.toggle_tab_daily_active,self,self.ToggleTabDailyActiveOnValueChange)
    GUI:SetToggleOnValueChange(self.view.toggle_tab_activity,self,self.ToggleTabActivityOnValueChange)
end

function this:ToggleTabDailyActiveOnValueChange(_,_,value)
    if value[1] then
        GUI:UIPanel_Open("dev/outui/DailyGoal/Panel/KLDailyActive/KLDailyActivePanel")
        GUI:UIPanel_Close("dev/outui/DailyGoal/Panel/KLDailyActivity/KLDailyActivityPanel")
    end
end

function this:ToggleTabActivityOnValueChange(_,_,value)
    if value[1] then
        GUI:UIPanel_Close("dev/outui/DailyGoal/Panel/KLDailyActive/KLDailyActivePanel")
        GUI:UIPanel_Open("dev/outui/DailyGoal/Panel/KLDailyActivity/KLDailyActivityPanel")
    end
end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/DailyGoal/Panel/KLDailyGoalMain/KLDailyGoalMainPanel")
    GUI:UIPanel_Close("dev/outui/DailyGoal/Panel/KLDailyActive/KLDailyActivePanel")
    GUI:UIPanel_Close("dev/outui/DailyGoal/Panel/KLDailyActivity/KLDailyActivityPanel")
    SL.ShowMainPanel()
end

function this:Close()
    GUI:UIPanel_Close("dev/outui/DailyGoal/Panel/KLDailyActive/KLDailyActivePanel")
    GUI:UIPanel_Close("dev/outui/DailyGoal/Panel/KLDailyActivity/KLDailyActivityPanel")
end

return this
