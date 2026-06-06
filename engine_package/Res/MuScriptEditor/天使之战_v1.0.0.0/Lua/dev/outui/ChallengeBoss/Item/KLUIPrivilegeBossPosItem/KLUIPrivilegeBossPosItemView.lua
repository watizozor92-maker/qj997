---@class KLUIPrivilegeBossPosItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControl
---@field level_select UIKmlLuaControl
---@field type_name UIKmlLuaControl
local KLUIPrivilegeBossPosItemView = {}
setmetatable(KLUIPrivilegeBossPosItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIPrivilegeBossPosItem/KLUIPrivilegeBossPosItemKml'
---@param parent UIKmlLuaControl
function KLUIPrivilegeBossPosItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIPrivilegeBossPosItemView
