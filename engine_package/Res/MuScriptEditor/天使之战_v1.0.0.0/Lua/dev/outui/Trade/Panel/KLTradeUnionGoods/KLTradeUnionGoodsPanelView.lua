---@class KLTradeUnionGoodsPanelView:UIKmlLuaViewBase
---@field img_48 UIKmlLuaControl
---@field text_49 UIKmlLuaControl
---@field text_50 UIKmlLuaControl
---@field text_51 UIKmlLuaControl
---@field text_52 UIKmlLuaControl
---@field osa_scrollview_union_goods UIKmlLuaControl
local KLTradeUnionGoodsPanelView = {}
setmetatable(KLTradeUnionGoodsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeUnionGoods/KLTradeUnionGoodsPanelKml'
---@param parent UIKmlLuaControl
function KLTradeUnionGoodsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeUnionGoodsPanelView
