---@class KLFirstDropItemView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControl
---@field name UIKmlLuaControl
---@field reward UIKmlLuaControl
---@field num UIKmlLuaControl
---@field player UIKmlLuaControl
local KLFirstDropItemView = {}
setmetatable(KLFirstDropItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FirstDrop/Item/KLFirstDrop/KLFirstDropItemKml'
---@param parent UIKmlLuaControl
function KLFirstDropItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLFirstDropItemView
