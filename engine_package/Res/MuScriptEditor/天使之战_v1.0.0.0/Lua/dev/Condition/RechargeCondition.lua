---@class RechargeCondition
RechargeCondition = class(ConditionBase)

RechargeCondition.comparatorMap = {
    --每日充值金额
    [0] = function(self)
        return InfoManager.dailyAddRechargeInfo.roleTodayAllMoney >  self.param
    end,
    [1] = function(self)
        return InfoManager.dailyAddRechargeInfo.roleTodayAllMoney >=  self.param
    end,
    [2] = function(self)
        return InfoManager.dailyAddRechargeInfo.roleTodayAllMoney ==  self.param
    end,
    [3] = function(self)
        return InfoManager.dailyAddRechargeInfo.roleTodayAllMoney <=  self.param
    end,
    [4] = function(self)
        return InfoManager.dailyAddRechargeInfo.roleTodayAllMoney <  self.param
    end,
    [5] = function(self)
        return InfoManager.dailyAddRechargeInfo.roleTodayAllMoney ~=  self.param
    end,
    --总充值金额
    [6] = function(self)
        return InfoManager.mainRechargeInfo.roleTotalMoney >  self.param
    end,
    [7] = function(self)
        return InfoManager.mainRechargeInfo.roleTotalMoney >=  self.param
    end,
    [8] = function(self)
        return InfoManager.mainRechargeInfo.roleTotalMoney ==  self.param
    end,
    [9] = function(self)
        return InfoManager.mainRechargeInfo.roleTotalMoney <=  self.param
    end,
    [10] = function(self)
        return InfoManager.mainRechargeInfo.roleTotalMoney <  self.param
    end,
    [11] = function(self)
        return InfoManager.mainRechargeInfo.roleTotalMoney ~=  self.param
    end,
}

function RechargeCondition:InitParam(param)
    self.param = tonumber(param)
end