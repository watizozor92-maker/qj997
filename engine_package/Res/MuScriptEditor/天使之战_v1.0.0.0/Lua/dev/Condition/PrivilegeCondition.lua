---@class PrivilegeCondition
PrivilegeCondition = class(ConditionBase)

PrivilegeCondition.comparatorMap = { 
    [3] = function(self)
        return PrivilegeCardManager.haveSomeonePrivilege(self.param)
    end, 
}

function PrivilegeCondition:InitParam(param)
    self.param = tonumber(param)
end