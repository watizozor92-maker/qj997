-- 离线挂机等待怪物刷新状态模块
WaitMonsterRefreshState = {}

-- 处理等待怪物刷新状态
function WaitMonsterRefreshState.handle(actor, sx, sy, immutableCache)
    local mapId = immutableCache.mapId
    local radius = immutableCache.radius

    local now = getbaseinfo("nowsec")
    local startTime = StateManager.getNoMonsterStartTime(actor)
    if startTime <= 0 then
        StateManager.setNoMonsterStartTime(actor, now)
    end

    local open = immutableCache.autoPick
    local items = AutoPickupItem.getPickItems(actor, mapId, sx, sy, radius)
    if not table.isEmpty(items) and not open then
        StateManager.transformState(actor, StateManager.STATE_PICKUP_ITEM)
        return
    end

    local monsters = getmapobjects(actor, mapId, sx, sy, radius, 2)
    if HookCommonUtils.findClosestMonster(actor, monsters, sx, sy, mapId) ~= nil then
        --有怪则转移到攻击状态
        StateManager.resetNoMonsterTimer(actor) -- 找到怪物，重置无怪物计时器
        StateManager.transformState(actor, StateManager.STATE_ATTACK_MONSTER)
    else
        --没怪则判断是否超时
        if StateManager.isNoMonsterTimeout(actor, immutableCache.noMonsterTimeout) then
            -- 超时回到初始位置
            StateManager.transformState(actor, StateManager.STATE_GO_TO_ORIGIN)
        end
        return 1000
    end
end
