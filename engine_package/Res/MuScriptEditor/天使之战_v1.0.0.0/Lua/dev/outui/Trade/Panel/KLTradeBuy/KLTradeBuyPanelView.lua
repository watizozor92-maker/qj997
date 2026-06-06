---@class KLTradeBuyPanelView:UIKmlLuaViewBase
---@field btn_close UIKmlLuaControlHandler
---@field img_111 UIKmlLuaControlHandler
---@field layout_112 UIKmlLuaControlHandler
---@field group_input_count UIKmlLuaControlHandler
---@field text_114 UIKmlLuaControlHandler
---@field panel_115 UIKmlLuaControlHandler
---@field input_count UIKmlLuaControlHandler
---@field btn_minus UIKmlLuaControlHandler
---@field btn_add UIKmlLuaControlHandler
---@field panel_119 UIKmlLuaControlHandler
---@field text_120 UIKmlLuaControlHandler
---@field img_121 UIKmlLuaControlHandler
---@field img_coin_icon UIKmlLuaControlHandler
---@field txt_price UIKmlLuaControlHandler
---@field btn_buy UIKmlLuaControlHandler
local KLTradeBuyPanelView = {}
setmetatable(KLTradeBuyPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeBuy/KLTradeBuyPanelKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLTradeBuyPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeBuyPanelView
