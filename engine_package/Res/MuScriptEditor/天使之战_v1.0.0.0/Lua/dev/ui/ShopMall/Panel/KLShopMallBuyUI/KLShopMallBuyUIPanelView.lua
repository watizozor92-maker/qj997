---@class KLShopMallBuyUIPanelView:UIKmlLuaViewBase
---@field prefab_80 UIKmlLuaControlHandler
---@field ClickMask UIKmlLuaControlHandler
---@field InputFieldLevel UIKmlLuaControlHandler
---@field Text UIKmlLuaControlHandler
---@field TextTotalPrice UIKmlLuaControlHandler
---@field BtnBuy UIKmlLuaControlHandler
---@field BtnLevelMinus UIKmlLuaControlHandler
---@field BtnLevelAdd UIKmlLuaControlHandler
---@field icon_money UIKmlLuaControlHandler
local KLShopMallBuyUIPanelView = {}
setmetatable(KLShopMallBuyUIPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ShopMall/Panel/KLShopMallBuyUI/KLShopMallBuyUIPanelKml'
---@param parent UIKmlLuaControlHandler
function KLShopMallBuyUIPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLShopMallBuyUIPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/ShopMall/Panel/KLShopMallBuyUI/KLShopMallBuyUIPanel']

return KLShopMallBuyUIPanelView
