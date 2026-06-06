ConditionHandler:register(ConditionId.active["真实时间检测"], "真实时间检测", function(actor, param)
    local activeTime = string.split(param,"-")
    if table.count(activeTime) < 2 then
        return false
    end

    local startDataStr = string.split(activeTime[1],"_")
    local startTime = TimeUtil.earlyOneMorning(tonumber(startDataStr[1]),tonumber(startDataStr[2]),tonumber(startDataStr[3]))
    local endDataStr = string.split(activeTime[2],"_")
    local endTime = TimeUtil.midnightOneDay(tonumber(endDataStr[1]),tonumber(endDataStr[2]),tonumber(endDataStr[3]))
    local currentTime = getbaseinfo("nowsec")
    if currentTime >= startTime  and currentTime < endTime then
        return true
    end
    return false
end)

ConditionHandler:register(ConditionId.active["主活动持续时间检测"], "主活动持续时间检测", function(actor, param)
    -- 读取当前活动的开始时间
    local mainDurationInfo = string.split(param,"#")
    if table.count(mainDurationInfo) < 2 then
        return true
    end
    local mainGroup =  tonumber(mainDurationInfo[1])
    local durationDay =  tonumber(mainDurationInfo[2])
    local currentActive = getsysvar(CURRENT_ACTIVE)
    if table.isNullOrEmpty(currentActive)  then
        return true
    end
    local mainActive = currentActive.mainActive
    local saveMainGroup = mainActive["mainGroup"]
    if saveMainGroup == mainGroup then
        local closeTime = mainActive["closeTime"]
        local currentTime = getbaseinfo("now")
        if currentTime < closeTime then
            return false
        end
    end
    return true
end)

ConditionHandler:register(ConditionId.active["子活动持续时间检测"], "子活动持续时间检测", function(actor, param)
    -- 读取当前活动的开始时间
    local mainDurationInfo = string.split(param,"#")
    if table.count(mainDurationInfo) < 3 then
        return true
    end
    local mainGroup =  tonumber(mainDurationInfo[1])
    local subType = tonumber(mainDurationInfo[2])
    local durationDay = tonumber(mainDurationInfo[3])
    local currentActive = getsysvar(CURRENT_ACTIVE)
    if table.isNullOrEmpty(currentActive)  then
        return true
    end
    local subActive = currentActive.subActive
    if table.isNullOrEmpty(subActive) then
        return true
    end

    local subActiveId = ConfigDataManager.getTableValue("cfg_OperateActivity_subActivity","id","mainGroup",mainGroup,"subType",subType)
    local subStartTime = subActive[tonumber(subActiveId)]
    if subStartTime == nil then
        return true
    end
    local subCloseTime = TimeUtil.addDayEnd(subStartTime, durationDay)
    local currentTime = getbaseinfo("nowsec")
    if currentTime < subCloseTime then
        return false
    end
    return true
end)

ConditionHandler:register(ConditionId.active["检测为几周"], "检测为几周", function(actor, param)
    -- 读取当前活动的开始时间
    local checkWeek = string.split(param,"#")
    local currentTime = getbaseinfo("nowsec")
    local weekDay = tonumber(os.date("%w", tonumber(currentTime)))
    if weekDay == 0 then
        weekDay = 7
    end
    for k, day in pairs(checkWeek) do
        if tonumber(day) == weekDay then
            return true
        end
    end
    return false
end)