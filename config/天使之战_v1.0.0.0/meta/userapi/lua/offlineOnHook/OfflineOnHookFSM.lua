-- 离线挂机有限状态机主模块
OfflineOnHookFSM = {}

-- 记录挂机拾取日志
function OfflineOnHookFSM.writePickUpItem(actor, itemLog)
    local filters = {}
    for itemCfgId, count in pairs(itemLog) do
        local config = ConfigDataManager.getById("cfg_item", itemCfgId)
        if not table.isEmpty(config) then
            if (string.tonumber(config.id) ~= ItemConfigId.GOLD and string.tonumber(config.id) ~= ItemConfigId.BIND_QI_JI_MONEY) then
                filters[itemCfgId] = count
            end
        end
    end
    -- gameDebug.print(actor, "记录挂机拾取日志", filters)
    if not table.isEmpty(filters) then
        local now = getbaseinfo(actor, "now")
        local pickItems = getplaydef(actor, StateManager.OFFLINE_ON_HOOK_PICK_ITEMS) or {}
        local ite = { time = now, logs = filters }
        table.insert(pickItems, ite)
        -- pickItems最多max条记录
        local max = ConfigDataManager.getTableValue("cfg_global", "value", "id", 730001)
        if #pickItems > string.tonumber(max) then
            table.remove(pickItems, 1)
        end
        -- gameDebug.print(actor, "记录挂机拾取日志", #pickItems)
        setplaydef(actor, StateManager.OFFLINE_ON_HOOK_PICK_ITEMS, pickItems)
    end
end

-- 获取挂机拾取日志
function OfflineOnHookFSM.getPickUpItems(actor)
    local pickItems = getplaydef(actor, StateManager.OFFLINE_ON_HOOK_PICK_ITEMS) or {}
    -- gameDebug.print(actor, "读取挂机拾取日志", pickItems)
    local items = {}
    for i, log in ipairs(pickItems) do
        local time = log.time
        local logs = log.logs
        items[time] = logs
    end
    return items
end

-- 清除挂机拾取日志
function OfflineOnHookFSM.clearPickUpItems(actor)
    gameDebug.print(actor, "清除离线挂机拾取日志")
    setplaydef(actor, StateManager.OFFLINE_ON_HOOK_PICK_ITEMS, {})
end

--离线挂机玩家行为更新事件
function onhookheart(actor)
    local sx = getbaseinfo(actor, "x")
    local sy = getbaseinfo(actor, "y")

    local currState = StateManager.getCurrState(actor)
    local immutableCache = onHook.getImmutableCache(actor)
    local delta
    if currState == StateManager.STATE_NONE then
        delta = NoActionState.handle(actor)
    elseif currState == StateManager.STATE_ATTACK_MONSTER then
        delta = AttackMonsterState.handle(actor, sx, sy, immutableCache)
    elseif currState == StateManager.STATE_PICKUP_ITEM then
        delta = PickupItemState.handle(actor, sx, sy, immutableCache)
    elseif currState == StateManager.STATE_WAIT_MONSTER_REFRESH then
        delta = WaitMonsterRefreshState.handle(actor, sx, sy, immutableCache)
    elseif currState == StateManager.STATE_GO_TO_ORIGIN then
        delta = GoToOriginState.handle(actor, sx, sy, immutableCache)
    end

    AutoPickupItem.autoPickUpItem(actor, sx, sy, currState, immutableCache)

    -- 根据当前状态动态调整心跳间隔
    local sleepTime = 400
    if currState == StateManager.STATE_WAIT_MONSTER_REFRESH then
        sleepTime = 1000  -- 等待刷怪时降低频率到1秒
    elseif currState == StateManager.STATE_PICKUP_ITEM then
        sleepTime = 600   -- 拾取状态保持较高频率(拾取优先)
    elseif currState == StateManager.STATE_ATTACK_MONSTER then
        sleepTime = 600   -- 打怪状态降低频率(打怪次要)
    elseif currState == StateManager.STATE_GO_TO_ORIGIN then
        sleepTime = 600   -- 移动到初始位置状态降低频率(移动到次要)
    elseif currState == StateManager.STATE_NONE then
        sleepTime = 60000 -- 无状态保持60秒
    end

    if delta then
        sleepTime = delta
    end
    onhooksetsleep(actor, sleepTime)
end
