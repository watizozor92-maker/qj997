---@class KLSelfSelectBoxItemView:UIKmlLuaViewBase
---@field SelfBoxItemTemplate UIKmlLuaControl
---@field itemicon UIKmlLuaControl
---@field decbtn UIKmlLuaControl
---@field addbtn UIKmlLuaControl
---@field numbertext UIKmlLuaControl
local KLSelfSelectBoxItemView = {}
setmetatable(KLSelfSelectBoxItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ItemBase/Item/KLSelfSelectBox/KLSelfSelectBoxItemKml'
---@param parent UIKmlLuaControl
function KLSelfSelectBoxItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLSelfSelectBoxItemView
