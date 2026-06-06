OpenSeverRecharge = {}
OpenSeverRecharge.__index = OpenSeverRecharge
local function _rechargeType()
    return "12"
end
local function _playerDbKey()
    return "T$open_sever_continuous_recharge"
end

function OpenSeverRecharge.get(actor)
    local obj = getplaydef(actor, _playerDbKey())
    return setmetatable(obj or {}, OpenSeverRecharge)
end

function OpenSeverRecharge:save(actor)
    setplaydef(actor, _playerDbKey(), self)
end

function OpenSeverRecharge:next()
    for i = 2, table.count(self.data), 1 do
        local before = self.data[i - 1]
        local next = self.data[i]
        if before.state == 3 and next then
            next.canUpdate = true
        end
    end
end

function OpenSeverRecharge.rechargeEvent(actor, cfg, count, amount, ext, outRewards)
    --[[ TODO 策划说活动没开始也要累计 ]]
    --local openCondition = ConfigDataManager.getTableValue("sub_mainRecharge", "showcondition", "id", "9")
    --if not ConditionManager.Check(actor, openCondition) then
    --    return
    --end
    
    local osr = OpenSeverRecharge.get(actor)
    if osr.data then
        local update = false
        for k, v in pairs(osr.data) do
            if v.canUpdate and v.state == 2 then
                v.count = v.count + amount
                if v.count >= v.goal then
                    v.state = 1
                    update = true
                end
            end
        end

        osr.totalMoney = osr.totalMoney + amount
        osr:save(actor)
        if update then
            OpenSeverRecharge.sendPanel(actor, _rechargeType(), "panel")
        end
    end
end

function OpenSeverRecharge.reqAction(actor, type, action, reqParameter)
    if action == "panel" then
        OpenSeverRecharge.sendPanel(actor, type, action)
    elseif action == "reward" then
        OpenSeverRecharge.gainReward(actor, reqParameter)
    end
end

function OpenSeverRecharge.gainReward(actor, reqParameter)
    local openCondition = ConfigDataManager.getTableValue("sub_mainRecharge", "showcondition", "id", "9")
    if not ConditionManager.Check(actor, openCondition) then
        return
    end
    local id = tonumber(reqParameter["id"])
    local osr = OpenSeverRecharge.get(actor)
    local carreer = getbaseinfo(actor, "getbasecareer")
    local task = osr.data[id]
    if task == nil then
        tipinfo(actor, "找不到该任务")
        return
    end
    if task.state ~= 1 then
        tipinfo(actor, "该任务未完成")
        return
    end
    task.state = 3
    osr:save(actor)
    --发奖励
    local rewardstr = ConfigDataManager.getTableValue("cfg_newServerGIft", "reward", "id", task.id)
    local rewards = string.toIntIntMap4Career(carreer, rewardstr, "#", "|")
    -- 发送奖励
    additemmaptobag(actor, rewards, 0, 9999, ItemActionProxy.OPENSEVERRECHARGE)
    --奖励面板
    sendluamsg(actor, LuaMessageIdToClient.COMMON_REWARD_PANEL, rewards)
    OpenSeverRecharge.sendPanel(actor, _rechargeType(), "panel")
end

function OpenSeverRecharge.sendPanel(actor, type, action)
    local osr = OpenSeverRecharge.get(actor)
    if table.isNullOrEmpty(osr.data) then
        osr = OpenSeverRecharge.init(actor)
    end

    local openCondition = ConfigDataManager.getTableValue("sub_mainRecharge", "showcondition", "id", "9")
    if not ConditionManager.Check(actor, openCondition) then
        return
    end

    local res = {}
    res.data = {}

    for _, v in ipairs(osr.data) do
        table.insert(res.data, { id = v.id, state = v.state })
    end
    res.totalMoney = osr.totalMoney
    if not table.isNullOrEmpty(res.data) then
        jprint("开服连充任务面板", actor, res)
        Recharge.resAction(actor, type, action, res)
    end
