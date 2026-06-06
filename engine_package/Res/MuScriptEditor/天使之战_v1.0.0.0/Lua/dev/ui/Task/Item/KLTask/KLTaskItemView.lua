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
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLTaskItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTaskItemView
