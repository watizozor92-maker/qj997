---@class UIMonthCardInfo
---@field IsGetMonthCard boolean
---@field IsGetDailyCard boolean
UIMonthCardInfo = class()
local this = UIMonthCardInfo

function this:ctor()
end

function this:Reset()
    ---月卡会包含日卡权益 单买日卡不包含月卡权益 先买月卡再买日卡会直接加月卡天数
    self.IsGetMonthCard = false--是否开启了月卡
    self.IsGetDailyCard = false--是否开启了日卡
    self.MonthCardBuyCount = 0 --月卡购买次数
    self.DailyCardBuyCount = 0 --日卡购买次数
    self.MonthCardTime = 0 ---月卡时间
    self.DailyCardTime = 0 ---日卡时间
    self.IsFirstBuyMonthCard = true
    self.IsFirstBuyDailyCard = true
    self.MonthCardTimeTotal = 0 ---月卡总时间 先开月卡再开日卡时间会叠加(服务器处理)
    self.ThreeTime = 0 --三倍收益时间
    self.ToDayThreeTimeIsGet = false ---今天是否领取了三倍收益

    self.IsShowActivePanel = false
    self.MonthCardTbl = SL:GetConfigTable("cfg_monthlyPass")

    if self.coHide ~= nil then
        Coroutine.Stop(self.coHide)
    end
    
end

function this:Init()
    self:InitData()
    self:RegistMessages()
    self:Reset()
end

function this:InitData()
end
function this:RegistMessages()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_MONTHCARD_INFO, self.RES_GET_MONTHCARD_INFO, self)-- 响应获取月卡信息
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MONTHCARD_CHANGE_INFO, self.RES_MONTHCARD_CHANGE_INFO, self)-- 响应月卡变化信息
    SL:RegisterLUAEvent(LUA_EVENT_ROLE_LOGIN, self.EnterGame, self)
    --SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_MONTHCARD_OVERTIME  , self.RES_MONTHCARD_OVERTIME  , self) --响应月卡过期提示
    SL:RegisterLUAEvent(MESSAGE_ACCEPT, self.DataProcessing, self)
end
function this:DataProcessing(_, message)
    if message then
        if message.id == 31 then
            if message.params[1] == SL:GetConfig("cfg_item", self:GetMonthCardTblData().id).name then
                if self.coHide ~= nil then
                    Coroutine.Stop(self.coHide)
                end
                GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLMonthCardActiveEffect/KLMonthCardActiveEffectPanel", nil, nil, { cfgId = self:GetMonthCardTblData().id })
                self.coHide = Coroutine.Start(
                        function()
                            Coroutine.Wait(2)
                            GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLMonthCardActiveEffect/KLMonthCardActiveEffectPanel")
                        end
                )
            end
            if message.params[1] == SL:GetConfig("cfg_item", self:GetDailyCardTblData().id).name then
                if self.coHide ~= nil then
                    Coroutine.Stop(self.coHide)
                end
                GUI:UIPanel_Open("dev/outui/MonthCard/Panel/KLMonthCardActiveEffect/KLMonthCardActiveEffectPanel", nil, nil, { cfgId = self:GetDailyCardTblData().id })
                self.coHide = Coroutine.Start(
                        function()
                            Coroutine.Wait(2)
                            GUI:UIPanel_Close("dev/outui/MonthCard/Panel/KLMonthCardActiveEffect/KLMonthCardActiveEffectPanel")
                        end
                )
            end
        end
    end
end
function this:EnterGame()
    --SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_MONTHCARD_INFO)
