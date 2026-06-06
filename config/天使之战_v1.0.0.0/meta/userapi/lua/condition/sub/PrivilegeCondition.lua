ConditionHandler:register(ConditionId.privilege["拥有某项特权卡"], "拥有某项特权卡", function(actor, param)
    return PrivilegeMonth.hasPrivilegeCardType(actor, tonumber(param))
end)

ConditionHandler:register(ConditionId.privilege["拥有某项特权"], "拥有某项特权", function(actor, param)
    if not string.find(param, "#") then
        local has, total = Privilege.hasPrivilege(actor, tonumber(param))
        return has
    end
    local v = string.splitInt(param, "#")
    local id, value = v[1], v[2]
    local has, hasValue = Privilege.hasPrivilege(actor, tonumber(id))
    return has and hasValue >= value
end)
