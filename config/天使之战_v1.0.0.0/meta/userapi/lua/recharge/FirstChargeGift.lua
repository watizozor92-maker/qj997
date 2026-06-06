FirstChargeGift = {}
FirstChargeGift.__index = FirstChargeGift

local function _rechargeType()
    return "3"
end

local function _playerDbKey()
    return "T$recharge_first_gift_data"
end

function FirstChargeGift.getData(actor)
    local var = getplaydef(actor, _playerDbKey())
    local data = setmetatable(var or {}, FirstChargeGift)
    if data.rewards == nil then
        data.rewards = {}
    end
    if not data.totalMoney then
        data.totalMoney = 0
    end
    return data
end

function FirstChargeGift:saveData(actor)
    setplaydef(actor, _playerDbKey(), self)
end

---充值回调触发事件
function FirstChargeGift.rechargeEvent(actor, cfg_recharge, count, amount, ext, outRewards)
    local data = FirstChargeGift.getData(actor)
    if tonumber(data[cfg_recharge["parameter"]] or 0) > 0 then
        return
    end
    data.totalMoney = data.totalMoney + amount
    local configs = ConfigDataManager.getTable("cfg_first_charge")
    gameDebug.assertTrue(not table.isNullOrEmpty(configs), "首充礼包配置为空")
    for _, config in ipairs(configs) do
        if string.isNullOrEmpty(config["showswitch"]) then
            local cfg_recharge_amount = ConfigDataManager.getTableValue("cfg_recharge", "amount", "type", _rechargeType(), "parameter", config["id"])
            gameDebug.assertNil(cfg_recharge_amount, "查找充值配置异常", "type", _rechargeType(), "parameter", config["id"])
            if data.totalMoney >= tonumber(cfg_recharge_amount) then
                if tonumber(data.rewards[config["id"]] or 0) < 1 then
                    data.rewards[config["id"]] = 1
                end
            end
        end
    end
    FirstChargeGift.saveData(data, actor)
    FirstChargeGift.sendPanel(actor, data)
    -- jprint("更新豪礼数据",data,config)
end

---统一的请求消息处理
function FirstChargeGift.reqAction(actor, type, action, reqParameter)
    if action == "panel" then
        local data = FirstChargeGift.getData(actor)
        FirstChargeGift.sendPanel(actor, data)
    elseif action == "reward" then
        FirstChargeGift.gainReward(actor, reqParameter)
    end
end

function FirstChargeGift.gainReward(actor, reqParameter)
    local id = tostring(reqParameter["id"])

    local rechargeCfg = ConfigDataManager.getById("cfg_first_charge", id)
    gameDebug.assertTrue(table.notNullOrEmpty(rechargeCfg), "首充配置查找失败", id)

    local data = FirstChargeGift.getData(actor)
    local reward = data.rewards[id] or 0

    if reward < 1 then
        tipinfo(actor, "未达到领取条件")
        return
    end

    if reward > 1 then
        tipinfo(actor, "已经领取条件")
        return
    end

    -- 改变状态
    data.rewards[id] = 2
    FirstChargeGift.saveData(data, actor)
    info(actor, "领取首充礼包", actor, id)
    -- 发送奖励
    Bag.sendRewards4CareerString(actor, rechargeCfg['firstreward'], ItemActionProxy.FIRST_RECHARGE_GIFT)
    FirstChargeGift.sendPanel(actor, data)
    -- jprint("领奖豪礼数据",data)
end

function FirstChargeGift.sendPanel(actor, data)
    Recharge.resAction(actor, _rechargeType(), "panel", data)
end

--TODO 一定要放到文件最后
EventListerTable.registerType("首充礼包", _rechargeType(), _playerDbKey())
--注册充值事件
RechargeEventListerTable:eventLister(_rechargeType(), "首充礼包", FirstChargeGift.rechargeEvent)
-- 注册请求消息监听
RechargeMessageEventListerTable:eventLister(_rechargeType(), "首充礼包", FirstChargeGift.reqAction)