-- 离线挂机移动到初始位置状态模块
GoToOriginState = {}

-- 处理移动到初始位置状态
function GoToOriginState.handle(actor, sx, sy, immutableCache)
    local x, y = immutableCache.originx, immutableCache.originy
    local dis = HookCommonUtils.distance(x, y, sx, sy)
    if dis <= 1 then
        --转移到攻击的状态
        StateManager.setMoveFailCount(actor, 0) -- 重置移动失败计数
        StateManager.transformState(actor, StateManager.STATE_ATTACK_MONSTER)
    else
        local ok = movetopoint(actor, x, y)
        if not ok then
            local failCount = StateManager.getMoveFailCount(actor) + 1
            StateManager.setMoveFailCount(actor, failCount)
            -- 连续失败2次则放弃当前点
            if failCount >= 2 then
                StateManager.setMoveFailCount(actor, 0)
                local toOrigin = HookCommonUtils.goToOrigin(actor, sx, sy, immutableCache)
                if not toOrigin then
                    StateManager.transferAfterMoveFail(actor, immutableCache)
                end
            end
        else
            StateManager.setMoveFailCount(actor, 0) -- 移动成功，重置计数
        end
    end
end