end
---@param message RES_GET_MONTHCARD_INFO
function this:RES_GET_MONTHCARD_INFO(_, message)
    if message then
        self.IsGetMonthCard = false--是否开启了月卡
        self.IsGetDailyCard = false--是否开启了日卡
        self.MonthCardTimeTotal = 0
        self.ThreeTime = tonumber(message.threetime)
        self.ToDayThreeTimeIsGet = self:StringToBoolean(message.todayreceivethreetime)
        local MonthCardData = message[tostring(EMonthType.MonthCard)]
        if MonthCardData then
            --月卡
            self.MonthCardBuyCount = tonumber(MonthCardData.buycount)
            self.MonthCardTime = math.modf(tonumber(MonthCardData.vaildTime))
            self.IsGetMonthCard = self:StringToBoolean(MonthCardData.isopen)
            self.IsFirstBuyMonthCard = self:StringToBoolean(MonthCardData.isfirstbuy)
        end
        local DailyCardData = message[tostring(EMonthType.DailyCard)]
        if DailyCardData then
            --日卡
            self.DailyCardBuyCount = tonumber(DailyCardData.buycount)
            self.DailyCardTime = math.modf(tonumber(DailyCardData.vaildTime))
            self.IsGetDailyCard = self:StringToBoolean(DailyCardData.isopen)
            self.IsFirstBuyDailyCard = self:StringToBoolean(DailyCardData.isfirstbuy)
        end
        --[[        if self.MonthCardTime >= SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME) then
                    self.IsGetMonthCard = true
                end
                if self.DailyCardTime >= SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME) then
                    self.IsGetDailyCard = true
                end
                if self.IsGetMonthCard then
                    self.IsGetDailyCard = false
                end]]
        if self.MonthCardTime > self.DailyCardTime then
            self.MonthCardTimeTotal = self.MonthCardTime
        else
            self.MonthCardTimeTotal = self.DailyCardTime
        end
        if self.IsGetMonthCard or self.IsGetDailyCard then
            self.IsShowActivePanel = false
        else
            self.IsShowActivePanel = true
        end
        SL:onLUAEvent(LUA_EVENT_GET_MONTH_CARD_INFO, message)
        self:CheckPriviegeBoss()
    end
end
function this:RES_MONTHCARD_CHANGE_INFO(_, message)
    if message then
        if tonumber(message.cfgId) == EMonthType.MonthCard then
            self.MonthCardBuyCount = tonumber(message.buycount)
            self.MonthCardTime = math.modf(tonumber(message.vaildTime))
            self.IsGetMonthCard = self:StringToBoolean(message.isopen)
            self.IsFirstBuyMonthCard = self:StringToBoolean(message.isfirstbuy)
        end
        if tonumber(message.cfgId) == EMonthType.DailyCard then
            self.DailyCardBuyCount = tonumber(message.buycount)
            self.DailyCardTime = math.modf(tonumber(message.vaildTime))
            self.IsGetDailyCard = self:StringToBoolean(message.isopen)
            self.IsFirstBuyDailyCard = self:StringToBoolean(message.isfirstbuy)
        end
        if self.MonthCardTime > self.DailyCardTime then
            self.MonthCardTimeTotal = self.MonthCardTime
        else
            self.MonthCardTimeTotal = self.DailyCardTime
        end
        SL:onLUAEvent(LUA_EVENT_GET_MONTH_CARD_CHANGE, message)
        self:CheckPriviegeBoss()
        ---刷新自动拾取勾选显示
        if InfoManager.monthCardInfo:IsHaveMonthCardRights("pickUp") then
            SL:SendPlayerAutoPickChange(true)
        end
        if InfoManager.monthCardInfo:IsHaveMonthCardRights("recovery") then
            SL:SendPlayerAutoRecoverChange(true)
        end
    end
end
function this:StringToBoolean(value)
    if value == "true" then
        return true
    else
        return false
    end
end
---是否需要月卡和日卡功能
---@param Name string @表字段名字
function this:IsNeedMonthAndDailyCard(Name)
    local IsNeedMonthCard = false
    local IsNeedDailyCard = false
    if table.isNullOrEmpty(self.MonthCardTbl) then
        return false, false
    end
    for _, v in pairs(self.MonthCardTbl) do
        if v.id == EMonthType.MonthCard and v[Name] == 1 then
            IsNeedMonthCard = true
        end
        if v.id == EMonthType.DailyCard and v[Name] == 1 then
            IsNeedDailyCard = true
        end
    end
    return IsNeedMonthCard, IsNeedMonthCard
