---@class UILuckyTurnTableSecondInfo
UILuckyTurnTableSecondInfo = class()
local this = UILuckyTurnTableSecondInfo

function this:Init()
    self:RegistMessages()
    self:Reset()
end
function this:Reset()
    self.IsSkip = false
    self.IsFree = false
    self.IsCanReceived = false
    self.BtnRedDotList = {}
    self.turntableRaffleActiveList = {}
end

function this:RegistMessages()

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WEEK_TURNTABLE_RAFFLE_FREE_TIME, self.RES_TURNTABLE_RAFFLE_FREE_TIME, self)-- 响应抽奖免费时间
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WEEKEN_GIFT, self.RES_MAIN_ACTIVE_INFO, self)-- 响应抽奖
    SL:RegisterLUAEvent(LUA_EVENT_MAINOPERATEACTIVITY_SECOND_CHANGE, self.RefreshRedDotShow, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_COMMON_RED_POINT_MESSAGE, self.CommonRedPointMessage, self)
    
    
end

function this:CommonRedPointMessage(_, message)
    for k, v in pairs(message) do
        local redPointId = tonumber(k)
        if redPointId==110 then
            self.IsFree = v
            InfoManager.mainOperateActivitySecondInfo:RefreshMainOperateActivityRedPoint( EOperateActivityActivityType.luckyTurnTable,"tog_lottery", self:IsRedDot())
            --SL:RefreshPanelALLRedStateKmlByCondition("checkLuckyTurnTable")
        end
        if redPointId==111 then
            InfoManager.mainOperateActivitySecondInfo:RefreshMainOperateActivityRedPoint( EOperateActivityActivityType.luckyTurnTable,"tog_lottery", self:IsRedDot())
            --SL:RefreshPanelALLRedStateKmlByCondition("checkLuckyTurnTable")
        end
    end
end
function this:RefreshRedDotShow()
    if next(self.turntableRaffleActiveList) then
        for id, v in pairs(self.turntableRaffleActiveList) do
            InfoManager.mainOperateActivitySecondInfo:RefreshMainOperateActivityRedPoint( EOperateActivityActivityType.luckyTurnTable,"tog_lottery", self:IsBtnRedDot(id))
        end
    end
end

function this:RES_MAIN_ACTIVE_INFO(_, message)
    -----面板信息
    if message and message.turntableRaffleActive then
        self.IsCanReceived = false
        self.turntableRaffleActiveList = message.turntableRaffleActive
        for id, v in pairs(self.turntableRaffleActiveList) do
            local totalCount = v.total--抽奖总次数
            self.IsFree = v.canFree--可否免费抽奖
            local received = v.received--已经领取过的奖励id cfg_turntable_extra表id

            local curTurnTbl = self:GetTurnTableDataByActivityId(message.mainActive.mainGroup)
            local CountRewardTbl = self:GetTurnTableAwardListByActivityId(curTurnTbl.id)
            if self.IsFree == true then
                self.BtnRedDotList[id] = self.IsFree
            else
                self.BtnRedDotList[id] = false
            end
            for _, reward in pairs(CountRewardTbl) do
                if totalCount > reward.num then
                    if not self:IsGetReceived(reward.id, received) then
                        self.BtnRedDotList[id] = true
                        self.IsCanReceived = true
                    end
                end
            end
        end
        self:RefreshRedDotShow()
        --SL:RefreshPanelALLRedStateKmlByCondition("checkLuckyTurnTable")
    end
end
---@field id number @cfg_turntable表id
function this:IsGetReceived(id, received)
    for _, v in pairs(received) do
        if id == v then
            return true
        end
    end
    return false
end
function this:RES_TURNTABLE_RAFFLE_FREE_TIME(_, message)
    if message then
        self.IsFree = message.isFree
        self:RefreshRedDotShow()
        --SL:RefreshPanelALLRedStateKmlByCondition("checkLuckyTurnTable")
    end
end
---@field btnId number @cfg_turntable表id
function this:IsBtnRedDot(btnId)
    return self.BtnRedDotList[btnId]
end
function this:IsRedDot()
    return self.IsFree or self.IsCanReceived
end
---获取某id活动转盘表id  暂时唯一
---@field group number @cfg_turntable表mainGroup
function this:GetTurnTableDataByActivityId(group)
    local turnTbl = SL:GetConfigTable("cfg_turntable")
    for _, v in pairs(turnTbl) do
        if v.mainGroup == tonumber(group) then
            return v
        end
    end
    return nil
end
---获取某id活动转盘表id  暂时唯一
---@field group number @cfg_turntable表mainGroup
function this:GetTurnTableDataByActivityIdAndType(group,type)
    local turnTbl = SL:GetConfigTable("cfg_turntable_reward")
    for _, v in pairs(turnTbl) do
        if v.group == tonumber(group) and v.type == type then
            return v
        end
    end
    return nil
end
---获取轮盘大奖主表id
function this:GetTurnTableBigListByActivityId(relevance)
    local bigList = {}
    local turnTbl = SL:GetConfigTable("cfg_turntable_extra")
    for _, v in pairs(turnTbl) do
        if v.bigReward == 1 and tonumber(relevance) == v.relevance then
            table.insert(bigList, v)
        end
    end
    return bigList

end
---获取轮盘奖主表id
function this:GetTurnTableAwardListByActivityId(relevance)
    local List = {}
    local turnTbl = SL:GetConfigTable("cfg_turntable_extra")
    for _, v in pairs(turnTbl) do
        if tonumber(relevance) == v.relevance then
            table.insert(List, v)
        end
    end
    return List
end


