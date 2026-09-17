---@class KLTaskItemView:UIKmlLuaViewBase
---@field layout_1047 UIKmlLuaControlHandler
---@field task_goad_ UIKmlLuaControlHandler
---@field equip_name UIKmlLuaControlHandler
---@field equip_num UIKmlLuaControlHandler
---@field GuidePanel UIKmlLuaControlHandler
---@field GuideBG UIKmlLuaControlHandler
---@field Desc UIKmlLuaControlHandler
---@field LeftArrow UIKmlLuaControlHandler
---@field TaskGuidePoint UIKmlLuaControlHandler
---@field taskType UIKmlLuaControlHandler
local KLTaskItemView = {}
setmetatable(KLTaskItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Task/Item/KLTask/KLTaskItemKml'
---@param parent UIKmlLuaControlHandler
function KLTaskItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTaskItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Task/Item/KLTask/KLTaskItem']

return KLTaskItemView
