---@class OpenServiceGiftInfo 开服七日累积登录
OpenServiceGiftInfo = class()
local this = OpenServiceGiftInfo
 
this.countDay = 0
this.hadReceiveReward = {}
function this:Init()
    self:RegistMessages()
    self:Reset()
end
function this:Reset() 
end

function this:RegistMessages()
    -- SL:RegisterLUAEvent(LUA_EVENT_ROLE_LOGIN, self.EnterGame, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_LOGIN_REWARD_INFO_CHANGE, self.InfoChangeCallBack, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECEIVE_LOGIN_REWARD, self.InfoChangeCallBack, self)

end

function this:InfoChangeCallBack(_, message) 
    self.countDay = message.countDay
    self.hadReceiveReward = message.hadReceiveReward
    self:RefreshRedPoint() 
    SL:onLUAEvent(LUA_EVENT_SEVEN_DAY_GIFT)
end

function this:EnterGame()
end

function this:RefreshRedPoint()
    local allReward = SL:GetConfigTable("cfg_accumulateLogOn")
    local isShow = false
    for index, value in ipairs(allReward) do
            if value.accumulateDay<= InfoManager.openServiceGiftInfo.countDay and not table.contains(InfoManager.openServiceGiftInfo.hadReceiveReward,value.id) then
                    isShow = true 
                    break
            end
    end
    InfoManager.mainActivityInfo:RefreshMainActivityRedPoint("tog_SevenDayGiftActivity",isShow)
end




