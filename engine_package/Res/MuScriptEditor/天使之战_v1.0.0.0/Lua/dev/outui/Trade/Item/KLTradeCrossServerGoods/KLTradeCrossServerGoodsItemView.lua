---@class KLTradeCrossServerGoodsItemView:UIKmlLuaViewBase
---@field img_200 UIKmlLuaControl
---@field btn_item_tips UIKmlLuaControl
---@field item_award UIKmlLuaControl
---@field text_name UIKmlLuaControl
---@field text_time UIKmlLuaControl
---@field panel_205 UIKmlLuaControl
---@field btn_bidding_price UIKmlLuaControl
---@field text_state UIKmlLuaControl
---@field layout1 UIKmlLuaControl
---@field img_money_icon_cur UIKmlLuaControl
---@field text_cur_price UIKmlLuaControl
---@field panel_210 UIKmlLuaControl
---@field btn_buy UIKmlLuaControl
---@field layout2 UIKmlLuaControl
---@field img_money_icon_buy UIKmlLuaControl
---@field text_buy_price UIKmlLuaControl
local KLTradeCrossServerGoodsItemView = {}
setmetatable(KLTradeCrossServerGoodsItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Item/KLTradeCrossServerGoods/KLTradeCrossServerGoodsItemKml'
---@param parent UIKmlLuaControl
function KLTradeCrossServerGoodsItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeCrossServerGoodsItemView
