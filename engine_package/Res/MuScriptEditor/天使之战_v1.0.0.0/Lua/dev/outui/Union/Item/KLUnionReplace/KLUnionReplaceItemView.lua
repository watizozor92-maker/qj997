---@class KLUnionReplaceItemView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field txtName UIKmlLuaControlHandler
---@field txtLv UIKmlLuaControlHandler
local KLUnionReplaceItemView = {}
setmetatable(KLUnionReplaceItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Union/Item/KLUnionReplace/KLUnionReplaceItemKml'
---@param parent UIKmlLuaControlHandler
function KLUnionReplaceItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUnionReplaceItemView
