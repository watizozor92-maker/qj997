---@class VIPCondition
VIPCondition = class(ConditionBase)

VIPCondition.comparatorMap = { 
    [1] = function(self)
        return InfoManager.newVipInfo.vipLevel >=  self.param
    end, 
}

function VIPCondition:InitParam(param)
    self.param = tonumber(param)
end