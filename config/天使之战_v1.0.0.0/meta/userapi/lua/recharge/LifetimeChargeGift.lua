LifetimeChargeGift = {}
local function _rechargeType()
    return "7"
end

function LifetimeChargeGift.rechargeEvent(actor, cfg_recharge, count, amount, ext, outRewards)
    --职业
    -- local career = getbaseinfo(actor, "getbasecareer")
    -- 拥有终身礼包的额外奖励
    -- local rewardTable = string.toIntIntMap4Career(career, rechargeCfg['firstreward'], "#", "|")
    local cfg = ConfigDataManager.getById("cfg_Lifetimegiftbag", cfg_recharge["parameter"])
    gameDebug.assertNil(cfg, "cfg_Lifetimegiftbag表找不到配置：", cfg_recharge["parameter"])
    string.putIntIntMap(outRewards, cfg.rewards, "#", "|")
end

---统一的请求消息处理
function LifetimeChargeGift.reqAction(actor, type, action, reqParameter)
    if action == "panel" then
        LifetimeChargeGift.sendPanel(actor, type, action)
    end
end

function LifetimeChargeGift.sendPanel(actor, type, action)
    local data = {}
    local list = ConfigDataManager.getList("cfg_Lifetimegiftbag")
    for _, cfg in pairs(list) do
        local rechargeId = ConfigDataManager.getTableValue("cfg_recharge", "id", "parameter", cfg.id, "type", type)
        if not string.isNullOrEmpty(rechargeId) then
            table.insert(data, rechargeId)
        end
    end
    Recharge.resAction(actor, type, action, data)
end

-- 注册请求消息监听
EventListerTable.registerType("终身礼包", _rechargeType())
RechargeMessageEventListerTable:eventLister(_rechargeType(), "终身礼包", LifetimeChargeGift.reqAction)
RechargeEventListerTable:eventLister(_rechargeType(), "终身礼包", LifetimeChargeGift.rechargeEvent)
