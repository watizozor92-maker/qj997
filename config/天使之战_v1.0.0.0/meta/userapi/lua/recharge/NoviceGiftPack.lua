NoviceGiftPack = {}
NoviceGiftPack.__index = NoviceGiftPack

local function _rechargeType()
    return "9"
end

function NoviceGiftPack.rechargeEvent(actor, cfg, count, amount, ext, outRewards)
    local cfg = ConfigDataManager.getById("cfg_Starterpack", cfg["parameter"])
    gameDebug.assertNil(cfg, "cfg_Starterpack表找不到配置：", cfg["parameter"])
    string.putIntIntMap(outRewards, cfg.rewards, "#", "|")
end

function NoviceGiftPack.reqAction(actor, type, action, reqParameter)
    if action == "panel" then
        NoviceGiftPack.sendPanel(actor, type, action)
    end
end

function NoviceGiftPack.zero(actor)
    NoviceGiftPack.sendPanel(actor, _rechargeType(), "panel")
end

function NoviceGiftPack.login(actor)
    NoviceGiftPack.sendPanel(actor, _rechargeType(), "panel")
end

function NoviceGiftPack.sendPanel(actor, type, action)
    local data = {}
    local list = ConfigDataManager.getList("cfg_Starterpack")
    for _, cfg in pairs(list) do
        if ConditionManager.Check(actor, cfg.condition) then
            -- 充值项
            local rechargeId = ConfigDataManager.getTableValue("cfg_recharge", "id", "parameter", cfg.id, "type", type)
            if not string.isNullOrEmpty(rechargeId) then
                table.insert(data, rechargeId)
            end
        end
    end

    if not table.isNullOrEmpty(data) then
        Recharge.resAction(actor, type, action, data)
    end
end

-- 注册请求消息监听
EventListerTable.registerType("新手礼包", _rechargeType())
ZeroEventListerTable:eventLister("0", "新手礼包", NoviceGiftPack.zero)
LoginEventListerTable:eventLister("0", "新手礼包", NoviceGiftPack.login)
RechargeMessageEventListerTable:eventLister(_rechargeType(), "新手礼包", NoviceGiftPack.reqAction)
RechargeEventListerTable:eventLister(_rechargeType(), "新手礼包", NoviceGiftPack.rechargeEvent)
