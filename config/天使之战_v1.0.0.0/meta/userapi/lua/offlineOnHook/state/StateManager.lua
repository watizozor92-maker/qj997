-- 离线挂机状态管理模块
StateManager = {}

-- 状态定义
StateManager.STATE_NONE = 0                 -- 默认无状态, 站立
StateManager.STATE_ATTACK_MONSTER = 1       -- 攻击怪物状态
StateManager.STATE_PICKUP_ITEM = 2          -- 拾取道具
StateManager.STATE_WAIT_MONSTER_REFRESH = 3 -- 等待怪物刷新
StateManager.STATE_GO_TO_ORIGIN = 4         -- 移动到初始位置状态

-- 键值定义
StateManager.KEY_CURR_STATE = "@curr_state"
StateManager.KEY_MOVE_FAIL_COUNT = "@move_fail_count"               -- 移动失败计数
StateManager.KEY_PICKUP_FAIL_COUNT = "@pickup_fail_count"           -- 拾取失败计数
StateManager.KEY_PICKUP_FAIL_START_TIME = "@pickup_fail_start_time" -- 拾取失败开始时间
StateManager.KEY_NO_MONSTER_START_TIME = "@no_monster_start_time"   -- 无怪物开始时间
StateManager.KEY_LAST_AUTO_PICKUP_TIME = "@last_auto_pickup_time"   -- 上次自动拾取道具时间
StateManager.OFFLINE_ON_HOOK_PICK_ITEMS = "T$offline_pick_items"    -- 离线挂机拾取道具日志

-- 常量定义
StateManager.PICKUP_FAIL_LIMIT = 2           -- 连续拾取失败3次后转为打怪
StateManager.PICKUP_FAIL_BLOCK_DURATION = 60 -- 拾取失败后阻止拾取的时间(秒)

-- 默认配置值
StateManager.DEFAULT_ACTIVITY_RADIUS = 8    -- 默认活动半径8格
StateManager.DEFAULT_NO_MONSTER_TIMEOUT = 5 -- 默认5秒无怪物则回退

-- 获取当前状态
function StateManager.getCurrState(actor)
    local state = getplaydef(actor, StateManager.KEY_CURR_STATE) or StateManager.STATE_ATTACK_MONSTER
    return state
end

-- 设置当前状态
function StateManager.setCurrState(actor, state)
    setplaydef(actor, StateManager.KEY_CURR_STATE, state)
end

-- 获取移动失败计数
function StateManager.getMoveFailCount(actor)
    return getplaydef(actor, StateManager.KEY_MOVE_FAIL_COUNT) or 0
end

-- 设置移动失败计数
function StateManager.setMoveFailCount(actor, count)
    setplaydef(actor, StateManager.KEY_MOVE_FAIL_COUNT, count)
end

-- 获取拾取失败计数
function StateManager.getPickupFailCount(actor)
    return getplaydef(actor, StateManager.KEY_PICKUP_FAIL_COUNT) or 0
end

-- 设置拾取失败计数
function StateManager.setPickupFailCount(actor, count)
    setplaydef(actor, StateManager.KEY_PICKUP_FAIL_COUNT, count)
end

-- 增加拾取失败计数
function StateManager.incrementPickupFailCount(actor)
    local count = StateManager.getPickupFailCount(actor) + 1
    StateManager.setPickupFailCount(actor, count)
    -- 达到失败上限时，记录失败开始时间
    if count >= StateManager.PICKUP_FAIL_LIMIT then
        local now = getbaseinfo("nowsec")
        StateManager.setPickupFailStartTime(actor, now)
    end
    return count
end

-- 获取拾取失败开始时间
function StateManager.getPickupFailStartTime(actor)
    return getplaydef(actor, StateManager.KEY_PICKUP_FAIL_START_TIME) or 0
end

-- 设置拾取失败开始时间
function StateManager.setPickupFailStartTime(actor, time)
    setplaydef(actor, StateManager.KEY_PICKUP_FAIL_START_TIME, time)
end

-- 检查是否处于拾取阻止期
function StateManager.isPickupBlocked(actor)
    local failCount = StateManager.getPickupFailCount(actor)
    if failCount < StateManager.PICKUP_FAIL_LIMIT then
        return false
    end
    local startTime = StateManager.getPickupFailStartTime(actor)
    if startTime <= 0 then
        return false
    end
    local now = getbaseinfo("nowsec")
    local elapsed = now - startTime
    -- 超过阻止时间后，重置计数器
    if elapsed >= StateManager.PICKUP_FAIL_BLOCK_DURATION then
        StateManager.setPickupFailCount(actor, 0)
        StateManager.setPickupFailStartTime(actor, 0)
        return false
    end
    return true
end

function StateManager.setLastAutoPickupTime(actor, time)
    setplaydef(actor, StateManager.KEY_LAST_AUTO_PICKUP_TIME, time)
end

function StateManager.inAutoPickCD(actor, cd)
    local lastPickTime = getplaydef(actor, StateManager.KEY_LAST_AUTO_PICKUP_TIME) or 0
    local now = getbaseinfo("now")
    local inCD = now - lastPickTime <= cd
    if inCD then
        return true
    end
    StateManager.setLastAutoPickupTime(actor, now)
    return false
end

-- 状态转换
function StateManager.transformState(actor, state)
    StateManager.setCurrState(actor, state)
end

function StateManager.transferAfterMoveFail(actor, immutableCache)
    local Id = immutableCache.mapId
    local originx, originy = immutableCache.originx, immutableCache.originy
    local mapId, mapLine = gamemap.parseMapKey(Id)
    maptransfer(actor, originx, originy, mapId, mapLine, 1)
end

-- ==================== 活动范围与回退机制 ====================

-- 获取配置的无怪物超时时间
function StateManager.judgeHpMp(actor, hp, mp)
    if not isofflineplay(actor) then
        return
    end

    -- local result = Privilege.hasPrivilege(actor, Privilege.PrivilegeType.OFFLINE_ON_HOOK)
    -- local cfgLevel = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.OFFLINE_ON_HOOK_LEVEL)
    -- cfgLevel = tonumber(cfgLevel)
    -- local level = getbaseinfo(actor, "level")
    -- if (level < cfgLevel or not result) then
    --     return
    -- end
    local _, _, HpMpRate, _ = HookCommonUtils.getPlayerHookSetting(actor)
    local hpRate = HpMpRate.hp or 0
    local mpRate = HpMpRate.mp or 0
    if hpRate > 0 then
        hp = hp or getbaseinfo(actor, "hp")
        local maxHp = getattrinfo(actor, "maxHP")
        if hp <= maxHp * hpRate then
            local hpList = ConfigDataManager.getTable("cfg_onhook", "group", 1)
            for _, cfg in ipairs(hpList) do
                local items = cfg.itemid
                if string.isNullOrEmpty(items) then
                    return
                end
                items = string.split(items, "#")
                for _, item in ipairs(items) do
                    local count = getbagitemcountbyid(actor, item)
                    if count > 0 then
                        useitembycfgid(actor, item, 1)
                        return
                    end
                end
            end
        end
    end
    if mpRate > 0 then
        mp = mp or getbaseinfo(actor, "mp")
        local maxMp = getattrinfo(actor, "maxMP")
        if mp <= maxMp * mpRate then
            local mpList = ConfigDataManager.getTable("cfg_onhook", "group", 2)
            for _, cfg in ipairs(mpList) do
                local items = cfg.itemid
                if string.isNullOrEmpty(items) then
                    return
                end
                items = string.split(items, "#")
                for _, item in ipairs(items) do
                    local count = getbagitemcountbyid(actor, item)
                    if count > 0 then
                        useitembycfgid(actor, item, 1)
                        return
                    end
                end
            end
        end
    end
end

-- 设置无怪物开始时间
function StateManager.setNoMonsterStartTime(actor, time)
    setplaydef(actor, StateManager.KEY_NO_MONSTER_START_TIME, time)
end

-- 获取无怪物开始时间
function StateManager.getNoMonsterStartTime(actor)
    return getplaydef(actor, StateManager.KEY_NO_MONSTER_START_TIME) or 0
end

-- 重置无怪物计时
function StateManager.resetNoMonsterTimer(actor)
    StateManager.setNoMonsterStartTime(actor, 0)
end

-- 检查是否超过无怪物超时时间
function StateManager.isNoMonsterTimeout(actor, timeout)
    local startTime = StateManager.getNoMonsterStartTime(actor)
    if startTime <= 0 then
        return false
    end
    local now = getbaseinfo("nowsec")
    return (now - startTime) >= timeout
end
