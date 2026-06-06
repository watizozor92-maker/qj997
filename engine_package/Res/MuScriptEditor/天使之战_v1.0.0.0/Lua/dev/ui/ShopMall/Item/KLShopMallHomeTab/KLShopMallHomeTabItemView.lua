---@class KLShopMallHomeTabItemView:UIKmlLuaViewBase
---@field KmlShopMallHomeTab UIKmlLuaControlHandler
---@field Label UIKmlLuaControlHandler
local KLShopMallHomeTabItemView = {}
setmetatable(KLShopMallHomeTabItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ShopMall/Item/KLShopMallHomeTab/KLShopMallHomeTabItemKml'
---@param parent UIKmlLuaControlHandler
function KLShopMallHomeTabItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLShopMallHomeTabItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/ShopMall/Item/KLShopMallHomeTab/KLShopMallHomeTabItem']

return KLShopMallHomeTabItemView
