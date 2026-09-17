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
---@type KLUnionReplaceItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Union/Item/KLUnionReplace/KLUnionReplaceItem']

return KLUnionReplaceItemView
