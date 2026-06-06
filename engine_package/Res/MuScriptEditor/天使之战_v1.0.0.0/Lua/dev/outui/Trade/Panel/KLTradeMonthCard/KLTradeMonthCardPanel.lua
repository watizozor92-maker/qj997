---@class KLTradeMonthCardPanel:UIKmlLuaPanelBase
---@field view KLTradeMonthCardPanelView
local KLTradeMonthCardPanel = class(UIKmlLuaPanelBase)
local this = KLTradeMonthCardPanel

EMonthCardTradeToggle = {
    MonthCard = 1,
    Coin = 2
}
---创建时调用一次
function this:Init()

    self.message = nil
    GUI:DataListInitData(self.view.datalist_goods, function()
        return self:ItemCountFunc()
    end, function(realIndex)
        return self:ItemGetFunc(realIndex)
    end, nil, function(realIndex, kmlCtrl)
        return self:ItemUpdateFunc(realIndex, kmlCtrl)
    end)
    ---@type table<UIKmlLuaControl,KLTradeGoodsItem>
    self.goodsItems = {}
    ---@type table<number, KLTradeGoodsItemData>
    self.goodsItemDataList = {}
    self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
        return self:Tick()
    end)

    --GUI:SetActive(self.view.toggle_coin, false)
    self.CurSelect = EMonthCardTradeToggle.MonthCard
    GUI:Toggle_setIsOn(self.view.toggle_month_card, true)
end
function this:ItemCountFunc()
    return #self.goodsItemDataList
end

function this:ItemGetFunc(realIndex)
    ---@type KLTradeGoodsItem
    local item = GUI:UIPanel_Open("dev/outui/Trade/Item/KLTradeGoods/KLTradeGoodsItem", self.view.datalist_goods, self, nil, true)
    self.goodsItems[item.view.root] = item
    return item.view.root
end

function this:ItemUpdateFunc(realIndex, kmlCtrl)
    local data = self.goodsItemDataList[realIndex + 1]
    local item = self.goodsItems[kmlCtrl]
    item:UpdateData(data)
    local id = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    local minPrice = data.publicityStatue == "1" and self.minPricePublic or self.minPrice
    if id ~= data.ownerId and (data.totalPrice/data.count) > minPrice then
        item:UpdateBuyClickFun(self.MinPriceBuyCheck,self)
    end
end
---@param itemData table
function this:MinPriceBuyCheck(item)
    local itemData = item.itemData
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_GOODS_INFO, {itemData.itemId, itemData.ownerId })
    GUI:UIPanel_Open("dev/outui/Trade/Panel/KLMonthCardBuyTip/KLMonthCardBuyTipPanel")
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:SetToggleOnValueChange(self.view.toggle_month_card, self, self.MonthCardToggle)
    GUI:SetToggleOnValueChange(self.view.toggle_coin, self, self.CoinToggle)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_TRADE_GOODS, self.RES_GET_TRADE_GOODS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_BUY_GOODS, self.Refresh, self)
    --SL:RegisterLUAEvent(LUA_EVENT_TRADE_BUY_REQUEST, self.Refresh, self)
end
function this:RES_GET_TRADE_GOODS(_, message)
    if not message then
        return
    end
    self.message = message
    if self.CurSelect == EMonthCardTradeToggle.MonthCard then
        self:MonthCardToggle()
    elseif self.CurSelect == EMonthCardTradeToggle.Coin then
        self:CoinToggle()
    end
end
function this:MonthCardToggle()
    self.CurSelect = EMonthCardTradeToggle.MonthCard
    if not self.message then
        return
    end
    table.clear(self.goodsItemDataList)
    for k, v in pairs(self.message) do
        local stallTbl = SL:GetConfig("cfg_stall", v.itemCfgId)
        if stallTbl and stallTbl.type == 5 then
            --[[local publicityTime = v.listingTime + v.publicityTime
            local offShelfTime = publicityTime + v.upShelfDuration
            local now = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
            if publicityTime > now then
                v.time = (publicityTime - now) / 100
            elseif publicityTime < now and offShelfTime > now then
                v.time = (offShelfTime - now) / 100
            end]]
            table.insert(self.goodsItemDataList, v)
        end
    end
    table.sort(self.goodsItemDataList,self.SortGoodsByPriceFun)
    local id = SL:GetMetaValue(EMetaVarGetKey.MAIN_ACTOR_ID)
    self.minPrice = math.maxinteger
    self.minPricePublic = math.maxinteger
    if #self.goodsItemDataList > 0 then
        self.minPrice = self.goodsItemDataList[1].totalPrice/self.goodsItemDataList[1].count
    end
    for k, v in pairs(self.goodsItemDataList) do
        if v.ownerId ~= id then
            local unitPrice = v.totalPrice/v.count
            if v.publicityStatue then
                if unitPrice < self.minPricePublic then
                    self.minPricePublic = unitPrice
                end
            else
                if unitPrice < self.minPrice then
                    self.minPrice = unitPrice
                end
            end
        end
    end
    GUI:DataListUpdateData(self.view.datalist_goods)
end

function this.SortGoodsByPriceFun(a,b)
    return a.totalPrice/a.count < b.totalPrice/b.count
end
function this:CoinToggle()
    self.CurSelect = EMonthCardTradeToggle.Coin
    if not self.message then
        return
    end
    table.clear(self.goodsItemDataList)
    for k, v in pairs(self.message) do
        local stallTbl = SL:GetConfig("cfg_stall", v.itemCfgId)
        if stallTbl and stallTbl.type == 1 then
            table.insert(self.goodsItemDataList, v)
        end
    end
    GUI:DataListUpdateData(self.view.datalist_goods)
end
---创建或者刷新界面数据时调用
function this:Refresh()
    self:RequestRefreshGoodsList(0, 0, 0, 0, 0, 0)
end

function this:Close()
    SL:UnSchedule(self.tickTimer)
    table.clear(self.goodsItemDataList)
    GUI:DataListUpdateData(self.view.datalist_goods)
end
function this:RequestRefreshGoodsList(type, subType, sortType, careerType, filterLevel, filterQuality)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_TRADE_GOODS, { type, subType, sortType, careerType, filterLevel, filterQuality })
end

function this:Tick()
    local refresh = false
    for _, v in pairs(self.goodsItems) do
        refresh = refresh or v:Tick()
    end
    if refresh then
        self:RequestRefreshGoodsList(0, 0, 0, 0, 0, 0)
    end
end
return this
