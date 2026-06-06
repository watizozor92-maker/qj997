---@class KLUIMonthCardDescTipsPanelView:UIKmlLuaViewBase
---@field BG UIKmlLuaControlHandler
---@field bgBth UIKmlLuaControlHandler
---@field CloseBtn UIKmlLuaControlHandler
---@field scrollview8 UIKmlLuaControlHandler
---@field layout9 UIKmlLuaControlHandler
---@field contentText UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLUIMonthCardDescTipsPanelView = {}
setmetatable(KLUIMonthCardDescTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MonthCard/Panel/KLUIMonthCardDescTips/KLUIMonthCardDescTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIMonthCardDescTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMonthCardDescTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MonthCard/Panel/KLUIMonthCardDescTips/KLUIMonthCardDescTipsPanel']

return KLUIMonthCardDescTipsPanelView
