GameMapHeart = {}

local TIME_TAG = "G$_MAP_HEART_TIME"

function GameMapHeart.getMapHeartTime()
    local timeMap = getsysvar(TIME_TAG)
    if timeMap == nil then
        timeMap = {}
        timeMap[1] = {}
        timeMap[3] = {}
        timeMap[5] = {}
        setsysvar(TIME_TAG, timeMap)
    end

    return timeMap
end

function GameMapHeart.setMapHeartTime(allTimeMap)
    setsysvar(TIME_TAG, allTimeMap)
end

function GameMapHeart.getTime(timeMap, uniMapId)
    local time = table.getValue(timeMap, uniMapId)
    if time == nil then
        return 0
    end
    return time
end

function GameMapHeart.setTime(allTimeMap, timeMap, uniMapId, timeSec)
    setsysvar(TIME_TAG, allTimeMap)
end

function GameMapHeart.AddMap(uniMapId)

end

function GameMapHeart.RemoveMap(uniMapId)
    local allMapTime = GameMapHeart.getMapHeartTime()
    for _, timeInfo in pairs(allMapTime) do
        timeInfo[uniMapId] = nil
    end
end

function GameMapHeart.doSecondHeart(allTimeMap, nowSec, uniMapId, mapId)
    local mapSecondHeartTime = allTimeMap[1]
    local diff = nowSec - GameMapHeart.getTime(mapSecondHeartTime, uniMapId)
    if diff >= 1 then
        mapSecondHeartTime[uniMapId] = nowSec
        if lua_mapsecondheart ~= nil then
            gameDebug.debug(lua_mapsecondheart, uniMapId, mapId)
        end
    end
end

function GameMapHeart.do3SecondHeart(allTimeMap, nowSec, uniMapId, mapId)
    local map3secondHeartTime = allTimeMap[3]
    local diff = nowSec - GameMapHeart.getTime(map3secondHeartTime, uniMapId)
    if diff >= 3 then
        map3secondHeartTime[uniMapId] = nowSec
        if lua_map3secondheart ~= nil then
            gameDebug.debug(lua_map3secondheart, uniMapId, mapId)
        end
    end
end

function GameMapHeart.do5SecondHeart(allTimeMap, nowSec, uniMapId, mapId)
    local map5secondHeartTime = allTimeMap[5]
    local diff = nowSec - GameMapHeart.getTime(map5secondHeartTime, uniMapId)
    if diff >= 5 then
        map5secondHeartTime[uniMapId] = nowSec
        if lua_map5secondheart ~= nil then
            gameDebug.debug(lua_map5secondheart, uniMapId, mapId)
        end
    end
end

function GameMapHeart.DoHeart()
    local allmap = getallmap(1)
    local type = type(allmap)
    if type == "string" then
        allmap = string.split(allmap, ",")
    end
    local allTimeMap = GameMapHeart.getMapHeartTime()
    --此处不依赖系统时间，可以用lua time库
    local nowSec = os.time()
    for _, uniMapId in pairs(allmap) do
        local mapCfgId, _ = gamemap.parseMapKey(uniMapId)
        gameDebug.debug(GameMapHeart.doSecondHeart, allTimeMap, nowSec, uniMapId, mapCfgId)
        gameDebug.debug(GameMapHeart.do3SecondHeart, allTimeMap, nowSec, uniMapId, mapCfgId)
        gameDebug.debug(GameMapHeart.do5SecondHeart, allTimeMap, nowSec, uniMapId, mapCfgId)
    end
    GameMapHeart.setMapHeartTime(allTimeMap)
end 
