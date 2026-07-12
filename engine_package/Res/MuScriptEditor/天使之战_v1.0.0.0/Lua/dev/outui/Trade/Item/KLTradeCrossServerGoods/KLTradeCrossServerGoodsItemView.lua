---@class KLTradeCrossServerGoodsItemView:UIKmlLuaViewBase
---@field img_200 UIKmlLuaControlHandler
---@field btn_item_tips UIKmlLuaControlHandler
---@field item_award UIKmlLuaControlHandler
---@field text_name UIKmlLuaControlHandler
---@field text_time UIKmlLuaControlHandler
---@field panel_205 UIKmlLuaControlHandler
---@field btn_bidding_price UIKmlLuaControlHandler
---@field text_state UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field img_money_icon_cur UIKmlLuaControlHandler
---@field text_cur_price UIKmlLuaControlHandler
---@field panel_210 UIKmlLuaControlHandler
---@field btn_buy UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field img_money_icon_buy UIKmlLuaControlHandler
---@field text_buy_price UIKmlLuaControlHandler
local KLTradeCrossServerGoodsItemView = {}
setmetatable(KLTradeCrossServerGoodsItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Item/KLTradeCrossServerGoods/KLTradeCrossServerGoodsItemKml'
---@param parent UIKmlLuaControlHandler
function KLTradeCrossServerGoodsItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeCrossServerGoodsItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Item/KLTradeCrossServerGoods/KLTradeCrossServerGoodsItem']

return KLTradeCrossServerGoodsItemView
