---@class KLTradeMonthCardPanelView:UIKmlLuaViewBase
---@field img5 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field togglegroup2 UIKmlLuaControlHandler
---@field layout_71 UIKmlLuaControlHandler
---@field toggle_month_card UIKmlLuaControlHandler
---@field text_73 UIKmlLuaControlHandler
---@field toggle_coin UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field loopscrollview1 UIKmlLuaControlHandler
---@field datalist_goods UIKmlLuaControlHandler
local KLTradeMonthCardPanelView = {}
setmetatable(KLTradeMonthCardPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeMonthCard/KLTradeMonthCardPanelKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLTradeMonthCardPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTradeMonthCardPanelView
