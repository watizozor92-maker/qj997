---@class KLTradeCrossServerBuyPanel:UIKmlLuaPanelBase
---@field view KLTradeCrossServerBuyPanelView
local KLTradeCrossServerBuyPanel = class(UIKmlLuaPanelBase)
local this =KLTradeCrossServerBuyPanel
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close,self,self.BtnCloseOnClick)
    GUI:AddOnClickEvent(self.view.btn_buy,self,self.BtnBuyOnClick)

end

function this:BtnCloseOnClick()
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeCrossServerBuy/KLTradeCrossServerBuyPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTipsComparsion/KLUIEquipTipsComparsionPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLIUItemTipsOtherPanel")
end

function this:BtnBuyOnClick()
    if self.isBidding then
        SL:CommonTipsMessage({  showTips = "确认竞拍", ui = self, sureBtnText = "确定", cancelBtnText = "取消",
                               callback = function()
                                self:Buy()
                               end })
    else
        SL:CommonTipsMessage({ showTips = "确认以一口价的价格购买", ui = self, sureBtnText = "确定", cancelBtnText = "取消",
                               callback = function()
                                self:Buy()
                               end })
    end
    
end

function this:Buy()
    if self.isBidding then
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_KUN_DUN_AUCTION_BIDDING,{goodsId=self.id,type=0})
    else
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_KUN_DUN_AUCTION_BIDDING,{goodsId=self.id,type=1})
    end
    self:BtnCloseOnClick()
end

---创建或者刷新界面数据时调用
function this:Refresh()
    self.moneyType = self.args.moneyType
    --self.itemId = self.args.itemId
    self.id = self.args.id
    self.price = self.args.price
    self.isBidding = self.args.isBidding
    self.increment = self.args.increment
    self.oneprice = self.args.oneprice
    
    GUI:Image_loadTexture(self.view.img_coin_icon,self:GetCoinIcon(self.moneyType),"Atlas/UIBagPanel.spriteatlas")
    local ownMoney = SL:GetBagItemCount(self.moneyType)
    --[[---@type cfg_stall_column
    local stallTbl = SL:GetConfig("cfg_stall",self.itemId)]]
    if self.isBidding then
        --local bindingPrice = math.ceil(self.price * (1+self.increment / 10000))
        local bindingPrice = self.price
        GUI:Text_setString(self.view.txt_price,tostring(bindingPrice))
        GUI:Text_setTextColor(self.view.txt_price,ownMoney >= bindingPrice and "#00ff00" or "#FF2323")
    else
        GUI:Text_setString(self.view.txt_price,tostring(self.oneprice))
        GUI:Text_setTextColor(self.view.txt_price,ownMoney >= self.oneprice and "#00ff00" or "#FF2323")
    end
    GUI:Text_setString(self.view.btn_buy,self.isBidding and "竞价" or "购买")
end

function this:Close()
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

function this:RES_KUN_DUN_AUCTION_BUY_RESULT(_id,message)
    SL:LogError("RES_KUN_DUN_AUCTION_BUY_RESULT")
    SL:LogTable(message,true)
end

return this
