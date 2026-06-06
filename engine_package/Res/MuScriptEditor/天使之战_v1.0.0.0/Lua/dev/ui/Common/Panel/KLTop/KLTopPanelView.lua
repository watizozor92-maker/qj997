---@class KLTopPanelView:UIKmlLuaViewBase
local KLTopPanelView = {}
setmetatable(KLTopPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Panel/KLTop/KLTopPanelKml'
---@param parent UIKmlLuaControl
function KLTopPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLTopPanelView
