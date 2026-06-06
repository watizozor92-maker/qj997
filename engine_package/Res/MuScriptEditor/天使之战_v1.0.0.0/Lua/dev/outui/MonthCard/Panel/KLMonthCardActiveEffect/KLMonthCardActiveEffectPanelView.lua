---@class KLMonthCardActiveEffectPanelView:UIKmlLuaViewBase
---@field MonthCard_ActiveIcon UIKmlLuaControlHandler
local KLMonthCardActiveEffectPanelView = {}
setmetatable(KLMonthCardActiveEffectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MonthCard/Panel/KLMonthCardActiveEffect/KLMonthCardActiveEffectPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMonthCardActiveEffectPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMonthCardActiveEffectPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MonthCard/Panel/KLMonthCardActiveEffect/KLMonthCardActiveEffectPanel']

return KLMonthCardActiveEffectPanelView
