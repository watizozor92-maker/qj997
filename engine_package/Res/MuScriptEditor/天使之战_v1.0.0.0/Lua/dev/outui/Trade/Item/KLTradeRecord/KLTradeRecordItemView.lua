---@class KLTradeRecordItemView:UIKmlLuaViewBase
---@field img_413 UIKmlLuaControl
---@field img_item_bg UIKmlLuaControl
---@field txt_item_name UIKmlLuaControl
---@field txt_time UIKmlLuaControl
---@field txt_trade_type UIKmlLuaControl
---@field layout1 UIKmlLuaControl
---@field img_coin_icon UIKmlLuaControl
---@field txt_price UIKmlLuaControl
local KLTradeRecordItemView = {}
setmetatable(KLTradeRecordItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Item/KLTradeRecord/KLTradeRecordItemKml'
---@param parent UIKmlLuaControl
function KLTradeRecordItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeRecordItemView
