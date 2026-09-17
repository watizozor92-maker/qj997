---@class KLTaskLoopSelectItemView:UIKmlLuaViewBase
---@field item UIKmlLuaControlHandler
---@field equipInfo UIKmlLuaControlHandler
---@field xinyun UIKmlLuaControlHandler
---@field strengthLevel UIKmlLuaControlHandler
---@field appendLevel UIKmlLuaControlHandler
---@field quality UIKmlLuaControlHandler
---@field select UIKmlLuaControlHandler
---@field item_click UIKmlLuaControlHandler
local KLTaskLoopSelectItemView = {}
setmetatable(KLTaskLoopSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Task/Item/KLTaskLoopSelect/KLTaskLoopSelectItemKml'
---@param parent UIKmlLuaControlHandler
function KLTaskLoopSelectItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLTaskLoopSelectItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Task/Item/KLTaskLoopSelect/KLTaskLoopSelectItem']

return KLTaskLoopSelectItemView
