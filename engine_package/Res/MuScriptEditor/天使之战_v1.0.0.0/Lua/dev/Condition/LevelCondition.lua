---@class LevelCondition
LevelCondition = class(ConditionBase)

LevelCondition.comparatorMap = {
    [0] = function(self) 
        return SL:MeData_GetLevel() >  self.param
    end,
    [1] = function(self) 
        return SL:MeData_GetLevel() >=  self.param
    end,
    [2] = function(self) 
        return SL:MeData_GetLevel() ==  self.param
    end,
    [3] = function(self) 
        return SL:MeData_GetLevel() <=  self.param
    end,
    [4] = function(self) 
        return SL:MeData_GetLevel() <  self.param
    end,
    [5] = function(self) 
        return SL:MeData_GetLevel() ~=  self.param
    end,
}

function LevelCondition:InitParam(param)
    self.param = tonumber(param)
end


