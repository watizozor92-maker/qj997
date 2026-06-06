---@class GodsDescendInfo @注释
---@field godsDescendData {id:number, cfgid:number, name:string, state:number, ownerid:number, ownername:string}[]
GodsDescendInfo = class()
local this = GodsDescendInfo

function this:ctor()

end

function this:Init()
    this.godsDescendData = {}
    this.deadStates = {}
    self:RegistMessages()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GODS_DESCENDED_DATA , self.RES_GODS_DESCENDED_DATA)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GODS_DESCENDED_MONSTER_STATE_CHANGE  , self.RES_GODS_DESCENDED_MONSTER_STATE_CHANGE)
end

---@param message {monsterdata:table}
function this.RES_GODS_DESCENDED_DATA(id, message)
    table.clear(this.godsDescendData)
    table.clear(this.deadStates)
    for mapId, v in pairs(message.monsterdata) do
        if not this.godsDescendData[mapId] then
            this.godsDescendData[mapId] = {}
        end
        if not this.deadStates[mapId] then
            this.deadStates[mapId] = {}
        end
        for k, value in pairs(v) do
            if not this.godsDescendData[mapId][k] then
                this.godsDescendData[mapId][k] = {}
            end
            ---@param data {id:number, cfgid:number, name:string, state:number, ownerid:number, ownername:string}
            for _, data in pairs(value) do
                this.godsDescendData[mapId][k][data.id] = data
                this.deadStates[mapId][data.id] = data.state
            end
        end
    end
    SL:onLUAEvent(LUA_EVENT_GODSDESCEND_DATA_CHANGE)
    SL:RefreshPanelALLRedStateKmlByCondition("checkGodDescentMonster")
end

---@param message {id:number, mapid:number, cfgid:number, name:string, state:number, ownerid:number, ownername:string}[]
function this.RES_GODS_DESCENDED_MONSTER_STATE_CHANGE(id, message)
    for mapId, v in pairs(message) do
        if not this.godsDescendData[mapId] then
            this.godsDescendData[mapId] = {}
        end
        if not this.deadStates[mapId] then
            this.deadStates[mapId] = {}
        end
        if not this.godsDescendData[mapId][v.cfgid] then
            this.godsDescendData[mapId][v.cfgid] = {}
        end
        this.godsDescendData[mapId][v.cfgid][v.id] = v
        this.deadStates[mapId][v.id] = v.state
    end
    SL:onLUAEvent(LUA_EVENT_GODSDESCEND_DATA_CHANGE, message)
    SL:RefreshPanelALLRedStateKmlByCondition("checkGodDescentMonster")
end

---@return {id:number, cfgid:number, name:string, state:number, ownerid:number, ownername:string}[]
function this.GetMonsterInfosByCfgId(cfgId)
    cfgId = tostring(cfgId)
    local res = {}
    for mapId, v in pairs(this.godsDescendData) do
        if v[cfgId] then
            for _, data in pairs(v[cfgId]) do
                table.insert(res, data)
            end
        end
    end
    return res
end

---@return {id:number, cfgid:number, name:string, state:number, ownerid:number, ownername:string}
function this.GetMonsterInfosById(cfgId, id)
    for mapId, v in pairs(this.godsDescendData) do
        if v[cfgId] and v[cfgId][id] then
            return v[cfgId][id]
        end
    end
    return nil
end

--获取是否有怪物存活（红点状态）
function this.GetRedState()
    local red = false
    for _, v in pairs(this.deadStates) do
        for k, data in pairs(v) do
            if data ~= 2 then
                red = true
                break
            end
        end
    end
    return red
end

function this.CheckActivityCondition(id)
    local message = ""
    ---@type cfg_activity_rule_column
--     local tbl = SL:GetConfig("cfg_activity_rule", id)
--     if tbl.condition and tbl.condition[1] then
--         local condition = tbl.condition[1]
--         local level = condition[1]
--         local strength_level = condition[2]
--         local append_level = condition[3]
--         local player_level = SL:GetMetaValue("LEVEL")
--         local all_strength_level = EquipFunc.GetAllStrengthLevel()
--         local all_append_level = EquipFunc.GetAllAppendLevel()
--         if player_level < level then
--             message = level.."级开启，无法进入"
--             return false, message
--         end
--         if all_strength_level < strength_level then
--             return false,  SL:GetConfig('cfg_string',257).text
--         end
--         if all_append_level < append_level then
--             return false, SL:GetConfig('cfg_string',257).text
--         end
-- --[[        if not this.IsHavePrivilege() then
--             return false, SL:GetConfig('cfg_string',258).text
--         end]]
--     end
    return true, message
end

function this.CheckActivityConditionMapId(id)
    local message = ""
    ---@type cfg_activity_rule_column
    local mapid = SL:GetConfig("cfg_activity_rule",id).mapid[1]
    local tbl = SL:GetConfig("cfg_map_info",mapid)
    if tbl.condition and #tbl.condition > 0 then
        local condition = tbl.condition
        local level = condition[1]
        local strength_level = condition[2]
        local append_level = condition[3]
        local player_level = SL:GetMetaValue("LEVEL")
        local all_strength_level = EquipFunc.GetAllStrengthLevel()
        local all_append_level = EquipFunc.GetAllAppendLevel()
        if player_level < level then
            message = level.."级开启，无法进入"
            return false, message
        end
        if all_strength_level < strength_level then
            return false,  SL:GetConfig('cfg_string',257).text
        end
        if all_append_level < append_level then
            return false, SL:GetConfig('cfg_string',257).text
        end
--[[        if not this.IsHavePrivilege() then
            return false, SL:GetConfig('cfg_string',258).text
        end]]
    end
    return true, message
end

function this.IsHavePrivilege()
    if InfoManager.monthCardInfo.IsGetMonthCard or InfoManager.monthCardInfo.IsGetDailyCard then
        --有月卡或是日卡
        return true
    end
    return false
end


function this:Reset()
    this.godsDescendData = {}
    this.deadStates = {}
end
