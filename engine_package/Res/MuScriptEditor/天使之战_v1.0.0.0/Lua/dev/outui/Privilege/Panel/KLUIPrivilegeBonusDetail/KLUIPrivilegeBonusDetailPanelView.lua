---@class KLUIPrivilegeBonusDetailPanelView:UIKmlLuaViewBase
local KLUIPrivilegeBonusDetailPanelView = {}
setmetatable(KLUIPrivilegeBonusDetailPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Privilege/Panel/KLUIPrivilegeBonusDetail/KLUIPrivilegeBonusDetailPanelKml'
---@param parent UIKmlLuaControl
function KLUIPrivilegeBonusDetailPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIPrivilegeBonusDetailPanelView
