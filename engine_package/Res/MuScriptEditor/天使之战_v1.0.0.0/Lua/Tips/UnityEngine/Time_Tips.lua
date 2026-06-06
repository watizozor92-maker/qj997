---@class Time
Time = {}
local this = Time
local unity_time = CS.UnityEngine.Time
local inited = false
local timer = 0
local openServerDay

function Time.Update(time, unscaledTime)
    if not inited then
        rawset(this, "deltaTime", unity_time.deltaTime)
        rawset(this, "unscaledDeltaTime", unity_time.unscaledDeltaTime)
        rawset(this, "time", unity_time.time)
        rawset(this, "unscaledTime", unity_time.unscaledTime)
        --rawset(this, "timeSinceLevelLoad", unity_time.timeSinceLevelLoad)
        rawset(this, "frameCount", unity_time.frameCount)
        --rawset(this, "renderedFrameCount", unity_time.renderedFrameCount)
        inited = true
    else
        this.deltaTime = time - this.time
        this.unscaledDeltaTime = unscaledTime - this.unscaledTime
        this.time = time
        this.unscaledTime = unscaledTime
        --this.timeSinceLevelLoad = this.timeSinceLevelLoad + this.deltaTime
        this.frameCount = this.frameCount + 1
        --this.renderedFrameCount = this.renderedFrameCount + 1
        timer = timer + this.deltaTime
        if timer >= 15 then
            if LoginManager.EnterRoleRes and  LoginManager.EnterRoleRes.openServerTime then
                local defTime = Time.GetServerTime() - LoginManager.EnterRoleRes.openServerTime + LoginManager.millisecond
                if defTime > 0 then
                    local day = math.ceil(defTime / 86400000)
                    if not openServerDay or (openServerDay ~= day) then
                        openServerDay = day
                        SL:onLUAEvent(LUA_EVENT_OPEN_SERVER_DAY_CHANGE,openServerDay)
                    end
                end
            end
            timer = 0
        end
    end
end

local serverTime = 0
local recvServerTime = 0

-- 单位毫秒
function Time.SetServerTime(time)
    serverTime = time
    recvServerTime = this.unscaledTime
    CS.KingML.DataManager.SetServerTime(time)
end

-- 单位毫秒
function Time.GetServerTime()
    return serverTime + math.floor((this.unscaledTime - recvServerTime) * 1000)
end
--时分秒
function Time.FormatTime(time)
    time = math.modf(time / 1000)
    local hour = math.modf(time / 3600)
    local minute = math.modf(time % 3600 / 60)
    local second = time % 60
    local formatTime = string.format("%02d:%02d:%02d", hour, minute, second)
    return formatTime
end

--时分
function Time.FormatTimeHMString(time)
    local hour = math.modf(time / 3600)
    local minute = math.modf(time % 3600 / 60)
    local formatTime = string.format("%02d小时%02d分", hour, minute)
    return formatTime
end

--分秒
function Time.FormatTimeMS(time)
    time = math.modf(time / 1000)
    local minute = math.modf(time / 60)
    local second = time % 60
    local fmtTime = string.format("%02d:%02d", minute, second)
    return fmtTime
end
--同上但艺术字
function Time.FormatTimeMSForArt(time)
    time = math.modf(time / 1000)
    local minute = math.modf(time / 60)
    local second = time % 60
    local fmtTime = string.format("%02da%02d", minute, second)
    return fmtTime
end

--分秒
function Time.ShowFormatTimeMS(time)
    time = math.modf(time / 1000)
    local minute = math.modf(time / 60)
    local second = time % 60
    if minute > 0 then
        local s = "%2s分%2s秒"
        if minute <= 9 then
            s = "%02s分%2s秒"
        end
        return string.format(s, minute, second)
    end
    if minute == 0 then
        return string.format("%2s秒", second)
    end
end

--时分秒毫秒
function Time.ShowFormatTimeHMSM(time)
    local time1 = math.modf(time / 1000)
    local hour = math.modf(time1 / 3600 )
    local minute = math.modf(time1 % 3600/60)
    local second = time1 % 60
    local millisecond = math.floor(time % 1000 / 10)
    return string.format("%02d:%02d:%02d:%02d", hour,minute, second, millisecond)
end

--分秒毫秒
function Time.ShowFormatTimeMSM(time)
    local time1 = math.modf(time / 1000)
    local minute = math.modf(time1 / 60)
    local second = time1 % 60
    local millisecond = math.floor(time % 1000 / 10)
    return string.format("%02d:%02d:%02d", minute, second, millisecond)
