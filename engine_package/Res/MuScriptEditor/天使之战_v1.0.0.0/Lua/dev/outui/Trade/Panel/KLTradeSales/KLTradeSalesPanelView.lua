---@class KLTradeSalesPanelView:UIKmlLuaViewBase
---@field title_bg UIKmlLuaControlHandler
---@field TradeSales_title UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field TradeSales_Main UIKmlLuaControlHandler
---@field sales_scroll UIKmlLuaControlHandler
---@field sales_grid UIKmlLuaControlHandler
---@field StallButton UIKmlLuaControlHandler
---@field StallView UIKmlLuaControlHandler
---@field stall_btn_chat UIKmlLuaControlHandler
---@field stall_btn_walk UIKmlLuaControlHandler
---@field tanwei UIKmlLuaControlHandler
---@field stall_time UIKmlLuaControlHandler
---@field taxRate UIKmlLuaControlHandler
local KLTradeSalesPanelView = {}
setmetatable(KLTradeSalesPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeSales/KLTradeSalesPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTradeSalesPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeSalesPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Panel/KLTradeSales/KLTradeSalesPanel']

return KLTradeSalesPanelView
