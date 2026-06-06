---@class KLShowStallGoodsItemView:UIKmlLuaViewBase
---@field btn_goods_item UIKmlLuaControlHandler
---@field scroll_text_template UIKmlLuaControlHandler
---@field KmlScrollTextTemplate UIKmlLuaControlHandler
---@field txt_item_name UIKmlLuaControlHandler
---@field monthCardText UIKmlLuaControlHandler
---@field zhuoyue UIKmlLuaControlHandler
---@field strengthLevel_ UIKmlLuaControlHandler
---@field appendLevel_ UIKmlLuaControlHandler
---@field arrow_ UIKmlLuaControlHandler
---@field imgQuality UIKmlLuaControlHandler
---@field xingyun UIKmlLuaControlHandler
---@field icon_career_bg UIKmlLuaControlHandler
---@field icon_career UIKmlLuaControlHandler
---@field item UIKmlLuaControlHandler
---@field img_favor_count UIKmlLuaControlHandler
---@field txt_favor_count UIKmlLuaControlHandler
---@field itemCount UIKmlLuaControlHandler
---@field txt_count_down UIKmlLuaControlHandler
---@field btn_xiajia UIKmlLuaControlHandler
---@field img_coin_type UIKmlLuaControlHandler
---@field txt_price UIKmlLuaControlHandler
---@field btn_buy UIKmlLuaControlHandler
local KLShowStallGoodsItemView = {}
setmetatable(KLShowStallGoodsItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLShowStallGoodsItem/KLShowStallGoodsItemKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLShowStallGoodsItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLShowStallGoodsItemView
