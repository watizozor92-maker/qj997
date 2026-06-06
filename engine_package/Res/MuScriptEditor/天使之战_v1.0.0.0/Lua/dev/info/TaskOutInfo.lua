---@class TaskOutInfo
TaskOutInfo = class()
local this = TaskOutInfo

function this:Init()
    self.panelTaskList = {}
    local cfgs = SL:GetConfigTable("cfg_task_target")
    for i, v in ipairs(cfgs) do
        if v.taskGoalType == 50 then 
            table.insert(self.panelTaskList,v)
        end
    end
    self:RegistMessages()
end

function this:Reset()
    self:SetTaskTempCacheData()
end

function this:RegistMessages()
    if LUA_EVENT_CONTROL_UI_ONCLICK then
        SL:RegisterLUAEvent(LUA_EVENT_CONTROL_UI_ONCLICK, self.UI_OnClick, self)
    end
end

local function checkTableEqual(a, b)
    if not a or not b then
       return false 
    end
    -- if type(a)=="string" or table.isNullOrEmpty(a) then
    --     return false
    -- end
    for k, v in pairs(a) do
        if not b[k] or b[k] ~= v then
            return false
        end
    end
    return true
end

function this:IsFinishPanelTask(path, args)
    local taskInfoList = SL:TaskInfo_GetAllTasks()
    if taskInfoList then
        for i, taskInfo in pairs(taskInfoList) do
            if taskInfo.state == TaskState.Accepted then
                for _, goal in pairs(taskInfo.taskGoalRecord) do
                    local targetId = goal.goalId
                    ---@type cfg_task_target_column
                    local cfg = SL:GetConfig('cfg_task_target', targetId)
                    if cfg.taskGoalType == ETaskGoalType.OpenPanel and cfg.taskGoalParam == 1 then
                        local instruction = cfg.instruction[1]
                        local param
                        if not table.isNullOrEmpty(instruction) and instruction[4] then
                            param = {}
                            local tbl = string.split(instruction[4], '&')
                            for _, tbl1 in pairs(tbl) do
                                local tbl2 = string.split(tbl1, '=')
                                if #tbl2 > 1 then
                                    param[tbl2[1]] = tonumber(tbl2[2])
                                else
                                    table.insert(param, tonumber(tbl[1]))
                                end
                            end
                        end
                        local argsEqual = true
                        if args and param then
                            local typeArgs = type(args)
                            local typeParam = type(param)
                            if typeArgs ~= typeParam then
                            argsEqual = false
                            else
                                if typeArgs == "table" then
                                argsEqual = checkTableEqual(args, param) 
                                else
                                    argsEqual = args == param 
                                end
                            end
                        end
                        
                        if cfg.taskGoalType == ETaskGoalType.OpenPanel and cfg.taskGoalParam == 1 and instruction[2] == path and argsEqual then
                            local str1= ""
                            for i, v in ipairs(cfg.taskGoalParam3) do
                                if i==1 then
                                    str1 = str1..tostring(v)
                                else
                                    str1 = str1 .."#"..tostring(v)
                                end
                            end
                            return str1
                        end
                    end
                end
            end
        end
    end
    return nil
end

---@param monsterId number 怪物唯一id
---@return boolean
function this:IsTaskMonsterById(monsterId)
    local taskInfoList = SL:TaskInfo_GetAllTasks()
    local monster = SL:GetRoleById(monsterId)
    local monsterCfgId = 0
    if monster then
        monsterCfgId = monster.data.serverData.cfgId
    end
    
    if taskInfoList then
        for i, taskInfo in pairs(taskInfoList) do
            if taskInfo.state == TaskState.Accepted then
                for _, goal in pairs(taskInfo.taskGoalRecord) do
                    local targetId = goal.goalId
                    ---@type cfg_task_target_column
                    local cfg = SL:GetConfig('cfg_task_target', targetId)
                    if cfg.taskGoalType == ETaskGoalType.Monster or cfg.taskGoalType == ETaskGoalType.DamageMonster then
                        if cfg.taskGoalParam == monsterCfgId then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function this:IsFinishBtnTask(uipanel,btn_id)
    local taskInfoList = SL:TaskInfo_GetAllTasks()
    if taskInfoList then
        for i, taskInfo in pairs(taskInfoList) do
            if taskInfo.state == TaskState.Accepted then
                for _, goal in pairs(taskInfo.taskGoalRecord) do
                    local targetId = goal.goalId
                    ---@type cfg_task_target_column
                    local cfg = SL:GetConfig('cfg_task_target', targetId)
                    if cfg.taskGoalType == ETaskGoalType.OpenPanel and cfg.taskGoalParam == 2 and table.count(cfg.taskGoalParam3) > 1 then
                        if cfg.taskGoalParam3[1] == uipanel and cfg.taskGoalParam3[2] == btn_id then
                            return uipanel.."#"..btn_id
                        end
                    end
                end
            end
        end
    end
    return nil
end

function this:UI_OnClick(_, data)
    local uipanel_id = data.selfHandle.panel.panelName
    local btn_id = data.selfHandle.controlId
    GUI:OnClickSendTask(uipanel_id,btn_id)
end

---杀怪任务临时缓存
function this:SetTaskTempCacheData(data)
    self.tempCacheData = data
end
function this:GetTaskTempCacheData()
    return self.tempCacheData
end

---挂机界面点击前往判断是否与缓存怪物id相同
function this:CheckMonsterIdIsInCacheData(monsterId)
    if self.tempCacheData and self.tempCacheData[3] and self.tempCacheData[3] == monsterId then
        return true
    end
    return false
end

