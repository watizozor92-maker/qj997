---@class KLDailyGoalMainPanelView:UIKmlLuaViewBase
---@field img_27 UIKmlLuaControl
---@field img_28 UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field tab_toggle_group UIKmlLuaControl
---@field layout_31 UIKmlLuaControl
---@field toggle_tab_daily_active UIKmlLuaControl
---@field text_33 UIKmlLuaControl
---@field toggle_tab_activity UIKmlLuaControl
---@field text_35 UIKmlLuaControl
local KLDailyGoalMainPanelView = {}
setmetatable(KLDailyGoalMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DailyGoal/Panel/KLDailyGoalMain/KLDailyGoalMainPanelKml'
---@param parent UIKmlLuaControl
function KLDailyGoalMainPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLDailyGoalMainPanelView
