---@class KLTaskPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControl
---@field root UIKmlLuaControl
---@field info_view UIKmlLuaControl
---@field left_top_task_process_panel_layout UIKmlLuaControl
---@field left_top_task_list UIKmlLuaControl
local KLTaskPanelView = {}
setmetatable(KLTaskPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Task/Panel/KLTask/KLTaskPanelKml'
---@param parent UIKmlLuaControl
function KLTaskPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTaskPanelView
