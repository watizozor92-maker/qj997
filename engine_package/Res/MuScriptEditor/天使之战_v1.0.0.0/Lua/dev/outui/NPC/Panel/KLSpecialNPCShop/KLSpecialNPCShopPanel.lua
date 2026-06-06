---@class KLSpecialNPCShopPanel:UIKmlLuaPanelBase
---@field view KLSpecialNPCShopPanelView

---@field goods NpcShopProto.NpcShopGoodsInfoRes
local KLNPCShopPanel = class(UIKmlLuaPanelBase)
local this = KLNPCShopPanel
---创建时调用一次
function this:Init()
    SL:HideMainPanel()
    self.goods = {}
end

---创建或者刷新界面数据时调用
function this:Refresh()
    if SL:HasConfig("cfg_global",25001) then
        ---@type cfg_global_column
        local tbl = SL:GetConfig("cfg_global",25001)
        GUI:Text_setString(self.view.noItem,tbl.value)
    end
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_NPC_CHEST_GOODS_INFO,{shopId=tonumber(self.args)})
    self:UpdateMoney()
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel", nil, nil, { x = -415, y = 0, bagType = EBagShowType.NPCShop })
end

---@param message NpcShopProto.NpcShopGoodsInfoRes @商品信息响应
function this:RES_NPC_CHEST_GOODS_INFO(_, message)
    table.clear(self.goods)

    for _, v in pairs(message) do
        if type(v) == "table" then
            table.insert(self.goods,v)
        end
    end
    
    table.sort(self.goods, function(a, b)
        return a.id < b.id
    end)
    GUI:setVisible(self.view.noItem,#self.goods<=0)
    self:RefreshGoodsUI()
end

function this:RefreshGoodsUI()
    GUI:UIPanel_Open("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel", nil, nil, { x = -415, y = 0, bagType = EBagShowType.NPCShop })
    GUI:DataListInitData(self.view.goods, function()
        return table.count(self.goods)
    end, function(realIndex)
        --return self:DataListGoodsItemGetFunc(realIndex)
    end, function(realIndex, kmlcontrol)
        --return self:DataListGoodsItemInitFunc(realIndex, kmlcontrol)
    end, function(realIndex, kmlcontrol)
        return self:DataListGoodsItemUpdateFunc(realIndex, kmlcontrol)
    end)
    GUI:DataListUpdateData(self.view.goods)
end

function this:DataListGoodsItemUpdateFunc(realIndex, kmlcontrol)
    local data = self.goods[realIndex + 1]
    local showItem_ = GUI:GetChildControl(self.view.goods,realIndex, "showItem_")
    ---@type cfg_npcChest_column
    local gooditem = SL:GetConfig("cfg_npcChest", data.id,"id" )
    GUI:Item_UpdataData(showItem_, {
        itemid = gooditem.itemId[1],
        itemcount = gooditem.itemId[2]
    })
    local itemclick =GUI:GetChildControl(self.view.goods,realIndex, "itemclick")
    GUI:AddOnClickEvent(itemclick, self, function()
        SL:OpenTips(nil,gooditem.itemId[1])
    end)
    local title_ =GUI:GetChildControl(self.view.goods,realIndex, "title_")

    GUI:Text_setString(title_, gooditem.itemName)
    local coinitem =GUI:GetChildControl(self.view.goods,realIndex, "coinitem")
    GUI:Item_setItemId(coinitem, data.coinType)
    local coinClick =GUI:GetChildControl(self.view.goods,realIndex, "coinClick")
    GUI:AddOnClickEvent(coinClick, self, function()
        SL:OpenTips(nil, data.coinType)
    end)
    local coinnum =GUI:GetChildControl(self.view.goods,realIndex, "coinnum")
    GUI:Text_setString(coinnum, tostring(data.unitPrice * data.count))
    local buy =GUI:GetChildControl(self.view.goods,realIndex, "buy")
    GUI:AddOnClickEvent(buy, self, function()
        local ownerCount = SL:GetBagItemCount(data.coinType)
        if ownerCount < data.unitPrice * data.count then
            SL:TipMessage("货币不足",1,NoticeType.NoticeMid)
            return
        end
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_BUY_NPC_CHEST,{shopId = tonumber(self.args),goodsId= data.id,count = data.count})
    end)
end

function this:TipCard()
    local text = SL:GetConfig("cfg_string",229,"id").text
    SL:CommonTipsMessage({  stringTblID=229,showTips = text, ui = self, sureBtnText = "确定", cancelBtnText = "取消",
            callback = self.OpenFirsh})
end

function this:UpdateAutoBuy()
end

function this:OpenFirsh()
    this:ClosePanel()
    GUI:UIPanel_Open("dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel",nil,nil,{2})
end

function this:DesBtn()
    local helpCfg = SL:GetConfig("cfg_rule_text", 201,"id")
    if helpCfg then
        SL:CommonStrTipsMessage({ title = helpCfg.menutxt, str = helpCfg.location })
    end
end
---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.CloseButton, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.desButton, self, self.DesBtn)
    GUI:AddOnClickEvent(self.view.moneyBackground, self, function()
        SL:OpenTips(nil, 10010001)
    end)
    GUI:AddOnClickEvent(self.view.MUCoinBackground, self, function()
        SL:OpenTips(nil, 10020001)
    end)
    SL:RegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.UpdateMoney, self)
    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_NPC_CHEST_GOODS_INFO, self.RES_NPC_CHEST_GOODS_INFO, self)

end

--刷新货币数据
function this:UpdateMoney()
    GUI:Text_setString(self.view.moneyText, tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.GoldMoney)))
    GUI:Text_setString(self.view.muCoinText, tostring(SL:GetMetaValue(EMetaVarGetKey.MONEY, MUEResourceType.MiracleCurrency)))
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/NPC/Panel/KLSpecialNPCShop/KLSpecialNPCShopPanel")
end

function this:Close()
    SL:UnRegisterLUAEvent(LUA_EVENT_MONEYCHANGE, self.UpdateMoney, self)
    GUI:UIPanel_Close("dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel")
    SL:ShowMainPanel()
    table.clear(self.goods)
end

return this
