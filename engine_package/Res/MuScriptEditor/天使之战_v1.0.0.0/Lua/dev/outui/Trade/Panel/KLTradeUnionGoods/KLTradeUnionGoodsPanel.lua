---@class KLTradeUnionGoodsPanel:UIKmlLuaPanelBase
---@field view KLTradeUnionGoodsPanelView
local KLTradeUnionGoodsPanel = class(UIKmlLuaPanelBase)
local this = KLTradeUnionGoodsPanel
---创建时调用一次
function this:Init()
    GUI:OSAScrollView_Initialized(self.view.osa_scrollview_union_goods, self.UnionGoodsGetFun, self.UnionGoodsUpdateFun, self)
    self.goodsListData = {}
    self.refreshTimer = SL:Schedule(self.refreshTimer, 0, 3, -1, function()
        return self:RequestCurRefreshGoodsList()
    end)
    ---@type KLTradeUnionGoodsItem[]
    self.tradeUnionGoodsItems = {}
    self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
        return self:Tick()
    end)
end

function this:UnionGoodsGetFun(index)
    local item = GUI:UIPanel_Open("dev/outui/Trade/Item/KLTradeUnionGoods/KLTradeUnionGoodsItem", self.view.osa_scrollview_union_goods, self, nil, true,function(item)
        self.tradeUnionGoodsItems[item] = item
        self:UnionGoodsUpdateFun(item,index)
    end)
    return item
end

---@param item KLTradeUnionGoodsItem
function this:UnionGoodsUpdateFun(item, index)
    if self.tradeUnionGoodsItems[item] then
        local data = self.goodsListData[index + 1]
        item:SetData(data)
    end
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WAR_ALLIANCE_AUCTION_GOODS, self.RES_WAR_ALLIANCE_AUCTION_GOODS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_WAR_ALLIANCE_OPT_INFO, self.RequestCurRefreshGoodsList, self)
end

function this:RES_WAR_ALLIANCE_AUCTION_GOODS(_, message)
    table.clear(self.goodsListData)
    if next(message) then
        for k, v in pairs(message) do
            self.goodsListData[tonumber(k)] = v
        end
    end

    GUI:OSAScrollView_RefreshList(self.view.osa_scrollview_union_goods, #self.goodsListData)
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
    SL:UnSchedule(self.refreshTimer)
    SL:UnSchedule(self.tickTimer)
end

function this:RequestRefreshGoodsList(type, subType, sortType, careerType, filterLevel, filterQuality)
    self.currentType = type
    self.currentSubType = subType
    self.currentSortType = sortType
    self.currentCareerType = careerType
    self.currentFilterLevel = filterLevel
    self.currentFilterQuality = filterQuality
    self:RequestCurRefreshGoodsList()
end

function this:RequestCurRefreshGoodsList()
    if not self.currentCareerType then
        return
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WAR_ALLIANCE_UPDATE_GOODS, { self.currentType, self.currentSubType, self.currentSortType, self.currentCareerType, self.currentFilterLevel, self.currentFilterQuality })

end

function this:Tick()
    local refresh
    local items = GUI:OSAScrollView_GetAllItems(self.view.osa_scrollview_union_goods)
    for i = 0, items.Count - 1 do
        local item = items[i]
        local expireData = item:Tick()
        if expireData then
            refresh = true
            table.removeByValue(self.goodsListData, expireData)
        end
    end
    if refresh then
        GUI:OSAScrollView_RefreshList(self.view.osa_scrollview_union_goods, #self.goodsListData)
    end
end

return this
