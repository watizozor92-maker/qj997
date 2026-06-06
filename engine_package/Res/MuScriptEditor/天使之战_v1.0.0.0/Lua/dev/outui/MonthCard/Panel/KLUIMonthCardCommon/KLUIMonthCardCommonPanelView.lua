---@class KLUIMonthCardCommonPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout9 UIKmlLuaControlHandler
---@field contentText UIKmlLuaControlHandler
---@field GoBtn UIKmlLuaControlHandler
---@field TitleText UIKmlLuaControlHandler
local KLUIMonthCardCommonPanelView = {}
setmetatable(KLUIMonthCardCommonPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MonthCard/Panel/KLUIMonthCardCommon/KLUIMonthCardCommonPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIMonthCardCommonPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMonthCardCommonPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MonthCard/Panel/KLUIMonthCardCommon/KLUIMonthCardCommonPanel']

return KLUIMonthCardCommonPanelView
