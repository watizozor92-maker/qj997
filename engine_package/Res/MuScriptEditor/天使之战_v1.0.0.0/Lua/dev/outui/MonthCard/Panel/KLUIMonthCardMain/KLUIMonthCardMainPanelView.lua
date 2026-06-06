---@class KLUIMonthCardMainPanelView:UIKmlLuaViewBase
---@field bg1 UIKmlLuaControlHandler
---@field monthCardBg UIKmlLuaControlHandler
---@field PrivigeBg UIKmlLuaControlHandler
---@field UI UIKmlLuaControlHandler
---@field togglegroup UIKmlLuaControlHandler
---@field TogList UIKmlLuaControlHandler
---@field MonthCardToggle UIKmlLuaControlHandler
---@field img_toggle_month_card UIKmlLuaControlHandler
---@field PrivilegeToggle UIKmlLuaControlHandler
---@field img_toggle_privilege UIKmlLuaControlHandler
---@field CloseBtn UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
local KLUIMonthCardMainPanelView = {}
setmetatable(KLUIMonthCardMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIMonthCardMainPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMonthCardMainPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MonthCard/Panel/KLUIMonthCardMain/KLUIMonthCardMainPanel']

return KLUIMonthCardMainPanelView
