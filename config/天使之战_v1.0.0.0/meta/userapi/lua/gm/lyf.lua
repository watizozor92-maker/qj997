-- 通过充值id 代币充值
function trecharge(actor, param)
    local msgData = {}
    msgData["rechargeId"] = tonumber(param)
    msgData["count"] = 1
    Recharge.request(actor, msgData)
end