GoldLine = {}

function GoldLine.GetGoldMapInfo(actor, mapCfgId)
    local mapLineConfig = ConfigDataManager.getTableValue("cfg_map_line", "mapline", "id", mapCfgId)
    if string.isNullOrEmpty(mapLineConfig) then
        return
    end
    local lineMap = string.toStringStringMap(mapLineConfig, "#", "|")
    local result = {}
    for _, line in pairs(lineMap) do
        local playerCount = getmapplayercount(actor, mapCfgId, line)
        local mapItem = { mapCfgId = mapCfgId, line = line, playerCount = playerCount }
        table.insert(result, mapItem)
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_MAP_INFO, result)
end 