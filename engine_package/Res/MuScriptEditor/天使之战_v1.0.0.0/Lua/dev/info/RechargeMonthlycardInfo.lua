---@class RechargeMonthlycardInfo
RechargeMonthlycardInfo = class()
local this = RechargeMonthlycardInfo
UIMonthCard = {
    WhiteAndGoldCardID = 0,
    WhiteCardID = 1,
    GoldCardID = 2,
}
function this:ctor()

end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.cfgListAll = SL:GetConfigTable("cfg_MonthlyPack")
    self.normalCfg = self:FindCfgInfo(self.cfgListAll, UIMonthCard.WhiteCardID)
    self.goldCfg = self:FindCfgInfo(self.cfgListAll, UIMonthCard.GoldCardID)
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_ACTION, self.RES_RECHARGE_ACTION, self)
    SL:RegisterLUAEvent(LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE,self.LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE,self)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE,self.LUA_EVENT_LEVELCHANGE,self)
end

function this:LUA_EVENT_ENTRY_MAP_LOADING_PANEL_CLOSE(_, message)
   -- self:TryReqMessageOnce()
end

function this:LUA_EVENT_LEVELCHANGE(_, message)
    self:RedDotCheck()
end

function this:RES_RECHARGE_ACTION(_, message)
    self.message = message
    if message.type ~= tostring(ERechargeType.MonthCardGift) then
        return
    end
    self:RedDotCheck()
end

function this:RedDotCheck()
    if not self.message then
        return
    end
    self.RedPointState = false
    local tabRankingConfig = SL:GetConfig("sub_mainRecharge", 2)
    local outLevelTbl = ConditionManager.GetConditionParams(tabRankingConfig.showCondition)
    if SL:GetMetaValue(EMetaVarGetKey.LEVEL) < outLevelTbl[1] then
        InfoManager.mainRechargeInfo:RefreshMainRechargeRedPoint("tog_BtnMonthCard",self.RedPointState)
        return 
    end
    ---是否已查看过红点 true 为已查看
    local isHadLook = SL:GetLocalString(SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID) .. "_RechargeMonthlycard" ,"false")
    if isHadLook == "true" then
        local normalKey = tostring(self.normalCfg.id)
        local goldKey = tostring(self.goldCfg.id)
        self.messageTab = {}
        local whihtEndTime = 0
        local goldEndTime = 0
        local month_data = self.message.data.month_data
        local daily_data = self.message.data.daily_data
        local whiteReceive, goldReceive = true
        if month_data and month_data[normalKey] then
            whihtEndTime = month_data[normalKey] + 86400000 * 30
        end
        if month_data and month_data[goldKey] then
            goldEndTime = month_data[goldKey] + 86400000 * 30
        end
        --- receive 为true可领取
        if daily_data then
            whiteReceive = not table.contains(daily_data, normalKey)
            goldReceive = not table.contains(daily_data, goldKey)
        else
            whiteReceive = true
            goldReceive = true
        end
        
        self.messageTab[UIMonthCard.WhiteCardID] = { endTime = whihtEndTime, receive = whiteReceive }
        self.messageTab[UIMonthCard.GoldCardID] = { endTime = goldEndTime, receive = goldReceive }
        
        for i, v in pairs(self.messageTab) do
            if not self:CheckOneMonthIsEndTime(v.endTime) and v.receive then
                self.RedPointState = true
                break
            end
        end
    else
        self.RedPointState = true
    end
    InfoManager.mainRechargeInfo:RefreshMainRechargeRedPoint("tog_RechargeMonthlycard",self.RedPointState)
end

function this:TryReqMessageOnce()
    if not self.isReqMsg then
        self.isReqMsg = true
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = ERechargeType.MonthCardGift, action = "panel" })
    end
end

---@return cfg_MonthlyPack_column
function this:FindCfgInfo(tab, order)
    for _, v in pairs(tab) do
        if v.sortId == order then
            return v
        end
    end
    return nil
end

---true为过期
function this:CheckOneMonthIsEndTime(endTime)
    --- 检查是否过期
    local serverTime = Time.GetServerTime()
    if endTime ~= nil then
        if endTime < serverTime then
            return true
        end
    end
    return false
end

function this:Reset()
    self.isReqMsg = nil
end