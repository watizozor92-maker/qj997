VipGiftPack = {}
VipGiftPack.__index = VipGiftPack

local this = {}

local function _rechargeType()
    return "8"
end

local function _playerDbKey()
    return "T$_VIP_WEEK_GIFT_DATA_KEY"
end

function VipGiftPack.get(actor)
    local data = getplaydef(actor, _playerDbKey())
    return setmetatable(data or {}, VipGiftPack)
end

function VipGiftPack.getLv(actor)
    local data = VipGiftPack.get(actor)
    return data.lv or 0
end

function VipGiftPack:save(actor)
    setplaydef(actor, _playerDbKey(), self)
end

function VipGiftPack.getVipLv(actor)
    local data = VipGiftPack.get(actor)
    if table.isEmpty(data) then
        return 0
    end
    return data.lv or 0
end

function VipGiftPack.getTargetVipLv(actor, targetRid)
    if targetRid and not tonumber(targetRid) then
        return 0
    end
    local target = targetRid == nil and actor or getactor(actor, targetRid)
    local data = VipGiftPack.get(target)
    if table.isEmpty(data) then
        return 0
    end
    return data.lv or 0
end

function VipGiftPack.login(actor)
    this.queryData(actor, { type = _rechargeType(), action = "panel" })
    this.showVipExpRate(actor)
end

--- 请求充值档位信息
function VipGiftPack.reqRechargeAction(actor, _, action, reqParameter)
    if action == "panel" then
        this.queryData(actor, reqParameter)
    end
end

--- 触发充值
function VipGiftPack.rechargeEvent(actor, cfg_recharge, count, amount, ext, outRewards)
    this.debug("购买VIP礼包", cfg_recharge, "购买数量", count, ext, outRewards)
    local vipGiftId = cfg_recharge.parameter
    local rechargeType = cfg_recharge.type

    local config = ConfigDataManager.getById("cfg_VIP_Pack", vipGiftId)
    gameDebug.assertTrue(table.notEmpty(config), "没有配置VIP礼包", vipGiftId)

    local is_pass = ConditionManager.Check(actor, config.conditionid)
    if not is_pass then
        tipinfo(actor, "VIP购买条件不满足")
        return
    end

    local career = getbaseinfo(actor, "getbasecareer")
    -- 发放道具
    local reward_str = config.rewards
    if not string.isNullOrEmpty(reward_str) then
        string.putIntIntMap4Career(outRewards, career, reward_str, "#", "|")
    end

    local vip_config_list = ConfigDataManager.getTable("cfg_vip", "vippack", vipGiftId)
    if table.notEmpty(vip_config_list) then
        local vip_config = vip_config_list[1]

        this.debug("----- vip_config -----", vip_config, vip_config.grade)
        local lv = string.tonumber(vip_config.grade)

        local gift_data = VipGiftPack.get(actor)
        local old_lv = gift_data.lv or 0

        -- 激活
        gift_data.lv = lv
        gift_data:save(actor)
        local success, result = xpcall(VipPrivilege.activateVIP, debug.traceback, actor, vip_config, old_lv)
        gameDebug.assertPrint(success, "激活特权异常！", result, "vip等级", lv)
        SceneMap.sendEnterViewInfoByType(actor, SceneMap.viewKey.VIP_LV, lv)
    end

    -- 发送界面信息数据
    this.queryData(actor, { type = rechargeType, action = "panel" })
    this.debug("购买VIP礼包成功", cfg_recharge, "购买数量", count, ext, outRewards)
end

function this.queryData(actor, reqParameter)
    this.debug("请求VIP礼包信息", reqParameter)

    local rechargeType = reqParameter["type"]
    local config_list = ConfigDataManager.getList("cfg_VIP_Pack")
    gameDebug.assertTrue(table.notNullOrEmpty(config_list), "没有配置充值档位")

    local gift_data = VipGiftPack.get(actor)
    local resData = {}
    this.debug("配置表数据", config_list)

    resData['lv'] = gift_data.lv or 0
    Recharge.resAction(actor, rechargeType, reqParameter.action, resData)
end

-- ------------------------------------------------------------- --
VipPrivilege = {}

VipPrivilege.Type = {
    -- goldway = "goldway",               -- 黄金线路
    rate = "rate",                     -- 攻速加成
    castle = "castle",                 -- 血色城堡每日次数
    plaza = "plaza",                   -- 恶魔广场每日次数
    exp = "exp",                       -- 经验加成
    attributepoint = "attributepoint", -- 赠送额外属性点
    recycle = "recycle",               -- 收回金币提升
    explosiverate = "explosiverate",   -- 套装爆率提升
    tax = "tax",                       -- 交易行税率下降
    kalima = "kalima",                 -- 卡利玛每日次数
}

