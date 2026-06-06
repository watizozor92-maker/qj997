---@class KLTradeUnionBuyPanelView:UIKmlLuaViewBase
---@field btn_close UIKmlLuaControl
---@field img_258 UIKmlLuaControl
---@field panel_259 UIKmlLuaControl
---@field text_260 UIKmlLuaControl
---@field img_261 UIKmlLuaControl
---@field img_coin_icon UIKmlLuaControl
---@field txt_price UIKmlLuaControl
---@field btn_buy UIKmlLuaControl
local KLTradeUnionBuyPanelView = {}
setmetatable(KLTradeUnionBuyPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeUnionBuy/KLTradeUnionBuyPanelKml'
---@param parent UIKmlLuaControl
function KLTradeUnionBuyPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeUnionBuyPanelView
