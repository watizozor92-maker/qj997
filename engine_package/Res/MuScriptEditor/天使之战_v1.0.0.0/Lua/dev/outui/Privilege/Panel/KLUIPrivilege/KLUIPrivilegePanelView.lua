---@class KLUIPrivilegePanelView:UIKmlLuaViewBase
local KLUIPrivilegePanelView = {}
setmetatable(KLUIPrivilegePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Privilege/Panel/KLUIPrivilege/KLUIPrivilegePanelKml'
---@param parent UIKmlLuaControl
function KLUIPrivilegePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIPrivilegePanelView
