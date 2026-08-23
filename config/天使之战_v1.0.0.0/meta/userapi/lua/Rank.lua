RankScript = {}
local this = {}
-- 排行榜类型
RANK_TYPES = {
    levelType = 1,
}
RANK_FIELD_TYPE = {
    name = 1,
    unionname = 2,
    career = 3,
}
local rankScriptConst = {
    -- 排行榜上限人数id
    RANK_LIMIT_MEMBERS = 17,
    -- 排行榜奖励时间id
    RANK_REWARD_TIME = 10002,
    -- 职业类型
    CAREERS = {
        0, 1, 2, 3, 4, 5, 6
    },
    -- 奖励邮件
    REWARD_MAIL = 110001,
    REWARD_TITLE = "排行榜",
    -- 本地或跨服排行榜
    LOCAL_RANK = 1,
    CROSS_RANK = 2,

}


function this.getKey()
    return "rankData"
end

function this.setGlobal(id, data)
    gset(this.getKey(), id, data)
end

function this.getGlobal(id)
    return gget(this.getKey(), id) or {}
end

function this.getAll()
    return gget(this.getKey()) or {}
end

function RankScript.stopRefreshData(actor)
    -- 暂时不做
end

-- 请求排行榜数据
function RankScript.loadRankData(actor, msgData)
    local career = tonumber(msgData["career"])
    local type = tonumber(msgData["type"])
    local rootType = tonumber(msgData["roottype"]) or 1
    if career == nil or type == nil then
        return
    end
    if rootType ~= rankScriptConst.LOCAL_RANK then
        return
    end
    -- 请求数据
    local id = ConfigDataManager.getTableValue("cfg_rank", "id", "roottype", rootType, "career", career, "type", type)
    if id == "" or id == nil then
        return
    end
    local rankRoles = this.getRankByCondition(actor, career, type, rootType)
    local selfData = this.getSelfById(actor, type)
    local sendMsg = {
        id = id,
        rankDatas = rankRoles,
        myRankData = selfData
    }
    sendluamsg(actor, LuaMessageIdToClient.SEND_RANK_DATA_TO_CLIENT, sendMsg)
end

--- func desc 更新排行榜中个人数据
---@param actor any
---@param type number 排行榜类型
function RankScript.updateByType(actor, type, ...)
    local serverType = getbaseinfo(actor, "servertype")
    if serverType ~= ServerType.Game then
        return
    end
    local args = { ... }
    local role = this.getGlobal(actor:toString())
    local update = true
    if table.isNullOrEmpty(role) then
        role = this.buildOne(actor)
    else
        if tonumber(type) == RANK_TYPES.levelType then
            local newLevel = getbaseinfo(actor, "level")
            if newLevel > role.level then
                role.rankTime = getbaseinfo("nowsec")
            else
                update = false
            end
            role.level = newLevel
        end

        local fields = {
            { key = "crossid",   value = getbaseinfo("crossserverid") },
            { key = "serverid",  value = getbaseinfo(actor, "currserverid") },
            { key = "name",      value = getbaseinfo(actor, "rolename") },
            { key = "unionname", value = getbaseinfo(actor, "guildname") },
            { key = "career",    value = getbaseinfo(actor, "getbasecareer") },
        }

        for _, field in ipairs(fields) do
            if role[field.key] ~= field.value then
                role[field.key] = field.value
                update = true
            end
        end
    end

    if update then
        this.log(actor, "更新数据", type, role)
        this.setGlobal(actor:toString(), role)
    end
end

--- func desc
---@param actor any
function this.buildOne(actor)
    local role = {}
    role.rid = actor:toString()
    role.serverid = getbaseinfo(actor, "currserverid")
    role.name = getbaseinfo(actor, "rolename")
    role.unionname = getbaseinfo(actor, "guildname") or ""
    role.crossid = getbaseinfo("crossserverid")
    role.level = getbaseinfo(actor, "level")
    role.rankTime = getbaseinfo("nowsec")
    local career = getbaseinfo(actor, "getbasecareer")
    role.career = career
    return role
end

--- func desc 个人查询排行榜
---@param actor any
function this.getRankByCondition(actor, career, type, rootType)
    local rank = {}
    if tonumber(rootType) == rankScriptConst.LOCAL_RANK then
        local serverId = table.select(actor, nil, getbaseinfo("serverid"), getbaseinfo(actor, "currserverid"))
        rank = this.queryRankByCondition(career, type, serverId, nil)
    elseif tonumber(rootType) == rankScriptConst.CROSS_RANK then
        local crossServerId = getbaseinfo("crossserverid")
        if crossServerId == 0 then
            -- 本服未跨服
            return {}
        end
        rank = this.queryRankByCondition(career, type, nil, crossServerId)
    end
    this.log(actor, "查询结果长度: " .. #rank)
    return rank
end

function this.queryRankByCondition(career, type, serverId, crossServerId)
    local sql = this.writeSql(career, type, serverId, crossServerId)
    this.log("查询sql: ", sql)
    local roles = {}
    if string.isNullOrEmpty(sql) then
        return roles
    end
    local rank = gquery(sql)
    if table.isNullOrEmpty(rank) then
        return roles
    end
    for k, v in pairs(rank) do
        table.insert(roles, v)
    end
    this.setShowData(roles, type, false)
    this.sortByType(roles, type)
    this.setRankno(roles)
    return roles
end

function this.getSelfById(actor, type)
    local my = this.getGlobal(actor:toString())
    if table.isNullOrEmpty(my) then
        return my
    end
    local res = {}
    res.rid = my.rid
    res.serverid = my.serverid
    if tonumber(type) == RANK_TYPES.levelType then
        res.level = my.level
        res.rankTime = my.rankTime
    end
    this.setShowData(res, type, true)
    return res
end

function this.writeSql(career, type, serverId, crossServerId)
    local typeConfig = {
        [RANK_TYPES.levelType] = {
            fields = "level, rankTime",
            conditionField = "level",
            order = "level desc, rankTime asc"
        },
    }

    local config = typeConfig[tonumber(type)]
    if not config then
        error("排行榜请求类型错误" .. type)
        return
    end

    local condition = ConfigDataManager.getTableValue("cfg_rank", "rankcondition", "career", career, "type", type)
    if string.isNullOrEmpty(condition) then
        condition = 0
    end
    local limitCount = ConfigDataManager.getTableValue("cfg_global", "value", "id", rankScriptConst.RANK_LIMIT_MEMBERS)
    if string.isNullOrEmpty(limitCount) then
        limitCount = 50
    end
    local idType = crossServerId and 'crossid' or 'serverid'
    local id = table.select(crossServerId, crossServerId, serverId)
    local common = tonumber(career) == rankScriptConst.CAREERS[1]

    local baseSql = string.format(
        'select * from %s where %s >= %d and %s = %d',
        -- config.fields,
        this.getKey(),
        config.conditionField,
        condition,
        idType,
        id
    )

    if not common then
        baseSql = baseSql .. ' and career = ' .. career
    end

    return baseSql .. ' order by ' .. config.order .. ' limit ' .. limitCount
end

function this.setShowData(rankRole, type, isSelf)
    if isSelf then
        this.buildOneRole(rankRole, type)
    else
        for i, role in ipairs(rankRole) do
            this.buildOneRole(role, type)
        end
    end
end

function this.buildOneRole(role, type)
    local actor = getactor(role.rid)
    role.actor = actor
    role.rid = nil
    local valueMap = {
        [RANK_TYPES.levelType] = role.level,
    }
    role.value = valueMap[tonumber(type)]
    role.level = nil
    role.rankTime = nil
end

-- 数组排序
function this.sortByType(roles, type)
    if tonumber(type) == RANK_TYPES.levelType then
        table.sort(roles, function(a, b)
            if a["value"] ~= b["value"] then
                return a["value"] > b["value"]
            else
                return this.fieldAndIdRank(a, b, "rankTime")
            end
        end)
    end
end

function this.fieldAndIdRank(a, b, field)
    if not field then
        return this.sortOnId(a, b)
    end
    if tonumber(a[field]) ~= tonumber(b[field]) then
        return tonumber(a[field]) < tonumber(b[field])
    else
        return this.sortOnId(a, b)
    end
end

function this.sortOnId(a, b)
    local aId = a["actor"]:toString()
    local bId = b["actor"]:toString()
    return aId < bId
end

-- 设置排名
function this.setRankno(tobeStoreRoles)
    -- 允许并列排名
    for i, roleInfo in ipairs(tobeStoreRoles) do
        if i == 1 then
            roleInfo["rankno"] = 1
        else
            -- 判断和前一个名次是否并列
            local equal = this.rankNoIsEquals(tobeStoreRoles, i)
            if equal then
                roleInfo["rankno"] = tobeStoreRoles[i - 1]["rankno"]
            else
                roleInfo["rankno"] = i
            end
        end
    end
end

function this.rankNoIsEquals(tobeStoreRoles, nowIndex)
    local preRole = tobeStoreRoles[nowIndex - 1]
    local currRole = tobeStoreRoles[nowIndex]
    return tonumber(currRole["value"]) == tonumber(preRole["value"])
end

-- 检查数据有效性
function RankScript.checkData()
    local date = TimeUtil.timeToDate(getbaseinfo("nowsec"))
    if date.hour == 1 then
        local infos = getallrolesummaryinfos()
        local localPlayers = {}
        for _, info in pairs(infos) do
            local player = info.actor
            localPlayers[player:toString()] = true
        end
        local all = this.getAll()
        local localServerId = getbaseinfo("serverid")
        for _, role in pairs(all) do
            local rid = role.rid
            local serverId = role.serverid
            if localServerId == serverId then
                if not localPlayers[rid] then
                    this.setGlobal(rid, {})
                end
            end
        end
    end
end

function RankScript.updateAllRank()
    local infos = getallrolesummaryinfos()
    for _, info in pairs(infos) do
        local player = info.actor
        this.updateAllType(player)
    end
end

--- func desc : 更新三种类型的数据
function this.updateAllType(player)
    RankScript.updateByType(player, RANK_TYPES.levelType)
end

--- func desc 发送奖励
function RankScript.sendReward(serverType)
    local rankRewardTime = ConfigDataManager.getTableValue("cfg_global", "value", "id", rankScriptConst.RANK_REWARD_TIME)
    if string.isNullOrEmpty(rankRewardTime) then
        return
    end
    local weekAndHour = string.splitByAll(rankRewardTime, "#")
    local date = TimeUtil.timeToDate(getbaseinfo("nowsec"))
    local nowDay = date.wday
    if nowDay == tonumber(weekAndHour[1]) and date.hour == tonumber(weekAndHour[2]) then
        this.log("发送排行榜奖励")
        local configs = ConfigDataManager.getList("cfg_rank")
        if not table.isNullOrEmpty(configs) then
            for i, congfig in ipairs(configs) do
                local career = congfig.career
                local type = congfig.type
                local rootType = congfig.roottype
                if serverType == ServerType.Game and tonumber(rootType) == rankScriptConst.LOCAL_RANK then
                    local rank = this.getRankByCondition(nil, career, type, rootType)
                    this.sendReward(rank, congfig)
                -- elseif serverType == ServerType.Cross and tonumber(rootType) == rankScriptConst.CROSS_RANK then
                --     local rank = this.getRankByCondition(nil, career, type, rootType)
                --     this.sendReward(rank, congfig)
                end
            end
        end
    end
end

-- 发奖励
function this.sendReward(rank, congfig)
    local rewardThing = congfig.reward
    if string.isNullOrEmpty(rewardThing) then
        return
    end
    for _, currRole in ipairs(rank) do
        local actor = currRole.actor
        local rankNo = currRole.rankno
        local itemMap = this.getRewardByRank(rankNo, rewardThing)
        local itemBing = ConfigDataManager.getTableValue("cfg_bind", "bind", "id", 14)
        if itemMap then
            sendconfigmailbyrid(actor, actor:toString(), rankScriptConst.REWARD_MAIL, itemMap,
                rankScriptConst.REWARD_TITLE, itemBing)
        end
    end
end

function this.getRewardByRank(rankno, rewardConfig)
    for _, config in ipairs(string.split(rewardConfig, "|")) do
        local parts = string.split(config, "#")
        if #parts == 4 then
            local minRank = tonumber(parts[1])
            local maxRank = tonumber(parts[2])
            if rankno >= minRank and rankno <= maxRank then
                return { [tonumber(parts[3])] = tonumber(parts[4]) }
            end
        end
    end
    return nil
end

--- func desc 清除个人数据
---@param actor any
function RankScript.clearSelfData(actor)
    this.log(actor, "玩家清除数据")
    this.setGlobal(actor:toString(), {})
end

--- func desc 更新个人数据
---@param actor any
function RankScript.updateSelfData(actor, type)
    local fieldMap = {
        [RANK_FIELD_TYPE.name] = { col = "name", val = getbaseinfo(actor, "rolename") },
        [RANK_FIELD_TYPE.unionname] = { col = "unionname", val = getbaseinfo(actor, "guildname") },
        [RANK_FIELD_TYPE.career] = { col = "career", val = getbaseinfo(actor, "getbasecareer") }
    }

    local field = fieldMap[tonumber(type)]
    if field then
        local sql = string.format(
            'update %s set %s = "%s" where rid = "%s"',
            this.getKey(),
            field.col,
            field.val,
            actor:toString()
        )
        this.log(actor, "更新个人排行字段信息:", sql)
        gquery(sql)
    end
end

function this.log(actor, ...)
    if type(actor) == "userdata" then
        -- info(actor, "[[--排行榜--]]", "actor_id: ", actor:toString(), ...)
    else
        -- info("[[--排行榜--]]", ...)
    end
end

-- ====================测试========================
--- func desc
function rank_updaterank(player)
    this.updateAllType(player)
end

--- func desc
---@param actor any
function rank_updateall(actor)
    local infos = getallrolesummaryinfos()
    for _, info in pairs(infos) do
        local player = info.actor
        this.updateAllType(player)
    end
end

function rank_clearrank(actor, id)
    local infos = getallrolesummaryinfos()
    for _, info in pairs(infos) do
        local player = info.actor
        this.setGlobal(player:toString(), {})
    end
    if id then
        this.setGlobal(id, {})
    end
end

--- func desc
---@param actor any
function rank_gettype(actor, career, type, rootType)
    if career then
        this.getRankByCondition(actor, career, type, rootType)
    else
        this.getRankByCondition(actor, 0, 1, 1)
    end
end

--- func desc
---@param actor any
function rank_getmy(actor, type)
    this.getSelfById(actor, type)
end

function rank_rankreward(actor)
    local serverType = getbaseinfo("servertype")
    RankScript.sendReward(serverType)
end
