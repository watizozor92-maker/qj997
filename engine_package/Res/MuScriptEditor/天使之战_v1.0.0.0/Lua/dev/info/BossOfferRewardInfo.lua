---@class BossOfferRewardInfo
BossOfferRewardInfo = class()
local this = BossOfferRewardInfo
E_MonsterShowState = {
    Go = enum(0),
    CanReceive = enum(1),
    HadReceive = enum(2)
}
E_LevelRewardState = {
    NotCanReceive = enum(0),
    CanReceive = enum(1),
    HadReceive = enum(2)
}
function this:ctor()

end

function this:Reset()
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.RES_BOSS_BOUNTY_DATA)
    SL:UnRegisterLuaNetMsg(LuaMessageIdToClient.BOSS_BOUNTY_CHANGE)
    SL:UnRegisterLUAEvent(LUA_EVENT_ROLE_LOGIN)
    self.monsterInfo = nil
    self.groupIdInfo = nil
end

function this:Init()
    self.monsterInfo = {}
    self.groupIdInfo = {}
    self:RegistMessages()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_BOSS_BOUNTY_DATA,self.RES_BOSS_BOUNTY_DATA,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.BOSS_BOUNTY_CHANGE,self.BOSS_BOUNTY_CHANGE,self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_LOGIN,self.EnterGame,self)
    
end

function this:EnterGame()
    --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BOSS_BOUNTY_DATA)
end

---响应boss悬赏数据
---@param message {group:number[],monster:table<string,number>}
function this:RES_BOSS_BOUNTY_DATA(_,message)
    self.monsterInfo = message.monster or {}
    self.groupIdInfo = message.group or {}
    SL:RefreshPanelALLRedPoint("KLUISystemTopPanel")
    SL:onLUAEvent(LUA_EVENT_BOSS_OFFER_CHANGE)
end

---响应boss悬赏数据变化
---@param message {monsterId:number,status:number}
function this:BOSS_BOUNTY_CHANGE(_,message)
    if not self.monsterInfo then
        self.monsterInfo = {}
    end
    self.monsterInfo[tostring(message.monsterId)] = message.status
    SL:RefreshPanelALLRedPoint("KLUISystemTopPanel")
    SL:onLUAEvent(LUA_EVENT_BOSS_OFFER_CHANGE)
end

---@return number
function this:GetMonsterStateByMonserId(monserId)
    monserId = tostring(monserId)
    if not self.monsterInfo then
        self.monsterInfo = {}
    end
    if not self.monsterInfo[monserId] then
        return E_MonsterShowState.Go
    end
    return self.monsterInfo[monserId]
end

function this:GetLevelRewardState(level)
    local groupID = cfg_newarea_offerreward_post.GetGroupIdByLevel(level)
    if not self.groupIdInfo then
        self.groupIdInfo = {}
    end
    if table.contains(self.groupIdInfo,groupID) then
        return E_LevelRewardState.HadReceive
    end
    local levelMonsterInfo = cfg_newarea_offerreward_post.GetLevelMonsterInfo(level)
    for i, v in pairs(levelMonsterInfo) do
        if self:GetMonsterStateByMonserId(v.monsterId) == E_MonsterShowState.Go then
            return E_LevelRewardState.NotCanReceive
        end
    end
    return E_LevelRewardState.CanReceive
end

function this:GetCanShowLevel()
    local allLevel = cfg_newarea_offerreward_post.GetLevelInfo()
    local canShowLevel = {}
    local playerLevel = SL:GetMetaValue(EMetaVarGetKey.LEVEL)
    for i, level in ipairs(allLevel) do
        if level <= playerLevel then
            table.insert(canShowLevel,level)
        else
            table.insert(canShowLevel,level)
            break
        end
    end
    return canShowLevel
end

function this:IsHasBossOfferReward()
    local allLevel = cfg_newarea_offerreward_post.GetLevelInfo()
    for i, level in ipairs(allLevel) do
        local levelMonsterInfo = cfg_newarea_offerreward_post.GetLevelMonsterInfo(level)
        for i, v in pairs(levelMonsterInfo) do
            if self:GetMonsterStateByMonserId(v.monsterId) == E_MonsterShowState.CanReceive then
                return true
            end
        end
        if self:GetLevelRewardState(level) == E_LevelRewardState.CanReceive then
            return true
        end
    end
    return false
end

---某一个等级标签是否有可领取的物品
function this:IsHasRewardInOneLevel(level)
    local levelMonsterInfo = cfg_newarea_offerreward_post.GetLevelMonsterInfo(level)
    for i, v in pairs(levelMonsterInfo) do
        if self:GetMonsterStateByMonserId(v.monsterId) == E_MonsterShowState.CanReceive then
            return true
        end
    end
    local state = self:GetLevelRewardState(level)
    if state == E_LevelRewardState.CanReceive then
        return true
    end
    return false
end

