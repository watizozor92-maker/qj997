---@class KLTradeRecordItem:UIKmlLuaPanelBase
---@field view KLTradeRecordItemView
local KLTradeRecordItem = class(UIKmlLuaPanelBase)
local this =KLTradeRecordItem
---创建时调用一次
function this:Init()
    
end

---注册UI事件和服务器消息
function this:RegistEvents()
end

---创建或者刷新界面数据时调用
function this:Refresh()
end

---@param itemData TradeRecordItemData
function this:UpdateItem(itemData,index)
    GUI:Text_setString(self.view.txt_item_name,itemData.itemname)
    local seconds = itemData.time // 1000
    local formatted_time = os.date("%Y-%m-%d %H:%M:%S", seconds)
    GUI:Text_setString(self.view.txt_time,formatted_time)
    local tradetypename = "购买"
    if itemData.tradetype == 2 then
        tradetypename = "售出"
    elseif itemData.tradetype == 0 then
        tradetypename = "预购"
    end
    GUI:Text_setString(self.view.txt_trade_type,tradetypename)
    
    GUI:Image_loadTexture(self.view.img_coin_icon,self:GetCoinIcon(tonumber(itemData.cointype)),"Atlas/UIBagPanel.spriteatlas")
    if itemData.tradetype == 1 or itemData.tradetype == 0 then
        GUI:Text_setString(self.view.txt_price,"-" .. tostring(itemData.price))
        GUI:Text_setTextColor(self.view.txt_price,"#FF2323")
        GUI:Text_setTextColor(self.view.txt_trade_type,"#FF2323")
    else
        GUI:Text_setString(self.view.txt_price,"+" .. tostring(itemData.price))
        GUI:Text_setTextColor(self.view.txt_price,"#00ff00")
        GUI:Text_setTextColor(self.view.txt_trade_type,"#00ff00")
    end
    
    GUI:setVisible(self.view.img_item_bg,index % 2 == 0)
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
    return tostring(coinType)
end

function this:Close()
end

return this
