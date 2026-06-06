---@class DailyAddRechargeInfo
DailyAddRechargeInfo = class()
local this = DailyAddRechargeInfo

function this:ctor()
end

function this:Reset()
end

function this:Init()
    self:InitData()
    self:RegistMessages()
end

function this:InitData()
    self.roleTodayAllMoney = 0 --玩家今日总充值钱数
    self.dailyAddRechargeDataTbl = {} 
    self.investFundInfo = {} --投资基金信息
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_ACTION,self.RefreshRoleTodayMoney,self)
end

--玩家今日总充值钱数
function this:RefreshRoleTodayMoney(_,msg)
    if not table.isNullOrEmpty(msg) then
        if msg.type == "0" and msg.action == "record" then --通用协议内后端给的标识
            self.roleTodayAllMoney = msg.data.dailyTotalMoney
            SL:onLUAEvent(LUA_DAILYADD_RECHARGE_CHANGE)
        end
        if msg.type == "11" and msg.action == "panel" then --通用协议内后端给的标识
            self.dailyAddRechargeDataTbl = {}
            local tmpData = msg.data
            for _, v in pairs(tmpData) do
                v.dailyCfgData = SL:GetConfig("cfg_dailyRecharge",tonumber(v.dailyRechargeId))
                if not table.isNullOrEmpty(v.dailyCfgData) then
                    if v.dailyCfgData.showCondition == "" or ConditionManager.Check4D(v.dailyCfgData.showCondition) then
                        table.insert(self.dailyAddRechargeDataTbl,v)
                    end
                end
            end
            this:RefreshDailyAddRechargeRedPoint(self.dailyAddRechargeDataTbl)
            SL:onLUAEvent(LUA_DAILYADD_RECHARGE_CHANGE)
        end
        
        if msg.type == "10" and msg.action == "panel" then --投资基金信息
            self.investFundInfo = msg.data
            self:RefreshInvestFundRedPoint()
        end
    end
end

function this:RefreshInvestFundRedPoint()
    local gotNum = table.count(self.investFundInfo.rewards)
    local totalNum = self.investFundInfo.buyDay
    local redPoint = totalNum > gotNum --是否有可领取的奖励
    InfoManager.mainRechargeInfo:RefreshMainRechargeRedPoint("tog_Nvestment",redPoint)
end

--每日累充红点逻辑:有可领取的奖励
function this:RefreshDailyAddRechargeRedPoint(msg)
    local isShowRedPoint = false
    local data = msg
    for _, v in pairs(data) do
        if v.giftState == E_RechargeState.CanGet then
            isShowRedPoint = true
            break
        end
    end
    InfoManager.mainRechargeInfo:RefreshMainRechargeRedPoint("tog_DailyAddRecharge",isShowRedPoint)
end
