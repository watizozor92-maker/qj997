---@class PrivilegeMonthData
---@field PrivilegeTypeData table<number,PrivilegeTypeData>
---@class PrivilegeTypeData
---@field id number
---@field start_time number
---@field durationtime number 持续时长 单位小时
PrivilegeMonth = {}

local this = {}

this.PRIVILEGE_DATA_KEY = "T$_PLAYER_MONTH_PRIVILEGE_DATA_KEY"
this.PRIVILEGE_OVER_TIME_DATA_KEY = "T$_PLAYER_MONTH_PRIVILEGE_OVER_TIME_DATA_KEY"
this.PRIVILEGE_DATA_RESTRICTWALK_KEY = "T$RestrictedWalkingTimer"
this.PRIVILEGE_DATA_RESTRICTWALKTIME_KEY = "T$RestrictedWalkingTime"
PrivilegeCardType = {
    MONTH_CARD = 1,
    PRIVILEGE_CARD = 2
}

-- 是否有某种特权卡
function PrivilegeMonth.hasPrivilegeCardType(actor, p_type)
    return this.hasPrivilegeType(actor, p_type)
end

-- 是否有任一种特权卡
function PrivilegeMonth.hasAnyPrivilegeCard(actor)
    return this.hasAnyPrivilege(actor)
end

function PrivilegeMonth.login(actor)
    this.sendPrivilegeBubbleData(actor)
end

function PrivilegeMonth.sendHasPrivilege(actor, p_type)
    local ret = this.hasPrivilegeType(actor, p_type)
    sendluamsg(actor, LuaMessageIdToClient.RES_CHECK_MONTH_PRIVILEGE_IS_OPEN, ret)
end

function PrivilegeMonth.sendPrivilegeData(actor)
    local data = this.getPrivilegeData(actor)
    this.debug("send_privilege_data", data)
    sendluamsg(actor, LuaMessageIdToClient.RES_GET_MONTH_PRIVILEGE_DATA, data)
end

function PrivilegeMonth.OnWalk(actor)
    local openPri = this.hasAnyPrivilegeValid(actor)
    if not openPri then
        --开启特权卡
        local lastBackTime = getplaydef(actor, this.PRIVILEGE_DATA_RESTRICTWALKTIME_KEY)
        info(actor, "lastBackTime", lastBackTime, os.time())
        if not lastBackTime or os.time() - lastBackTime > 10 then
            this.restrictWalkNextTime(actor)
        end
    end
end

function restrictwalkcallback(actor)
    info(actor, "[restrictWalkBallback]")
    local openPri = this.hasAnyPrivilegeValid(actor)
    if openPri then
        this.clearRestrictWalkTime(actor)
        return
    end
    local toMapId = 1001
    local x = getbaseinfo(actor, "x")
    local y = getbaseinfo(actor, "y")
    local mapId = getbaseinfo(actor , "mapid")
    local line = getbaseinfo(actor, "line")
    local rebirthPoint = ConfigDataManager.getTableValue("cfg_map_info", "rebirthPoint", "id", toMapId)
    local rebirthPointMap = string.toAllIntIntMap(rebirthPoint, "#", "|")
    if mapId ~= 1001 or (math.abs(x - rebirthPointMap[1][2]) > 10 or math.abs(y - rebirthPointMap[1][3]) > 10) then
        maptransfer(actor, rebirthPointMap[1][2] + math.random(-5, 5),
            rebirthPointMap[1][3] + math.random(-5, 5) , 1001, line)
    end
    this.restrictWalkNextTime(actor)
end
-- -------------------------------------------------------------------------- --
function this.restrictWalkNextTime(actor)
    local timerid = getplaydef(actor, this.PRIVILEGE_DATA_RESTRICTWALK_KEY)
    if timerid then
        clearintervalcall(timerid)
    end
    timerid = intervalcalldelay(actor, 5000, 5000, 1, "restrictwalkcallback")
    -- print("timerid", timerid)
    setplaydef(actor, this.PRIVILEGE_DATA_RESTRICTWALKTIME_KEY, os.time())
    setplaydef(actor, this.PRIVILEGE_DATA_RESTRICTWALK_KEY, timerid)
end

function this.clearRestrictWalkTime(actor)
    local timerid = getplaydef(actor, this.PRIVILEGE_DATA_RESTRICTWALK_KEY)
    if timerid then
        clearintervalcall(timerid)
    end
    -- print("timerid", timerid)
    setplaydef(actor, this.PRIVILEGE_DATA_RESTRICTWALKTIME_KEY, nil)
    setplaydef(actor, this.PRIVILEGE_DATA_RESTRICTWALK_KEY, nil)
end

function this.hasAnyPrivilegeValid(actor)
    return this.hasPrivilegeType(actor, 73)
       or this.hasPrivilegeType(actor, 72)
       or this.hasPrivilegeType(actor, 74)
end

---@return PrivilegeMonthData
function this.getPrivilegeData(actor)
    return getplaydef(actor, this.PRIVILEGE_DATA_KEY)
end

function this.setPrivilegeData(actor, data)
    setplaydef(actor, this.PRIVILEGE_DATA_KEY, data)
end

function this.hasPrivilegeType(actor, p_type)
    local data = this.getPrivilegeData(actor)
    if table.isEmpty(data) then
        return false
    end

    ---@type PrivilegeTypeData
    local type_data = data[p_type]
    if table.isEmpty(type_data) then
        return false
    end
    if type_data.start_time < 1 then
        return false
    end
    if type_data.durationtime == -1 then
        return true
    else
        local now = getbaseinfo("now")
        local end_mills = type_data.start_time + type_data.durationtime * 60 * 60 * 1000
        return end_mills > tonumber(now)
    end
end

function this.hasAnyPrivilege(actor)
    local data = this.getPrivilegeData(actor)
    if table.isEmpty(data) then
        return false
    end
    for p_type, _ in pairs(data) do
        local tableValue = ConfigDataManager.getTable("cfg_privilege", "id", p_type)
        return not table.isNullOrEmpty(tableValue)
    end
    return false
end

function PrivilegeMonth.checkTimeOut(actor)
    local data = this.getPrivilegeData(actor)
    if table.isEmpty(data) then
        return
    end
    local now = getbaseinfo("now")
    local update = false
    for k, v in pairs(data) do
        if v.start_time >= 1 then
            local end_mills = v.start_time + v.durationtime * 60 * 60 * 1000
            local left_mills = end_mills - tonumber(now)
            if left_mills < 0 then
                gameDebug.print(actor, "玩家特权卡已到期:", k)
                data[k] = nil
                update = true
                this.setPrivilegeBubbleTime(actor, k, now)
                sendluamsg(actor, LuaMessageIdToClient.RES_MONTH_PRIVILEGE_TIME_OUT, k)
            end
        end
    end
    if update then
        this.setPrivilegeData(actor, data)
    end
end

---- 特权过期气泡
function this.sendPrivilegeBubbleData(actor)
    local data = this.getPrivilegeBubbleData(actor)
    if table.isEmpty(data) then
        return
    end
    sendluamsg(actor, LuaMessageIdToClient.RES_PRIVILEGE_MONTH_BUBBLE_DATA, data)
end

function this.getPrivilegeBubbleData(actor)
    return getplaydef(actor, this.PRIVILEGE_OVER_TIME_DATA_KEY)
end

function this.setPrivilegeBubbleTime(actor, p_type, time)
    local data = this.getPrivilegeBubbleData(actor)
    if table.isEmpty(data) then
        data = {}
    end
    data[p_type] = time
    setplaydef(actor, this.PRIVILEGE_OVER_TIME_DATA_KEY, data)
end

-- ======================================特权卡使用=======================================
--- 使用特权卡
---@param actor table 角色对象
---@param itemConfigId number 道具配置ID
---@param count number 使用数量
function PrivilegeMonth.usePrivilegeCard(actor, itemConfigId, count)
    local tableValues = ConfigDataManager.getTable("cfg_privilege", "type", PrivilegeCardType.PRIVILEGE_CARD)
    local p_type = 0
    local p_minType = 0;
    local config = {}
    for _, v in pairs(tableValues) do
        if tonumber(v.item) == tonumber(itemConfigId) then
            p_type = tonumber(v.id)
            p_minType = tonumber(v.mintype)
            config = v
            break
        end
    end

    if p_type > 0 then
        local is_activation
        -- 获取特权数据
        local data = this.getPrivilegeData(actor)
        if table.isEmpty(data) then
            data = {}
            is_activation = true
        elseif this.hasPrivilegeType(actor, p_type) then
            is_activation = false
        end

        if p_minType == PrivilegeCardMinType.SILVER then
            p_type = PrivilegeCardId.SILVER1
        elseif p_minType == PrivilegeCardMinType.GOLD then
            p_type = PrivilegeCardId.GOLD1
        elseif p_minType == PrivilegeCardMinType.DIAMOND then
            p_type = PrivilegeCardId.DIAMOND1
        elseif p_minType == PrivilegeCardMinType.RECOVERY then
            local id = ConfigDataManager.getTableValue("cfg_privilege", "id", "mintype", p_minType)
            if string.isNullOrEmpty(id) then
                error("该类型特权卡暂时未实现", p_type, p_minType)
                return
            end
            p_type = tonumber(id)
        else
            local id = ConfigDataManager.getTableValue("cfg_privilege", "id", "mintype", p_minType)
            if string.isNullOrEmpty(id) then
                error("该类型特权卡暂时未实现", p_type, p_minType)
                return
            end
            p_type = tonumber(id)
        end



        ---@type PrivilegeTypeData
        local type_data = data[p_type]
        if table.isEmpty(type_data) then
            type_data = {}
            type_data.id = p_type
            type_data.start_time = 0
            type_data.durationtime = 0
            is_activation = true
        else
            is_activation = false
        end
        local now = tonumber(getbaseinfo("now"))
        if type_data.start_time == 0 then
            type_data.start_time = now
        end

        local configTime = config.time
        if not string.isNullOrEmpty(configTime) then
            configTime = configTime / 60 / 24
            local durationtime = configTime * 24 * count
            type_data.durationtime = type_data.durationtime + durationtime
        else
            type_data.durationtime = -1
        end

        data[p_type] = type_data
        this.setPrivilegeData(actor, data)
        this.debug("激活成功, 特权数据:", data)
        PrivilegeMonth.sendPrivilegeData(actor)

        -- 开启特权功能
        if is_activation then
            -- 白银特权任务
            TaskHandler.TriggerTaskGoal(actor, TaskTargetType.ACTIVATE_SILVER_PRIVILEGE)
        end

        local time = (tonumber(config.time) and tonumber(config.time) * 60 * 1000 or nil)
        local privilegeList = config.privilege
        if not string.isNullOrEmpty(privilegeList) then
            local privilegeIds = string.split(privilegeList, "#")
            for _, privilegeId in ipairs(privilegeIds) do
                Privilege.addPrivilege(actor, tonumber(privilegeId), time, Privilege.Source.PRIVILEGECARD)
            end
        end

        -- 新手特权
        if p_minType == PrivilegeCardMinType.NEW_SILVER then
            local value = ConfigDataManager.getGlobal(GlobalConfigId.SILVER_PRIVILEGE_BUFF)
            if not string.isNullOrEmpty(value) then
                local buffId = string.split(value, "|")[1]
                local condition = string.split(value, "|")[2]
                if ConditionManager.Check(actor, condition) then
                    local buffs = getbuffinfo(actor)
                    if not table.isEmpty(buffs) then
                        for _, buff in pairs(buffs) do
                            local bid = buff.buffcfgid
                            local cfg = ConfigDataManager.getTable("cfg_huanyingdaoshi", "buff", bid, "type", 1)
                            if not table.isEmpty(cfg) then
                                delbuff(actor, bid)
                            end
                        end
                    end
                    buffer(actor, buffId)
                end
            end
        end
    end
end

---是否激活白银特权
function PrivilegeMonth.hasSilverPrivilege(actor)
    if PrivilegeMonth.hasPrivilegeCardType(actor, PrivilegeCardId.SILVER1) or
        PrivilegeMonth.hasPrivilegeCardType(actor, PrivilegeCardId.SILVER2) or
        PrivilegeMonth.hasPrivilegeCardType(actor, PrivilegeCardId.SILVER3) or
        PrivilegeMonth.hasPrivilegeCardType(actor, PrivilegeCardId.SILVER4) then
        return true;
    end
    return false;
end

function PrivilegeMonth.getCardCfgIds()
    local cfgList = ConfigDataManager.getList("cfg_privilege")
    local cfgIds = {}
    if table.isEmpty(cfgList) then
        return cfgIds
    end
    for _, cfg in pairs(cfgList) do
        table.insert(cfgIds, cfg.item)
    end
    return cfgIds
end

---------------------------- 日志打印 -----------------------------
this.log_open = false
function this.debug(...)
    if not this.log_open then
        return
    end
    gameDebug.print(...)
end

function this.jprint(param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 输出内容为空. nil"
    end
    jprint(param)
end

function this.loginfo(actor, param)
    if not this.log_open then
        return
    end
    if param == nil then
        param = "error! 日志输出内容为空. nil"
    end
    jprint(param)
    info(actor, param)
end
