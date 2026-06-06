--月卡相关
MonthCard = {}

local function _rechargeType1()
    return "21"
end

local function _rechargeType2()
    return "22"
end

local function _playerDbKey()
    return "T$monthcard"
end

function MonthCard.resResult(actor, cfg_recharge, count, amount, ext, outRewards)
    Recharge.resAction(actor, cfg_recharge.type, "reward", {})
end
--TODO 一定要放到文件最后
EventListerTable.registerType("月卡白银卡", _rechargeType1())
EventListerTable.registerType("月卡黄金卡", _rechargeType2())
--注册充值事件
RechargeEventListerTable:eventLister(_rechargeType1(), "月卡白银卡", MonthCard.resResult)
RechargeEventListerTable:eventLister(_rechargeType2(), "月卡黄金卡", MonthCard.resResult)