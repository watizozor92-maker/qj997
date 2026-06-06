---@class CopActivityInfo
CopActivityInfo = class()
local this = CopActivityInfo

function this:ctor()

end

function this:Reset()
    self:ClearCopyData()
end

function this:ClearCopyData()
    self:ClearDevilMessage()
    self:ClearDevilWaveMessage()
    self:ClearBloodMessage()
    self:ClearBloodFightMessage()
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    this.bloodTaskState = 0
    this.pickUpWeaponRid = 0
    this.hideTask = false
    this.hideTeam = false
    ---@type cfg_repTask_column[]
    local tblList = SL:GetConfigTable("cfg_repTask")
    ---@param v cfg_repTask_column
    for i, v in pairs(tblList) do
        if v.type == 3 then
            this.bloodNpcId = v.param[2]
            break
        end
    end
    this.isShowCrossServerTrade = true
    this.ShowSettlementPanelArgs = nil
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DEVIL_SQUARE_SETTLEMENT,self.RES_DEVIL_SQUARE_SETTLEMENT)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BLOODY_CASTLE_SETTLEMENT ,self.RES_BLOODY_CASTLE_SETTLEMENT)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.BLOODY_CASTLE_SWORD_VIEW ,self.BLOODY_CASTLE_SWORD_VIEW)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE,self.RES_QUIT_SUCCESS)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DUPLICATE_TEAM_INFO,self.RES_DUPLICATE_TEAM_INFO)
    
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.KALIMA_TEMP_PANEL_INFO, self.ACTIVITY_REWARD_PANEL, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.BRAVE_TEST_REWARD, self.ACTIVITY_REWARD_PANEL, self)
    
    SL:RegisterLUAEvent(LUA_EVENT_NPC_CREATE,self.LUA_EVENT_NPC_CREATE)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.DEVIL_SQUARE_STATE,self.DEVIL_SQUARE_STATE,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DEVIL_SQUARE_TASK,self.RefreshFightStage,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BLOODY_CASTLE_STATE_UPDATE,self.RES_BLOODY_CASTLE_STATE_UPDATE,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BLOODY_CASTLE_TASK_UPDATE ,self.RefreshBloodFightStage,self)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_DUPLICATE_TEAM_INFO ,self.RES_DUPLICATE_TEAM_INFO,self)
end

function this.RES_DEVIL_SQUARE_SETTLEMENT(id,message)
    this.ShowSettlementPanelArgs = message
    GUI:UIPanel_Open("dev/outui/Activity/Panel/KLSettlement/KLSettlementPanel",nil,nil,message)
end

function this.RES_BLOODY_CASTLE_SETTLEMENT(id,message)
    this.ShowSettlementPanelArgs = message
    GUI:UIPanel_Open("dev/outui/Activity/Panel/KLSettlement/KLSettlementPanel",nil,nil,message)
end

--恶魔广场状态
function this:DEVIL_SQUARE_STATE(id,message)
    self.devilMessage = message
end
function this:CheckDevilMessage()
    return self.devilMessage
end
function this:ClearDevilMessage()
    self.devilMessage = nil
end
--恶魔广场战斗数据
function this:RefreshFightStage(id,message)
    self.devilWaveMessage = message
end
function this:GetDevilWaveMessage()
    return self.devilWaveMessage
end
function this:ClearDevilWaveMessage()
    self.devilWaveMessage = nil
end
--血色城堡状态
function this:RES_BLOODY_CASTLE_STATE_UPDATE(id, message)
    self.bloodyCastleMessage = message
end
function this:GetBloodMessage()
    return self.bloodyCastleMessage
end
function this:ClearBloodMessage()
    self.bloodyCastleMessage = nil
end
--血色城堡战斗数据
function this:RefreshBloodFightStage(id, message)
    self.bloodFightMessage = message
end
function this:GetBloodFightMessage()
    return self.bloodFightMessage
end
function this:ClearBloodFightMessage()
    self.bloodFightMessage = nil
end

function this.BLOODY_CASTLE_SWORD_VIEW(id,message)
    local rid = tonumber(message["1"])
    local itemCfg = tonumber(message["2"])
    if not rid then
        rid = tonumber(message[1])
        itemCfg = tonumber(message[2])
    end
    SL:AttachActivityWeapon(rid,itemCfg)
    this.pickUpWeaponRid = rid
end

function this.LUA_EVENT_NPC_CREATE(_, data)
    if this.bloodNpcId == data.npcId then
        if this.bloodTaskState == 0 then
            SL:SetNpcIcon(data.npcId, "task_progress")
        elseif this.bloodTaskState > 0 then
            SL:SetNpcIcon(data.npcId, "task_finish")
        end
    end
end

function this.RES_QUIT_SUCCESS()
    this.bloodTaskState = 0
    this.pickUpWeaponRid = 0
    SL:SetMetaValue(EMetaVarSetKey.SET_ISNOTCHANGEPKMODE, false)
end 

function this.RES_DUPLICATE_TEAM_INFO(id,message)
    ---@type KLCopyTeamPanel
    -- local panel = GUI:GetUI("dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanel")
    -- if not panel then
    --     GUI:UIPanel_Open("dev/outui/Activity/Panel/KLCopyTeam/KLCopyTeamPanel",nil,nil,message)
    -- end

    local panel = GUI:GetUI("dev/outui/Activity/Panel/KLTeamCopyStatus/KLTeamCopyStatusPanel")
    if not panel then
        GUI:UIPanel_Open("dev/outui/Activity/Panel/KLTeamCopyStatus/KLTeamCopyStatusPanel",nil,nil,message)
    end
end

function this:ACTIVITY_REWARD_PANEL(_, message)
    local reward = {}
    for i, v in pairs(message) do
        reward[tonumber(i)] = tonumber(v)
    end
    ---延时调用，要不会被地图切换关闭所有界面关掉
    SL:ScheduleOnce(0.1, function()
        SL:OpenRewardTips(reward,0)
    end)
end


-- function this:RES_DUPLICATE_TEAM_INFO(_, message)
--     SL:LogTable(message,true)
-- end