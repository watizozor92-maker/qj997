---@class KLDailyActivityPanelView:UIKmlLuaViewBase
---@field scrollview_55 UIKmlLuaControlHandler
---@field datalist_activity UIKmlLuaControlHandler
local KLDailyActivityPanelView = {}
setmetatable(KLDailyActivityPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DailyGoal/Panel/KLDailyActivity/KLDailyActivityPanelKml'
---@param parent UIKmlLuaControlHandler
function KLDailyActivityPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLDailyActivityPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/DailyGoal/Panel/KLDailyActivity/KLDailyActivityPanel']

return KLDailyActivityPanelView
