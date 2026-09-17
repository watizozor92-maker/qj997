---@class KLTradeRecordItemView:UIKmlLuaViewBase
---@field img_413 UIKmlLuaControlHandler
---@field img_item_bg UIKmlLuaControlHandler
---@field txt_item_name UIKmlLuaControlHandler
---@field txt_time UIKmlLuaControlHandler
---@field txt_trade_type UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field img_coin_icon UIKmlLuaControlHandler
---@field txt_price UIKmlLuaControlHandler
local KLTradeRecordItemView = {}
setmetatable(KLTradeRecordItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Item/KLTradeRecord/KLTradeRecordItemKml'
---@param parent UIKmlLuaControlHandler
function KLTradeRecordItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeRecordItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Item/KLTradeRecord/KLTradeRecordItem']

return KLTradeRecordItemView
