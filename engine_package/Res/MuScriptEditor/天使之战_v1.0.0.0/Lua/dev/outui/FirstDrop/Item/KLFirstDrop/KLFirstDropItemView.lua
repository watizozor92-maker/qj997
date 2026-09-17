---@class KLFirstDropItemView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field reward UIKmlLuaControlHandler
---@field num UIKmlLuaControlHandler
---@field player UIKmlLuaControlHandler
local KLFirstDropItemView = {}
setmetatable(KLFirstDropItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FirstDrop/Item/KLFirstDrop/KLFirstDropItemKml'
---@param parent UIKmlLuaControlHandler
function KLFirstDropItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLFirstDropItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/FirstDrop/Item/KLFirstDrop/KLFirstDropItem']

return KLFirstDropItemView
