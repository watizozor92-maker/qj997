---@class UnscaledTimer:TimerBase
UnscaledTimer = rrequire("Common/TimerBase")

function UnscaledTimer.GetTime()
    return Time.unscaledTime
end