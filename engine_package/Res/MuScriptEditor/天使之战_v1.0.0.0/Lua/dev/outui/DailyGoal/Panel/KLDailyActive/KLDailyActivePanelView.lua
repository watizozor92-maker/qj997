---@class KLDailyActivePanelView:UIKmlLuaViewBase
---@field datalist_active UIKmlLuaControl
---@field txt_cur_active_num UIKmlLuaControl
---@field icon_get_5 UIKmlLuaControl
---@field icon_get_4 UIKmlLuaControl
---@field icon_get_3 UIKmlLuaControl
---@field icon_get_2 UIKmlLuaControl
---@field icon_get_1 UIKmlLuaControl
---@field icon_box_5 UIKmlLuaControl
---@field icon_box_4 UIKmlLuaControl
---@field icon_box_3 UIKmlLuaControl
---@field icon_box_2 UIKmlLuaControl
---@field icon_box_1 UIKmlLuaControl
---@field slider_active_num UIKmlLuaControl
local KLDailyActivePanelView = {}
setmetatable(KLDailyActivePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DailyGoal/Panel/KLDailyActive/KLDailyActivePanelKml'
---@param parent UIKmlLuaControl
function KLDailyActivePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLDailyActivePanelView
