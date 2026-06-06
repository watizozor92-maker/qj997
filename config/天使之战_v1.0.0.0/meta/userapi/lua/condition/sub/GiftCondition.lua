ConditionHandler:register(ConditionId.gift["购买过特惠礼包"], "购买过特惠礼包", function(actor, param)
    local rechargeRecord = RechargeRecord.get(actor)
    local giftRecoed = rechargeRecord[param]
    return giftRecoed ~= nil
end)
