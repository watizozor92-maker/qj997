---@class TimerFunc
TimerFunc ={
    timerTasks={};--延时任务
    timerLoopTasks={};--延时循环任务
    timerRemoveTasks = {};
    taskIndex=1;--任务编号
    loopPool = TablePool();
    delayPool = TablePool();
};
local this = TimerFunc
--设置延时循环函数 id,初次延时,循环后间隔延时,循环时间,循环函数,结束时回调函数
function TimerFunc:SetDelayLoopFunction(delayTime, delayTime1, loopTime, funcLoop,funcOnFinish)
    if self.timerLoopTasks[self.taskIndex] == nil then
        self.timerLoopTasks[self.taskIndex] = self.loopPool:Pop()
    end
    self.timerLoopTasks[self.taskIndex].startTime=Time.time+delayTime;--触发时机
    self.timerLoopTasks[self.taskIndex].loopDelay=delayTime1;--每次循环的间隔
    self.timerLoopTasks[self.taskIndex].overTime=Time.time+loopTime+delayTime;--循环持续时间
    self.timerLoopTasks[self.taskIndex].funcLoop=funcLoop;--循环函数
    self.timerLoopTasks[self.taskIndex].funcOnFinish=funcOnFinish;--结束时回调函数
    self.timerLoopTasks[self.taskIndex].isTimerFuncStop = false
    self.taskIndex=self.taskIndex+1;
    return self.taskIndex-1;
end
--延时函数 id，延时时间，触发方法
function TimerFunc:SetDelayFunction(delayTime, func)
    if self.timerTasks[self.taskIndex] == nil then
        self.timerTasks[self.taskIndex] = self.delayPool:Pop()
    end
    self.timerTasks[self.taskIndex].func = func;
    self.timerTasks[self.taskIndex].startTime = Time.time + delayTime;
    self.timerTasks[self.taskIndex].isTimerFuncStop = false
    self.taskIndex=self.taskIndex+1;
    return self.taskIndex-1;
end
--更新
function TimerFunc:Update()
    table.clear(self.timerRemoveTasks)
    for k, v in pairs(self.timerTasks) do
        --满足延时条件 触发
        if v.startTime < Time.time then
            v.isTimerFuncStop = true
            --self.timerTasks[k]=nil;--回收任务
            table.insert(self.timerRemoveTasks,k)
            if v.func~=nil then
                v.func();--延时方法
            end
        end
    end
    for k,v in pairs(self.timerLoopTasks) do
        --过期任务
        if v.overTime < Time.time then
            v.isTimerFuncStop = true
            --self.timerLoopTasks[k]=nil;--回收任务
            table.insert(self.timerRemoveTasks,k)
            if v.funcOnFinish~=nil then
                v.funcOnFinish();--循环方法结束回调
            end
            --有效任务
        else
            --满足触发条件
            if v.startTime < Time.time then
                v.startTime=v.startTime+v.loopDelay;--设置下一次触发时间
                if v.funcLoop~=nil then
                    v.funcLoop();--循环方法
                end
            end
        end
    end

    for k, v in pairs(self.timerRemoveTasks) do
        self:Remove(v)
    end
end
--撤销任务
function TimerFunc:Remove(id)
    if self.timerTasks[id] then
        self.delayPool:Push(self.timerTasks[id])
        self.timerTasks[id].isTimerFuncStop = true
        self.timerTasks[id] = nil
    end

    if self.timerLoopTasks[id] then
        self.timerLoopTasks[id].isTimerFuncStop = true
        self.delayPool:Push(self.timerLoopTasks[id])
        self.timerLoopTasks[id] = nil
    end
    --for k,v in pairs(self.timerTasks) do
    --    if k==id then
    --        self.timerTasks[id]=nil;
    --        return;
    --    end
    --end
    --for k,v in pairs(self.timerLoopTasks) do
    --    if k==id then
    --        self.timerLoopTasks[id]=nil;
    --        return;
    --    end
    --end
end

function TimerFunc:IsStoped(id)
    if self.timerTasks[id] then
        return self.timerTasks[id].isTimerFuncStop
    end

    if self.timerLoopTasks[id] then
        return self.timerLoopTasks[id].isTimerFuncStop
    end
    return true
end

--清理
function TimerFunc:Clear()
    for k, v in pairs(self.timerTasks) do
        self.timerTasks[k] = nil;
    end
    for k, v in pairs(self.timerLoopTasks) do
        self.timerLoopTasks[k] = nil;
    end
    self.taskIndex=1;
end

