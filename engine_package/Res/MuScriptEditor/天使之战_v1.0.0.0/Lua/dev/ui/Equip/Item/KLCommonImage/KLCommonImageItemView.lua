---@class KLCommonImageItemView:UIKmlLuaViewBase
---@field img UIKmlLuaControlHandler
local KLCommonImageItemView = {}
setmetatable(KLCommonImageItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Equip/Item/KLCommonImage/KLCommonImageItemKml'
---@param parent UIKmlLuaControlHandler
function KLCommonImageItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLCommonImageItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Equip/Item/KLCommonImage/KLCommonImageItem']

return KLCommonImageItemView
