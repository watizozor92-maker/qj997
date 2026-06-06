---@class KLUIPrivilegeItemDescriptionPanelView:UIKmlLuaViewBase
local KLUIPrivilegeItemDescriptionPanelView = {}
setmetatable(KLUIPrivilegeItemDescriptionPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Privilege/Panel/KLUIPrivilegeItemDescription/KLUIPrivilegeItemDescriptionPanelKml'
---@param parent UIKmlLuaControl
function KLUIPrivilegeItemDescriptionPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIPrivilegeItemDescriptionPanelView
