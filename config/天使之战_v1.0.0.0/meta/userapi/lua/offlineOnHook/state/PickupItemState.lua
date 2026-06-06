-- 离线挂机拾取道具状态模块
PickupItemState = {}
local this = {}
-- 处理拾取道具状态
function PickupItemState.handle(actor, sx, sy, immutableCache)
    local mapId = immutableCache.mapId
    local radius = immutableCache.radius
    local open = immutableCache.autoPickUp
    -- 检查自动拾取是否开启
    local items = AutoPickupItem.getPickItems(actor, mapId, sx, sy, radius)
    if not table.isEmpty(items) and not open then
        local closestItem, dis = HookCommonUtils.findClosestItem(actor, items)
        if closestItem ~= nil then
            if dis <= 0 then
                local paramMap = {}
                paramMap["cfgid"] = closestItem.cfgid
                local count = closestItem.iteminfo and closestItem.iteminfo.count or 1
                paramMap["itemcount"] = count
                local param = { paramMap }
                local can = checkitemscanputbag(actor, param)
                if can == 1 then
                    local ok = pickuprounditem(actor, closestItem.id, 0)
                    if ok then
                        if closestItem.iteminfo.type ~= ItemType.COIN then
                            StateManager.setPickupFailCount(actor, 0)     -- 拾取成功，重置失败计数
                            StateManager.setPickupFailStartTime(actor, 0) -- 重置失败时间
                        end
                        --记录日志
                        OfflineOnHookFSM.writePickUpItem(actor, { [closestItem.cfgid] = count })
                    else
                        -- 拾取失败，增加失败计数
                        StateManager.incrementPickupFailCount(actor)
                    end
                else
                    -- 背包满了，增加拾取失败计数
                    StateManager.incrementPickupFailCount(actor)
                    -- 背包满了，优先攻击怪物
                    local monsters = getmapobjects(actor, mapId, sx, sy, radius, 2)
                    if not table.isEmpty(monsters) then
                        StateManager.transformState(actor, StateManager.STATE_ATTACK_MONSTER)
                    else
                        StateManager.transformState(actor, StateManager.STATE_WAIT_MONSTER_REFRESH)
                    end
                end
            else
                --走向道具
                local moveOk = movetopoint(actor, closestItem.x, closestItem.y)
                -- moveOk = false
                if not moveOk then
                    -- 移动失败，增加失败计数
                    local failCount = StateManager.getMoveFailCount(actor) + 1
                    StateManager.setMoveFailCount(actor, failCount)

                    -- 连续失败2次则切换到寻找点状态，寻找新的怪物
                    if failCount >= 2 then
                        StateManager.setMoveFailCount(actor, 0)
                        local toOrigin = HookCommonUtils.goToOrigin(actor, sx, sy, immutableCache)
                        if not toOrigin then
                            StateManager.transferAfterMoveFail(actor, immutableCache)
                        end
                    end
                else
                    -- 移动成功，重置失败计数
                    StateManager.setMoveFailCount(actor, 0)
                end
                return
            end
        else
            local monsters = getmapobjects(actor, mapId, sx, sy, radius, 2) --获取5格范围内的怪物
            if table.isEmpty(monsters) then
                StateManager.transformState(actor, StateManager.STATE_WAIT_MONSTER_REFRESH)
            else
                StateManager.transformState(actor, StateManager.STATE_ATTACK_MONSTER)
            end
        end
    else
        local monsters = getmapobjects(actor, mapId, sx, sy, radius, 2)
        if table.isEmpty(monsters) then
            StateManager.transformState(actor, StateManager.STATE_WAIT_MONSTER_REFRESH)
        else
            StateManager.transformState(actor, StateManager.STATE_ATTACK_MONSTER)
        end
    end
end

AutoPickupItem = {}
function AutoPickupItem.autoPickUpItem(actor, sx, sy, currState, immutableCache)
    local mapId = immutableCache.mapId
    local openPick = immutableCache.autoPick
    local pickRange = immutableCache.autoPickRange
    local autoPickCD = immutableCache.autoPickCD
    local allowPublicItems = immutableCache.allowPublicItems
    if currState == StateManager.STATE_PICKUP_ITEM then
        -- 走动拾取道具状态, 不再自动拾取
        return
    end
    if not openPick then
        return
    end
    -- 背包满了阻塞或者冷却中则不拾取
    if StateManager.inAutoPickCD(actor, autoPickCD) then
        return
    end
    -- 自动范围拾取前检查背包
    -- 检查就近的道具能不能进包, 如果这里的范围小于战斗状态对道具的判断范围，否则可能会在战斗和攻击状态之间来回切换
    local items = AutoPickupItem.getPickItems(actor, mapId, sx, sy, pickRange)
    if not table.isEmpty(items) then
        items = this.filterItems(actor, items, allowPublicItems)
        if table.isEmpty(items) then
            return
        end
        -- 检查是否能拾取
        local canPick = false
        for i, item in pairs(items) do
            local paramMap = {}
            paramMap["cfgid"] = item.cfgid
            local count = item.iteminfo and item.iteminfo.count or 1
            paramMap["itemcount"] = count
            local can = checkitemscanputbag(actor, { paramMap })
            if can == 1 then
                canPick = true
                break
            end
        end
        if not canPick then
            return
        end
        pickuprangeitem(actor)                        -- 拾取范围物品
        StateManager.setPickupFailCount(actor, 0)     -- 拾取成功，重置失败计数
        StateManager.setPickupFailStartTime(actor, 0) -- 重置失败时间
    end
end

function AutoPickupItem.getPickItems(actor, mapId, sx, sy, radius)
    local finalItem = {}
    local items = getmapobjects(actor, mapId, sx, sy, radius, 7)
    if table.isEmpty(items) then
        return finalItem
    end
    local block = StateManager.isPickupBlocked(actor)
    if block then
        finalItem = this.getCoins(items)
    else
        finalItem = items
    end
    return finalItem
end

function this.getCoins(items)
    local coins = {}
    for i = #items, 1, -1 do
        local item = items[i]
        local type = item.iteminfo.type
        if type == ItemType.COIN then
            table.insert(coins, item)
        end
    end
    return coins
end

function this.filterItems(actor, items, allowPublicItems)
    if table.isEmpty(items) then
        return
    end
    local actorId = tonumber(actor:toString())
    local filteredItems = {}
    for i = 1, #items do
        local item = items[i]
        local owners = item.owners or {}
        local shouldPick = false
        if not table.isEmpty(owners) then
            if table.contains(owners, actorId) then
                shouldPick = true
            end
        else
            if allowPublicItems then
                shouldPick = true
            end
        end
        if shouldPick then
            table.insert(filteredItems, item)
        end
    end
    return filteredItems
end
