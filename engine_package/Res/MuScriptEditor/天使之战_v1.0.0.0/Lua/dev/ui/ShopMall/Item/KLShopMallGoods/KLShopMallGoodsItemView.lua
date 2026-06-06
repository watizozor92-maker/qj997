---@class KLShopMallGoodsItemView:UIKmlLuaViewBase
---@field prefab_848 UIKmlLuaControlHandler
---@field UIScrollTextTemplate UIKmlLuaControlHandler
---@field txt_goods_title UIKmlLuaControlHandler
---@field Text_Condition UIKmlLuaControlHandler
---@field img_goods_icon UIKmlLuaControlHandler
---@field item_goods UIKmlLuaControlHandler
---@field txt_purchase_limitation UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field img_money_icon UIKmlLuaControlHandler
---@field txt_price UIKmlLuaControlHandler
---@field ButtonBg UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field light UIKmlLuaControlHandler
---@field RawImage UIKmlLuaControlHandler
---@field Effect UIKmlLuaControlHandler
---@field btn_bg UIKmlLuaControlHandler
---@field HotIcon UIKmlLuaControlHandler
local KLShopMallGoodsItemView = {}
setmetatable(KLShopMallGoodsItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ShopMall/Item/KLShopMallGoods/KLShopMallGoodsItemKml'
---@param parent UIKmlLuaControlHandler
function KLShopMallGoodsItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLShopMallGoodsItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/ShopMall/Item/KLShopMallGoods/KLShopMallGoodsItem']

return KLShopMallGoodsItemView
