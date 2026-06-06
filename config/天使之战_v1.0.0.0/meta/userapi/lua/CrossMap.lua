CrossMap = {}

local IN_CROSS_MAP_KEY = "T$ENTER_CROSS_MAP"

-- 跨服主城ID
CrossMap.CROSS_MAP_ID = 21000

--跨服地图类型
CrossMap.CROSS_MAP_TYPE = 2;

-- 进入跨服地图 开服天数要求
local OPEN_DAY_GLOBAL_KEY = 11006

function CrossMap.Enter(actor)
    --神之国度的地图ID
    local mapId = CrossMap.CROSS_MAP_ID;
    if getbaseinfo(actor, "mapid") == mapId then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT344)
        return
    end
    local cfgs = ConfigDataManager.getTable("cfg_mapmove", "mapid", mapId)
    local cfg = cfgs[1]
    local x = cfg["mapx"]
    local y = cfg["mapy"]
    if x == nil or x == nil then
        noticeTip.noticeinfo(actor, StringIdConst.TEXT345)
        return
    end

    local can_enter = CrossMap.canEnter(actor, mapId)
    if not can_enter then
        return
    end

    maptransfer(actor, x, y, mapId, 1)
end

function CrossMap.Transfer2NPC(actor, data)
    -- 快捷指令 - 传送跨服地图NPC
    local npc_id = data.npcid
    local npc_config = ConfigDataManager.getById("cfg_npclist", npc_id)
    gameDebug.assertTrue(table.notEmpty(npc_config), "获取NPC配置为空", npc_id)

    local map_id = npc_config.mapid
    local can_enter = CrossMap.canEnter(actor, map_id)
    if not can_enter then
        return
    end

    local x = npc_config.x
    local y = npc_config.y
    local line = 1
    local range = 1

    maptransfer(actor, x, y, map_id, line, range)

    local param = { ['map_id'] = map_id, ['npc_id'] = npc_id }
    sendluamsg(actor, LuaMessageIdToClient.RES_CROSS_MAP_TRANSFER_TO_NPC, param)
end

--- 校验是否可以进入跨服地图  (跨服地图的cfg_map_info表ID)
function CrossMap.canEnter(actor, mapId)
    -- 开服天数
    local limit_day = ConfigDataManager.getTableValue("cfg_global", "value", "id", OPEN_DAY_GLOBAL_KEY)
    limit_day = string.tonumber(limit_day)
    if limit_day > 0 then
        local openday = getbaseinfo(actor, "serveropendays")
        if tonumber(openday) < limit_day then
            tipinfo(actor, "跨服活动未开启")
            return false
        end
    end

    local condition = ConfigDataManager.getTableValue("cfg_map_info", "condition", "id", mapId)
    local condition_arr = string.split(condition, "#")
    if table.isEmpty(condition_arr) or #condition_arr < 3 then
        return true
    end

    -- 检查玩家等级、强化、追加
    local level_limit = string.tonumber(condition_arr[1])
    -- 检查等级
    if level_limit > 0 then
        local level = getbaseinfo(actor, "level")
        if level < level_limit then
            tipinfo(actor, "进入跨服地图角色等级需要" .. condition_arr[1] .. "级")
            return false
        end
    end

    -- 检查强化
    local strengthlv = CrossMap.GetEquipStrengthORAppendLv(actor, "strengthlv")
    local strong_limit = string.tonumber(condition_arr[2])
    if strong_limit > 0 and strengthlv < strong_limit then
        tipinfo(actor, "进入跨服强化总等级需要" .. condition_arr[2] .. "级")
        return false
    end

    -- 检查追加
    local appentlv = CrossMap.GetEquipStrengthORAppendLv(actor, "appendlv")
    local append_limit = string.tonumber(condition_arr[3])
    if append_limit > 0 and appentlv < append_limit then
        tipinfo(actor, "进入跨服追加总等级需要" .. condition_arr[3] .. "级")
        return false
    end
    return true
end

function CrossMap.EnterView(actor, targetActor)
    local osid = getbaseinfo(targetActor, "originalserverid")
    local targetServerId = getbaseinfo(targetActor, "serverid")

    if osid ~= targetServerId then
        local targetId = getbaseinfo(targetActor, "id")
        local targetName = getbaseinfo(targetActor, "rolename")

        local res = {
            targetServerId = osid,
            targetId       = targetId,
            targetName     = targetName
        }
        sendluamsg(actor, LuaMessageIdToClient.RES_SERVER_ID_INFO, res)
    end
end

function CrossMap.CheckEnterCrossMap(actor, oldMapCfgId, newMapCfgId)
    local serverType = ConfigDataManager.getTableValue("cfg_map_info", "servertype", "id", newMapCfgId)
    if tonumber(serverType) == CrossMap.CROSS_MAP_TYPE then
        setplaydef(actor, IN_CROSS_MAP_KEY, 1)

        --进入跨服地图
        local res = { type = 1, mapId = newMapCfgId }
        sendluamsg(actor, LuaMessageIdToClient.RES_IN_OUT_CROSS_MAP, res)
    else
        local state = getplaydef(actor, IN_CROSS_MAP_KEY)
        if state ~= nil and state == 1 then
            --退出跨服地图
            local res = { type = 0, mapId = newMapCfgId }
            sendluamsg(actor, LuaMessageIdToClient.RES_IN_OUT_CROSS_MAP, res)
        end
        setplaydef(actor, IN_CROSS_MAP_KEY, 0)
    end
end

function CrossMap.GetEquipStrengthORAppendLv(actor, args_name)
    local all_equip = getputonequipinfo(actor)
    if table.isEmpty(all_equip) then
        return false
    end

    local max_level = 0
    for _, equip in pairs(all_equip) do
        local equip_data = EquipAndAppear.getItemExtData(actor, equip.id)

        if table.isEmpty(equip_data) then
            goto continue
        end
        local lv = equip_data[args_name] or 0

        max_level = max_level + lv
        :: continue ::
    end
    return max_level
end
