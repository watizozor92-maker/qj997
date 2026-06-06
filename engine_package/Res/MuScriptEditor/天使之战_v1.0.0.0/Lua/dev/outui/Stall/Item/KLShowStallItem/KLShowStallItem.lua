---@class KLShowStallItem:UIKmlLuaPanelBase
---@field view KLShowStallItemView
---@field goodsItem KLTradeGoodsItem
---@field goods boolean
---@field goodsInfo
local KLShowStallItem = class(UIKmlLuaPanelBase)
local this = KLShowStallItem
---创建时调用一次
function this:Init()

end

---注册UI事件和服务器消息
function this:RegistEvents()
end

function this:UpdateUI(data)
    if table.count(data) > 0 then
        GUI:setVisible(self.view.null_panel, false)
        GUI:setVisible(self.view.have_panel, true)
        self.goods = true
        if not GUI:IsWebGLAsync() then
            if not self.goodsItem then
                self.goodsItem = GUI:UIPanel_Open("dev/outui/Stall/Item/KLShowStallGoodsItem/KLShowStallGoodsItem", self.view.have_panel, self, nil, true)
            end
            self.goodsInfo = data
            self.goodsItem:UpdateData(data)
            GUI:AddOnClickEvent(self.goodsItem.view.btn_goods_item, self, self.Click)
            self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
                return self.goodsItem:Tick()
            end)
        else
            if self.goodsItem then
                self.goodsInfo = data
                self.goodsItem:UpdateData(data)
                GUI:AddOnClickEvent(self.goodsItem.view.btn_goods_item, self, self.Click)
                self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
                    return self.goodsItem:Tick()
                end)
            else
                self.goodsInfo = data
                GUI:UIPanel_Open("dev/outui/Stall/Item/KLShowStallGoodsItem/KLShowStallGoodsItem", self.view.have_panel, self, nil, true,
                function ( tempUI )
                    self.goodsItem = tempUI
                    self.goodsItem:UpdateData(data)
                    GUI:AddOnClickEvent(self.goodsItem.view.btn_goods_item, self, self.Click)
                    self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
                        return self.goodsItem:Tick()
                    end)
                end)
            end
        end
    else
        GUI:setVisible(self.view.null_panel, false)
        GUI:setVisible(self.view.have_panel, false) 
    end
end

function this:HideItem()
    GUI:setVisible(self.view.null_panel, false)
    GUI:setVisible(self.view.have_panel, false) 
end

function this:Remove()
    if self.tickTimer then
        SL:UnSchedule(self.tickTimer)
        self.tickTimer = nil
    end
    self.goods = false
    self.goodsInfo = {}
end

function this:IsGoods()
    return self.goods
end

function this:Click()
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_GOODS_INFO, {self.goodsInfo.itemId, self.goodsInfo.ownerId })
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.goods = false
    self.goodsItem = nil
end

function this:Close()
    if self.tickTimer then
        SL:UnSchedule(self.tickTimer)
        self.tickTimer = nil
    end
    if self.goodsItem then

    end
    self.goodsItem = GUI:UIPanel_Close("dev/outui/Trade/Item/KLTradeGoods/KLTradeGoodsItem", self.goodsItem)
end

return this
