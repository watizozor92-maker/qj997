---@class OtherCondition
OtherCondition = class(ConditionBase)

OtherCondition.comparatorMap = { 
    [0] = function(self)
        local param = tonumber(self.param)
        local data = InfoManager.activityPreviewInfo:GetInActivityInfo(param)
        return data and data.status == 1
    end, 
}

function OtherCondition:InitParam(param)    
    self.param = param
end