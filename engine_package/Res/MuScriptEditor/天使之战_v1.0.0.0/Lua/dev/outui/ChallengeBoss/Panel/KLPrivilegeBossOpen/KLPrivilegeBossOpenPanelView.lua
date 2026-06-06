
local KLPrivilegeBossOpenPanelView = {}
setmetatable(KLPrivilegeBossOpenPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLPrivilegeBossOpen/KLPrivilegeBossOpenPanelKml'
---@param parent UIKmlLuaControl
function KLPrivilegeBossOpenPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLPrivilegeBossOpenPanelView
