---@class KLPrivilegeBossEndPanelView:UIKmlLuaViewBase
local KLPrivilegeBossEndPanelView = {}
setmetatable(KLPrivilegeBossEndPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLPrivilegeBossEnd/KLPrivilegeBossEndPanelKml'
---@param parent UIKmlLuaControl
function KLPrivilegeBossEndPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLPrivilegeBossEndPanelView
