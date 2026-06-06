---
--- Created by zhouzhipeng.
--- DateTime: 2025/10/29 上午10:35
--- Desc：套装图鉴
---

EquipChart = {}
local this = {}

local EQUIP_CHART_VAR = {
    SUIT_CHART_ATTR = "equipChartAttr",
}

-- 穿脱装备，更新图鉴：更新属性
function EquipChart.equipChange(actor, itemCfgId)
    local career = getbaseinfo(actor, "getbasecareer")
    local cfg_FashionGuide_list = ConfigDataManager.getTable("cfg_FashionGuide", "career", career)
    if table.isNullOrEmpty(cfg_FashionGuide_list) then
        return
    end
    local cfg_FashionGuide = this.getSuitChartCfg(cfg_FashionGuide_list, itemCfgId)
    if not cfg_FashionGuide then
        return
    end
    -- 获得穿戴的所有装备
    local allEquips = getputonequipinfo(actor)
    local count = 0
    -- 时装id-已穿戴的装备数量
    for key, t in pairs(cfg_FashionGuide_list) do
        local num = 0
        local fashionIds = string.split(t.fashionid, "#")
        for _, equip in pairs(allEquips) do
            local cfgId = tostring(equip.cfgid)
            local bindEqualItem = ConfigDataManager.getTableValue("cfg_item","bindequalitem","id",cfgId)
            if table.contains(fashionIds, cfgId) or table.contains(fashionIds, tostring(bindEqualItem)) then
                num = num + 1
            end
        end
        if num >= string.tonumber(t.quantity) then
            count = count + 1
        end
    end

    -- 更新属性
    local attrMap = {}
    if count > 1 then
        local attr_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.TWO_SUIT_CHART_ATTR)
        local attrMap2 = string.toIntIntMap(attr_str, "#", "|")
        table.mergeAdd(attrMap, attrMap2)
    end
    if count > 2 then
        local attr_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.THREE_SUIT_CHART_ATTR)
        local attrMap2 = string.toIntIntMap(attr_str, "#", "|")
        table.mergeAdd(attrMap, attrMap2)
    end
    if count > 3 then
        local attr_str = ConfigDataManager.getTableValue("cfg_global", "value", "id", GlobalConfigId.FOUR_SUIT_CHART_ATTR)
        local attrMap2 = string.toIntIntMap(attr_str, "#", "|")
        table.mergeAdd(attrMap, attrMap2)
    end

    
    addrolekmlattributes(actor, EQUIP_CHART_VAR.SUIT_CHART_ATTR .. "_ALL", attrMap)

end

function this.getSuitChartCfg(cfg_FashionGuide_list, itemCfgId)
    local id = tostring(itemCfgId)
    for _, cfg_FashionGuide in pairs(cfg_FashionGuide_list) do
        local fashionIds = string.split(cfg_FashionGuide.fashionid, "#")
        if table.contains(fashionIds, id) then
            return cfg_FashionGuide
        end
    end
    return nil
end


function gm_make_all_suit(actor)
    local career = getbaseinfo(actor, "getbasecareer")
    local cfg_FashionGuide_list = ConfigDataManager.getTable("cfg_FashionGuide", "career", career)
    local allItems = {}
    for _, cfg_FashionGuide in pairs(cfg_FashionGuide_list) do
       local fashionIds = string.split(cfg_FashionGuide.fashionid, "#")
        for index, itemId in pairs(fashionIds) do
            allItems[itemId]=1
        end
    end
    additemmaptobag(actor, allItems, 0, 9999, '一键生成所有时装')
end
