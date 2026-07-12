---@class KLTradeGoodsItemView:UIKmlLuaViewBase
---@field Node UIKmlLuaControlHandler
---@field scroll_text_template UIKmlLuaControlHandler
---@field KmlScrollTextTemplate UIKmlLuaControlHandler
---@field txt_item_name UIKmlLuaControlHandler
---@field btn_goods_item UIKmlLuaControlHandler
---@field item UIKmlLuaControlHandler
---@field txt_count_down UIKmlLuaControlHandler
---@field img_coin_type UIKmlLuaControlHandler
---@field monthCardText UIKmlLuaControlHandler
---@field txt_price UIKmlLuaControlHandler
---@field img_favor_count UIKmlLuaControlHandler
---@field txt_favor_count UIKmlLuaControlHandler
---@field icon_career_bg UIKmlLuaControlHandler
---@field icon_career UIKmlLuaControlHandler
---@field btn_buy UIKmlLuaControlHandler
---@field btn_xiajia UIKmlLuaControlHandler
---@field zhuoyue UIKmlLuaControlHandler
---@field strengthLevel_ UIKmlLuaControlHandler
---@field appendLevel_ UIKmlLuaControlHandler
---@field imgQuality UIKmlLuaControlHandler
---@field arrow_ UIKmlLuaControlHandler
---@field xinyun UIKmlLuaControlHandler
local KLTradeGoodsItemView = {}
setmetatable(KLTradeGoodsItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Item/KLTradeGoods/KLTradeGoodsItemKml'
---@param parent UIKmlLuaControlHandler
function KLTradeGoodsItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeGoodsItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Item/KLTradeGoods/KLTradeGoodsItem']

return KLTradeGoodsItemView
