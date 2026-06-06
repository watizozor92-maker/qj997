CronosUtil = {}
local startTime  = UtilityLua.ToLocalTime(DateTime(1970,1,1))
CronosUtil.IsActivityOpening = function(cron,continueTime)
    local now = Time.GetServerTime()
    local preTime = now - continueTime * 60000
    local dateTimeNow = startTime:AddMilliseconds(now)
    local dateTimePre = startTime:AddMilliseconds(preTime)
    dateTimeNow = DateTime.SpecifyKind(dateTimeNow,CS.System.DateTimeKind.Utc)
    dateTimePre = DateTime.SpecifyKind(dateTimePre,CS.System.DateTimeKind.Utc)
    local exp = CS.Cronos.CronExpression.Parse(cron)
    ---@type System.DateTime
    local o1 = exp:GetNextOccurrence(dateTimeNow)
    ---@type System.DateTime
    local o2 = exp:GetNextOccurrence(dateTimePre)
    return o1 ~= o2
end