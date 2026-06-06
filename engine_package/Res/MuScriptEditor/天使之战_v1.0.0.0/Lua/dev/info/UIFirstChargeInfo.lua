---@class UIFirstChargeInfo
UIFirstChargeInfo = class()
local this = UIFirstChargeInfo
---首充挡位
EFirstRechargeLevel = {
    one = 301,
    two = 302,
    three = 303,
    four = 304,
    five = 305,
    six = 306,
}

function this:Init()
    self:RegistMessages()
    self:Reset()
end
function this:Reset()
    self.FirstChargeInfo = nil
end

function this:RegistMessages()
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_CURR_BIG_BANG_NUMBER,self.RES_CURR_BIG_BANG_NUMBER,self)
    SL:RegisterLUAEvent(LUA_EVENT_LEVELCHANGE, self.LUA_EVENT_LEVELCHANGE, self)
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_LOGIN, self.EnterGame, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_RECHARGE_ACTION, self.RES_RECHARGE_ACTION, self)
end

function this:RES_RECHARGE_ACTION(_, message)
    if message.type == "3" then
        self:RES_FirstChargeGift_Info(_,message)
    end
end
function this:RES_FirstChargeGift_Info(_, message)
    if message then
        self.FirstChargeInfo = message
        SL:onLUAEvent(LUA_EVENT_RES_FIRST_CHARGE_GIFT_INFO, message)
        SL:RefreshPanelALLRedStateKmlByCondition("checkFirstCharge")
    end
end
function this:EnterGame()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_RECHARGE_ACTION, { type = 3, action = "panel" })
end

function this:LUA_EVENT_LEVELCHANGE(_,level, old)
    if level then
        local rechargeTbl = SL:GetConfig("cfg_first_charge", EFirstRechargeLevel.one)
        if rechargeTbl then
            local popUpsRule = rechargeTbl.popUpsRule
            local popUpsPicture=rechargeTbl.popUpsPicture
            for _, v in pairs(popUpsRule) do
                if tonumber(v[1]) == level then
                    local PlayerPanel = GUI:GetUI("dev/ui/MainUI/Panel/KLUISystemTop/KLUISystemTopPanel")
                    local findPanel 
                    if PlayerPanel and PlayerPanel.systemTemplateList then
                        for i, systemItem in pairs(PlayerPanel.systemTemplateList) do
                            if systemItem.args.id == 203 and GUI:getVisible(systemItem.view.root) then
                                findPanel = systemItem
                            end
                        end
                    end
                    if findPanel then
                        GUI:CloseAllUIWithoutMainUI()
                        GUI:UIPanel_Open("dev/outui/FirstCharge/Panel/KLFirstChargeAD/KLFirstChargeADPanel", nil, nil, { count = tonumber(v[2]),popUpsPicture=popUpsPicture })
                    end
                    return
                end
            end
        end
    end
end

function this:ISRedDot()
    if not self.FirstChargeInfo then
        return false
    end
    local infoTbl = self:SortTable(self.FirstChargeInfo.data.rewards)
    for _, v in pairs(infoTbl) do
        if v.state == 1 then
            return true
        end
    end
    return false
end
---是否购买了此挡位
function this:IsBuyFirstCharge(cfgId)
    if not self.FirstChargeInfo then
        return false
    end
    local infoTbl = self:SortTable(self.FirstChargeInfo.data.rewards)
    for _, v in pairs(infoTbl) do
        if v.state == 1 and v.cfgId == cfgId then
            return true
        end
    end
    return false
end
---是否领取了此挡位
function this:IsGetAwardFirstCharge(cfgId)
    if not self.FirstChargeInfo then
        return false
    end
    local infoTbl = self:SortTable(self.FirstChargeInfo.data.rewards)
    for _, v in pairs(infoTbl) do
        if v.state == 2 and tonumber(v.cfgId) == cfgId then
            return true
        end
    end
    return false
end
function this:IsShowBtn()
    if not self.FirstChargeInfo then
        return true
    end
    if self:IsGetAwardFirstCharge(EFirstRechargeLevel.one) and self:IsGetAwardFirstCharge(EFirstRechargeLevel.two) and self:IsGetAwardFirstCharge(EFirstRechargeLevel.three)  then
        return false
    end
    return true
end
function this:SortTable(Table)
    local temp = {}
    for i, v in pairs(Table) do
        local data = {
            cfgId = i,
            state = v
        }
        table.insert(temp, data)
    end
    table.sort(temp, function(a, b)
        return tonumber(a.cfgId) < tonumber(b.cfgId)
    end)
    return temp
end


