---@class KLMonthCardBuyTipPanelView:UIKmlLuaViewBase
---@field btn_close UIKmlLuaControl
---@field img_232 UIKmlLuaControl
---@field txt_title UIKmlLuaControl
local KLMonthCardBuyTipPanelView = {}
setmetatable(KLMonthCardBuyTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLMonthCardBuyTip/KLMonthCardBuyTipPanelKml'
---@param parent UIKmlLuaControl
function KLMonthCardBuyTipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMonthCardBuyTipPanelView
