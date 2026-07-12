---@class KLTradeCommonGoodsPanelView:UIKmlLuaViewBase
---@field loopscrollview_50 UIKmlLuaControlHandler
---@field datalist_goods UIKmlLuaControlHandler
local KLTradeCommonGoodsPanelView = {}
setmetatable(KLTradeCommonGoodsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeCommonGoods/KLTradeCommonGoodsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTradeCommonGoodsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeCommonGoodsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Panel/KLTradeCommonGoods/KLTradeCommonGoodsPanel']

return KLTradeCommonGoodsPanelView
