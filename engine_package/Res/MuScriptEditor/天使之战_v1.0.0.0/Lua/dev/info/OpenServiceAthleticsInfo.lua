---@class OpenServiceAthleticsInfo
OpenServiceAthleticsInfo = class()
local this = OpenServiceAthleticsInfo

function this:ctor()

end

function this:Init()
    self.BossBossRedPoint = false
    self.RewardRedPoint = false
    self.bossFistKillInfo = {}
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_ALL_SERVER_FIRST_KILL_INFO, self.RES_ALL_SERVER_FIRST_KILL_INFO, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECEIVE_FIRST_KILL_ENVELOPE, self.RES_RECEIVE_FIRST_KILL_ENVELOPE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECEIVE_PERSONAL_FIRST_KILL_AWARD, self.RES_RECEIVE_PERSONAL_FIRST_KILL_AWARD, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GOAL_FIRST_KILL_CHANGE, self.RES_GOAL_FIRST_KILL_CHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE,self.LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE,self)
    
end

function this:LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE(_, message)
    self:TryReqMessageOnce()
end

----响应全服首杀和红包数据
----@param message GoldFirstKillProtos.ResponseAllServerFirstKillData
function this:RES_ALL_SERVER_FIRST_KILL_INFO(_, message)
    self.bossFistKillInfo = message
    self:RedDotCheck()
    SL:onLUAEvent(LUA_EVENT_OPENSERVICE_GOLDBOSSKILL_REDPONT_CHANGE)
end

----响应领取全服首杀红包
----@param message GoldFirstKillProtos.ResponseFirstKillRedEnvelope[]
function this:RES_RECEIVE_FIRST_KILL_ENVELOPE(_, message)
    if self.bossFistKillInfo then
        self.bossFistKillInfo.envelope = message
        self:RedDotCheck()
        SL:onLUAEvent(LUA_EVENT_OPENSERVICE_GOLDBOSSKILL_REDPONT_CHANGE,true)
    end
end

----响应领取个人奖励
----@param message GoldFirstKillProtos.ResponsePersonalGoldFirstKillRewardTable[]
function this:RES_RECEIVE_PERSONAL_FIRST_KILL_AWARD(_, message)
    if self.bossFistKillInfo then
        self.bossFistKillInfo.taskInfo = message
        self:RedDotCheck()
        --有奖励变化发ture
        SL:onLUAEvent(LUA_EVENT_OPENSERVICE_GOLDBOSSKILL_REDPONT_CHANGE,true)
    end
end

----黄金首杀任务变化包
----@param message GoldFirstKillProtos.PersonalFirstKillTaskStatusChange[]
function this:RES_GOAL_FIRST_KILL_CHANGE(_, message)
    if self.bossFistKillInfo then
        self.bossFistKillInfo.taskInfo = message
        self:RedDotCheck()
        SL:onLUAEvent(LUA_EVENT_OPENSERVICE_GOLDBOSSKILL_REDPONT_CHANGE)
    end
end

----@param data GoldFirstKillProtos.ResponseAllServerFirstKillData
function this:RedDotCheck()
    self.BossBossRedPoint = false
    ---@type sub_mainActivity_column
    local tabRankingConfig = SL:GetConfig("sub_mainActivity", 1)
    local isShow = tabRankingConfig.showCondition == "" or ConditionManager.Check4D(tabRankingConfig.showCondition)
    if isShow then
        if not table.isNullOrEmpty(self.bossFistKillInfo) and self.bossFistKillInfo.allServerData ~= nil and self.bossFistKillInfo.taskInfo ~= nil then
            for monsterId, v in pairs(self.bossFistKillInfo.allServerData) do
                if ((not self.bossFistKillInfo.envelope[monsterId]
                        or self.bossFistKillInfo.envelope[monsterId] == false))
                        or self.bossFistKillInfo.taskInfo[monsterId] == "2" then
                    self.BossBossRedPoint = true
                    break
                end
            end
            for monsterId, v in pairs(self.bossFistKillInfo.taskInfo) do
                if v == "2" then
                    self.BossBossRedPoint = true
                    break
                end
            end
        end
    end
    InfoManager.mainActivityInfo:RefreshMainActivityRedPoint("tog_FirstKill",self.BossBossRedPoint)
end

function this:TryReqMessageOnce()
    -- if not self.isReqMsg then
    --     self.isReqMsg = true
    --     SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_ALL_SERVER_FIRST_KILL_INFO)
    -- end
end

function this:GetDiffTime()
    local isbeforerefresh, differenceTime = self:GetServerOpendifferenceTime()

    local serverTime = Time.GetServerTime()
    local outTimeTbl = ConditionManager.GetConditionParams(tabRankingConfig.showCondition)
    local endTime = (tonumber(outTimeTbl[2]) - 1) * 86400000 + SL:GetEnterRoleRes().openServerTime
    local diff = endTime - serverTime - differenceTime * 1000
    if isbeforerefresh then
        diff = endTime - serverTime + differenceTime * 1000
    end
    return diff
end

function this:GetServerOpendifferenceTime()
    if SL:GetEnterRoleRes() == nil then
        return -1
    end
    local openTime = Time.FormatTimeYMDHMS(SL:GetEnterRoleRes().openServerTime / 1000)
    local hour = tonumber(string.sub(openTime, 12, 13))
    local minute = tonumber(string.sub(openTime, 15, 16))
    local second = tonumber(string.sub(openTime, 18, 19))
    local differenceTime = 0  --刷新差值
    local refreshTime = 5  --刷新时间5点改为0点
    local isbeforerefresh = hour < refreshTime
    differenceTime = hour * 3600 + minute * 60 + second
    return isbeforerefresh, differenceTime
end

function this:Reset()
    self.isReqMsg = nil
end