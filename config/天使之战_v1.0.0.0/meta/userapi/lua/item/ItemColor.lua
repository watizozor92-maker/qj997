EquipColorService = {}

function EquipColorService.getColorByEquipInfo(actor, equipInfo)
    local cfgId = equipInfo.cfgid
    local color = nil
    local t = ConfigDataManager.getById("cfg_equip_strengthen", cfgId)
    if t ~= nil then
        local luaExtData = EquipAndAppear.getItemExtData(actor, equipInfo.id)
        local strengthLevel = string.tonumber(luaExtData.strengthlv)
        if string.tonumber(luaExtData.appendlv) > 0 or luaExtData.IsLuck == 1 or (not string.isNullOrEmpty(luaExtData.skillName)) then
            color = ConfigDataManager.getTableValue("cfg_global", "value", "id", 480003)
        elseif strengthLevel > 0 and strengthLevel < 3 then
            color = ConfigDataManager.getTableValue("cfg_global", "value", "id", 480001)
        elseif strengthLevel > 2 then
            color = ConfigDataManager.getTableValue("cfg_global", "value", "id", 480002)
        end
    else
        -- 是否是套装
        if EquipUtil.isSuit(cfgId) then
            color = ConfigDataManager.getTableValue("cfg_global", "value", "id", 480005)
        end
    end

    if color == nil then
        local ic = ConfigDataManager.getTableValue("cfg_item", "dropcolor", "id", cfgId)
        color = ConfigDataManager.getTableValue("cfg_color", "color", "id", ic)
    end
    return color
end

function EquipColorService.getColorById(actor, itemId)
    return EquipColorService.getColorByEquipInfo(actor, getequipinfo(actor, itemId, 1))
end
