---@class KLMountAttInfoItemView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field name UIKmlLuaControl
---@field num UIKmlLuaControl
---@field arrow UIKmlLuaControl
---@field preNum UIKmlLuaControl
local KLMountAttInfoItemView = {}
setmetatable(KLMountAttInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Item/KLMountAttInfo/KLMountAttInfoItemKml'
---@param parent UIKmlLuaControl
function KLMountAttInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMountAttInfoItemView
