---@class KLTradeBuyPanel:UIKmlLuaPanelBase
---@field view KLTradeBuyPanelView
local KLTradeBuyPanel = class(UIKmlLuaPanelBase)
local this = KLTradeBuyPanel
---创建时调用一次
function this:Init()

end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.BtnCloseClick)
    GUI:AddOnClickEvent(self.view.btn_buy, self, self.BtnBuyOnClick)
    GUI:Input_SetOnEndEdit(self.view.input_count, self, self.InputCountEndEdit)
    GUI:AddOnClickEvent(self.view.btn_add, self, self.BtnAddOnClick)
    GUI:AddOnClickEvent(self.view.btn_minus, self, self.BtnSubOnClick)
end

function this:BtnAddOnClick()
    ---@type KLTradeGoodsItemData
    local data = self.args
    local count = tonumber(GUI:Text_getString(self.view.input_count))
    count = count + self.minNumber
    if count >= data.count then
        count = data.count
    end
    GUI:Text_setString(self.view.input_count, tostring(count))
    self:RefreshPrice()
end

function this:BtnSubOnClick()
    local count = tonumber(GUI:Text_getString(self.view.input_count))
    count = count - self.minNumber
    if count <= self.minNumber then
        count = self.minNumber
    end
    
    GUI:Text_setString(self.view.input_count, tostring(count))
    self:RefreshPrice()
end

function this:InputCountEndEdit()
    local count = tonumber(GUI:Text_getString(self.view.input_count))
    count = math.floor(count / self.minNumber)
    count = count * self.minNumber
    if count < self.minNumber then
        count = self.minNumber
    end
    ---@type KLTradeGoodsItemData
    local data = self.args
    if count > data.count then
        count = data.count
    end
    GUI:Text_setString(self.view.input_count, tostring(count))
    self:RefreshPrice()
end

function this:IsCanBuy()
    if EquipFunc.GetItemIsBind(self.args.cointype) then
        local count = SL:GetBagBindItemCount()
        if count >= self.args.price then
            return true
        end
    end
    local count = SL:GetBagItemCount(self.args.cointype,false)
    if count >= self.args.totalprice then
        return true
    end
    return false
end

function this:BtnBuyOnClick()
    local IsNeedMonthCard, IsNeedDailyCard = InfoManager.monthCardInfo:IsNeedMonthAndDailyCard("stall")
    if IsNeedDailyCard and InfoManager.monthCardInfo.IsGetDailyCard and not InfoManager.monthCardInfo.IsGetMonthCard then
        ---获得了月卡
        if InfoManager.monthCardInfo:IsBanType(self.args.type, self.args.subtype, false) then
            SL:TipMessage( SL:GetConfig('cfg_string', 440).text, 1, NoticeType.NoticeMid )--"开通月卡后可使用交易行功能",
            return
        end
    end
    if not InfoManager.monthCardInfo:IsHaveMonthCardRights("stall") then
        SL:TipMessage( SL:GetConfig('cfg_string', 278).text, 1, NoticeType.NoticeMid )--"开通月卡后可使用交易行功能",
        return
    end
    if not self:IsCanBuy() then
        SL:TipMessage("当前货币不足",1, NoticeType.NoticeMid)
        return
    end
    ---@type KLTradeGoodsItemData
    local data = self.args
    if data.publicity == 1 then
        --[[        local message = {stringTblID=225,
                    showTips = "公示期结束后从预购玩家中<color=#00ff00>抽取一位获得该商品</color>\n其他玩家邮件返还预购货币",
                    title = "提示",
                    callback = function()
                        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_PRE_ORDER,{data.itemcfgid,data.itemid,data.type})
                    end
                }]]
        SL:CommonTipsMessage({ stringTblID = 225,
                               title = "提示",
                               callback = function()
                                   SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_PRE_ORDER, { data.itemcfgid, data.itemid, data.type, data.ownid })
                               end
        })
    else
        local count = tonumber(GUI:Text_getString(self.view.input_count))
        SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_BUY_GOODS, { data.itemcfgid, data.itemid, data.type, count, data.ownid })
    end
    self:BtnCloseClick()

end

function this:BtnCloseClick()
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeBuy/KLTradeBuyPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTipsComparsion/KLUIEquipTipsComparsionPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGrailTips/KLArchangelGrailTipsPanel")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    ---@type KLTradeGoodsItemData
    local data = self.args
    self.minNumber = SL:GetConfig("cfg_stall",data.itemcfgid,"id").minNumber
    GUI:Image_loadTexture(self.view.img_coin_icon, data.cointype, "Atlas/UIBagPanel.spriteatlas")

    GUI:Text_setString(self.view.btn_buy, data.publicity == 1 and "预购" or "购买")
    GUI:setVisible(self.view.group_input_count, data.publicity ~= 1)
    GUI:Text_setString(self.view.input_count,tostring(self.minNumber))
    self:RefreshPrice()
end

function this:RefreshPrice()
    ---@type KLTradeGoodsItemData
    local data = self.args
    local count
    local minNumber = SL:GetConfig("cfg_stall",data.itemcfgid,"id").minNumber
    if data.publicity == 1 then
        count = data.count
    else
        count = tonumber(GUI:Text_getString(self.view.input_count))
    end
    local unit = ""
    if data.cointype == "30030305" then
        unit = "天"
    end
    if not data.unitPrice then
        data.unitPrice = 0
    end
    local price = data.unitPrice * count / minNumber
    price = math.floor(price)
    GUI:Text_setString(self.view.txt_price, tostring(price) .. unit)
end

function this:Close()
end

--[[function this:GetCoinIcon(coinType)
    if coinType == 10010001 then
        return "img_bag_01"
    elseif coinType == 10020001 then
        return "img_bag_02"
    elseif coinType == 10030001 then
        return "img_bag_03"
    elseif coinType == 10040001 then
        return "img_bag_04"
    end
end]]

return this
