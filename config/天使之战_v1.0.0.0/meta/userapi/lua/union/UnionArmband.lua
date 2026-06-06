---@class UnionArmbands.ArmbandsData
---@field level number -- 等级
---@field reallevel number -- 真实等级
---@field strong number -- 强化等级

UnionArmbands = {}

local this = {}

local UnionArmbandsKey = PlayerDefKey.UNION.UnionArmbandsKey
local UnionArmbandsLevelupLimitCacheKey = PlayerDefKey.UNION.UnionArmbandsLevelUpLimitCacheKey

function UnionArmbands.serverStart()
    local success, result = xpcall(this.startCacheUnionLevelUpLimit, debug.traceback)
    gameDebug.assertPrint(success, "启动时缓存战盟臂章升级限制异常！", result)
end

function UnionArmbands.sendArmbandInfo(actor)
    this.sendArmbandInfo(actor)
end

function UnionArmbands.levelupUnionArmband(actor)
    this.levelupUnionArmband(actor)
end

function UnionArmbands.strongArmband(actor)
    this.strongArmband(actor)
end

function UnionArmbands.onEnterUnion(actor)
    this.onEnterUnion(actor)
end

function UnionArmbands.onQuitUnion(actor)
    this.onQuitUnion(actor)
end

function this.startCacheUnionLevelUpLimit()
    local cache_map = {}

    local config_arr = ConfigDataManager.getList("cfg_gard_armbands")
    gameDebug.print("------ config_arr ------", config_arr)
    if table.isEmpty(config_arr) then
        return
    end
    for _, config in ipairs(config_arr) do
        local limit_arr = string.split(config.guildrank, "#")
        cache_map[tonumber(limit_arr[1])] = tonumber(limit_arr[2])
    end

    gameDebug.print("------ cache_map ------", cache_map)
    setsysvar(UnionArmbandsLevelupLimitCacheKey, cache_map)
end

function this.cacheStrongAttr(cache_map)
    local attr_cache = {}
    local config_arr = ConfigDataManager.getList("cfg_gard_bandsStrength")
    if table.isEmpty(table.isEmpty) then
        return
    end
    for _, config in pairs(config_arr) do
        local level = config.level
        local attr_str = config.strengthenattribute
        local attr_map = string.toIntIntMap(attr_str, "#", "|")
        attr_cache[tonumber(level)] = attr_map
    end
    cache_map.strong = attr_cache
end

function this.sendArmbandInfo(actor)
    ---@type UnionArmbands.ArmbandsData
    local armband_data = this.getArmbandData(actor)
    if table.isEmpty(armband_data) then
        this.jprint("--- 获取战盟臂章数据为空， 开始初始化臂章数据 ---")
        armband_data = this.initArmbandData(actor)
    end

    -- 初始化失败的功能尝试重新初始化
    if armband_data.reallevel < 1 then
        this.levelupUnionArmband(actor)
    end
    if armband_data.strong < 0 then
        this.strongArmband(actor)
    end

    sendluamsg(actor, LuaMessageIdToClient.RES_SEND_UNION_ARMBAND_INFO, armband_data)
end

function this.getArmbandData(actor)
    return getplaydef(actor, UnionArmbandsKey)
end

function this.setArmbandData(actor, data)
    setplaydef(actor, UnionArmbandsKey, data)
end

function this.levelupUnionArmband(actor)
    local union_data = getunioninfo(actor)
    if table.isEmpty(union_data) then
        this.jprint("获取战盟信息异常1")
        return
    end

    ---@type UnionArmbands.ArmbandsData
    local armband_data = this.getArmbandData(actor)

    local level = armband_data.level
    local next_level = level + 1
    local config_arr = ConfigDataManager.getTable("cfg_gard_armbands", "level", next_level)

    if table.isEmpty(config_arr) then
        this.jprint("未获取到配置信息")
        return
    end
    local config = config_arr[1]
    local union_level = tostring(union_data.unionlevel)
    local max_level = this.getLevelupMaxLevel(union_level)

    if tonumber(level) >= tonumber(max_level) then
        this.jprint("战盟等级达到上限")
        return
    end

    if armband_data.reallevel < next_level then
        -- 消耗道具
        local cost_str = config.levelupcost
        local cost_ret = this.unionCostItem(actor, cost_str, 1)
        if not cost_ret then
            this.jprint("消耗道具失败! 资源不足")
            return
        end
    end
    this.setArmbandLevel(actor, armband_data, next_level)
    sendluamsg(actor, LuaMessageIdToClient.RES_UNION_ARMBAND_LEVEL_UP, next_level)
end

function this.getLevelupMaxLevel(union_level)
    local data = getsysvar(UnionArmbandsLevelupLimitCacheKey)
    gameDebug.print("----- 臂章等级缓存 ------", data)

    -- 获取所有等级的键并排序
    local levels = {}
    for k in pairs(data) do
        table.insert(levels, k)
    end
    table.sort(levels)

    -- 查找最接近的较小等级
    local closestLevel = nil
    for _, l in ipairs(levels) do
        if l <= tonumber(union_level) then
            closestLevel = l
        else
            break
        end
    end

    -- 返回最接近的较小等级的可用最大值
    if closestLevel ~= nil then
        return data[closestLevel]
    else
        return 9999999999
    end
end

function this.initArmbandData(actor)
    local armband_data = {
        level     = 0,
        reallevel = 0,
        strong    = -1
    }
    this.setArmbandData(actor, armband_data)
    this.levelupUnionArmband(actor)
    this.strongArmband(actor)
    return armband_data
