---@class KLTradeUnionGoodsItemView:UIKmlLuaViewBase
---@field img_271 UIKmlLuaControl
---@field btn_item_tips UIKmlLuaControl
---@field item_award UIKmlLuaControl
---@field text_name UIKmlLuaControl
---@field text_time UIKmlLuaControl
---@field panel_276 UIKmlLuaControl
---@field btn_bidding_price UIKmlLuaControl
---@field text_state UIKmlLuaControl
---@field layout1 UIKmlLuaControl
---@field img_money_icon_cur UIKmlLuaControl
---@field text_cur_price UIKmlLuaControl
---@field panel_281 UIKmlLuaControl
---@field btn_buy UIKmlLuaControl
---@field layout5 UIKmlLuaControl
---@field img_money_icon_buy UIKmlLuaControl
---@field text_buy_price UIKmlLuaControl
local KLTradeUnionGoodsItemView = {}
setmetatable(KLTradeUnionGoodsItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Item/KLTradeUnionGoods/KLTradeUnionGoodsItemKml'
---@param parent UIKmlLuaControl
function KLTradeUnionGoodsItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeUnionGoodsItemView
