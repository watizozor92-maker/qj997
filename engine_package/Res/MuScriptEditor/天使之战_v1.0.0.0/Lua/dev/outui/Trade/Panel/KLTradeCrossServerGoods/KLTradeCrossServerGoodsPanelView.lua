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
---@param parent UIKmlLuaControlHandler
function KLTradeCrossServerGoodsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeCrossServerGoodsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Panel/KLTradeCrossServerGoods/KLTradeCrossServerGoodsPanel']

return KLTradeCrossServerGoodsPanelView
