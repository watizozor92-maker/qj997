SceneMap = {}
local this = {}

SceneMap.viewKey = {
    -- VIP数据
    VIP_LV = "vipLv",
    KUN_DUN_FACTION = "kunDunFaction",
    DEMON_HERMIT_SKILL = "demonHermitSkill",
    -- 坐骑数据
    MOUNT = "mount",
    -- 护盾
    SHIELD = "shield",
}

--- 指定坐标是否为阻挡点 地图ID可不填 （T-非阻挡点, F-阻挡点）
function SceneMap.notBlockPoint(actor, map_x, map_y, map_id)
    return this.notBlockPoint(actor, map_x, map_y, map_id)
end

--- 传送到指定地图
function SceneMap.doTransfer(actor, map_id, map_line, map_x, map_y, range)
    this.doTransfer0(actor, map_id, map_line, map_x, map_y, range)
end

--- 玩家进入视野发送全量消息(发送玩家进入视野)
function SceneMap.playerEnterView(actor, target)
    local s, e = xpcall(this.playerEnterView, debug.traceback, actor, target)
end

--- 发送单个信息(更新给周围玩家视野内容变动)
function SceneMap.sendEnterViewInfoByType(actor, ...)
    this.sendRangeViewChange(actor, ...)
end

-- ----------------------------------------------------------------- --

function this.notBlockPoint(actor, map_x, map_y, map_id)
    if map_id == nil then
        return notblockpoint(actor, map_x, map_y)
    end
    return notblockpoint(actor, map_x, map_y, map_id)
end

function this.isBlockPoint(actor, map_x, map_y, map_id)
    return not this.notBlockPoint(actor, map_x, map_y, map_id)
end

function this.doTransfer0(actor, map_id, map_line, map_x, map_y, range)
    maptransfer(actor, map_x, map_y, map_id, map_line, range)
end

function this.playerEnterView(actor, target)
    local data = {}
    data.rid = target:toString()

    data[SceneMap.viewKey.VIP_LV] = VipGiftPack.getVipLv(target)
    if KunDun.isInKunDun(target) then
        data[SceneMap.viewKey.KUN_DUN_FACTION] = KunDun.getKunDunViewData(target)
    end
    data[SceneMap.viewKey.DEMON_HERMIT_SKILL] = getplaydef(target, PlayerDefKey.skill.DEMON_HERMIT_SKILL)
    data[SceneMap.viewKey.MOUNT] = Mount.getMountView(target)
    AGAndSD.sendSDAndAG(target)
    -- 发送通知
    sendluamsg(actor, LuaMessageIdToClient.RES_PLAYER_ENTER_VIEW_INFO, data)
end

function this.sendRangeViewChange(actor, ...)
    -- 参数必须是偶数
    local args = { ... }
    if #args % 2 > 0 then
        return
    end

    local data = {}
    data.rid = actor:toString()

    -- 解析参数
    for i = 1, #args, 2 do
        local type = args[i]
        local param = args[i + 1]
        data[type] = param
    end
    sendrefluamsg(actor, LuaMessageIdToClient.RES_PLAYER_ENTER_VIEW_INFO, data)
end

-- ----------------------------------------------------------------- --
MapMoveTransfer = {}

--- MapMove传送
function MapMoveTransfer.mapMove(actor, move_id)
    this.doMapMove(actor, move_id)
end

function MapMoveTransfer.mapMoveWithLine(actor, move_id, line)
    this.doMapMove(actor, move_id, line)
end

function this.doMapMove(actor, move_id, line)
    if line == nil then
        kmlmapmove(actor, move_id)
        return
    end
    kmlmapmove(actor, move_id, line)
end

--- 请求地图内定点传送
function MapMoveTransfer.transferWithinMap(actor, msgData)
    this.transferWithinMap(actor, msgData)
end

function this.transferWithinMap(actor, msgData)
    if table.isEmpty(msgData) then
        return
    end

    if DuplicateCommon.IsInDuplicate(actor) then
        tipinfo(actor, "当前地图不可使用")
        return
    end

    local map_x = tonumber(msgData[1])
    local map_y = tonumber(msgData[2])

    if this.isBlockPoint(actor, map_x, map_y) then
        tipinfo(actor, "目标地点无法抵达")
        return
    end

    local map_id = getbaseinfo(actor, "mapid")
    local line = getbaseinfo(actor, "line")
    local range = 1

    local cost_map = {}
    local cost_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.TRANSFER_WITHIN_MAP)
    if not string.isNullOrEmpty(cost_str) then
        string.putIntIntMap(cost_map, cost_str, "#", "|")
    end

    if not table.isNullOrEmpty(cost_map) then
        if not Bag.checkCostMap(actor, cost_map) then
            tipinfo(actor, "道具不足")
            return
        end
        Bag.costMap(actor, cost_map)
    end

    this.doTransfer0(actor, map_id, line, map_x, map_y, range)
end

function MapMoveTransfer.getRangePoints(actor, range)
    local x = getbaseinfo(actor, "x")
    local y = getbaseinfo(actor, "y")
    local mapId = getbaseinfo(actor, "mapid")
    local points = {}
    for i = -range, range do
        for j = -range, range do
            if i == 0 and j == 0 then
                goto continue
            end
            local new_x = x + i
            local new_y = y + j
            if checkmapmove(actor, mapId, new_x, new_y) then
                table.insert(points, {new_x, new_y})
            end
            ::continue::
        end
    end
    return points
end

function MapMoveTransfer.getOneRangePoints(actor, range)
    local points = MapMoveTransfer.getRangePoints(actor, range)
    if table.isEmpty(points) then
        return {}
    end
    local index = math.random(1, #points)
    return points[index]
end
