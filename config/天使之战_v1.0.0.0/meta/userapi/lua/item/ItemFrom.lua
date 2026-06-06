-- 装备来源
-------------------------------------------------- domain层 -----------------------------------------------------
ItemFrom = {}
local this = {}
-- 道具来源信息
local ItemFromceData = {}
---@class ItemSourceData 首曝全局数据
---@field fromText string 来源 （掉落是怪物名字）
---@field mapName string 地图名字
---@field owner string 作者
---@field fromType integer 来源类型
---@field createTime integer 创建时间,秒时间戳

ItemFromType = {
    DROP = 1,
    OTHER = 2,
}



------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- trigger层 -----------------------------------------------------
function ItemFrom.setFrom(actor, itemId, itemCfgId, actionDesc)
    -- 必须是装备
    local type = ConfigDataManager.getTableValue("cfg_item", "type", "id", itemCfgId)
    if tonumber(type) ~= ItemType.EQUIP then
        return
    end

    -- 还未设置来源
    local itemExtData = EquipAndAppear.getItemExtData(actor, itemId)
    if itemExtData.fromType ~= nil then
        return
    end

    local content = ""

    if not string.startsWith(actionDesc, "邮件") then
        local config = this.getRecord(actionDesc)
        if table.isEmpty(config) then
            error("装备来源信息未配置，请检查: " .. actionDesc)
        else
            if not string.isNullOrEmpty(config.rewrite) then
                content = config.rewrite
            end
        end
    else
        content = "邮件"
    end

    local itemInfo = getequipinfo(actor, itemId, 1)
    local fromText = itemInfo.from

    if not string.isNullOrEmpty(content) then
        fromText = content
    end


    local fromData = ItemFrom.genericOtherFromInfo(actor, fromText)
    ItemFrom.copy2ItemExt(itemExtData, fromData)
    EquipAndAppear.SetItemExtData(actor, itemId, itemExtData)
end

function ItemFrom.genericDropInfo(mapId, monsterCfgId, killerId)
    local extData = {}
    local mapInfo = getmapinfobyid(mapId)
    local monsterName = ConfigDataManager.getTableValue("cfg_monster", "name", "id", monsterCfgId)
    extData.fromText = monsterName
    extData.mapName = mapInfo.name
    local killActor = getactor(killerId)
    extData.owner = getbaseinfo(killActor, "rolename")
    extData.fromType = ItemFromType.DROP
    extData.createTime = getbaseinfo("nowsec")
    return extData
end

function ItemFrom.genericOtherFromInfo(actor, fromText)
    local extData = {}
    -- local mapInfo = getmapinfobyid(actor, getbaseinfo(actor, "unimapid"))
    extData.fromText = fromText
    -- extData.mapName = mapInfo.name
    -- extData.owner = getbaseinfo(actor, "rolename")
    extData.fromType = ItemFromType.OTHER
    extData.createTime = getbaseinfo("nowsec")
    return extData
end

function ItemFrom.copy2ItemExt(itemExt, fromData)
    itemExt.fromText = fromData.fromText
    itemExt.mapName = fromData.mapName
    itemExt.owner = fromData.owner
    itemExt.fromType = fromData.fromType
    itemExt.createTime = fromData.createTime
end

------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- service层 -----------------------------------------------------







------------------------------------------------------------------------------------------------------------------
-------------------------------------------------- infrastructure层 ----------------------------------------------
-- 配置读取

function this.getRecord(actionDesc)
    local config = ConfigDataManager.getTableFirst("cfg_SourceEnumeration", "source", actionDesc)
    return config
end

---------------------------------------------------------------------------------------------------------------------
