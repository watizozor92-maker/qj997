---@class KLUnionTaskPanel:UIKmlLuaPanelBase
---@field view KLUnionTaskPanelView
local KLUnionTaskPanel = class(UIKmlLuaPanelBase)
local this = KLUnionTaskPanel
---创建时调用一次
function this:Init()
    self.unionTaskIdToInfo = {}
    self.unionTaskList = {}
    self.unionFinishList = {}

    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_TASK_DATA)
end

---创建或者刷新界面数据时调用
function this:Refresh()
    --self:ShowTaskList()
    -- SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_UNION_TASK_DATA)
    SL.HideMainPanel()
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_UNION_TASK_DATA,self.ResUnionTaskData, self)
    GUI:AddOnClickEvent(self.view.btnClose, self, self.btnClose)
end

function this:btnClose()
    GUI:UIPanel_Close("dev/outui/Union/Panel/KLUnionTask/KLUnionTaskPanel")
    GUI:UIPanel_Close("dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel")
    SL.ShowMainPanel()
end

function this:Close()
end

function this:ResUnionTaskData(_, message)
    self.unionFinishList = message.memberrecord or {}
    self:SetUnionTaskList(message)
    self:ShowTaskList(message)
    GUI:SetControl_time(self.view.timeCounter, (self:GetNextRefreshTime(message.createtime//1000,SL:GetConfig('cfg_gard_task',1).taskRefreshes)*1000-SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME))//1000)
end


function this:ShowTaskList(message)

    for _, unionTaskInfo in pairs(self.unionTaskList) do
        local taskId = unionTaskInfo.taskid
        if self.unionTaskIdToInfo[taskId] then
            self.unionTaskIdToInfo[taskId]:Refresh()
        else
            self.unionTaskIdToInfo[taskId] = GUI:UIPanel_Open("dev/outui/Union/Item/KLUnionTask/KLUnionTaskItem", self.view.layout2, self, {info=unionTaskInfo, finish=table.contains(self.unionFinishList, taskId)}, true)
        end
    end
end

function this:SetUnionTaskList(message)
    self.unionTaskList = {}
    
    local taskRecord = message.taskrecord
    for _, unionTaskInfo in pairs(taskRecord) do
        table.insert(self.unionTaskList, unionTaskInfo)
    end
    
    table.sort(self.unionTaskList, function(a, b) 
        return a.taskid < b.taskid
    end)
end

function this:GetNextRefreshTime(creationTimestamp, day)
    if day == 0 then
        day = 1
    end
        
    local currentTime = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)//1000
    local creationTime = os.date("*t", creationTimestamp)

    -- 将创建时间转换为时间戳
    creationTime.hour = 0
    creationTime.min = 0
    creationTime.sec = 0

    -- 计算下一个任务刷新时间
    local nextRefreshTimestamp = os.time(creationTime)

    --while nextRefreshTimestamp <= currentTime do
    --    nextRefreshTimestamp = nextRefreshTimestamp + day * 24 * 3600
    --end
    nextRefreshTimestamp = nextRefreshTimestamp + day * 24 * 3600

    return nextRefreshTimestamp
end


return this

