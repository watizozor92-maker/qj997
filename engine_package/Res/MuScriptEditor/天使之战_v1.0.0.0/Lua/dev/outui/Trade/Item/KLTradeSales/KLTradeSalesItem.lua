---@class KLTradeSalesItem:UIKmlLuaPanelBase
---@field view KLTradeSalesItemView
---@field goodsItem KLTradeGoodsItem
---@field goods boolean
---@field goodsInfo
local KLTradeSalesItem = class(UIKmlLuaPanelBase)
local this = KLTradeSalesItem
---创建时调用一次
function this:Init()

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.Item_btn, self, self.ItemClick)
   
end


function this:UpdateUI(data)
    if table.count(data) > 0 then
        GUI:setVisible(self.view.null_panel, false)
        GUI:setVisible(self.view.have_panel, true)
        self.goods = true
        if not GUI:IsWebGLAsync() then
            if not self.goodsItem then
                self.goodsItem = GUI:UIPanel_Open("dev/outui/Trade/Item/KLTradeGoods/KLTradeGoodsItem",
                    self.view.have_panel,
                    self, nil, true)
            end
            self.goodsInfo = data
            self.goodsItem:UpdateData(data,true)
            GUI:setVisible(self.goodsItem.view.btn_buy, false)
            GUI:setVisible(self.goodsItem.view.btn_xiajia, true)
            self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
                if self.goodsItem then
                    return self.goodsItem:Tick()
                end
            end)
        else
            if not self.goodsItem then
                GUI:UIPanel_Open("dev/outui/Trade/Item/KLTradeGoods/KLTradeGoodsItem", self.view.have_panel,
                    self, nil, true, function(goodsItem)
                        self.goodsItem = goodsItem
                        self.goodsInfo = data
                        self.goodsItem:UpdateData(data,true)
                        self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
                            if self.goodsItem then
                                return self.goodsItem:Tick()
                            end
                        end)
                        GUI:setVisible(self.goodsItem.view.btn_buy, false)
                        GUI:setVisible(self.goodsItem.view.btn_xiajia, true)
                    end)
            else
                self.goodsInfo = data
                self.goodsItem:UpdateData(data,true)
                GUI:setVisible(self.goodsItem.view.btn_buy, false)
                GUI:setVisible(self.goodsItem.view.btn_xiajia, true)
                self.tickTimer = SL:Schedule(self.tickTimer, 0, 1, -1, function()
                    if self.goodsItem then
                        return self.goodsItem:Tick()
                    end
                end)
            end
        end
    end
end

function this:Remove()
    if self.tickTimer then
        SL:UnSchedule(self.tickTimer)
        self.tickTimer = nil
    end
    self.goods = false
    
    self.goodsInfo = {}
    GUI:setVisible(self.view.null_panel, true)
    GUI:setVisible(self.view.have_panel, false)
end

function this:IsGoods()
    return self.goods
end

function this:ItemClick()
    if table.isNullOrEmpty(self.goodsInfo) then
        return
    end
    local type = SL:GetMetaValue(EMetaVarGetKey.ITEMTYPE, self.goodsInfo.itemCfgId)
    local subType = SL:GetMetaValue(EMetaVarGetKey.ITEMSUBTYPE, self.goodsInfo.itemCfgId)
    if type == 9 and subType == 1 then
        SL:OpenTips(nil, self.goodsInfo.itemCfgId, self.goodsInfo.itemId, nil, nil,
            { otherRid = tonumber(self.goodsInfo.ownerId) })
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_GOODS_INFO, { self.goodsInfo.itemId, self.goodsInfo.ownerId })
    end

    --GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeRemove/KLTradeRemovePanel", _, _,
    --    {
    --        cfgId = self.goodsInfo.itemCfgId,
    --        id = self.goodsInfo.itemId,
    --        type = self.goodsInfo.coinType,
    --        price = self
    --            .goodsInfo.unitPrice
    --    })
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.goods = false
end

function this:Close()
    if self.tickTimer then
        SL:UnSchedule(self.tickTimer)
        self.tickTimer = nil
    end
    if self.goodsItem then
        GUI:UIPanel_Close(nil, self.goodsItem)
        self.goodsItem = nil
    end
   
end

return this
