---@class KLDailyActivityPanelView:UIKmlLuaViewBase
---@field datalist_activity UIKmlLuaControl
local KLDailyActivityPanelView = {}
setmetatable(KLDailyActivityPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DailyGoal/Panel/KLDailyActivity/KLDailyActivityPanelKml'
---@param parent UIKmlLuaControl
function KLDailyActivityPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLDailyActivityPanelView
