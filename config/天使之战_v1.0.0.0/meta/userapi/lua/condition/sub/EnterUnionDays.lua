local function __getEnterTime(actor)
    ---@type UnionData
    local union_data = getunioninfo(actor)
    if table.isEmpty(union_data) then
        return 0
    end

    local memberInfos = union_data.memberinfos
    if table.isEmpty(memberInfos) then
        return 0
    end
    local rid = tonumber(actor:toString())

    ---@type UnionMemberInfos
    local info = memberInfos[rid]
    if table.isEmpty(info) then
        return 0
    end

    local joinTime = tonumber(info.jointime)
    local now = tonumber(getbaseinfo('now'))
    return math.floor((now - joinTime) / 1000 / 60)
end


ConditionHandler:register(ConditionId.union["加入战盟分钟>"], "加入战盟分钟>", function(actor, param)
    local time = __getEnterTime(actor)
    return time > tonumber(param)
end)
ConditionHandler:register(ConditionId.union["加入战盟分钟>="], "加入战盟分钟>=", function(actor, param)
    local time = __getEnterTime(actor)
    return time >= tonumber(param)
end)
ConditionHandler:register(ConditionId.union["加入战盟分钟=="], "加入战盟分钟==", function(actor, param)
    local time = __getEnterTime(actor)
    return time == tonumber(param)
end)
ConditionHandler:register(ConditionId.union["加入战盟分钟<="], "加入战盟分钟<=", function(actor, param)
    local time = __getEnterTime(actor)
    return time <= tonumber(param)
end)
ConditionHandler:register(ConditionId.union["加入战盟分钟<"], "加入战盟分钟<", function(actor, param)
    local time = __getEnterTime(actor)
    return time < tonumber(param)
end)
ConditionHandler:register(ConditionId.union["加入战盟分钟~="], "加入战盟分钟~=", function(actor, param)
    local time = __getEnterTime(actor)
    return time ~= tonumber(param)
end)