end

function OpenSeverRecharge.init(actor)
    local osr = OpenSeverRecharge.get(actor)
    local data = {}
    local list = ConfigDataManager.getList("cfg_newServerGIft")
    for _, cfg in pairs(list) do
        if ConditionManager.Check(actor, cfg.condition) then
            -- 任务项
            local task = {}
            task.id = cfg.id
            task.state = 2
            task.count = 0
            task.goal = tonumber(cfg.needrecharge)
            task.canUpdate = cfg.id == "1" and true or false
            data[tonumber(cfg.id)] = task
        end
    end
    osr.data = data
    osr.totalMoney = 0
    osr.updateTime = getbaseinfo("nowsec")
    osr:save(actor)
    return osr
end

function OpenSeverRecharge.zeroCheckRewards(actor)
    local osr = OpenSeverRecharge.get(actor)
    local reward_items = {}
    local mailId = 0
    local carreer = getbaseinfo(actor, "getbasecareer")
    for index, task in pairs(osr.data) do
        if task.state == 1 then
            local cfg = ConfigDataManager.getById("cfg_newServerGIft", task.id)
            string.putIntIntMap4Career(reward_items, carreer, cfg.reward, "#", "|")
            mailId = cfg.mail
            task.state = 3
        end
    end
    osr:save(actor)
    if not table.isNullOrEmpty(reward_items) and mailId ~= 0 then
        sendconfigmailbyrid(actor, actor:toString(), mailId, reward_items, "", 1)
    end
end

function OpenSeverRecharge.zero(actor)
    local now = getbaseinfo("nowsec")
    local osr = OpenSeverRecharge.get(actor)

    if table.isNullOrEmpty(osr.data) then
        osr = OpenSeverRecharge.init(actor)
    end

    if not TimeUtil.isSameDay(now, osr.updateTime) then
        info("开服连充0点刷新", "玩家", actor)
        -- OpenSeverRecharge.zeroCheckRewards(actor)
        OpenSeverRecharge.refresh(actor, now)
    end
    -- OpenSeverRecharge.dataCheck(actor)
    OpenSeverRecharge.sendPanel(actor, _rechargeType(), "panel")
end

function OpenSeverRecharge.refresh(actor, now)
    local osr = OpenSeverRecharge.get(actor)
    osr.totalMoney = 0
    osr.updateTime = now
    osr:next()
    osr:save(actor)
end

function OpenSeverRecharge.login(actor)
    -- OpenSeverRecharge.sendPanel(actor, _rechargeType(), "panel")
    OpenSeverRecharge.zero(actor)
end

-- 临时处理后面删除 数据没刷新提前充钱了
function OpenSeverRecharge.dataCheck(actor)
    local osr = OpenSeverRecharge.get(actor)
    local rechargeRecord = RechargeRecord.get(actor)
    local dailyRecharge = rechargeRecord:totalDailyMoney()
    if osr.data then
        local update = false
        for k, v in pairs(osr.data) do
            if v.canUpdate and v.state == 2 then
                if dailyRecharge >= v.goal then
                    v.state = 1
                    v.count = v.goal
                    update = true
                end
            end
        end
        if osr.totalMoney == 0 then
            osr.totalMoney = dailyRecharge
            update = true
        end
        if update then
            osr:save(actor)
        end
    end
end

-- 注册请求消息监听
EventListerTable.registerType("开服连充", _rechargeType(), _playerDbKey)
ZeroEventListerTable:eventLister("0", "开服连充", OpenSeverRecharge.zero)
LoginEventListerTable:eventLister("0", "开服连充", OpenSeverRecharge.login)
RechargeMessageEventListerTable:eventLister(_rechargeType(), "开服连充", OpenSeverRecharge.reqAction)
RechargeEventListerTable:eventLister("0", "开服连充", OpenSeverRecharge.rechargeEvent)
