WeeklyGiftPack = {}
WeeklyGiftPack.__index = WeeklyGiftPack

local this = {}

local function _rechargeType()
    return "6"
end

local function _playerDbKey()
    return nil
end

function WeeklyGiftPack.login(actor)
    this.queryData(actor, { type = _rechargeType(), action = "panel" })
end

--- 请求充值档位信息
function WeeklyGiftPack.reqRechargeAction(actor, _, action, reqParameter)
    if action == "panel" then
        this.queryData(actor, reqParameter)
    end
end

--- 触发充值
function WeeklyGiftPack.rechargeEvent(actor, cfg_recharge, count, amount, ext, outRewards)
    this.debug("购买每周礼包", cfg_recharge, "购买数量", count, ext, outRewards)
    local weekGiftId = cfg_recharge.parameter
    local rechargeType = cfg_recharge.type

    local config = ConfigDataManager.getById("cfg_weeklygiftpack", weekGiftId)
    gameDebug.assertTrue(table.notEmpty(config), "没有配置每周礼包", weekGiftId)

    local is_pass = ConditionManager.Check(actor, config.conditionid)
    if not is_pass then
        tipinfo(actor, "每周礼包购买条件不满足")
        return
    end

    local reward_str = config.rewards
    if not string.isNullOrEmpty(reward_str, reward_str) then
        string.putIntIntMap(outRewards, reward_str, "#", "|")
        this.debug("----- 获得的奖励 -----", outRewards)
    end

    -- 发送界面信息数据
    this.queryData(actor, { type = rechargeType, action = "panel" })
    this.debug("购买每周礼包成功", cfg_recharge, "购买数量", count, ext, outRewards)
end

function WeeklyGiftPack.weekZero(actor)
    this.debug("---------- 触发周凌晨事件 -----------")
    intervalcalldelay(actor, 5000, 1000, 1, "delayflushweekgiftpackpanel", { type = _rechargeType(), action = "panel" })
end

function delayflushweekgiftpackpanel(actor, data)
    this.queryData(actor, data)
end

function this.queryData(actor, reqParameter)
    this.debug("请求每周礼包信息", reqParameter)

    local rechargeType = reqParameter["type"]
    local config_list = ConfigDataManager.getList("cfg_weeklyGiftPack")
    gameDebug.assertTrue(table.notNullOrEmpty(config_list), "没有配置充值档位")

    local resData = {}
    local recharge_ids = {}
    local group = 0

    for _, config in pairs(config_list) do
        if ConditionManager.Check(actor, config.conditionid) then
            group = config.packagetype
            local rechargeId = ConfigDataManager.getTableValue("cfg_recharge", "id", "parameter", config.id, "type", rechargeType)
            table.insert(recharge_ids, rechargeId)

            -- 刷新购买数据
            local count_key = ConfigDataManager.getTableValue("cfg_recharge", "countkey", "id", rechargeId)
            CountManager.getCount(actor, count_key)
        end
    end
    resData['group'] = group
    resData['recharge_ids'] = recharge_ids
    Recharge.resAction(actor, rechargeType, reqParameter.action, resData)
end


-- ------------------------------------------------------------- --
this.log_open = false

function this.debug(...)
    if not this.log_open then
        return
    end
    gameDebug.print(...)
end

function this.jprint(...)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(...)
end


-- ------------------------------------------------------------- --
EventListerTable.registerType("每周礼包", _rechargeType(), _playerDbKey())
-- 注册事件
LoginEventListerTable:eventLister("0", "recharge_week_gift", WeeklyGiftPack.login)
-- 凌晨事件
ZeroEventListerTable:eventLister("0", "每周礼包", WeeklyGiftPack.weekZero)
RechargeEventListerTable:eventLister(_rechargeType(), "recharge_week_gift", WeeklyGiftPack.rechargeEvent)
-- 注册请求消息监听
RechargeMessageEventListerTable:eventLister(_rechargeType(), "req_week_gift_info", WeeklyGiftPack.reqRechargeAction)
