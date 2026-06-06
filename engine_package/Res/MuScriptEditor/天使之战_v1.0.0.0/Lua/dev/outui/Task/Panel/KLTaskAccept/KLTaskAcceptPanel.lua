---@class KLTaskAcceptPanel:UIKmlLuaPanelBase
---@field taskId number
---@field taskCfg cfg_task_career_column
---@field view KLTaskAcceptPanelView
local KLTaskAcceptPanel = class(UIKmlLuaPanelBase)
local this =KLTaskAcceptPanel -- 任务接取面板

---创建时调用一次
function this:Init()
    self.taskId = nil
    self.taskCfg = nil
    self.canAcceptTask = false
    self.noTask = false
    self:InitCfg()
end

function this:InitCfg()
    if not self.args then
        return
    end
    if type(self.args) == "string" or type(self.args) == "number" then
        self.taskId = tonumber(self.args)
    elseif type(self.args) == "table" then
        self.args = GUIUtil.tblkeytonumber(self.args)
        for i, v in ipairs(self.args) do
            self.args[i] = tonumber(v)
        end
        table.sort(self.args, function(a, b)
            local cfg_task_career_a = SL:GetConfig("cfg_task_career", a)
            local cfg_task_career_b = SL:GetConfig("cfg_task_career", b)
            local order_a = cfg_task_career_a and cfg_task_career_a.order or 0
            local order_b = cfg_task_career_b and cfg_task_career_b.order or 0
            return order_a < order_b
        end)

        local matchTaskList = {}
        for _, taskId in ipairs(self.args) do
            if self:CheckTaskCareerLimit(taskId) then
                table.insert(matchTaskList, taskId)
            end
        end

        if #matchTaskList == 0 then
            self.noTask = true
            return
        end

        local taskCount = #matchTaskList
        for index, v in ipairs(matchTaskList) do
            local taskId = v
            local taskState = self:GetTaskState(taskId)
            if taskState == TaskState.Accepted then
                self.taskId = taskId
                break
            end
            if taskState == TaskState.Commited then
                -- 如果任务已提交，检查它的后置任务是否都提交了，如果有未提交的后置任务，则优先显示这个任务，否则显示第一个已提交的任务
                local isPostTaskFinished = false
                local postTask = nil
                local cfgTbl = nil
                if SL:HasConfig("cfg_task_career", taskId) then
                    cfgTbl = SL:GetConfig("cfg_task_career", taskId)
                elseif SL:HasConfig("cfg_task", taskId) then
                    cfgTbl = SL:GetConfig("cfg_task", taskId)
                end
                
                if cfgTbl then
                    postTask = cfgTbl.postTask or {}
                end
                
                if postTask and #postTask > 0 then
                    isPostTaskFinished = true
                    for _, vPost in ipairs(postTask) do
                        local pState = self:GetTaskState(vPost)
                        if pState ~= TaskState.Commited then
                            isPostTaskFinished = false
                            break
                        end
                    end
                end

                if isPostTaskFinished or index == taskCount then
                    if index == taskCount then
                        self.taskId = taskId
                        break
                    end
                else
                    self.taskId = taskId
                    break
                end
            else
                self.taskId = taskId
                break
            end
        end
    end

    if self.noTask then
        return
    end

    if not self.taskId then
        SL:LogError("taskId is nil")
        return
    end
    ---@type cfg_task_career_column
    self.taskCfg = SL:GetConfig("cfg_task_career", self.taskId)
    if not self.taskCfg then
        SL:LogError("cfg_task_career not found, id: " .. self.taskId)
        return
    end
    self.canAcceptTask = self:CheckTaskCanAccept(self.taskId)
end

---检查任务职业限制
---@param taskId number
---@return boolean
function this:CheckTaskCareerLimit(taskId)
    local cfg = SL:GetConfig("cfg_task_career", taskId)
    if not cfg then
        return true
    end

    local careerLimit = cfg.careerLimit
    if not careerLimit or #careerLimit == 0 then
        return true
    end

    if #careerLimit == 1 and careerLimit[1] and careerLimit[1][1] == 0 then
        return true
    end

    local meCareer = SL:MeData_GetCareer() or {}
    local baseCareer = meCareer.baseCareer

    for _, limit in ipairs(careerLimit) do
        if limit and limit[1] == baseCareer then
            return true
        end
    end

    return false
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_accept, self, self.OnClickAccept)
    GUI:AddOnClickEvent(self.view.btn_close, self, self.OnClickClose)
