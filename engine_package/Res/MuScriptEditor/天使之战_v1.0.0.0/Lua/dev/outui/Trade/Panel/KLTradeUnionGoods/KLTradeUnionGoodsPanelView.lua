---@class KLTradeUnionGoodsPanelView:UIKmlLuaViewBase
---@field img_48 UIKmlLuaControlHandler
---@field text_49 UIKmlLuaControlHandler
---@field text_50 UIKmlLuaControlHandler
---@field text_51 UIKmlLuaControlHandler
---@field text_52 UIKmlLuaControlHandler
---@field osa_scrollview_union_goods UIKmlLuaControlHandler
local KLTradeUnionGoodsPanelView = {}
setmetatable(KLTradeUnionGoodsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeUnionGoods/KLTradeUnionGoodsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTradeUnionGoodsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeUnionGoodsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Panel/KLTradeUnionGoods/KLTradeUnionGoodsPanel']

return KLTradeUnionGoodsPanelView
