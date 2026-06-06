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
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLTradeSalesPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeSalesPanelView
