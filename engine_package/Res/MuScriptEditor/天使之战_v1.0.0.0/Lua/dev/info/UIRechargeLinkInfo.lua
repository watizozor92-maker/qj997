---@class UIRechargeLinkInfo
UIRechargeLinkInfo = class()
local this = UIRechargeLinkInfo

function this:Init()
    self:RegistMessages()
    self:Reset()
end
function this:Reset()
    self.RechargeLinkData=nil
end

function this:RegistMessages()
    --SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.LUA_EVENT_LEVELCHANGE, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_ACTION, self.RES_RECHARGE_ACTION, self)
end

function this:RES_RECHARGE_ACTION(_, message)
    if message and message.type == tostring(ERechargeType.RechargeLink) then
        self.RechargeLinkData = message.data
        SL:onLUAEvent(LUA_EVENT_RECHARGE_LINK_CHANGE)
        --SL:RefreshPanelALLRedPoint("KLRechargeLinkPanel")
        SL:RefreshPanelALLRedStateKmlByCondition("KLUISystemTopPanel")
        InfoManager.mainRechargeInfo:RefreshMainRechargeRedPoint("tog_NewServerRecharge",self:IsShowRed())
    end
end

function this:IsShowRed()
    if self.RechargeLinkData and self.RechargeLinkData.data then
        for _,v in pairs(self.RechargeLinkData.data) do
            if v.state == 1 then
                return true
            end
        end
    end
    return false
end



