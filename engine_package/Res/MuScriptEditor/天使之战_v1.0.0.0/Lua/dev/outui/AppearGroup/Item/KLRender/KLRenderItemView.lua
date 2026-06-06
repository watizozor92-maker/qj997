---@class KLRenderItemView:UIKmlLuaViewBase
local KLRenderItemView = {}
setmetatable(KLRenderItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Item/KLRender/KLRenderItemKml'
---@param parent UIKmlLuaControl
function KLRenderItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLRenderItemView
