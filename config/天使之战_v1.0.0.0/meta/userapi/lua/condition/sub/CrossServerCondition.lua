ConditionHandler:register(ConditionId.crossServer["跨服天数>"], "跨服天数>", function(actor, param)
    local crossOpenTime = getbaseinfo("crossopentime")
    -- local crossOpenTime = 1745341200000
    if string.isNullOrEmpty(crossOpenTime) or crossOpenTime == 0 then
        return false
    end
    local now = getbaseinfo("now")
    if now > crossOpenTime then
        local crossOpenData = TimeUtil.timeToDate(math.floor(crossOpenTime/1000))
        local crossOpenDayTime = TimeUtil.earlyOneMorning(crossOpenData.year,crossOpenData.month,crossOpenData.day)
        local change = now - crossOpenDayTime * 1000
        local time = tonumber(param) * 24 * 60 * 60 * 1000
        return change > time
    end
    return false
end)
ConditionHandler:register(ConditionId.crossServer["跨服天数>="], "跨服天数>=", function(actor, param)
    local crossOpenTime = getbaseinfo("crossopentime")
    -- local crossOpenTime = 1745341200000
    if string.isNullOrEmpty(crossOpenTime) or crossOpenTime == 0 then
        return false
    end
    local now = getbaseinfo("now")
    if now > crossOpenTime then
        local crossOpenData = TimeUtil.timeToDate(math.floor(crossOpenTime/1000))
        local crossOpenDayTime = TimeUtil.earlyOneMorning(crossOpenData.year,crossOpenData.month,crossOpenData.day)
        local change = now - crossOpenDayTime * 1000
        local time = (tonumber(param) - 1) * 24 * 60 * 60 * 1000
        return change > time
    end
    return false
end)
ConditionHandler:register(ConditionId.crossServer["跨服天数=="], "跨服天数==", function(actor, param)
    local crossOpenTime = getbaseinfo("crossopentime")
    -- local crossOpenTime = 1745341200000
    info("跨服时间：",crossOpenTime)
    if string.isNullOrEmpty(crossOpenTime) or crossOpenTime == 0 then
        return false
    end
    local now = getbaseinfo("now")
    if now > crossOpenTime then
        local crossOpenData = TimeUtil.timeToDate(math.floor(crossOpenTime/1000))
        local crossOpenDayTime = TimeUtil.earlyOneMorning(crossOpenData.year,crossOpenData.month,crossOpenData.day)
        local change = now - crossOpenDayTime * 1000
        local timeStart = (tonumber(param) - 1) * 24 * 60 * 60 * 1000
        local timeEnd = tonumber(param) * 24 * 60 * 60 * 1000
        return change > timeStart and change < timeEnd
    end
    return false
end)
ConditionHandler:register(ConditionId.crossServer["跨服天数<="], "跨服天数<=", function(actor, param)
    local crossOpenTime = getbaseinfo("crossopentime")
    -- local crossOpenTime = 1745341200000
    if string.isNullOrEmpty(crossOpenTime) or crossOpenTime == 0 then
        return false
    end
    local now = getbaseinfo("now")
    if now > crossOpenTime then
        local crossOpenData = TimeUtil.timeToDate(math.floor(crossOpenTime/1000))
        local crossOpenDayTime = TimeUtil.earlyOneMorning(crossOpenData.year,crossOpenData.month,crossOpenData.day)
        local change = now - crossOpenDayTime * 1000
        local time = tonumber(param) * 24 * 60 * 60 * 1000
        return change < time
    end
    return false
end)
ConditionHandler:register(ConditionId.crossServer["跨服天数<"], "跨服天数<", function(actor, param)
    local crossOpenTime = getbaseinfo("crossopentime")
    -- local crossOpenTime = 1745341200000
    if string.isNullOrEmpty(crossOpenTime) or crossOpenTime == 0 then
        return false
    end
    local now = getbaseinfo("now")
    if now > crossOpenTime then
        local crossOpenData = TimeUtil.timeToDate(math.floor(crossOpenTime/1000))
        local crossOpenDayTime = TimeUtil.earlyOneMorning(crossOpenData.year,crossOpenData.month,crossOpenData.day)
        local change = now - crossOpenDayTime * 1000
        local time = (tonumber(param) - 1) * 24 * 60 * 60 * 1000
        return change <= time
    end
    return false
end)
ConditionHandler:register(ConditionId.crossServer["跨服天数~="], "跨服天数~=", function(actor, param)
    local crossOpenTime = getbaseinfo("crossopentime")
    -- local crossOpenTime = 1745341200000
    if string.isNullOrEmpty(crossOpenTime) or crossOpenTime == 0 then
        return false
    end
    local now = getbaseinfo("now")
    if now > crossOpenTime then
        local crossOpenData = TimeUtil.timeToDate(math.floor(crossOpenTime/1000))
        local crossOpenDayTime = TimeUtil.earlyOneMorning(crossOpenData.year,crossOpenData.month,crossOpenData.day)
        local change = now - crossOpenDayTime * 1000
        local timeStart = (tonumber(param) - 1) * 24 * 60 * 60 * 1000
        local timeEnd = tonumber(param) * 24 * 60 * 60 * 1000
        return change < timeStart or change > timeEnd
    end
    return false
end)