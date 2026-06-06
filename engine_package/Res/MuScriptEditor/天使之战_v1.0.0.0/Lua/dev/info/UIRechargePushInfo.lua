---@class UIRechargePushInfo @注释
UIRechargePushInfo = class()
local this = UIRechargePushInfo

function this:ctor()
    self.endTime = 0
end

function this:Init()
    self:Reset()
    self:InitData()
    self:RegistMessages()
end

function this:Reset()
    self.resData = nil
    self.endTime = 0
    self.DataList = {}
end
function this:InitData()
end

function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_PREFERENTIAL_BUTTON_PANEL_INFO, self.RES_PREFERENTIAL_BUTTON_PANEL_INFO, self)
    --SL:RegisterLUAEvent(MESSAGE_ACCEPT, self.DataProcessing, self)
end

function this:RES_PREFERENTIAL_BUTTON_PANEL_INFO(_, message)
    if message then
        ---单充礼包
        self.resData = message
        self:SetShowList()
        if self:IsShowBtn() then
            local topPanel = GUI:GetUI("dev/ui/MainUI/Panel/KLUISystemTop/KLUISystemTopPanel")
            if topPanel then
                topPanel:Refresh()
            end
        end
    end
end
function this:SetShowList()
    self.DataList = {}
    local endTimeTemp = 0
    if self.resData then
        for _, v in pairs(self.resData) do
            local giftId = tonumber(v.giftId)
            local endTime = tonumber(v.endtime) *1000
            if endTime > Time.GetServerTime() then
                table.insert(self.DataList, { endTime = endTime, giftId = giftId })
            end
            if endTime > endTimeTemp then
                endTimeTemp = endTime
            end
        end
    end
    table.sort(self.DataList,function(a, b) 
        return a.giftId < b.giftId
    end)
    self.endTime = endTimeTemp
end

function this:IsShowBtn()
    if self.resData then
        for _, v in pairs(self.resData) do
            local endTime = tonumber(v.endtime) *1000
            if endTime > Time.GetServerTime() then
                ---没买且时间没到
                return true
            end
        end
    end
        return false
end




