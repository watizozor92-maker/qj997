---@alias TimerBaseData {time:number,nextTime:number,count:number,func:function,args:any,isTimerStop:boolean}

---@class TimerBase
local TimerBase = {}
local this = TimerBase
---@class timers
local timers = {}
local updating = false

function TimerBase.Start(time, func, ...)
    return this.StartLoop(time, 1, func, ...)
end

function TimerBase.StartLoop(time, count, func, ...)
    local t =
    {
        time = time,
        nextTime = this.GetTime() + time,
        count = count,
        func = func,
        args = spack(...),
    }
    table.insert(timers, t)
    return t
end

function TimerBase.StartLoopDelay(delayTime,time, count, func, ...)
    local t =
    {
        time = time,
        nextTime =delayTime<=0 and (this.GetTime() +time) or (this.GetTime()+delayTime),
        count = count,
        func = func,
        args = spack(...),
    }
    table.insert(timers, t)
    if delayTime<=0 then
        t.func(sunpack(t.args))
    end
    return t
end

function TimerBase.StartLoopForever(time, func, ...)
    return this.StartLoop(time, -1, func, ...)
end

---@return void @调用开始的时候调用一次func
function TimerBase.StartLoopForeverBeginCallOnce(time, count,func, ...)
    local t =
    {
        time = time,
        nextTime = this.GetTime() + time,
        count = count,
        func = func,
        args = spack(...),
    }
    table.insert(timers, t)
    t.func(sunpack(t.args))
    return t
end

function TimerBase.Stop(t)
    if not t then
        return
    end
    if updating then
        t.count = 0
    else
        local index = array.indexOf(timers, t)
        if index then
            timers[index].isTimerStop = true
            table.remove(timers, index)
        end
    end
end

function TimerBase.Update()
    updating = true
    local now = this.GetTime()
    local count = #timers
    local i = 1
    while i <= count do
        local t = timers[i]
        local remove = false
        local needCall = false
        if t.count == 0 then
            remove = true
        elseif t.nextTime <= now then
            needCall = true
            if t.count == 1 then
                remove = true
            else
                if t.count > 1 then
                    t.count = t.count - 1
                end
                t.nextTime = t.nextTime + t.time
            end
        end

        if remove then
            table.remove(timers, i)
            t.isTimerStop = true
            count = count - 1
            if needCall then
                local ok, err = xpcall(t.func, debug.traceback, sunpack(t.args))
                if not ok then logError(err) end
            end
            if t.completed then
                local ok, err = xpcall(t.completed, debug.traceback)
                if not ok then logError(err) end
            end
        else
            if needCall then
                local ok, err = xpcall(t.func, debug.traceback, sunpack(t.args))
                if not ok then logError(err) end
            end
            i = i + 1
        end
    end
    updating = false
end

function TimerBase.GetTime()
    return 0
end

return TimerBase