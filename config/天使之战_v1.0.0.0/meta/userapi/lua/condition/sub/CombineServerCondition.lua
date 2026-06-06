ConditionHandler:register(ConditionId.combineServer["合服天数>"], "合服天数>", function(actor, param)
    local combineTime = getbaseinfo("combinetime")
    -- local combineTime = "2025-05-05 01:00:00"
    if string.isNullOrEmpty(combineTime) then
        return false
    end
    local combineSecTime = TimeUtil.getSec(combineTime)
    local nowSec = getbaseinfo("nowsec")
    if nowSec > combineSecTime then
        local combineSec =  TimeUtil.getDawnSec(combineTime)
        return nowSec > combineSec + (tonumber(param)) * 60 * 60 * 24
    end
    return false
end)
ConditionHandler:register(ConditionId.combineServer["合服天数>="], "合服天数>=", function(actor, param)
    local combineTime = getbaseinfo("combinetime")
    -- local combineTime = "2025-05-05 01:00:00"
    if string.isNullOrEmpty(combineTime) then
        return false
    end
    local combineSecTime = TimeUtil.getSec(combineTime)
    local nowSec= getbaseinfo("nowsec")
    if nowSec > combineSecTime then
        local combineSec =  TimeUtil.getDawnSec(combineTime)
        return nowSec > combineSec + (tonumber(param) - 1) * 60 * 60 * 24
    end
    return false
end)
ConditionHandler:register(ConditionId.combineServer["合服天数=="], "合服天数==", function(actor, param)
    local combineTime = getbaseinfo("combinetime")
    -- local combineTime = "2025-05-05 01:00:00"
    if string.isNullOrEmpty(combineTime) then
        return false
    end
    local combineSecTime = TimeUtil.getSec(combineTime)
    local nowSec= getbaseinfo("nowsec")
    if nowSec > combineSecTime then
        local combineSec =  TimeUtil.getDawnSec(combineTime)
        local resultTime = combineSec + (tonumber(param) - 1) * 60 * 60 * 24 + 1
        return TimeUtil.isSameDay(resultTime, nowSec)
    end
    return false
end)
ConditionHandler:register(ConditionId.combineServer["合服天数<="], "合服天数<=", function(actor, param)
    local combineTime = getbaseinfo("combinetime")
    -- local combineTime = "2025-05-05 01:00:00"
    if string.isNullOrEmpty(combineTime) then
        return false
    end
    local nowSec= getbaseinfo("nowsec")
    local combineSecTime = TimeUtil.getSec(combineTime)
    if nowSec > combineSecTime then
        local combineSec =  TimeUtil.getDawnSec(combineTime)
        return nowSec <= combineSec + (tonumber(param)) * 60 * 60 * 24
    end
    return false
end)
ConditionHandler:register(ConditionId.combineServer["合服天数<"], "合服天数<", function(actor, param)
    local combineTime = getbaseinfo("combinetime")
    -- local combineTime = "2025-05-05 01:00:00"
    if string.isNullOrEmpty(combineTime) then
        return false
    end
    local nowSec= getbaseinfo("nowsec")
    local combineSecTime = TimeUtil.getSec(combineTime)
    if nowSec > combineSecTime then
        local combineSec =  TimeUtil.getDawnSec(combineTime)
        return nowSec < combineSec + (tonumber(param) - 1) * 60 * 60 * 24 + 1
    end
    return false
end)
ConditionHandler:register(ConditionId.combineServer["合服天数~="], "合服天数~=", function(actor, param)
    local combineTime = getbaseinfo("combinetime")
    -- local combineTime = "2025-05-05 01:00:00"
    if string.isNullOrEmpty(combineTime) then
        return false
    end
    local nowSec= getbaseinfo("nowsec")
    local combineSecTime = TimeUtil.getSec(combineTime)
    if nowSec > combineSecTime then
        local combineSec =  TimeUtil.getDawnSec(combineTime)
        local resultTime = combineSec + (tonumber(param) - 1) * 60 * 60 * 24 + 1
        return not TimeUtil.isSameDay(resultTime, nowSec)
    end
    return false
end)