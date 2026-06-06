
---@class RechargeSevenDayGiftInfo 开服充值七日累积登录
RechargeSevenDayGiftInfo = class()
local this = RechargeSevenDayGiftInfo
 
this.countDay = 0
this.hadReceiveReward = {}
function this:Init()
    self:RegistMessages()
    self:Reset()
end
function this:Reset()
    self.countDay = 0
    self.hadReceiveReward = {} 
end

function this:RegistMessages()
    -- SL:RegisterLUAEvent(LUA_EVENT_ROLE_LOGIN, self.EnterGame, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECEIVE_RECHARGE_LOGIN_REWARD, self.InfoChangeCallBack, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_LOGIN_INFO_CHANGE, self.InfoChangeCallBack, self)

end

function this:InfoChangeCallBack(_, message) 
    self.countDay = message.countDay
    self.hadReceiveReward = message.hadReceiveReward
    self:RefreshRedPoint() 
    SL:onLUAEvent(LUA_EVENT_RECHAGE_SEVEN_DAY_GIFT)
end

function this:EnterGame()
end

function this:RefreshRedPoint()
    local allReward = SL:GetConfigTable("cfg_rechargeSevenDayGift")
    local isShow = false
    for index, value in ipairs(allReward) do
            if value.accumulateDay<= self.countDay and not table.contains(self.hadReceiveReward,value.id) then
                    isShow = true 
                    break
            end
    end
    InfoManager.mainRechargeInfo:RefreshMainRechargeRedPoint("tog_rechargeSevenDayGift",isShow)
end




