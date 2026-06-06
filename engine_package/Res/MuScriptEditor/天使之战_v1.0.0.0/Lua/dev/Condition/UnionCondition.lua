
---@class UnionCondition
UnionCondition = class(ConditionBase)

UnionCondition.comparatorMap = {
    [0] = function(self)
        --新增加入战盟时间（单位分钟）
        if string.isNullOrEmpty(self.param) then
            return false
        end
        return InfoManager.unionElectionInfo:GetJoinUnionTime() > self.param
    end,
    [1] = function(self)
        --新增加入战盟时间（单位分钟）
        if string.isNullOrEmpty(self.param) then
            return false
        end
        return InfoManager.unionElectionInfo:GetJoinUnionTime() >=  self.param
    end,
    --新增加入战盟时间（单位分钟）
    [2] = function(self)
        if string.isNullOrEmpty(self.param) then
            return false
        end
        return InfoManager.unionElectionInfo:GetJoinUnionTime() ==  self.param
    end,
    [3] = function(self)
        if string.isNullOrEmpty(self.param) then
            return false
        end
        return InfoManager.unionElectionInfo:GetJoinUnionTime() <=  self.param
    end,
    [4] = function(self)
        if string.isNullOrEmpty(self.param) then
            return false
        end
        return InfoManager.unionElectionInfo:GetJoinUnionTime() <  self.param
    end,
    [5] = function(self)
        if string.isNullOrEmpty(self.param) then
            return false
        end
        return InfoManager.unionElectionInfo:GetJoinUnionTime() ~=  self.param
    end,
    
}

function UnionCondition:InitParam(param)
    self.param = tonumber(param)
end