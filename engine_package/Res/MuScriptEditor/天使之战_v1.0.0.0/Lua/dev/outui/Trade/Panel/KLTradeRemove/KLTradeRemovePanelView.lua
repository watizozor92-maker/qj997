---@class KLTradeRemovePanelView:UIKmlLuaViewBase
---@field btn_close UIKmlLuaControlHandler
---@field img_250 UIKmlLuaControlHandler
---@field panel_251 UIKmlLuaControlHandler
---@field text_21 UIKmlLuaControlHandler
---@field img_22 UIKmlLuaControlHandler
---@field img_coin_unit UIKmlLuaControlHandler
---@field txt_price_unit UIKmlLuaControlHandler
---@field btn UIKmlLuaControlHandler
local KLTradeRemovePanelView = {}
setmetatable(KLTradeRemovePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeRemove/KLTradeRemovePanelKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLTradeRemovePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeRemovePanelView
