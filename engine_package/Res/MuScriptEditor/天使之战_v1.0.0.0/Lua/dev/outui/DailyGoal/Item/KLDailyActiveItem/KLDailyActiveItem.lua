---@class KLDailyActiveItem:UIKmlLuaPanelBase
---@field view KLDailyActiveItemView
local KLDailyActiveItem = class(UIKmlLuaPanelBase)
local this =KLDailyActiveItem
---创建时调用一次
function this:Init()
    
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_goto,self,self.BtnGotoOnClick)
end

function this:BtnGotoOnClick()
    ---@type cfg_task_target_column
    local target = SL:GetConfig("cfg_task_target",self.config.target)
    GUI:UIPanel_Close("dev/outui/DailyGoal/Panel/KLDailyGoalMain/KLDailyGoalMainPanel")
    shortcutOutMgr.DO(target.instruction[1])
end

function this:Close()
end

---更新数据
---@param data daily_task 数据
function this:UpdateData(data)
    self.data = data
    ---@type cfg_daily_activity_column
    self.config = SL:GetConfig("cfg_daily_activity",tonumber(data.task_id))
    GUI:SetID(self.view.root,"daily_activity_" .. self.data.task_id)
    GUI:Image_loadTexture(self.view.icon, self.config.icon , "Atlas/DailyGoal.spriteatlas")
    GUI:Text_setString(self.view.name, self.config.name)
    GUI:Text_setString(self.view.active_per_time,string.format("+%s/次",self.config.activity))
    GUI:Text_setString(self.view.active_info,string.format("活跃度&lt;color=#00FF00&gt;%d&lt;/color&gt;/%d",tonumber(self.data.task_finish_count) * self.config.activity,self.config.timeMax * self.config.activity))
    
    local check = SL:CheckCondition(self.config.conditions)
    GUI:setVisible(self.view.btn_goto,check)
    GUI:setVisible(self.view.txt_tip,not check)
    GUI:Text_setString(self.view.txt_tip,self.config.conditionsText)

    local finish = tonumber(self.data.task_finish_count) >= self.config.timeMax
    GUI:setVisible(self.view.txt_done,finish and (self.config.Done == 1))
end

return this
