---@class KLUIPrivilegeIntroducePanelView:UIKmlLuaViewBase
local KLUIPrivilegeIntroducePanelView = {}
setmetatable(KLUIPrivilegeIntroducePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Privilege/Panel/KLUIPrivilegeIntroduce/KLUIPrivilegeIntroducePanelKml'
---@param parent UIKmlLuaControl
function KLUIPrivilegeIntroducePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIPrivilegeIntroducePanelView
