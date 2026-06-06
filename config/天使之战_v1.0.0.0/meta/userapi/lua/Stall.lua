Stall = {}
local this = {}
HOUR_SECOND = 60 * 60
ROLE_STALL_START = "R$roleStallInfo"

-- 获取地图上的摆摊位置
function Stall.stallPosition(actor, msgData)
    local id = msgData.id
    local spotData = ConfigDataManager.getTable("cfg_spot", "id", id)
    if not spotData then
        -- error("当前摆摊城市错误".. id)
        return
    end
    local spot = spotData[1]
    local positionString = spot["position"]
    local position = string.split(positionString, "#")
    local minX = position[3]
    local maxX = position[1]
    local minY = position[4]
    local maxY = position[2]
    local mapId = tonumber(spot["map"])
    local serverType = ConfigDataManager.getTableValue("cfg_map_info","serverType", "id", mapId)
    getmapstallinfo(actor,mapId,minX,maxX,minY,maxY,serverType)
end
-- 发送摊位
function Stall.sendStallPosition(actor,stallPosition)
    local pointx = stallPosition["pointx"]
    if not pointx then
        tipinfo(actor,"当前地图没有合适的摆摊位置")
        return
    end
    sendluamsg(actor,LuaMessageIdToClient.RES_STALL_POSITION , stallPosition)
end

-- 获取摆摊结束位置
function Stall.getStallTimeInfo(actor)
    ---type Stall.Info 摆摊信息
    local allStallInfo = getsysvar(actor,ROLE_STALL_START)
    if not allStallInfo then
        return nil
    end
    return allStallInfo[actor:toString()]
end


---@class Stall.Info 摆摊摊位信息
---@field mapId number 摆摊地图配置id
---@field line number 摆摊地图线信息
---@field pointX number 摆摊点x坐标
---@field pointY number 摆摊点y坐标
---@field endTime number 结束时间

-- 开启摆摊
function Stall.startStall(actor, msgData)
    local title = msgData.title
    local id = msgData.id
    local costIndex = msgData.cost
    local spotData = ConfigDataManager.getTable("cfg_spot", "id", id)
    if not spotData then
        -- error("当前摆摊城市错误".. id)
        return
    end
    local stallInfo = Stall.getStallTimeInfo(actor)
    if stallInfo then
        if stallInfo == "{}" then
        else
            return
        end
    end
    local spot = spotData[1]
    local allCost = spot["cost"]
    local mapId = tonumber(spot["map"])
    local costDetail = string.split(allCost, "|")[costIndex]
    local cost = string.split(costDetail, "#")
    local time = tonumber(cost[1])
    local itemCfgId = tonumber(cost[2])
    local count = tonumber(cost[3])
    local haveCount = getbagitemcountbyid(actor,itemCfgId)
    if haveCount < count then
        tipinfo(actor,"背包道具不足")
        return
    end
    local serverType = ConfigDataManager.getTableValue("cfg_map_info","serverType", "id", mapId)
    local stallPosition = getmapstallinfo(actor,mapId,0,0,0,0,serverType)
    local haveStallCount = stallPosition["count"]
    local maxspot = spot["maxspot"]
    if haveStallCount == tonumber(maxspot) then
        tipinfo(actor,"当前地图摊位已满，请切换地图开启摆摊")
        return
    end

    local deleteItem = removeitemfrombag(actor,itemCfgId,count,0,9999,'摆摊')
    if not deleteItem then
        tipinfo(actor,"消耗道具失败")
        return
    end

    startstall(actor,mapId,msgData.pointX,msgData.pointY,time,title,serverType)
    sendluamsg(actor, LuaMessageIdToClient.RES_START_STALL, true)
    local now = getbaseinfo("nowsec")
    ---type Stall.Info 摆摊信息
    local stall = {
        mapId = mapId,
        line = 1,
        pointX = msgData.pointX,
        pointY = msgData.pointY,
        endTime = now + (time * HOUR_SECOND),
        title = title,
    }
    this.startStallSave(actor,stall)
    sendluamsg(actor, LuaMessageIdToClient.RES_STALL_INFO, stall)
end

function this.startStallSave(actor,stall)
    callonserial(actor, "start_stall_save", stall)
end

function start_stall_save(actor,stall)
    local allStallInfo = getsysvar(actor,ROLE_STALL_START)
    if not allStallInfo then
        allStallInfo = {}
    end
    allStallInfo[actor:toString()] = stall
    setsysvar(actor,ROLE_STALL_START,allStallInfo)
end

function endstalltest(actor)
    Stall.endStall(actor)
end

-- 结束摆摊
function Stall.endStall(actor)
    endstall(actor)
    sendluamsg(actor, LuaMessageIdToClient.RES_END_STALL, true)
    this.endStallSave(actor)
end

function this.endStallSave(actor)
    callonserial(actor, "end_stall_save")
end

function end_stall_save(actor)
    local allStallInfo = getsysvar(actor,ROLE_STALL_START)
    if table.isNullOrEmpty(allStallInfo) then
        return
    end
    allStallInfo[actor:toString()] = nil
    setsysvar(actor,ROLE_STALL_START,allStallInfo)
end


-- 合服务的时候结束全部摆摊
function Stall.combineglobalvar(varName,varData)
    info("合服时全部摊位信息", varData)
    for index, allStallInfo in pairs(varData) do
        if not table.isNullOrEmpty(allStallInfo) then
            for index, stallInfo in pairs(allStallInfo) do
                local stallActor = getactor(index)
                endstall(stallActor)
                if not table.isNullOrEmpty(stallInfo) and not table.isNullOrEmpty(stallActor) then
                    jprint("结束摆摊")
                end
            end
        end
    end
    setsysvar(ROLE_STALL_START,{})
end


-- 摆摊喊话消耗道具
function Stall.deleteItem(actor,msgData)
    removeitemfrombag(actor,msgData[1],msgData[2],0,9999,'摆摊')
end


 -- 获取摊位商品信息
function Stall.getStallGoods(actor,rid)
    local stallActor = getactor(actor,rid)
    local stallInfo = Stall.getStallTimeInfo(stallActor)
    if table.isEmpty(stallInfo) then
        return
    end
    local listingGood = {}
    listingGood["rid"] = rid
    listingGood["title"] = stallInfo.title
    
    local roleWorld = TradeGDataService.getActorListedGoods(actor)
    if table.isNullOrEmpty(roleWorld) then
        listingGood["number"] = 0
        listingGood["allgoods"] = {}
        sendluamsg(actor, LuaMessageIdToClient.RES_STALL_GOODS, listingGood)
        return
    end

    local allGoods = {}
    for index, good in pairs(roleWorld) do
        if good.itemCfgId ~= 30030305 then
            table.insert(allGoods,good)
        end
    end
    listingGood["number"] = #allGoods
    listingGood["allgoods"] = allGoods
    sendluamsg(actor, LuaMessageIdToClient.RES_STALL_GOODS, listingGood)
end

-- 在全局变量添加摊位信息
--function this.allStall(actor)
--    local allStall = getsysvar(actor, ALL_STALL_START)
--    if not allStall or allStall == "" then
--        allStall = {}
--    end
--    table.insert(allStall,actor:toString())
--    setsysvar(actor, ALL_STALL_START,allStall)
--end

--function clearallstallinfo(actor)
--    setsysvar(actor,ALL_STALL_START,{})
--end


-- 在全局变量减少摊位信息
--function this.deleteAllStall(actor)
--    local allStall = getsysvar(actor, ALL_STALL_START)
--    if not allStall then
--        return
--    end
--    local deleteIndex = 0
--    for index, stallActor in pairs(allStall) do
--        if actor:toString() == stallActor then
--            deleteIndex = index
--        end
--    end
--    allStall[deleteIndex] = nil
--    setsysvar(actor, ALL_STALL_START,allStall)
--end

function Stall.flushStall()
    callonserial("stall_flush")
end

function stall_flush()
    local allStallInfo = getsysvar(ROLE_STALL_START)
    if table.isEmpty(allStallInfo) then
        return
    end
    local stallActor
    local now = getbaseinfo("nowsec")
    for index, stallInfo in pairs(allStallInfo) do
        stallActor = getactor(index)
        if not table.isEmpty(stallInfo) and stallActor then
            if now > stallInfo.endTime then
                allStallInfo[index] = nil
                -- this.deleteAllStall(actor)
                endstall(stallActor)
                -- Stall.endStall(stallActor)
            end
        end
        stallActor = nil
    end
    setsysvar(ROLE_STALL_START,allStallInfo)
end
