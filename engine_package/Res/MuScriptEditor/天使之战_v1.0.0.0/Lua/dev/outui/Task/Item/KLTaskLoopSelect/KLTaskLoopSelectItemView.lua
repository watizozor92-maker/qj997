---@class KLTaskLoopSelectItemView:UIKmlLuaViewBase
---@field item UIKmlLuaControl
---@field equipInfo UIKmlLuaControl
---@field xinyun UIKmlLuaControl
---@field strengthLevel UIKmlLuaControl
---@field appendLevel UIKmlLuaControl
---@field quality UIKmlLuaControl
---@field select UIKmlLuaControl
---@field item_click UIKmlLuaControl
local KLTaskLoopSelectItemView = {}
setmetatable(KLTaskLoopSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Task/Item/KLTaskLoopSelect/KLTaskLoopSelectItemKml'
---@param parent UIKmlLuaControl
function KLTaskLoopSelectItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLTaskLoopSelectItemView
