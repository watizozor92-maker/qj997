Count = class()
local this = Count

function this:ctor(t)
    if t == nil then
        self.type = 0
        self.key = 0
        self.count = 0
        self.updateTime = 0
        self.total = 0
        self.totalUpdateTime = 0
    else
        self.type = t.type
        self.key = t.key
        self.count = t.count
        self.updateTime = t.updateTime
        self.total = t.total
        self.totalUpdateTime = t.totalUpdateTime
    end
end

function this:canAdd(add)
    if self.type == 0 then
        return true
    end
    local count = self.count + add
    if count > self.total then
        return false
    end
    return true
end

function this:countNum(actor, add)
    local now = getbaseinfo("nowsec")
    local oldCount = self.count
    local oldTime = self.updateTime

    self.count = self.count + add
    self.updateTime = now
    logop(actor, LogOpType.COUNT, "key:" ..self.key.. " countNum oldCount:" .. oldCount .. " add:" .. add .. " oldTime:" .. oldTime)
    info("玩家", actor, "计数计数数据", "oldCount", oldCount, "add", add, "oldTime", oldTime, "当前数据", self)
    return self.count
end

function this:canRefreshTotal(now)
    return false
end

function this:refreshTotal(now)
    return false
end

function this:canResetCount(now)
    if self.type == 1 then
        return false
    elseif self.type == 2 and (not TimeUtil.isSameMonth(self.updateTime, now)) then
        return true
    elseif self.type == 3 and (not TimeUtil.isSameWeek(self.updateTime, now)) then
        return true
    elseif self.type == 4 and (not TimeUtil.isSameDay(self.updateTime, now)) then
        return true
    elseif self.type == 5 and (TimeUtil.diffDays(self.updateTime, now) >= 7) then
        return true
    elseif self.type == 6 and (TimeUtil.diffDays(self.updateTime, now) >= 30) then
        return true
    end
    return false
end

function this:reset(actor, now)
    local oldCount = self.count
    local oldTime = self.updateTime
    self.count = 0
    self.updateTime = now
    logop(actor, LogOpType.COUNT, "key:" ..self.key.. " resetCount oldCount:" .. oldCount .. " oldTime:" .. oldTime)
    info("玩家", actor, "重置计数数据", "oldCount", oldCount, "oldTime", oldTime, "当前数据", self)
end

function this:toBuilder()
    return {
        ["key"] = self.key,
        ["count"] = self.count,
        ["total"] = self.total
    }
end