end
---界面显示时调用一次
function this:Show()
end
---创建或者刷新界面数据时调用
function this:Refresh()
    if self.noTask then
        GUI:setVisible(self.view.img_taskTitle, false)
        GUI:setVisible(self.view.txt_content, false)
        GUI:setVisible(self.view.btn_accept, false)
        GUI:setVisible(self.view.txt_noTask, true)
        return
    end

    GUI:setVisible(self.view.img_taskTitle, true)
    GUI:setVisible(self.view.txt_content, true)
    GUI:setVisible(self.view.btn_accept, true)
    GUI:setVisible(self.view.txt_noTask, false)

    if not self.taskCfg then
        return
    end
    local title = self.taskCfg.title
    local desc = self.taskCfg.diaLogGet
    GUI:Text_setText(self.view.txt_taskTitle, title)
    GUI:Text_setText(self.view.txt_content, desc)
    GUI:Button_setTitleText(self.view.btn_accept, self.canAcceptTask and "领取任务" or "已领取")
    GUI:Button_setBright(self.view.btn_accept, self.canAcceptTask)
    GUI:setTouchEnabled(self.view.btn_accept, self.canAcceptTask)
end

function this:Hide()
end

function this:Close()
    SL.ShowMainPanel()
end

function this:OnClickAccept()
    if not self.taskCfg or not self.canAcceptTask then
        return
    end
    -- 条件判断
    local isConditionOk = self:CheckAcceptCondition()
    if not isConditionOk then
        SL:TipMessage("条件不满足，无法领取任务", 1, NoticeType.NoticeMid)
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ACCEPT_PLAYER_CAREER_TASK, self.taskId)
    self:OnClickClose()
end

function this:OnClickClose()
    GUI:UIPanel_Close("dev/outui/Task/Panel/KLTaskAccept/KLTaskAcceptPanel")
end

---@param taskId number 任务ID
---@param visited table|nil
---@return number|nil
function this:GetTaskState(taskId, visited)
    -- local allTask = SL:TaskInfo_GetAllTasks() or {}
    -- for _, taskInfo in pairs(allTask) do
    --     if taskId == taskInfo.taskId then
    --         return taskInfo.state
    --     end
    -- end
    -- return nil
    visited = visited or {}
    if visited[taskId] then
        return nil
    end
    visited[taskId] = true

    local state = SL:GetTaskState(taskId)
    if state == -1 then
        -- 如果它的后置任务存在说明是已接取，否则是未接取
        local cfgTbl = nil
        if SL:HasConfig("cfg_task_career", taskId) then
            cfgTbl = SL:GetConfig("cfg_task_career", taskId)
        elseif SL:HasConfig("cfg_task", taskId) then
            cfgTbl = SL:GetConfig("cfg_task", taskId)
        end
        if cfgTbl then
            local postTask = cfgTbl.postTask or {}
            if postTask and #postTask > 0 then
                for _, v in ipairs(postTask) do
                    local childState = self:GetTaskState(v, visited)
                    if childState ~= TaskState.UnAccept and childState ~= nil then
                        return TaskState.Commited
                    end
                end
            else
                return TaskState.UnAccept
            end
        end

        return TaskState.UnAccept
    elseif state == 0 then
        return TaskState.Commited
    elseif state == 1 then
        return TaskState.Accepted
    elseif state == 2 then
        return TaskState.Completed
    end
    return nil
end

--- 检查任务是否可以接取
---@param taskId number 任务ID
function this:CheckTaskCanAccept(taskId)
    local state = self:GetTaskState(taskId)
    return state ~= TaskState.Accepted and state ~= TaskState.Completed and state ~= TaskState.Commited
end

function this:CheckAcceptCondition()
    local levelMin = self.taskCfg.levelMin or 0
    local levelMax = self.taskCfg.levelMax or 0
    local playerLevel = SL:MeData_GetLevel()
    if playerLevel < levelMin then
        return false
    end
    if levelMax > 0 and playerLevel > levelMax then
        return false
    end
    local preTaskCount = self.taskCfg.preTask and #self.taskCfg.preTask or 0
    local preTaskCondition = ""
    if preTaskCount > 0 then
        if preTaskCount == 1 then
            preTaskCondition = self.taskCfg.preTask[1][1] or ""
        else
            preTaskCondition = ""
            for i, v in ipairs(self.taskCfg.preTask) do
                if i > 1 then
                    preTaskCondition = preTaskCondition .. "|"
                end
                preTaskCondition = preTaskCondition .. v[1]
            end
        end
    end
    local isOk = SL:CheckCalculateConditionGroup(preTaskCondition)
    return isOk
end

return this
