ConditionHandler:register(ConditionId.equip["穿戴某装备"], "穿戴某装备", function(actor, param)
    local allEquips = getputonequipinfo(actor)
    if table.isNullOrEmpty(allEquips) then
        return false
    end
    for _, equip in ipairs(allEquips) do
        if equip.cfgid == tonumber(param) then
            return true
        end
    end
    return false
end)
