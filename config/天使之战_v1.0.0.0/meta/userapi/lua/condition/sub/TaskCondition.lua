ConditionHandler:register(ConditionId.task["拥有已接取任务"], "拥有已接取任务", function(actor, param)
    local taskList = gettasklist(actor)
    for _, taskInfo in pairs(taskList) do
        local taskId = taskInfo.taskid
        local taskState = taskInfo.state
        if tonumber(taskId) == tonumber(param) and taskState == 1 then
            return true
        end
    end
    return false
end)
