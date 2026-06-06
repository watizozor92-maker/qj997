CountManager = {}
local this = CountManager

CountConst = {
    TAG = "T$Count",
    GTAG = "R$Count"
}
function this.getCount(actor, key)
    if string.isNullOrEmpty(key) then
        return nil
    end

    key = tonumber(key)
    local data = this.getCountData(actor)
    local count, update = this.getRealCount(data, key)

    if this.checkReset(actor, count) then
        update = true
    end

    if update then
        this.saveData(actor, key, count)
    end
    return count
end

function this.count(actor, key, add)
    if string.isNullOrEmpty(key) then
        return 0
    end

    key = tonumber(key)
    local c = this.getCount(actor, key)
    if c and c:canAdd(add) then
        local curCount = c:countNum(actor, add)
        this.saveData(actor, key, c)
        this.sendMsg(actor, c)
        return curCount
    end

    return 0
end

-- 全服计数先不做
-- function this.getGloablCount(key)
--     local data = this.getGloablCountData()
--     local count, update = this.getRealCount(data, key)

--     if this.checkReset(count) then
--         update = true
--     end

--     if update then
--         this.saveGloablData(key, count)
--     end
--     return count
-- end

-- function this.globalCount(key, add)
--     local count = this.getGloablCount(key, key)
--     if count and count:canAdd() then
--         local curCount = count:count(add)
--         this.saveGloablData(key, count)
--         return curCount
--     end
--     return 0
-- end

function this.createCount(key)
    local config = ConfigDataManager.getById("Count_count", key)
    if config == nil then
        gameDebug.assertNotNil("count表找不到配置key=" .. key)
    end
    local count = Count()
    local now = getbaseinfo("nowsec")
    count.key = tonumber(config.id)
    count.type = tonumber(config.type)
    count.updateTime = now
    count.total = config.total == "" and 0 or tonumber(config.total)
    count.totalUpdateTime = now
    return count
end

function this.checkReset(actor, count)
    local update = false
    if count == nil then
        return update
    end
    local now = getbaseinfo("nowsec")
    if count:canRefreshTotal(now) then
        count:refreshTotal(now)
        update = true
    end
    if count:canResetCount(now) then
        count:reset(actor, now)
        update = true
    end
    return update
end

function this.getCountData(actor)
    return getplaydef(actor, CountConst.TAG) or {}
end

function this.saveData(actor, key, count)
    local data = this.getCountData(actor)
    data[key] = count
    setplaydef(actor, CountConst.TAG, data)
    info("玩家", actor, "保存计数数据", count)
end

-- function this.getGloablCountData()
--     return getsysvar(CountConst.GTAG) or {}
-- end

-- function this.saveGloablData(key, count)
--     local data = this.getGloablCountData()
--     data[key] = count
--     setsysvar(CountConst.GTAG, data)
-- end

function this.getRealCount(data, key)
    local config = ConfigDataManager.getById("Count_count", key)
    if config == nil then
        gameDebug.print("count表找不到配置key=" .. key)
        return nil, false
    end
    local source = data[key]
    -- if config.type == 1 then
    --     return Count(source)
    -- end
    if source == nil then
        local count = this.createCount(key)
        return count, true
    end
    return Count(source), false
end

function this.sendMsg(actor, count)
    -- jprint("计数测试单个数据=", count:toBuilder())
    sendluamsg(actor, LuaMessageIdToClient.RES_UPDATE_COUNT_INFO, count:toBuilder())
end

function this.sendPlayerAllCountsMsg(actor)
    local res = {}
    local data = this.getCountData(actor)
    for _, v in pairs(data) do
        local c = this.getCount(actor, v.key)
        if c then
            table.insert(res, {
                ["key"] = c.key,
                ["count"] = c.count,
                ["total"] = c.total
            })
        end
    end
    -- jprint("计数测试全部数据=", res)
    sendluamsg(actor, LuaMessageIdToClient.RES_ALL_COUNT_INFO, res)
end

function this.zero(actor)
    info("0点在线玩家刷新count次数", actor)
    this.sendPlayerAllCountsMsg(actor)
end

function this.login(actor)
    this.sendPlayerAllCountsMsg(actor)
end

-- function testcount(actor, key, action)
--     jprint("计数测试param=", key, action)
--     if action == "1" then
--         -- CountManager.count(actor, key, 1)
--         -- local b = this.getCount(actor, key)
--         -- local now = getbaseinfo("nowsec")
--         -- b:reset(actor, now)
--         -- this.saveData(actor, key, b)
--         -- jprint("计数测试b=", b)
--     elseif action == "2" then
--         local b = CountManager.getCount(actor, key)
--         jprint("计数测试b=", b)
--         -- CountManager.sendMsg(actor, b)
--     elseif action == "0" then
--         this.sendPlayerAllCountsMsg(actor)
--     elseif action == "-1" then
--         this.zeroRefreshCheck()
--     end
-- end

-- 凌晨刷新事件
ZeroEventListerTable:eventLister("0", "count计数", CountManager.zero, 1111)
-- 注册登录事件
LoginEventListerTable:eventLister("0", "count计数", CountManager.login, 1111)
