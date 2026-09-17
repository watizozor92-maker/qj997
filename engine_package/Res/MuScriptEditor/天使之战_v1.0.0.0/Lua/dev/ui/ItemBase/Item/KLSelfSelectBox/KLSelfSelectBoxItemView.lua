---@class KLSelfSelectBoxItemView:UIKmlLuaViewBase
---@field SelfBoxItemTemplate UIKmlLuaControlHandler
---@field itemicon UIKmlLuaControlHandler
---@field decbtn UIKmlLuaControlHandler
---@field addbtn UIKmlLuaControlHandler
---@field numbertext UIKmlLuaControlHandler
local KLSelfSelectBoxItemView = {}
setmetatable(KLSelfSelectBoxItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ItemBase/Item/KLSelfSelectBox/KLSelfSelectBoxItemKml'
---@param parent UIKmlLuaControlHandler
function KLSelfSelectBoxItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLSelfSelectBoxItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/ItemBase/Item/KLSelfSelectBox/KLSelfSelectBoxItem']

return KLSelfSelectBoxItemView
