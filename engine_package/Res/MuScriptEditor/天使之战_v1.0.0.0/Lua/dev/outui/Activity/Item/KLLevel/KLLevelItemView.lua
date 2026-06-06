---@class KLLevelItemView:UIKmlLuaViewBase
---@field KLLevel UIKmlLuaControl
---@field noClick UIKmlLuaControl
---@field levelName UIKmlLuaControl
---@field no_btn UIKmlLuaControl
local KLLevelItemView = {}
setmetatable(KLLevelItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLLevel/KLLevelItemKml'
---@param parent UIKmlLuaControl
function KLLevelItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLLevelItemView
