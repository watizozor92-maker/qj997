---@class KLTradeUnionBuyPanelView:UIKmlLuaViewBase
---@field btn_close UIKmlLuaControlHandler
---@field img_258 UIKmlLuaControlHandler
---@field panel_259 UIKmlLuaControlHandler
---@field text_260 UIKmlLuaControlHandler
---@field img_261 UIKmlLuaControlHandler
---@field img_coin_icon UIKmlLuaControlHandler
---@field txt_price UIKmlLuaControlHandler
---@field btn_buy UIKmlLuaControlHandler
local KLTradeUnionBuyPanelView = {}
setmetatable(KLTradeUnionBuyPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeUnionBuy/KLTradeUnionBuyPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTradeUnionBuyPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeUnionBuyPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Panel/KLTradeUnionBuy/KLTradeUnionBuyPanel']

return KLTradeUnionBuyPanelView
