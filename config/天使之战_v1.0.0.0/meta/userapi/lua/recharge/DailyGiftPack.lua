---
--- Created by zhouzhipeng.
--- DateTime: 2024/11/5 上午11:13
--- Desc：每日礼包
---

DailyGiftPack = {}
DailyGiftPack.__index = DailyGiftPack

local this = {}

--local DAILY_GIFT = 4
--- 每日礼包类型
local function _rechargeType()
    return "4"
end

local function _playerDbKey()
    return "J$daily_gift_pack_data"
end

function DailyGiftPack.get(actor)
    local obj = getplaydef(actor, _playerDbKey())
    return setmetatable(obj or {}, DailyGiftPack)
end

function DailyGiftPack:save(actor)
    setplaydef(actor, _playerDbKey(), self);
end

function DailyGiftPack:setRecordIndex(rechargeId, index)
    if not self.dailyGiftInfo then
        self.dailyGiftInfo = {}
    end
    self.dailyGiftInfo[rechargeId] = index
end

function DailyGiftPack:getRecordIndex(rechargeId)
    if not self.dailyGiftInfo then
        self.dailyGiftInfo = {}
    end
    return self.dailyGiftInfo[rechargeId] or 0
end

---充值事件触发
function DailyGiftPack.rechargeEvent(actor, cfg_recharge, count, amount, ext, outRewards)
    DailyGiftPack.print(actor, "购买每日礼包", cfg_recharge, "购买数量", count, ext, outRewards)
    if ext == "" then
        ext = {}
    end
    local dailyGiftId = cfg_recharge.parameter
    local rechargeType = cfg_recharge.type
    local cfg_DailyGiftPack = ConfigDataManager.getById("cfg_DailyGiftPack", dailyGiftId)
    gameDebug.assertTrue(table.notNullOrEmpty(cfg_DailyGiftPack), "没有配置每日礼包", dailyGiftId)
    if not ConditionManager.Check(actor, cfg_DailyGiftPack.conditionid) then
        tipinfo(actor, "购买条件不满足")
        return
    end
    local purchase = cfg_DailyGiftPack.purchase
    local dailyGiftPack = DailyGiftPack.get(actor)
    if string.isNullOrEmpty(purchase) then
        local cfgs = ConfigDataManager.getTable("cfg_DailyGiftPack", "purchase", dailyGiftId)
        if not cfgs then
            tipinfo(actor, "一键购买配置错误")
        end
        -- 判断是否购买过单个礼包
        for _, cfg in pairs(cfgs) do
            if tonumber(cfg.price) == 0 then
                goto continue
            end
            local c = CountManager.getCount(actor, cfg["limited"])
            local buyCount = c.count
            if buyCount > 0 then
                tipinfo(actor, "购买过单个礼包")
                return
            end
            :: continue ::
        end
        gameDebug.assertTrue(table.notNullOrEmpty(cfgs), "没有一键购买每日礼包配置", dailyGiftId)
        DailyGiftPack.print("读取的配置", cfgs)
        -- 购买一键礼包
        for i = 1, #cfgs do
            local cfg = cfgs[i]
            if tonumber(cfg.price) == 0 then
                goto continue
            end
            local limited = cfg["limited"]
            local total = tonumber(ConfigDataManager.getTableValue("Count_count", "total", "id", limited))
            local index = ext[tonumber(cfg.id)] or 0
            for j = 1, total do
                DailyGiftPack.print(actor, "购买一键礼包", cfg.id, "购买次数", j, "i", i, "ext", ext, "ext[e]", index)
                this.mergeItem(outRewards, cfg, index)
            end
            local recId = ConfigDataManager.getTableValue("cfg_recharge", "id", "parameter", cfg.id, "type", rechargeType)
            if index ~= 0 then
                dailyGiftPack:setRecordIndex(recId, index)
            end
            CountManager.count(actor, limited, total)
            :: continue ::
        end
    else
        -- 购买单个礼包
        local index = ext[tonumber(cfg_DailyGiftPack.id)] or 0
        this.mergeItem(outRewards, cfg_DailyGiftPack, index)
        if index ~= 0 then
            dailyGiftPack:setRecordIndex(cfg_recharge.id, index)
        end
    end
    dailyGiftPack:save(actor)
    -- 发送界面信息数据
    DailyGiftPack.queryData(actor, { type = rechargeType, action = "panel" })
    DailyGiftPack.print(actor, "购买每日礼包成功", cfg_recharge, "购买数量", count, ext, outRewards)
end

--- 请求充值档位信息
---@param msgData table 请求参数
function DailyGiftPack.reqRechargeAction(actor, rechargeType, action, reqParameter)
    if action == "panel" then
        DailyGiftPack.queryData(actor, reqParameter)
    elseif action == "reward" then
        DailyGiftPack.gainReward(actor, reqParameter)
    end
end

--- 每日礼包信息
function DailyGiftPack.queryData(actor, reqParameter)
    DailyGiftPack.print(actor, "请求每日礼包信息", reqParameter)
    local rechargeType = reqParameter["type"]
    local dailyGiftPacks = ConfigDataManager.getList("cfg_DailyGiftPack")
    gameDebug.assertTrue(table.notNullOrEmpty(dailyGiftPacks), "没有配置充值档位")
    local resData = {}
    local group = 0
    local countInfo = {}
    local dailyGiftPack = DailyGiftPack.get(actor)
    DailyGiftPack.print("配置表数据", dailyGiftPacks)
    for _, cfg in pairs(dailyGiftPacks) do
        if ConditionManager.Check(actor, cfg.conditionid) then
            local id = cfg.id
            local rechargeId = ConfigDataManager.getTableValue("cfg_recharge", "id", "parameter", id, "type", rechargeType)
            --local c = CountManager.getCount(actor, cfg["limited"])
            --local count = c.count
            local index = dailyGiftPack:getRecordIndex(rechargeId)
            countInfo[rechargeId] = index
            group = cfg.packagetype
        end
    end
    resData['group'] = group
    resData['countInfo'] = countInfo
    Recharge.resAction(actor, rechargeType, reqParameter.action, resData)
end

function DailyGiftPack.gainReward(actor, reqParameter)

end

function this.mergeItem(outRewards, cfg, index)
    string.putIntIntMap(outRewards, cfg['rewards'], "#", "|")
    -- todo 待优化，optionalreward   分隔为  {1={itemId=count},2={itemId=count},3={itemId=count}}
    local optionalReward = cfg['optionalreward']
    if not string.isNullOrEmpty(optionalReward) then
        local strShuXian = string.split(optionalReward, "|")
        local strJinHao = strShuXian[index]
        DailyGiftPack.print("合并奖励", cfg, "分隔好的", strShuXian, "根据索引选的", strJinHao, "索引", index)
        local str = string.split(strJinHao, "#")
        local itemCfgId = tonumber(str[1])
        local oldCount = outRewards[itemCfgId] or 0
        outRewards[itemCfgId] = oldCount + tonumber(str[2])
    end
end

--- 登录处理
function DailyGiftPack.login(play)
    DailyGiftPack.queryData(play, { type = _rechargeType(), action = "panel" })
end

--- 零点处理
function DailyGiftPack.zero(play)
    DailyGiftPack.queryData(play, { type = _rechargeType(), action = "panel" })
end

--- 打印日志
local isPrintLog = true
function DailyGiftPack.print(...)
    if isPrintLog then
        return
    end
    gameDebug.print(...)
end

function dailygiftpacktest(actor, id, type)
    gameDebug.print(actor, "请求每日礼包", id)
    local tab
    if tonumber(type == 1) then
        tab = { [1] = 1 }
    else
        tab = { [1] = 1, [2] = 1, [3] = 1, [4] = 1 }
    end
    Recharge.request(actor, { rechargeId = id, count = 1, extraParams = tab })
end

EventListerTable.registerType("每日礼包", _rechargeType(), _playerDbKey())
-- 凌晨刷新事件
ZeroEventListerTable:eventLister("0", "每日礼包", DailyGiftPack.zero)
-- 注册登录事件
LoginEventListerTable:eventLister("0", "每日礼包", DailyGiftPack.login)
-- 注册充值回调事件
RechargeEventListerTable:eventLister(_rechargeType(), "每日礼包", DailyGiftPack.rechargeEvent)
-- 注册请求消息监听
RechargeMessageEventListerTable:eventLister(_rechargeType(), "每日礼包", DailyGiftPack.reqRechargeAction)