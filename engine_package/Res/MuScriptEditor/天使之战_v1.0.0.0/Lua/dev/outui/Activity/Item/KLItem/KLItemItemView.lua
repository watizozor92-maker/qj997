---@class KLItemItemView:UIKmlLuaViewBase
---@field control_item UIKmlLuaControl
local KLItemItemView = {}
setmetatable(KLItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLItem/KLItemItemKml'
---@param parent UIKmlLuaControl
function KLItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLItemItemView
