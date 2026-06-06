---@class KLTradeUnionGoodsItem:UIKmlLuaPanelBase
---@field view KLTradeUnionGoodsItemView
local KLTradeUnionGoodsItem = class(UIKmlLuaPanelBase)
local this =KLTradeUnionGoodsItem
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
end

function this:BtnBuyOnClick()
    SL:CommonTipsMessage({ showTips = "确认以一口价的价格购买", ui = self, sureBtnText = "确定", cancelBtnText = "取消",
                           callback = function()
                               self:Buy(false)
                           end })
  
    ----SL:LogError("self.oneprice  "..self.oneprice)
    --GUI:UIPanel_Open("dev/outui/Trade/Panel/KLTradeUnionBuy/KLTradeUnionBuyPanel",nil,nil,
    --        {moneyType = self.moneyType,price = 0,isBidding=false,id=self.curId,oneprice = self.oneprice})
end

function this:Buy(isBidding)
    if isBidding then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WAR_ALLIANCE_BID_GOODS,{goodsId=self.curId,type=0})
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_WAR_ALLIANCE_BUY_NOW,{goodsId=self.curId,type=1})
    end
end

function this:BtnBiddingPriceOnClick()
    SL:CommonTipsMessage({  showTips = "确认竞拍", ui = self, sureBtnText = "确定", cancelBtnText = "取消",
                            callback = function()
                                self:Buy(true)
                            end })
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

---@class KLTradeUnionGoodsItemData
---@field itemcfgid string
---@field endtime string
---@field price string
---@field cointype string
---@field itemid number
---@field oneprice number
---@field increment number
---@field state string

---@param data KLTradeUnionGoodsItemData
function this:SetData(data)
    
    local itemId = data.itemcfgid
    GUI:Item_setItemId(self.view.item_award,itemId)
    GUI:Item_UpdataData(self.view.item_award,{itemcount=data.count})
    ---@type cfg_item_column
    local item = SL:GetConfig("cfg_item",itemId)
    GUI:Text_setString(self.view.text_name,item.name)
    local coinType = tonumber(data.cointype)
    local ownMoney = SL:GetBagItemCount(coinType)
    GUI:Text_setString(self.view.text_cur_price,tostring(data.price))
    GUI:Text_setTextColor(self.view.text_cur_price,ownMoney >= data.price and "#00ff00" or "#FF2323")
    GUI:Image_loadTexture(self.view.img_money_icon_cur,tostring(coinType),"Atlas/UIBagPanel.spriteatlas")
    GUI:Image_loadTexture(self.view.img_money_icon_buy,tostring(coinType), "Atlas/UIBagPanel.spriteatlas")
    
    GUI:Text_setString(self.view.text_buy_price,tostring(data.oneprice))
    GUI:Text_setTextColor(self.view.text_buy_price,ownMoney >= data.oneprice and "#00ff00" or "#FF2323")
    --GUI:Text_setString(self.view.text_state,data.state)
    local my_rid = SL:GetMetaValue(EMetaVarGetKey.UID)
    local bidderId = data.bidderid
    if bidderId and bidderId ~= 0 then
        if bidderId.id == my_rid then
            GUI:Text_setString(self.view.text_state,"我的竞拍")
        else
            GUI:Text_setString(self.view.text_state,"竞拍中")
        end
    else
        GUI:Text_setString(self.view.text_state,"")
    end
    
    self.curItemId = itemId
    self.curId = data.itemid
    self.moneyType = tonumber(data.cointype)
    self.endTime = tonumber(data.endtime)
    self.price = tonumber(data.price)
    self.oneprice = data.oneprice
    self.increment = data.increment
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

return this
