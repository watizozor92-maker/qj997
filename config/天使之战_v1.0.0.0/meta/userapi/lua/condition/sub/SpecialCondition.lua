ConditionHandler:register(ConditionId.special["使用经验药水"], "使用经验药水", function(actor, param)
    local expDrug = getplaydef(actor, PlayerDefKey.player.EXP_BOOST_EXPIRE_TIME) or {}
    expDrug = expDrug == '' and {} or expDrug
    if table.isNullOrEmpty(expDrug) then
        return false
    end
    local id = expDrug['buffId']
    return string.contains(param, id)
end)

ConditionHandler:register(ConditionId.special["跑环刷新"], "跑环刷新", function(actor, param)
    return TaskLoopManager.checkFlush(actor, param)
end)
