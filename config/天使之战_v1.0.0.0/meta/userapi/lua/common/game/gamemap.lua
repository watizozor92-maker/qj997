gamemap = {}

function gamemap.getMapKey(mapCfgId, mapLine)
    local v = tonumber(mapCfgId) << 11 | tonumber(mapLine)
    return v
end

function gamemap.parseMapKey(mapKey)
    mapKey = tonumber(mapKey)
    local mapCfgId = mapKey >> 11
    local mapLine = mapKey & 1023
    return mapCfgId, mapLine
end


-- 切换地图检查消耗
-- ret:是否可以切换
function gamemap.checkChangeMapCost(actor, curMapCfgId, targetMapCfgId, targetLine, fromMapMove)
    local curMapType = tonumber(ConfigDataManager.getTableValue("cfg_map_info", "type", "id", curMapCfgId))
    local targetMapType = tonumber(ConfigDataManager.getTableValue("cfg_map_info", "type", "id", targetMapCfgId))
    local currentLine = getbaseinfo(actor, "line")
    if (not fromMapMove) and (curMapType == 2 or targetMapType == 2 or (curMapCfgId == targetMapCfgId and currentLine ~= targetLine)) then
        return true
    end
    local costConfig = ConfigDataManager.getTableValue("cfg_map_info", "transferCost", "id", targetMapCfgId)
    local costItemMap = string.toIntIntMap(costConfig, "#", "|")
    if table.count(costItemMap) <= 0 then
        return true
    end
    local multiplier = PKSystem.getTransmitCostMultiplier(actor)
    for itemId, itemCount in pairs(costItemMap) do
        costItemMap[itemId] = itemCount * multiplier
    end

    if Bag.checkCostMap(actor, costItemMap) then
        Bag.costMap(actor, costItemMap, "切换地图消耗")
        return true
    else
        return false
    end
end

function gamemap.checkChangeMapLevel(actor, targetMapCfgId)
    local mapMoveCfg = ConfigDataManager.getTableFirst("cfg_mapmove", "mapid", targetMapCfgId)
    if table.isEmpty(mapMoveCfg) then
        gameDebug.error("切换地图检查等级失败，未配置切换地图等级", targetMapCfgId)
        return false
    end
    local level = getbaseinfo(actor, "level")
    local minLevel = tonumber(mapMoveCfg.level) or 0
    return level >= minLevel
end





--[[
function gamemap.getMapKey(mapCfgId, mapLine)
    local v = lshift(mapCfgId,11)
    v = bitwiseor(v,mapLine)
    return v
end

function gamemap.parseMapKey(mapKey)
    local mapCfgId = rshift(mapKey,11)
    local mapLine = bitwiseand(mapKey,1023)
    return mapCfgId, mapLine
end]]
