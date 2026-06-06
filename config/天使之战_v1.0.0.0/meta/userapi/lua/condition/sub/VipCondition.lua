ConditionHandler:register(ConditionId.vip["vip等级"], "vip等级", function(actor, param)
    local lv = VipGiftPack.getLv(actor)
    return lv >= tonumber(param)
end)