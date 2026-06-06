---@class KLTradeCommonGoodsPanel:UIKmlLuaPanelBase
---@field view KLTradeCommonGoodsPanelView
local KLTradeCommonGoodsPanel = class(UIKmlLuaPanelBase)
local this = KLTradeCommonGoodsPanel
---商品列表列数
local colCount = 4
---商品列表行数
local rowCount = 2
---刷新间隔
local autoRefreshInterval = 60
---左页
local leftPage
---右页
local rightPage

---创建时调用一次
function this:Init()
    --初始化商品列表配置
    GUI:DataListInitData(self.view.datalist_goods, function()
        return self:ItemCountFunc()
    end, function(realIndex)
        return self:ItemGetFunc(realIndex)
    end, nil, function(realIndex, kmlCtrl)
        return self:ItemUpdateFunc(realIndex, kmlCtrl)
    end, nil, true)
    ---@type table<UIKmlLuaControl,KLTradeGoodsItem>
    self.goodsItems = {}

    self.goodsItemDataList = {}
    self.pageItemDataDic = {}
    self.isRequestPage = false
    self.autoRefreshTime = 0
    self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
        return self:Tick()
    end)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_GET_TRADE_GOODS, self.RES_GET_TRADE_GOODS, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_BUY_GOODS, self.RES_TRADE_BUY_GOODS,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_PRE_ORDER, self.RES_TRADE_PRE_ORDER,self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_TRADE_MY_PRE_GOODS,self.RES_TRADE_PRE_ORDER,self)
end

---创建或者刷新界面数据时调用
function this:Refresh()
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
    item:UpdateData(data, nil, self.tradeSearchRequest.searchType)
    
    -- 在请求中，或者有两页数据，则不请求
    if self.isRequestPage or leftPage ~= rightPage then
        return
    end
    
    if not self.isLast and realIndex >= table.count(self.goodsItemDataList) - colCount * rowCount then
        -- 请求下一页
        self:RequestNextPage()
        return
    end
    if leftPage > 1 and realIndex < colCount * rowCount then
        -- 请求上一页
        self:RequestPrePage()
        return
    end
    -- 检查是否需要移除
    
end

---@param tradeSearchRequest TradeSearchRequest
function this:RequestRefreshGoodsList(tradeSearchRequest, forceUpdate)
    self.autoRefreshTime = 0
    self.isRequestPage = true
    self.tradeSearchRequest = tradeSearchRequest
    self.reset = forceUpdate
    if forceUpdate then
        self.tradeSearchRequest.pageParam.page = 1
    end
    --SL:LogError("请求第"..tradeSearchRequest.pageParam.page.."页")
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_GET_TRADE_GOODS, self.tradeSearchRequest)
end

---请求上一页
function this:RequestPrePage()
    self.isRequestNextPage = false
    self.tradeSearchRequest.pageParam.page = self.tradeSearchRequest.pageParam.page - 1
    self:RequestRefreshGoodsList(self.tradeSearchRequest)
end

---请求下一页
function this:RequestNextPage()
    self.isRequestNextPage = true
    self.tradeSearchRequest.pageParam.page = self.tradeSearchRequest.pageParam.page + 1
    self:RequestRefreshGoodsList(self.tradeSearchRequest)
end

function this:RES_GET_TRADE_GOODS(_, message)
    self.isRequestPage = false
    if not message then
        self.pageItemDataDic[self.tradeSearchRequest.pageParam.page] = nil
        -- 因为是在向下请求，数据为空代表是最后一页
        self.isLast = self.isRequestNextPage
        if self.isLast then
            return
        else
            -- 这里代表向上请求，数据页为空，继续向上
            if self.tradeSearchRequest.pageParam.page > 1 then
                self:RequestPrePage()
                return
            end
            message = {}
        end
    end
    self.isLast = table.count(message) < self.tradeSearchRequest.pageParam.size
    --local type = 0
    if self.reset then
        table.clear(self.goodsItemDataList)
        table.clear(self.pageItemDataDic)
        leftPage = 1
        rightPage = 1
    else
        if self.isRequestNextPage then
            rightPage = leftPage
            leftPage = self.tradeSearchRequest.pageParam.page
        else
            leftPage = rightPage
            rightPage = self.tradeSearchRequest.pageParam.page
        end
    end
    local tempMessage = {}
    for k, v in pairs(message) do
        tempMessage[tonumber(k)] = v
    end
    local now = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    ---@param v KLTradeGoodsItemData
    for k, v in pairs(tempMessage) do
        local stallTbl = SL:GetConfig("cfg_stall", tonumber(v.itemCfgId))
        if stallTbl and stallTbl.type ~= 1 and stallTbl.type ~= 5 then -- 月卡时间和奇迹币类型不在这里显示
            InfoManager.faceTradeInfo.SetTradeTime(v, now)
            table.insert(self.goodsItemDataList, v)
        end
    end
    --[[table.sort(self.goodsItemDataList,function (a,b)
        return a.listingTime > b.listingTime
    end)--]]
    self.pageItemDataDic[self.tradeSearchRequest.pageParam.page] = message and tempMessage or nil
    GUI:DataListUpdateData(self.view.datalist_goods, nil, nil, self.reset and 1 or nil)
end

function this:RES_TRADE_BUY_GOODS(_, message)
    if not message then
        SL:TipMessage("商品不存在", 1, NoticeType.NoticeMid)
    end
    self:RequestRefreshGoodsList(self.tradeSearchRequest, true)
end

function this:RES_TRADE_PRE_ORDER(_, message)
    self:RequestRefreshGoodsList(self.tradeSearchRequest, true)
end

function this:Tick()
    for i, v in pairs(self.goodsItems) do
        v:Tick()
    end
    self.autoRefreshTime = self.autoRefreshTime + 1
    if self.autoRefreshTime >= autoRefreshInterval then
        self:RequestRefreshGoodsList(self.tradeSearchRequest, true)
    end
end

function this:Close()
    SL:UnSchedule(self.tickTimer)
    table.clear(self.goodsItemDataList)
    GUI:DataListUpdateData(self.view.datalist_goods)
end

return this
