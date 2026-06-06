---@class KLTradeCrossServerGoodsItem:UIKmlLuaPanelBase
---@field view KLTradeCrossServerGoodsItemView
local KLTradeCrossServerGoodsItem = class(UIKmlLuaPanelBase)
local this =KLTradeCrossServerGoodsItem
---创建时调用一次
function this:Init()
    self.updateID = SL:Schedule(self.updateID,0,1,-1,function()
        self:Tick()
    end)
end



---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_item_tips,self,self.BtnItemTipsOnClick)
    GUI:AddOnClickEvent(self.view.btn_bidding_price,self,self.BtnBiddingPriceOnClick)
    GUI:AddOnClickEvent(self.view.btn_buy,self,self.BtnBuyOnClick)

    SL:RegisterLuaNetMsg(LuaMessageIdToClient.RES_KUN_DUN_AUCTION_BUY_RESULT,self.RES_KUN_DUN_AUCTION_BUY_RESULT,self)
end

function this:BtnBuyOnClick()
    SL:OpenTips(nil,self.curItemId,nil,nil,nil)
    --SL:LogError("self.oneprice  "..self.oneprice)
    GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeCrossServerBuy/KLTradeCrossServerBuyPanel",nil,nil,
            {moneyType = self.moneyType,price = 0,isBidding=false,id=self.curId,oneprice = self.oneprice})
end

function this:BtnBiddingPriceOnClick()
    SL:OpenTips(nil,self.curItemId,nil,nil,nil,{hideMask=true})
    --SL:LogError("self.price  "..self.price)
    GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeCrossServerBuy/KLTradeCrossServerBuyPanel",nil,nil,
            {moneyType = self.moneyType,increment = self.increment,price = self.price,isBidding=true,id=self.curId})
end

function this:BtnItemTipsOnClick()
    if not self.curItemId then
        return
    end
    --SL:OpenTips(nil,self.curItemId)
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WAR_ALLIANCE_GOODS_DETAIL,{itemId=self.curId,type=self.type})
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

function this:Close()
    self.endTime = nil
    if self.updateID then
        SL:UnSchedule(self.updateID)
        self.updateID = nil
    end
end

---@class KLTradeCrossServerGoodsItemData
---@field itemcfgid string
---@field endtime string
---@field price string
---@field cointype string
---@field itemid number
---@field oneprice number
---@field increment number
---@field state string

---@param data KLTradeCrossServerGoodsItemData
function this:SetData(data)
    
    local itemId = tonumber(data.cfgid)
    GUI:Item_setItemId(self.view.item_award,itemId)
    GUI:Item_UpdataData(self.view.item_award,{itemcount=data.count})
    ---@type cfg_item_column
    local item = SL:GetConfig("cfg_item",itemId)
    GUI:Text_setString(self.view.text_name,item.name)
    local coinType = tonumber(data.coinType)
    local ownMoney = SL:GetBagItemCount(coinType)
    GUI:Text_setString(self.view.text_cur_price,tostring(data.price))
    GUI:Text_setTextColor(self.view.text_cur_price,ownMoney >= data.price and "#00ff00" or "#FF2323")
    GUI:Image_loadTexture(self.view.img_money_icon_cur,self:GetCoinIcon(coinType),"Atlas/UIBagPanel.spriteatlas")
    GUI:Image_loadTexture(self.view.img_money_icon_buy,self:GetCoinIcon(coinType),"Atlas/UIBagPanel.spriteatlas")
    
    GUI:Text_setString(self.view.text_buy_price,tostring(data.fixedPrice))
    GUI:Text_setTextColor(self.view.text_buy_price,ownMoney >= data.fixedPrice and "#00ff00" or "#FF2323")
    --GUI:Text_setString(self.view.text_state,data.state)
    local my_rid = SL:GetMetaValue(EMetaVarGetKey.UID)
    local bidderId = data.bidderId
    if bidderId and bidderId ~= 0 then
        if bidderId == my_rid then
            GUI:Text_setString(self.view.text_state,"我的竞拍")
        else
            GUI:Text_setString(self.view.text_state,"竞拍中")
        end
    else
        GUI:Text_setString(self.view.text_state,"")
    end
    
    self.curItemId = itemId
    self.curId = data.id
    self.moneyType = tonumber(data.coinType)
    self.endTime = tonumber(data.endTime)
    self.price = tonumber(data.price)
    self.oneprice = data.fixedPrice
    self.increment = data.auction
    self.type = data.type
    self.data = data
    self:Tick()
end

function this:GetCoinIcon(coinType)
    if coinType == 10010001 then
        return "img_bag_01"
    elseif coinType == 10020001 then
        return "img_bag_02"
    elseif coinType == 10030001 then
        return "img_bag_03"
    elseif coinType == 10040001 then
        return "img_bag_04"
    end
end

function this:Tick()
    if not self.endTime then
        return
    end
    if not self.view then
        return
    end
    local server_time = SL:GetMetaValue(EMetaVarGetKey.SERVER_TIME)
    local timeLeft = (self.endTime - server_time) // 1000
    if timeLeft >= 0 then
        local timeLeftStr = SL:SecondToHMS(timeLeft,true)
        GUI:Text_setString(self.view.text_time,timeLeftStr)
    else
        GUI:Text_setString(self.view.text_time,"")
        return self.data
    end

end

function this:RES_KUN_DUN_AUCTION_BUY_RESULT(_id,message)
    if  message.goods and message.goods.id == self.curId then
       
        self:SetData(message.goods)
    end
end

return this
