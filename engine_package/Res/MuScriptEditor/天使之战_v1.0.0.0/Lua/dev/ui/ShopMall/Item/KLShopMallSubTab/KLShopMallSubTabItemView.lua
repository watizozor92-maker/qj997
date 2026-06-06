---@class KLShopMallSubTabItemView:UIKmlLuaViewBase
---@field prefab_860 UIKmlLuaControlHandler
---@field Label UIKmlLuaControlHandler
---@field Background UIKmlLuaControlHandler
---@field ToggleLevel UIKmlLuaControlHandler
local KLShopMallSubTabItemView = {}
setmetatable(KLShopMallSubTabItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ShopMall/Item/KLShopMallSubTab/KLShopMallSubTabItemKml'
---@param parent UIKmlLuaControlHandler
function KLShopMallSubTabItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLShopMallSubTabItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/ShopMall/Item/KLShopMallSubTab/KLShopMallSubTabItem']

return KLShopMallSubTabItemView
