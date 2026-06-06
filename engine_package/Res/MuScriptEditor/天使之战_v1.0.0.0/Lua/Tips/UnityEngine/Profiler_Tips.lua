---@class Profiler
Profiler = {}
local this = Profiler
ENABLE_PROFILER = CS.UnityEngine.Debug.isDebugBuild
local LuaProfiler = CS.TCFramework.LuaProfiler
local MikuLuaProfiler = CS.MikuLuaProfiler.LuaProfiler
ENABLE_PROFILER = false
--ENABLE_LUA_PROFILER = true
function Profiler.BeginSample(name,isMikuLua)
    if ENABLE_PROFILER then
        LuaProfiler.BeginSample(StringPool.ToID(name))
    end

    if isMikuLua then
        MikuLuaProfiler.BeginSampleCSharp(name)
    end
end

function Profiler.BeginSampleFunc(func)
    if ENABLE_PROFILER then
        local info = debug.getinfo(func, "nSl")
        local text = info.source .. ":" .. info.linedefined
        if info.name then
            text = info.name .. "@" .. text
        end
        Profiler.BeginSample(text)
    end
end

function Profiler.EndSample(isMikuLua)
    if ENABLE_PROFILER then
        LuaProfiler.EndSample()
    end
    if isMikuLua then
        MikuLuaProfiler.EndSampleCSharp()
    end
end

function Profiler.BeginTime()
    this.preTime = os.clock()*1000
end

function Profiler.EndTime(name, isError)
    this.nextTime = os.clock() * 1000
    if isError then
        logError(name .. ' time = ' .. (this.nextTime - this.preTime) .. ' ms')
    else
        if DebugFlag.LogEnable then
            log(name .. ' time = ' .. (this.nextTime - this.preTime) .. ' ms')
        end
    end
end

---@return number kb
function Profiler.GetMemory(func)
    -- 执行前GC+统计
    collectgarbage("collect")
    local mem_before = collectgarbage("count") 

    -- 执行目标函数
    func()

    -- 执行后GC+统计
    collectgarbage("collect")
    local mem_after = collectgarbage("count") 

    -- 返回增量（字节）
    return mem_after - mem_before
end