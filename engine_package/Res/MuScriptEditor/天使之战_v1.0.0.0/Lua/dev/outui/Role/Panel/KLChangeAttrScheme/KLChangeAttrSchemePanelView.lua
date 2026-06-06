---@class KLChangeAttrSchemePanelView:UIKmlLuaViewBase
local KLChangeAttrSchemePanelView = {}
setmetatable(KLChangeAttrSchemePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Role/Panel/KLChangeAttrScheme/KLChangeAttrSchemePanelKml'
---@param parent UIKmlLuaControl
function KLChangeAttrSchemePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLChangeAttrSchemePanelView
