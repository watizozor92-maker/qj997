---@class KLTradeCrossServerBuyPanelView:UIKmlLuaViewBase
---@field btn_close UIKmlLuaControlHandler
---@field img_103 UIKmlLuaControlHandler
---@field panel_104 UIKmlLuaControlHandler
---@field text_105 UIKmlLuaControlHandler
---@field img_106 UIKmlLuaControlHandler
---@field img_coin_icon UIKmlLuaControlHandler
---@field txt_price UIKmlLuaControlHandler
---@field btn_buy UIKmlLuaControlHandler
local KLTradeCrossServerBuyPanelView = {}
setmetatable(KLTradeCrossServerBuyPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeCrossServerBuy/KLTradeCrossServerBuyPanelKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLTradeCrossServerBuyPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeCrossServerBuyPanelView
