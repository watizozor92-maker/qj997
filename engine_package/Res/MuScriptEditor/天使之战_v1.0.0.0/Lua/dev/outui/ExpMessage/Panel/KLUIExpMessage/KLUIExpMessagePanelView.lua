---@class KLUIExpMessagePanelView:UIKmlLuaViewBase
local KLUIExpMessagePanelView = {}
setmetatable(KLUIExpMessagePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ExpMessage/Panel/KLUIExpMessage/KLUIExpMessagePanelKml'
---@param parent UIKmlLuaControl
function KLUIExpMessagePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIExpMessagePanelView
