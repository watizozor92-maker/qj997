---@class KLUIMonthGainItemTipsPanelView:UIKmlLuaViewBase
---@field CloseBG UIKmlLuaControl
---@field bgImg UIKmlLuaControl
---@field title UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field scrollview UIKmlLuaControl
---@field layout UIKmlLuaControl
---@field rewards UIKmlLuaControl
---@field showTxt UIKmlLuaControl
local KLUIMonthGainItemTipsPanelView = {}
setmetatable(KLUIMonthGainItemTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/RechargeMonthlycard/Panel/KLUIMonthGainItemTipsPanel/KLUIMonthGainItemTipsPanelKml'
---@param parent UIKmlLuaControl
function KLUIMonthGainItemTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIMonthGainItemTipsPanelView
