ConditionHandler:register(ConditionId.buff["存在某buff"], "存在某buff", function(actor, param)
    return hasbuff(actor,tonumber(param))
end)