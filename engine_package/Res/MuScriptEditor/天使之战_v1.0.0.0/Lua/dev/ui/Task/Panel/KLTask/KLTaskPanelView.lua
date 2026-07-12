---@class KLTaskPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field root UIKmlLuaControlHandler
---@field info_view UIKmlLuaControlHandler
---@field left_top_task_process_panel_layout UIKmlLuaControlHandler
---@field left_top_task_list UIKmlLuaControlHandler
local KLTaskPanelView = {}
setmetatable(KLTaskPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Task/Panel/KLTask/KLTaskPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTaskPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTaskPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Task/Panel/KLTask/KLTaskPanel']

return KLTaskPanelView