end
---是否需要显示按钮
---@param Name string @表字段名字
function this:IsNeedShowPanel(Name)
    for _, v in pairs(self.MonthCardTbl) do
        if v[Name] == 1 then
            return true
        end
    end
    return false
end
---获得月卡数据
---@return cfg_monthlyPass_column
function this:GetMonthCardTblData()
    for _, v in pairs(self.MonthCardTbl) do
        if v.id == EMonthType.MonthCard then
            v.price = self:GetRechargeMonthCard(v.id).amount
            return v
        end
    end
    return nil
end
---获得日卡数据
---@return cfg_monthlyPass_column
function this:GetDailyCardTblData()
    for _, v in pairs(self.MonthCardTbl) do
        if v.id == EMonthType.DailyCard then
            v.price = self:GetRechargeMonthCard(v.id).amount
            return v
        end
    end
    return nil
end
function this:GetRechargeMonthCard(TblId)
    local tbl= SL:GetConfigTable("cfg_recharge")
    for _,v in pairs(tbl) do
        if v.type == ERechargeType.MonthCardType and v.parameter == TblId then
            --v.amount = 0.01
            return v
        end
    end
end
---判断月卡日卡是否激活并且有该权益
----@param value string  @查月卡表获得
function this:IsHaveMonthCardRights(value)
    local IsNeedMonthCard, IsNeedDailyCard = self:IsNeedMonthAndDailyCard(value)
    if IsNeedMonthCard and self.IsGetMonthCard then
        return true
    end
    if IsNeedDailyCard and self.IsGetDailyCard then
        return true
    end
    if not IsNeedMonthCard and not IsNeedDailyCard then
        ---两个卡都不控制权益 默认为true
        return true
    end
    return false
end
---判断月卡时间是否小于1天
function this:IsHaveDayTime()
    local reTime = 0
    if self.MonthCardTimeTotal ~= nil then
        reTime = self.MonthCardTimeTotal - SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    end
    if reTime > 0 and reTime <= 86400000 then
        return true
    end
    return false
end

function this:CheckPriviegeBoss()
    if self.IsGetMonthCard then
        self:SendPriviegeBoss(3)
    end
    if self.IsGetDailyCard then
        self:SendPriviegeBoss(4)
    end
end

---通知特权boss
---@param value number @活动类型 1—黄金特权卡 2—钻石特权卡 3—月卡 4-日卡
function this:SendPriviegeBoss(value)
    SL:SendLuaNetMsg(LuaMessageIdToSever.PRIVILEGE_BOSS_COUNT_INIT, value)
end

---@获得月卡剩余天数
function this:GetMonthCardDayTime()
    local day = (InfoManager.monthCardInfo.MonthCardTimeTotal - SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)) // 86400000
    if day > 0 then
        return day
    end
    return 0
end
---月卡是否能进背包
function this:CanInBag()
    local MonthCardTbl = self:GetMonthCardTblData()
    if SL:CanPutToBag(MonthCardTbl.id, 1) then
        return true
    end
    local DailyCardTbl = self:GetDailyCardTblData()
    if SL:CanPutToBag(DailyCardTbl.id, 1) then
        return true
    end
    return false
end
----是否是交易行bantype
function this:IsBanType(type, subtype, isMonthCard)
    if isMonthCard then
        for _, v in pairs(self:GetMonthCardTblData().banType) do
            if v[1] == type and v[2] == subtype then
                return true
            end
        end
    else
        for _, v in pairs(self:GetDailyCardTblData().banType) do
            if v[1] == type and v[2] == subtype then
                return true
            end
        end
    end
    return false
end


