
ViewPanelGoal = {}

---@see 玩家查看界面
function ViewPanelGoal.flushViewPanelTask(actor, type, goal_id, goal_count, param)
    local goalParam = ConfigDataManager.getTableValue("cfg_task_target", "taskGoalParam3", "id", goal_id)
    if tostring(goalParam) == tostring(param) then
        return goal_count + 1
    end
    return goal_count
end

