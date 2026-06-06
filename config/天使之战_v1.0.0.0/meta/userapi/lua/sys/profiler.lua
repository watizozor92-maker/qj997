local reports = {}

local LuaProfiler = {}

 function LuaProfiler.formatFuncInfo(funcinfo)
    local name = funcinfo.name or 'unknown'
    local line = funcinfo.linedefined or 0
    local source = funcinfo.short_src or 'unknown'
    local key = string.format("%s|%s|%s", name, source, line)
    local result = {
        name= name,
        line= line,
        source= source,
        key= key
    }
    return result
end

function LuaProfiler.tracingCall(funcinfo)
    local info = LuaProfiler.formatFuncInfo(funcinfo)
    local key = info.key
    if not reports[key] then
        reports[key] = {
            callcount = 0,
            totaltime = 0,
        }
    end
    local report = reports[key]
    report.calltime    = os.clock()
    report.callcount   = report.callcount + 1
    report.name = info.name
    report.source = info.source
    report.line = info.line
end

function LuaProfiler.tracingReturn(funcinfo)
    local info = LuaProfiler.formatFuncInfo(funcinfo)
    local key = info.key
    local stoptime = os.clock()
    local report = reports[key]
    if report and report.calltime and report.calltime > 0 then
        report.totaltime = report.totaltime + (stoptime-report.calltime)
        report.calltime = 0
    end
end

function LuaProfiler.tracingHandler(hooktype)
    local funcinfo = debug.getinfo(2, 'nS')
    if hooktype == "call" then
        LuaProfiler.tracingCall(funcinfo)
    elseif hooktype == "return" then
        LuaProfiler.tracingReturn(funcinfo)
    end
end


function luaprofilercollect()
    if table.isNullOrEmpty(reports) then
        return nil
    end
    local result = table.values(reports)
    --被获取后清空
    reports = {}
    return result
end


function luainit()
    if is_open_break_point_debug() then
        --打开断点调试器，延迟5秒执行
        setontimerex(TimerIds.OPEN_BREAK_POINT_DEBUG, 9999999, 5)
    end

    -- local isDebug = getenv("debug")
    -- if isDebug then
    --     debug.sethook(LuaProfiler.tracingHandler, 'cr', 0)
    -- end
end

function ontimerex100006()
    local lpd = require("LuaPanda")
    lpd.start("127.0.0.1", 8818)
    lpd.autoReconnect = true
    info("断点调试器打开")
    setofftimerex(TimerIds.OPEN_BREAK_POINT_DEBUG)
end

function is_open_break_point_debug()
    local luaversion = getenv("luaversion")
    local isdbg = getenv("debug");
    local ok = isdbg == true and string.lower(luaversion) == "luacdbg"
    return ok
end
