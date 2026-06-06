Mount = {}
local this = {}

local __mountKey = "mount_equip_rid_data"

function Mount.handleMount(actor, reqIndex)
    reqIndex = tonumber(reqIndex)
    if not reqIndex then
        return
    end
    -- 坐骑装备索引
    local index = GameEquipIndex.mount
    if index == reqIndex then
        -- 脱装
        this.putoffEquip(actor, reqIndex)
    else
        -- 穿戴
        this.putonEquip(actor, reqIndex)
    end
end

function this.putonEquip(actor, bagIndex)
    -- 坐骑装备索引
    local index = GameEquipIndex.mount
    local iteminfo = getbagiteminfo(actor, bagIndex, 0)
    if table.isEmpty(iteminfo) then
        return
    end
    local itemCfgId = iteminfo.cfgid
    local config = ConfigDataManager.getById("cfg_item", itemCfgId)
    if table.isNullOrEmpty(config) then
        return
    end
    local type = config.type
    local subType = config.subtype
    if tonumber(type) ~= ItemType.EQUIP or tonumber(subType) ~= ItemSubType.MOUNT then
        return
    end
    local mountConfig = ConfigDataManager.getTableFirst("cfg_mount", "itemid", itemCfgId)
    if table.isNullOrEmpty(mountConfig) then
        local equalId = config.bindequalitem
        if string.isNullOrEmpty(equalId) then
            return
        end
        local equalItem = ConfigDataManager.getById("cfg_item", equalId)
        if table.isEmpty(equalItem) then
            return
        end
        mountConfig = ConfigDataManager.getTableFirst("cfg_mount", "itemid", equalId)
        if table.isNullOrEmpty(mountConfig) then
            return
        end
    end
    local id = tonumber(mountConfig.id)
    setridemountid(actor, id)
    putontheequip(actor, bagIndex, index)
    -- setequipgmext(actor, iteminfo.id, iteminfo.entries or {})
    this.sendMountInfo(actor)
    info(actor, actor:toString(), "坐骑装备穿戴", itemCfgId)
end

function this.putoffEquip(actor, equipIndex)
    local equpInfo = getequipinfo(actor, equipIndex)
    if table.isNullOrEmpty(equpInfo) then
        info(actor, actor:toString(), "坐骑装备脱装", "无坐骑装备")
    else
        local cfgId = equpInfo.cfgid
        local mountConfig = ConfigDataManager.getTableFirst("cfg_mount", "itemid", cfgId)
        if table.isNullOrEmpty(mountConfig) then
            local config = ConfigDataManager.getById("cfg_item", cfgId)
            local equalId = config.bindequalitem
            if string.isNullOrEmpty(equalId) then
                return
            end
            local equalItem = ConfigDataManager.getById("cfg_item", equalId)
            if table.isEmpty(equalItem) then
                return
            end
            mountConfig = ConfigDataManager.getTableFirst("cfg_mount", "itemid", equalId)
            if table.isNullOrEmpty(mountConfig) then
                return
            end
        end
        local id = tonumber(mountConfig.id)
        takeofftheequip(actor, equipIndex)
        setridemountid(actor, 0)
        mountisshow(actor, 0, id)
        this.updateRidingAttr(actor, id, 0)
        API.SetInt(actor, __mountKey, 0)
        this.sendMountInfo(actor)
        info(actor, actor:toString(), "坐骑装备脱装", cfgId)
    end
end

function this.login(actor)
    local show = API.GetInt(actor, __mountKey)
    if show == 1 then
        Mount.toggleMountShow(actor, 1)
    end
end

function Mount.toggleMountShow(actor, show)
    -- 坐骑装备索引
    local equipIndex = GameEquipIndex.mount
    local equpInfo = getequipinfo(actor, equipIndex)
    if table.isEmpty(equpInfo) then
        return
    end
    local cfgId = equpInfo.cfgid
    local mountConfig = ConfigDataManager.getTableFirst("cfg_mount", "itemid", cfgId)
    if table.isNullOrEmpty(mountConfig) then
        local config = ConfigDataManager.getById("cfg_item", cfgId)
        local equalId = config.bindequalitem
        if string.isNullOrEmpty(equalId) then
            return
        end
        local equalItem = ConfigDataManager.getById("cfg_item", equalId)
        if table.isEmpty(equalItem) then
            return
        end
        mountConfig = ConfigDataManager.getTableFirst("cfg_mount", "itemid", equalId)
        if table.isNullOrEmpty(mountConfig) then
            return
        end
    end
    local area = tonumber(mountConfig.area)
    if area == 1 and insafezone(actor) and show == 1 then
        tipinfo(actor, "安全区内不可骑乘该坐骑")
        return
    end
    local id = tonumber(mountConfig.id)
    mountisshow(actor, show, id)
    API.SetInt(actor, __mountKey, show)

    -- todo 处理移动速度
    this.updateRidingAttr(actor, id, show)
end

function Mount.getMountView(actor)
    local equipIndex = GameEquipIndex.mount
    local equpInfo = getequipinfo(actor, equipIndex)
    if table.isEmpty(equpInfo) then
        return
    end
    return equpInfo
end

function this.sendMountInfo(actor)
    local mountView = Mount.getMountView(actor) or {}
    local msg = {
        rid = actor:toString(),
        mount = mountView,
    }
    sendrefluamsg(actor, LuaMessageIdToClient.RES_PUT_OR_DOWN_MOUNT_EQUIP, msg)
end

function this.updateRidingAttr(actor, id, show)
    if show == 1 then
        local speed = tonumber(ConfigDataManager.getTableValue("cfg_mount", "speed", "id", id))
        addrolekmlattributes(actor, "mount_speed_enhance", { [318022] = speed })
    else
        addrolekmlattributes(actor, "mount_speed_enhance", { [318022] = 0 })
    end
end

MessageRouter:register(LuaMessageIdToSever.REQ_RIDE_OR_DOWN_MOUNT, Mount.handleMount)
MessageRouter:register(LuaMessageIdToSever.REQ_SHOW_OR_HIDDEN_MOUNT, Mount.toggleMountShow)
LoginEventListerTable:eventLister("0", "坐骑", this.login)



-- ====================================测试========================================
function testmountmanager(actor, ...)
    local args = { ... }
    local opt = tonumber(args[1])
    if opt == 1 then
        Mount.handleMount(actor, args[2])
    elseif opt == 2 then
        Mount.toggleMountShow(actor, args[2])
    end
end
