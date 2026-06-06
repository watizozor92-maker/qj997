---@class BagItemCondition
BagItemCondition = class(ConditionBase)

BagItemCondition.comparatorMap = {
    --背包中是否存在当前道具
    [1] = function(self)
        return SL:GetBagItemCount(tonumber(self.param)) > 0
    end,
}

function BagItemCondition:InitParam(param)
    self.param = tonumber(param)
end