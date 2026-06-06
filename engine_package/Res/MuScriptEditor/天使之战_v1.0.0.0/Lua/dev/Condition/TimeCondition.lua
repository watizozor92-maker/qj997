

---@class TimeCondition
TimeCondition = class(ConditionBase)

TimeCondition.comparatorMap = { 
    [0] = function(self)
        if not self.param then
            return false
        end
        return SL:GetOpenServerDay() > tonumber(self.param)
    end,
	[1] = function(self)
        if not self.param then
            return false
        end
        return SL:GetOpenServerDay() >= tonumber(self.param)
    end,
    [2] = function(self)
        if not self.param then
            return false
        end
        return SL:GetOpenServerDay() == tonumber(self.param)
    end,
    [3] = function(self)
        if not self.param then
            return false
        end
        return SL:GetOpenServerDay() <= tonumber(self.param)
    end,
    [4] = function(self)
        if not self.param then
            return false
        end
        return SL:GetOpenServerDay() < tonumber(self.param)
    end,
    [5] = function(self)
        if not self.param then
            return false
        end
        return SL:GetOpenServerDay() ~= tonumber(self.param)
    end,
    [71] = function(self)
        --判断是否在日期区间内
        if string.isNullOrEmpty(self.param) then
            return false
        end
        return InfoManager.mainOperateActivityInfo:IntervalTweenyearTime(self.param)
    end,
    [91] = function(self)
        --判断今天是否是周几 910
        if not self.param then
            return false
        end
        return InfoManager.mainOperateActivityInfo:WhatDayIsTodayInWeek() == tonumber(self.param)
    end,

    ---运营活动 持续天数
    [80] = function(self)
        if not string.isNullOrEmpty(self.param) then
            local content = string.split(self.param,"#")
            if InfoManager.mainOperateActivityInfo.NowOperateActivityMainGroup == tonumber(content[1]) then
                return InfoManager.mainOperateActivityInfo:GetDurationDayMainGroup() <= tonumber(content[2])
            end
        end
        return false
    end,
    [81] = function(self)
        if not string.isNullOrEmpty(self.param) then
            local content = string.split(self.param,"#")
            if InfoManager.mainOperateActivityInfo.NowOperateActivityMainGroup == content[1] then
                return InfoManager.mainOperateActivityInfo:JudgeThisSubtypeActivityIsOpen(content[2]) and
                         InfoManager.mainOperateActivityInfo:GetDurationDaySubType(content[2]) <= content[3]
            end
        end
        return false
    end,
}

function TimeCondition:InitParam(param)
    self.param = param
end