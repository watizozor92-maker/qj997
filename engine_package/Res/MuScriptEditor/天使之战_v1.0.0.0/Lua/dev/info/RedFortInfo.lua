---@class RedFortInfo
---@field cfgTabel cfg_rep_column[]
---@field activityId number @活动id
---@field activityCfg cfg_activity_rule_column @活动表
---@field nowRedFortCfg cfg_rep_column @最后一次获取的表数据（防止在副本中升级先存起来）
---@field cfg_repRedfortress cfg_repRedfortress_column @跟服务器相关的赤色要塞表数据
---@field isEnter boolean @是否进入副本
RedFortInfo = class()
local this = RedFortInfo

function this:ctor()

end

function this:Init()
    self.activityId = EActivityType.RedFort
    self.cfgTabel = {}
    ---@ type cfg_rep_column[]
    local repTable = SL:GetConfigTable("cfg_rep")
    for k, v in pairs(repTable) do
        if v.type == self.activityId then
            table.insert(self.cfgTabel, v)
        end
    end
    self:InitData()
    self:RegistMessages()
    self.activityCfg = SL:GetConfigMultiKeys("cfg_activity_rule", self.activityId , "id")
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RED_FORTRESS_PREPARE_COUNT, self.RES_RED_FORTRESS_PREPARE_COUNT, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RED_FORTRESS_TASK_INFO, self.RES_RED_FORTRESS_TASK_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RED_FORTRESS_SHRINKING_STAGE, self.RES_RED_FORTRESS_SHRINKING_STAGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RED_FORTRESS_SETTLEMENT_PANEL, self.RES_RED_FORTRESS_SETTLEMENT_PANEL, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE, self.RES_QUIT_DUPLICATE, self)
    
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_REVIVE, self.ResReliveMessage, self)
    
    SL:RegisterLUAEvent(LUA_EVENT_MAIN_PLAYER_DIE,self.LUA_EVENT_MAIN_PLAYER_DIE,self)
    
end

---赤色要塞缩圈数据
function this:RES_RED_FORTRESS_SHRINKING_STAGE(_, message)
    
end

----赤色要塞阶段
----@param message table @1：阶段 2 结束时间 3 活动id
function this:GET_RES_RED_FORTRESS_STATE_UPDATE()
    return self.RES_RED_FORTRESS_STATE_UPDATE_message 
end
----赤色要塞阶段
----@param message table @1：阶段 2 结束时间 3 活动id
function this:CLEAR_RES_RED_FORTRESS_STATE_UPDATE()
    self.RES_RED_FORTRESS_STATE_UPDATE_MESSAGE = nil
end

---赤色要塞准备阶段人数
function this:RES_RED_FORTRESS_PREPARE_COUNT(_, message)
    self.RES_RED_FORTRESS_PREPARE_COUNT_MESSAGE = message
end

---赤色要塞准备阶段人数
function this:GET_RES_RED_FORTRESS_PREPARE_COUNT(_, message)
    return self.RES_RED_FORTRESS_PREPARE_COUNT_MESSAGE
end
---赤色要塞准备阶段人数
function this:CLEAR_RES_RED_FORTRESS_PREPARE_COUNT(_, message)
    self.RES_RED_FORTRESS_PREPARE_COUNT_MESSAGE = nil
end

---赤色要塞任务面板信息
function this:RES_RED_FORTRESS_TASK_INFO(_, message)

end
---赤色要塞结算
function this:RES_RED_FORTRESS_SETTLEMENT_PANEL(_, message)
    GUI:UIPanel_Open("dev/outui/Activity/Panel/KLRedFortSettlement/KLRedFortSettlementPanel",nil,nil,message)
end

---退出赤色要塞
function this:RES_QUIT_DUPLICATE()
    local isDie = SL:GetMetaValue(EMetaVarGetKey.USER_IS_DIE)
    if isDie then
        SL:ShowMainPanel()
    end
    self.isEnter = false
end

function this:LUA_EVENT_MAIN_PLAYER_DIE()
    SL:HideMainPanel()
end

---通知玩家复活
function this:ResReliveMessage()
    SL:ShowMainPanel()
end


---@return cfg_rep_column
function this:GetCfgByLevel()
    self.nowRedFortCfg = nil
    local myLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    for k, v in pairs(self.cfgTabel) do
        if myLevel >= v.level[1] and (not self.nowRedFortCfg or self.nowRedFortCfg.level[1] < v.level[1]) then
            self.nowRedFortCfg = v
        end
    end
    if  self.nowRedFortCfg then
        self.cfg_repRedfortress =  SL:GetConfigMultiKeys("cfg_repRedfortress", self.nowRedFortCfg.id, "id")
    end
    return self.nowRedFortCfg
end

-----@return cfg_rep_column
function this:GetCfgByMinLevel()
    local minLevel = 0
    local minCfg = nil
    for k, v in pairs(self.cfgTabel) do
        if minLevel <= v.level[1] then
            minCfg = v
        end
    end
    return minCfg
end

function this:Reset()

end