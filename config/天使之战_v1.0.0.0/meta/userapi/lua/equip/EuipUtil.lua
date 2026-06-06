EquipUtil = {}

function EquipUtil.isSuit(cfgId)
    local list = ConfigDataManager.getList("cfg_equip_suit")
    for _, c in pairs(list) do
        local split = string.split(c.suititemid, "#")
        if table.contains(split, tostring(cfgId)) then
            return true
        end
    end
    return false
end

