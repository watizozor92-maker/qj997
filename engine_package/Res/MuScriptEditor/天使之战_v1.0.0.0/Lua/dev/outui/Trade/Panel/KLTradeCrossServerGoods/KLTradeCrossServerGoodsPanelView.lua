---@class KLTradeCrossServerGoodsPanelView:UIKmlLuaViewBase
---@field img_125 UIKmlLuaControlHandler
---@field text_126 UIKmlLuaControlHandler
---@field text_127 UIKmlLuaControlHandler
---@field text_128 UIKmlLuaControlHandler
---@field text_129 UIKmlLuaControlHandler
---@field osa_scrollview_crossServer_goods UIKmlLuaControlHandler
local KLTradeCrossServerGoodsPanelView = {}
setmetatable(KLTradeCrossServerGoodsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeCrossServerGoods/KLTradeCrossServerGoodsPanelKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLTradeCrossServerGoodsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeCrossServerGoodsPanelView
