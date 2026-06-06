---@class KLUCrossServerMainBtnItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControl
---@field level_select UIKmlLuaControl
---@field type_name UIKmlLuaControl
local KLUCrossServerMainBtnItemView = {}
setmetatable(KLUCrossServerMainBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CrossServer/Item/KLUCrossServerMainBtnItem/KLUCrossServerMainBtnItemKml'
---@param parent UIKmlLuaControl
function KLUCrossServerMainBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUCrossServerMainBtnItemView
