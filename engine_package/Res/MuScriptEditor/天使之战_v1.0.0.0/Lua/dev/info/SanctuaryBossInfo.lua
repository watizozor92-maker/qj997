---@class SanctuaryBossInfo
---@field sanctuaryNpcId number
---@field sanctuaryMapId number
SanctuaryBossInfo = class()
local this = SanctuaryBossInfo

function this:ctor()
end

function this:Reset()
    self.sanctuaryNpcId = nil
    self.sanctuaryMapId = nil
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()

end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_IN_OUT_CROSS_MAP, self.RES_IN_OUT_CROSS_MAP, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_CROSS_MAP_TRANSFER_TO_NPC, self.RES_CROSS_MAP_TRANSFER_TO_NPC, self)
end

----进入跨服地图(如果距离NPC很近打开NPC面板)
---@param message {mapId:number,type:number}
function this:RES_IN_OUT_CROSS_MAP(_, message)
    if self.sanctuaryNpcId and message.type == 1 then
        --local distance = SL:GetMetaValue(EMetaVarGetKey.NPC_DISTANCE)
        --if distance and distance < 2 then
        --    SL:TalkToNpc(self.sanctuaryNpcId)
        --    self.sanctuaryNpcId = nil
        --end
        SL:ScheduleOnce(Time.deltaTime, function()
            GUI:UIPanel_Open("dev/outui/ChallengeBoss/Panel/KLChallengeBossSanctuaryMap/KLChallengeBossSanctuaryMapPanel")
            self.sanctuaryNpcId = nil
        end)
    end
end
----进入跨服地图(如果距离NPC很近打开NPC面板)
---@param message {npc_id:number,map_id:number}
function this:RES_CROSS_MAP_TRANSFER_TO_NPC(_, message)
    local mapId = SL:GetMetaValue(EMetaVarGetKey.MAP_ID)
    if self.sanctuaryNpcId and message.map_id == tostring(mapId) then
        local npcList = SL:GetMetaValue(EMetaVarGetKey.SEE_NPC)
        local npcRoleId = nil
        for k,v in pairs(npcList) do
            if v.data.npcTbl and v.data.npcTbl.id == self.sanctuaryNpcId then
                npcRoleId = v.data.id
                break
            end
        end
        if npcRoleId then
            local distance = SL:GetMetaValue(EMetaVarGetKey.NPC_DISTANCE,npcRoleId)
            if distance and distance < 2 then
                SL:ScheduleOnce(Time.deltaTime, function()
                    SL:TalkToNpc(self.sanctuaryNpcId)
                    self.sanctuaryNpcId = nil
                end)
            end    
        end
    end
end

function this:GetIsSatisfy()
    ---@type cfg_activity_rule_column
    local tab = SL:GetConfig("cfg_activity_rule",25001)
    ---@type cfg_map_info_column
    local mapTab = SL:GetConfig("cfg_map_info",tab.mapid[1])
    self.level_lock = false
    self.strength_lock = false
    self.append_lock = false
    self.open_level = 0
    if mapTab and #mapTab.condition > 0 then
        local condition = mapTab.condition
        local level = condition[1]
        local strength_level = condition[2]
        local append_level = condition[3]
        local player_level = SL:GetMetaValue("LEVEL")
        local all_strength_level = EquipFunc.GetAllStrengthLevel()
        local all_append_level = EquipFunc.GetAllAppendLevel()
        if player_level < level then
            self.level_lock = true
            self.open_level = level
        end
        if all_strength_level < strength_level then
            self.strength_lock = true

        end
        if all_append_level < append_level then
            self.append_lock = true
        end
    end
    if self.level_lock then
        return false, self.open_level .. "级开启，无法进入"
    end
    if self.strength_lock then
        return false, SL:GetConfig('cfg_string', 257).text
    end
    if self.append_lock then
        return false, SL:GetConfig('cfg_string', 257).text
    end
    return true
end