end

function this.setArmbandLevel(actor, armband_data, level)
    armband_data.level = level
    if level > armband_data.reallevel then
        armband_data.reallevel = level
    end
    this.setArmbandData(actor, armband_data)

    -- 计算属性
    this.calculateArmbandAttr(actor, level, RoleAttrKey.UNION_ARMBAND_LEVEL)
end

function this.strongArmband(actor)
    local union_data = getunioninfo(actor)
    if table.isEmpty(union_data) then
        this.jprint("获取战盟信息异常2")
        return
    end
    ---@type UnionArmbands.ArmbandsData
    local armband_data = this.getArmbandData(actor)

    local strong = armband_data.strong or 0
    local next_strong = strong + 1

    local config_arr = ConfigDataManager.getTable("cfg_gard_bandsStrength", "level", next_strong)
    if table.isEmpty(config_arr) then
        this.jprint("未获取到配置信息")
        return
    end
    local config = config_arr[1]

    local limit = tonumber(config.playerlevellimit)
    if limit then
        local level = tonumber(getbaseinfo(actor, "level"))
        if level < limit then
            this.jprint("玩家等级不足!")
            return
        end
    end

    local cost_str = config.strengthcost
    local cost_ret = this.unionCostItem(actor, cost_str, 1)
    if not cost_ret then
        this.jprint("消耗道具失败! 资源不足")
        return
    end

    local rate = tonumber(config.strengthenprobability)
    local ret = this.strongResult(rate)

    if not ret then
        -- 强化失败 获取本级失败退回的等级
        local old_config = ConfigDataManager.getTable("cfg_gard_bandsStrength", "level", strong)

        local fall_level = ConfigDataManager.getTableValue("cfg_gard_bandsStrength", "levelFailure1", "level", strong)
        fall_level = tonumber(fall_level) or -1

        if tonumber(fall_level) < 0 then
            sendluamsg(actor, LuaMessageIdToClient.RES_UNION_ARMBAND_STRONG, strong)
            return
        end
        next_strong = tonumber(fall_level)
    end

    armband_data.strong = next_strong
    this.setArmbandData(actor, armband_data)

    -- 计算属性
    this.calculateArmbandAttr(actor, next_strong, RoleAttrKey.UNION_ARMBAND_STRONG)
    sendluamsg(actor, LuaMessageIdToClient.RES_UNION_ARMBAND_STRONG, next_strong)
end

function this.calculateArmbandAttr(actor, cfg_id, key)
    local attr_str
    if key == RoleAttrKey.UNION_ARMBAND_LEVEL then
        attr_str = ConfigDataManager.getTableValue("cfg_gard_armbands", "levelupattribute", "level", cfg_id)
    else
        attr_str = ConfigDataManager.getTableValue("cfg_gard_bandsStrength", "strengthenattribute", "level", cfg_id)
    end

    local attr_map = string.toIntIntMap(attr_str, "#", "|")
    if not table.isEmpty(attr_map) then
        this.jprint("添加属性")
        addrolekmlattributes(actor, key, attr_map)
    end
end

function this.strongResult(probability)
    local value = math.random(0, 9999)
    return value < probability
end

function this.combineTable(tbl, n)
    if type(n) ~= 'number' or n < 1 or n > table.count(tbl) then
        return {}
    end
    local combinedTable = {}
    for i = 1, n do
        local currentTable = tbl[i]
        for key, value in pairs(currentTable) do
            if combinedTable[key] then
                combinedTable[key] = combinedTable[key] + value
            else
                combinedTable[key] = value
            end
        end
    end
    return combinedTable
end

function this.onEnterUnion(actor)
    jprint(actor:toString())

    ---@type UnionArmbands.ArmbandsData
    local armband_data = this.getArmbandData(actor)
    if table.isEmpty(armband_data) then
        armband_data = this.initArmbandData(actor)
        return
    end

    local union_data = getunioninfo(actor)
    local union_level = union_data.unionlevel
    local max_level = this.getLevelupMaxLevel(union_level)
    if max_level == armband_data.level then
        return
    end

    local level = math.min(armband_data.reallevel, max_level)
    armband_data.level = union_level
    this.setArmbandLevel(actor, armband_data, level)
    this.calculateArmbandAttr(actor, armband_data.strong, RoleAttrKey.UNION_ARMBAND_STRONG)
end

function this.onQuitUnion(actor)
    ---@type UnionArmbands.ArmbandsData
    local armband_data = this.getArmbandData(actor)
    armband_data.level = 0
    this.setArmbandLevel(actor, armband_data, 0)
    this.calculateArmbandAttr(actor, 0, RoleAttrKey.UNION_ARMBAND_STRONG)
end

function this.unionCostItem(actor, cost_str, rate)
    rate = rate or 1
    if not cost_str or cost_str == "" then
        return true
    end
    local cost_item = string.split(cost_str, "#")
    local item_id = cost_item[1]
    local item_count = cost_item[2]

    item_count = math.floor(item_count * rate)
    local cost_ret = removeitemfrombag(actor, item_id, item_count, 0, 9999, '战盟臂章')
    if not cost_ret then
        this.debug("消耗道具失败！无法参与竞选/取代！", "cost_str ", tostring(cost_str), "rate ", tostring(rate))
        return false
    end
    return true
end

----------------------------------------
this.log_open = false
function this.debug(...)
    if not this.log_open then
        return
    end
    gameDebug.print(...)
end

function this.jprint(param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(param)
end