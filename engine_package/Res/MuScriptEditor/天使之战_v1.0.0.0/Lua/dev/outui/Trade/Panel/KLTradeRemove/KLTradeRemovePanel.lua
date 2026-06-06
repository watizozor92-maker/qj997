---@class KLTradeRemovePanel:UIKmlLuaPanelBase
---@field view KLTradeRemovePanelView
local KLTradeRemovePanel = class(UIKmlLuaPanelBase)
local this = KLTradeRemovePanel
---创建时调用一次
function this:Init()
    -- SL:OpenTips(_, self.args.cfgId, self.args.id)
end

---注册UI事件和服务器消息
function this:RegistEvents()
    GUI:AddOnClickEvent(self.view.btn_close, self, self.ClosePanel)
    GUI:AddOnClickEvent(self.view.btn, self, self.BtnClick)
end

function this:ClosePanel()
    GUI:UIPanel_Close("dev/outui/Trade/Panel/KLTradeRemove/KLTradeRemovePanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel")
    GUI:UIPanel_Close("dev/ui/Tips/Panel/KLUIEquipTipsComparsion/KLUIEquipTipsComparsionPanel")
    GUI:UIPanel_Close("dev/outui/Archangel/Panel/KLArchangelGrailTips/KLArchangelGrailTipsPanel")
end

---创建或者刷新界面数据时调用
function this:Refresh()
    --local src = self:GetCoinIcon(tonumber(self.args.type))
    local tbl = SL:GetConfig("cfg_stall", self.args.cfgId, "id")
    GUI:Image_loadTexture(self.view.img_coin_unit, tostring(tbl.money), "Atlas/UIBagPanel.spriteatlas")
    if tbl.money == 30030305 then
        GUI:Text_setString(self.view.txt_price_unit, tostring(self.args.price).."天")
    else
        GUI:Text_setString(self.view.txt_price_unit, tostring(self.args.price))
    end
    
end

function this:BtnClick()
    local data = { self.args.cfgId, self.args.id }
    SL:SendLuaNetMsg(LuaMessageIdToSever.REQ_TRADE_OFF_GOODS, data)
    self:ClosePanel()
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

function this:Close()
end

return this
