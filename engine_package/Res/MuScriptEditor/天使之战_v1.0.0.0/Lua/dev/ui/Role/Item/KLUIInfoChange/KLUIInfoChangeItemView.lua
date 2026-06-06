---@class KLUIInfoChangeItemView:UIKmlLuaViewBase
---@field item_root UIKmlLuaControlHandler
---@field img_effect UIKmlLuaControlHandler
---@field img_up UIKmlLuaControlHandler
---@field text_attr UIKmlLuaControlHandler
local KLUIInfoChangeItemView = {}
setmetatable(KLUIInfoChangeItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Role/Item/KLUIInfoChange/KLUIInfoChangeItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIInfoChangeItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLUIInfoChangeItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Role/Item/KLUIInfoChange/KLUIInfoChangeItem']

return KLUIInfoChangeItemView