end
--分钟
function Time.FormatTimeMM(time, bCeil)
    time = math.modf(time / 1000)
    local m = (bCeil == true) and math.ceil(time / 60) or (time // 60)
    return string.format("%2s分钟", m);
end
--(分)秒
function Time.FormatTimeAutoMS(time)
    time = math.modf(time / 1000)
    local minute = math.modf(time / 60)
    local second = time % 60
    local fmtTime = minute > 0 and string.format("%02d:%02d", minute, second)
            or string.format("%s", second)
    return fmtTime
end
--单位毫秒
function Time.FormatTimeHMS(time)
    time = time // 1000
    local s = time % 60
    local m = time // 60 % 60
    local h = time // 3600 % 24
    return string.format("%02d:%02d:%02d", h, m, s);
end
--秒（剩余秒数倒计时）
function Time.FormatTimeDHMS(time)
    local s = time % 60
    local m = time // 60 % 60
    local h = time // 3600 % 24
    local d = time // 86400
    return string.format("%02d天%02d小时%02d分钟%02d秒", d, h, m, s);
end

---时分秒用冒号连接
function Time.FormatTimeDHMSFormColon(time)
    local s = math.floor(time % 60)
    local m =  math.floor(time // 60 % 60)
    local h = math.floor(time // 3600 % 24)
    local d = time // 86400
    if d <= 0 then
        return string.format("%02d:%02d:%02d", h, m, s);
    else
        return string.format("%d天%02d:%02d:%02d", d, h, m, s);
    end
end

--秒（剩余秒数倒计时）
function Time.FormatTimeDHM(time)
    local s = time % 60
    local m = time // 60 % 60
    local h = time // 3600 % 24
    local d = time // 86400
    if h == 23 and m == 59 and s > 0 then
        d = d + 1
        m = 0
        h = 0
    elseif m == 59 and s > 0 then
        m = 0
        h = h + 1
    elseif s > 0 then
        m = m + 1
    end
    return string.format("%02d天%02d小时%02d分钟", d, h, m);
end

--秒（剩余秒数倒计时）
function Time.FormatTimeDH(time)
    local h = math.ceil(time // 3600) % 24
    local d = math.ceil(time // 86400)
    return string.format("%02d天%02d小时", d, h);
end

---@param time number @时间戳 单位秒
function Time.FormatTimeYMDHMS(time)
    return os.date("%Y-%m-%d %H:%M:%S", time)
end

--分钟（剩余秒数倒计时）
function Time.FormatTimeM(time, bCeil)
    local m = (bCeil == true) and math.ceil(time / 60) or (time // 60)
    return string.format("%02d分钟", m);
end

-- 获得当前时间戳
function Time.GetTimeStamp(year, month, day, hour, minute, second)
    return os.time({ day = day, month = month, year = year, hour = hour, min = minute, sec = second })
end

function Time.GetMinute()
    return os.date("%M", math.floor(this.GetServerTime() / 1000))
end
function Time.GetSecond()
    return os.date("%S", math.floor(this.GetServerTime() / 1000))
end
function Time.GetHour()
    return os.date("%H", math.floor(this.GetServerTime() / 1000))
end
function Time.GetDay()
    return os.date("%d", math.floor(this.GetServerTime() / 1000))
end
function Time.GetWeekDay()
    return os.date("%w", math.floor(this.GetServerTime() / 1000))
end
function Time.GetYear()
    return os.date("%Y", math.floor(this.GetServerTime() / 1000))
end
function Time.GetMonth()
    return os.date("%m", math.floor(this.GetServerTime() / 1000))
end



-- 根据时间戳判断是否是同一天
function Time.IsSameDay(stampOne, stampTwo)
    local year1, month1, day1 = os.date("%Y", math.floor(stampOne / 1000)), os.date("%m", math.floor(stampOne / 1000)), os.date("%d", math.floor(stampOne / 1000))
    local year2, month2, day2 = os.date("%Y", math.floor(stampTwo / 1000)), os.date("%m", math.floor(stampTwo / 1000)), os.date("%d", math.floor(stampTwo / 1000))

    return year1 == year2 and month1 == month2 and day1 == day2
end

local m = {
    __index = function(t, k)
        return unity_time[k]
    end,

    __newindex = function(t, k, v)
        unity_time[k] = v
    end,
}
setmetatable(Time, m)

CS.UnityEngine.Time = Time