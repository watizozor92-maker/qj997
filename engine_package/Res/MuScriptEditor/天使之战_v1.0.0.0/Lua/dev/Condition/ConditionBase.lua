---@class ConditionBase
ConditionBase = class()

ConditionBase.comparatorMap = {}

function ConditionBase:ctor(compareType,param)
    self.compareType = compareType
    self.comparator = self:GetComparator(compareType)
    self:InitParam(param)
end

function ConditionBase:InitParam(param)
    self.param = param
end

function ConditionBase:GetComparator(compareType)
    assert(self.comparatorMap[compareType],string.format('%d%s未定义',self.type,compareType))
    return self.comparatorMap[compareType]
end

function ConditionBase:Check()
    return self:comparator()
end

function ConditionBase:ReSet(compareType,param)
    self.compareType = compareType
    self.comparator = self:GetComparator(compareType)
    self:InitParam(param)
end

function ConditionBase:ConditionType()
    return self.type * 100 + self.compareType
end