function VipGiftPack.hasPrivilege(actor, type)
    local gift_data = VipGiftPack.get(actor)
    if table.isEmpty(gift_data) then
        return false
    end

    local lv = gift_data.lv
    local config = ConfigDataManager.getById("cfg_vip", lv)
    if table.isNullOrEmpty(config) then
        return false, 0
    end

    this.debug("VIP获取特权信息", "VIP等级", lv, "VIP特权配置", config[type], config)
    return true, config[type]
end

function VipPrivilege.activateVIP(actor, vip_config, old_lv)
    -- 添加自由属性
    local point_data = vip_config[VipPrivilege.Type.attributepoint]
    if not string.isNullOrEmpty(point_data) then
        local point_item = string.toIntIntMap(point_data, "#", "|")
        additemmaptobag(actor, point_item, 0, 9999, ItemActionProxy.VIPPRIVILEGE)
    end

    -- 活动剩余次数
    local dup_add_map = {}

    -- 血色城堡和恶魔广场
    this.addDupCount(dup_add_map, vip_config, VipPrivilege.Type.castle)
    this.addDupCount(dup_add_map, vip_config, VipPrivilege.Type.plaza)
    this.addDupLeftCount(actor, dup_add_map)

    -- 属性加成
    local attr_map = {}
    -- 攻速加成属性
    this.addAttr(attr_map, vip_config, VipPrivilege.Type.rate)
    -- 套装爆率提升属性
    this.addAttr(attr_map, vip_config, VipPrivilege.Type.explosiverate)
    -- 经验加成属性
    this.addAttr(attr_map, vip_config, VipPrivilege.Type.exp)
    --副本每日次数
    this.addDupCount(dup_add_map, vip_config, VipPrivilege.Type.kalima)
    addrolekmlattributes(actor, RoleAttrKey.VIP_GIFT_PACK, attr_map)

    -- 经验加成前端显示协议
    this.showVipExpRate(actor)

    this.debug("---- VIP特权结算 ----", "lv " .. vip_config.grade,
        "dup_count", dup_add_map, "attr_map", attr_map, "point", point_data)
end

function VipPrivilege.entryCountHandler(actor, activityId)
    local dup_map = {}
    local act_id = tonumber(activityId)
    if act_id == DuplicateType.BLOODY_CASTLE then
        this.getLevelActivityCount(actor, dup_map, VipPrivilege.Type.castle)
    elseif act_id == DuplicateType.DEVIL_SQUARE then
        this.getLevelActivityCount(actor, dup_map, VipPrivilege.Type.plaza)
    elseif act_id == DuplicateType.KALIMA_TEMP then
        this.getLevelActivityCount(actor, dup_map, VipPrivilege.Type.kalima)
    end
    this.addDupLeftCount(actor, dup_map)
end

function this.getLevelActivityCount(actor, dup_map, type)
    local level = VipGiftPack.getLv(actor)
    if level < 1 then
        return
    end

    for lv = 1, level do
        local config = ConfigDataManager.getById("cfg_vip", lv)
        if table.notEmpty(config) then
            this.addDupCount(dup_map, config, type)
        end
    end
end

function this.addDupCount(dup_add_map, vip_config, type)
    local str = vip_config[type]
    if not string.isNullOrEmpty(str) then
        string.putIntIntMap(dup_add_map, str, "#", "|")
    end
end

function this.addAttr(attr_map, vip_config, type)
    string.putIntIntMap(attr_map, vip_config[type], "#", "|")
end

function this.addDupLeftCount(actor, dup_map)
    if table.isEmpty(dup_map) then
        return
    end
    for k, v in pairs(dup_map) do
        if v > 0 then
            addleftcountofactivity(actor, k, v)
        end
    end
end

function this.showVipExpRate(actor)
    local is_has, rate = VipGiftPack.hasPrivilege(actor, VipPrivilege.Type.exp)
    if is_has then
        local rate_arr = string.split(rate, "#")
        ExpBonus.changeBonus(actor, BonusType.VIP_EXP_BONUS, tonumber(rate_arr[2]), 0, 0)
    end
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
EventListerTable.registerType("VIP礼包", _rechargeType(), _playerDbKey())
-- 注册登录事件
LoginEventListerTable:eventLister("0", "VIP礼包", VipGiftPack.login)
-- 注册充值回调事件
RechargeEventListerTable:eventLister(_rechargeType(), "recharge_vip_gift", VipGiftPack.rechargeEvent)
-- 注册请求消息监听
RechargeMessageEventListerTable:eventLister(_rechargeType(), "req_vip_gift_info", VipGiftPack.reqRechargeAction)
