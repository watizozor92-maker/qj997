---@class WolfSoulFortressInfo
---@field cfgTabel cfg_rep_column[]
---@field activityId number @活动id
---@field activityCfg cfg_activity_rule_column @活动表
---@field nowWolfSoulFortressCfg cfg_rep_column @最后一次获取的表数据（防止在副本中升级先存起来）
---@field nowWolfSoulCfg cfg_wolf_soul_column @最后一次获取的表数据（防止在副本中升级先存起来）
---@field wolf_soulTable cfg_wolf_soul_column[] @狼魂要塞相关参数表
---@field nextStateTime number @阶段时间
---@field nextStateTime_2 number @结束时间
---@field summonCount number @召唤了几个守护
---@field rankInfos  {success:boolean,list:{score:number,career:number,level:number,name:string,rank:number,rid:string}[]}
---@field isEnter boolean @是否进入副本
---@field success boolean @是否守护成功
WolfSoulFortressInfo = class()
local this = WolfSoulFortressInfo

function this:ctor()

end

function this:Init()
    self.activityId = EActivityType.WolfSoulFortress
    self.cfgTabel = {}
    self.wolf_soulTable = {}
    ---@ type cfg_rep_column[]
    local repTable = SL:GetConfigTable("cfg_rep")
    ---@ type cfg_wolf_soul_column[]
    local tempWolfTable = SL:GetConfigTable("cfg_wolf_soul")
    for k, v in pairs(repTable) do
        if v.type == self.activityId then
            self.cfgTabel[v.id] = v
        end
    end
    for k, v in pairs(tempWolfTable) do
        self.wolf_soulTable[v.id] = v
    end
    self.summonCount = 0
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WOLF_SOUL_STATE, self.RES_WOLF_SOUL_STATE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WOLF_SOUL_FIGHT_PANEL, self.RES_WOLF_SOUL_FIGHT_PANEL, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WOLF_SOUL_PREPARE_PANEL, self.RES_WOLF_SOUL_PREPARE_PANEL, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WOLF_SOUL_SETTLEMENT_PANEL, self.RES_WOLF_SOUL_SETTLEMENT_PANEL, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_QUIT_DUPLICATE, self.RES_QUIT_DUPLICATE, self)
end

---@param message {success:boolean,list:{score:number,career:number,level:number,name:string,rank:number,rid:string}[]}
function this:RES_WOLF_SOUL_SETTLEMENT_PANEL(_,message)
    self.rankInfos = message
    self.success = message.success
    GUI:UIPanel_Open("dev/outui/Activity/Panel/KLWolfSoulFortressScore/KLWolfSoulFortressScorePanel",nil,nil,message)
end

---@param message {"1":雕像HP万分比, "2":积分,"3":排名 , "4":下一波时间}
function this:RES_WOLF_SOUL_FIGHT_PANEL(_, message)

end

---@param message {"1":副本id, "2":哪个阶段,"3":下个阶段的时间}
function this:RES_WOLF_SOUL_STATE(_, message)
    local id = message["1"]
    self.nowWolfSoulFortressCfg = self.cfgTabel[id]
    self.nowWolfSoulCfg = self.wolf_soulTable[id]
    self.state = message["2"]
    self.nextStateTime = message["3"]
    self.nextStateTime_2 = 0
    self.isEnter = true
    if self.state ~= 1 then 
        self.nextStateTime_2 = message["3"]
    end
end

---@param message {"1":召唤数量}
function this:RES_WOLF_SOUL_PREPARE_PANEL(_, message)
    self.summonCount = message["1"]
    SL:onLUAEvent(LUA_EVENT_WOLFSOULFORTRESS_UPDATE_SUMMON_INFO)
end

function this:RES_QUIT_DUPLICATE(_, message)
    GUI:UIPanel_Close("dev/outui/Activity/Panel/KLWolfSoulFortressTask/KLWolfSoulFortressTaskPanel")
end

---@return cfg_rep_column
function this:GetCfgByOpenServerDay()
    local openServerDay = SL:GetOpenServerDay()
    for k, v in pairs(self.cfgTabel) do
        local minDay = self.wolf_soulTable[k].numberDay[1]
        local maxDay = self.wolf_soulTable[k].numberDay[2]
        if openServerDay >= minDay and openServerDay <= maxDay then
            self.nowWolfSoulFortressCfg = v
            self.nowWolfSoulCfg = self.wolf_soulTable[k]
        end
    end
    return self.nowWolfSoulFortressCfg
end

function this:GetNowRankReward(rank)
    if not self.nowWolfSoulCfg then
        return
    end
    local temp = {}
    local rewardCfg = {}
    if self.success then
        rewardCfg = self.nowWolfSoulCfg.victoryReward
    else
        rewardCfg = self.nowWolfSoulCfg.defeatReward
    end
    ---名次上限#名次上限#道具id#道具数量#道具id#道具数量|
    for k, v in pairs(rewardCfg) do
        local rankUp = v[1]
        local rankDown = v[2]
        if rank >= rankUp and rank <= rankDown then
            temp = v
            break
        end
    end
    local reward = {}
    for i = 3, #temp, 2 do
        local itemId = temp[i]
        local itemCount = temp[i + 1]
        table.insert(reward, { itemId = itemId, itemCount = itemCount })
    end
    return reward
end

function this:Reset()

end