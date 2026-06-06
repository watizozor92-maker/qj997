---@class KLRedDotItemView:UIKmlLuaViewBase
---@field redDotItem UIKmlLuaControl
local KLRedDotItemView = {}
setmetatable(KLRedDotItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/RedDot/Item/KLRedDot/KLRedDotItemKml'
---@param parent UIKmlLuaControl
function KLRedDotItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLRedDotItemView
