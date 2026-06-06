DailyRecharge = {}
DailyRecharge.__index = DailyRecharge
local function _rechargeType()
    return "11"
end
local function _playerDbKey()
    return "T$daily_recharge"
end

function DailyRecharge.get(actor)
    local obj = getplaydef(actor, _playerDbKey())
    return setmetatable(obj or {}, DailyRecharge)
end

function DailyRecharge:save(actor)
    setplaydef(actor, _playerDbKey(), self)
end

function DailyRecharge.rechargeEvent(actor, cfg, count, amount, ext, outRewards)
    local dailyRecharge = DailyRecharge.get(actor)
    local update = false
    for _, task in pairs(dailyRecharge.data) do
        local goal = ConfigDataManager.getTableValue("cfg_dailyRecharge", "goal", "id", task.id)
        local rechargeRecord = RechargeRecord.get(actor)
        if task.state == 2 and rechargeRecord:totalDailyMoney() >= tonumber(goal) then
            task.state = 1
            update = true
        end
    end

    if update then
        dailyRecharge:save(actor)
        DailyRecharge.sendPanel(actor, _rechargeType(), "panel")
    end
end

function DailyRecharge.reqAction(actor, type, action, reqParameter)
    if action == "panel" then
        DailyRecharge.sendPanel(actor, type, action)
    elseif action == "reward" then
        DailyRecharge.gainReward(actor, reqParameter)
    end
end

function DailyRecharge.gainReward(actor, reqParameter)
    local id = tostring(reqParameter["id"])
    local dailyRecharge = DailyRecharge.get(actor)
    local task = dailyRecharge.data[id]
    if task == nil then
        tipinfo(actor, "找不到该任务")
        return
    end
    if task.state ~= 1 then
        tipinfo(actor, "该任务未完成")
        return
    end
    task.state = 3
    dailyRecharge:save(actor)
    --发奖励
    local rewardstr = ConfigDataManager.getTableValue("cfg_dailyRecharge", "reward", "id", task.id)
    local rewards = string.toStringIntMap(rewardstr, "#", "|")
    -- 发送奖励
    additemmaptobag(actor, rewards, 0, 9999, ItemActionProxy.DAILYRECHARGE)
    --奖励面板
    sendluamsg(actor, LuaMessageIdToClient.COMMON_REWARD_PANEL, rewards)
    DailyRecharge.sendPanel(actor, _rechargeType(), "panel")
end

function DailyRecharge.sendPanel(actor, type, action)
    local data = {}
    local dailyRecharge = DailyRecharge.get(actor)
    if table.isNullOrEmpty(dailyRecharge.data) then
        dailyRecharge = DailyRecharge.refreshData(actor)
    end
    for _, v in pairs(dailyRecharge.data) do
        table.insert(data, { dailyRechargeId = v.id, giftState = v.state })
    end

    if not table.isNullOrEmpty(data) then
        jprint("每日累充任务面板", data)
        Recharge.resAction(actor, type, action, data)
    end
end

function DailyRecharge.zeroCheckRewards(actor)
    local dailyRecharge = DailyRecharge.get(actor)
    local reward_items = {}
    local mailId = 0
    if dailyRecharge.data then
        for _, task in pairs(dailyRecharge.data) do
            if task.state == 1 then
                local cfg = ConfigDataManager.getById("cfg_dailyRecharge", task.id)
                string.putIntIntMap(reward_items, cfg.reward, "#", "|")
                mailId = cfg.mail
            end
        end
    end

    if not table.isNullOrEmpty(reward_items) and mailId ~= 0 then
        sendconfigmailbyrid(actor, actor:toString(), mailId, reward_items, "", 1)
    end
end

function DailyRecharge.refreshData(actor)
    local dailyRecharge = DailyRecharge.get(actor)
    local data = {}
    local list = ConfigDataManager.getList("cfg_dailyRecharge")
    for _, cfg in pairs(list) do
        if ConditionManager.Check(actor, cfg.condition) then
            -- 充值项
            local task = {}
            task.id = cfg.id
            task.state = tonumber(cfg.goal) == 0 and 1 or 2
            data[cfg.id] = task
        end
    end
    dailyRecharge.data = data
    dailyRecharge.updateTime = getbaseinfo("nowsec")
    dailyRecharge:save(actor)
    return dailyRecharge
end

function DailyRecharge.zero(actor)
    local now = getbaseinfo("nowsec")
    local dailyRecharge = DailyRecharge.get(actor)
    if table.isNullOrEmpty(dailyRecharge.data) then
        dailyRecharge = DailyRecharge.refreshData(actor)
    end
    -- 线上数据未初始化
    dailyRecharge.updateTime = dailyRecharge.updateTime and dailyRecharge.updateTime or 0
    if not TimeUtil.isSameDay(now, dailyRecharge.updateTime) then
        info("每日累充0点刷新", "玩家", actor)
        -- DailyRecharge.zeroCheckRewards(actor)
        DailyRecharge.refreshData(actor)
    end
    -- DailyRecharge.dataCheck(actor)
    DailyRecharge.sendPanel(actor, _rechargeType(), "panel")
end

function DailyRecharge.login(actor)
    -- DailyRecharge.sendPanel(actor, _rechargeType(), "panel")
    DailyRecharge.zero(actor)
end

-- 临时处理后面删除 数据没刷新提前充钱了
function DailyRecharge.dataCheck(actor)
    local dailyRecharge = DailyRecharge.get(actor)
    local update = false
    if dailyRecharge.data then
        for _, task in pairs(dailyRecharge.data) do
            local goal = ConfigDataManager.getTableValue("cfg_dailyRecharge", "goal", "id", task.id)
            local rechargeRecord = RechargeRecord.get(actor)
            if task.state == 2 and rechargeRecord:totalDailyMoney() >= tonumber(goal) then
                task.state = 1
                update = true
            end
        end
    end
    if update then
        dailyRecharge:save(actor)
    end
end

-- 注册请求消息监听
EventListerTable.registerType("每日累充", _rechargeType(), _playerDbKey)
ZeroEventListerTable:eventLister("0", "每日累充", DailyRecharge.zero)
LoginEventListerTable:eventLister("0", "每日累充", DailyRecharge.login)
RechargeMessageEventListerTable:eventLister(_rechargeType(), "每日累充", DailyRecharge.reqAction)
RechargeEventListerTable:eventLister("0", "每日累充", DailyRecharge.rechargeEvent)
