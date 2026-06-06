---@class KLShopMallPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field sv_frame UIKmlLuaControlHandler
---@field img10 UIKmlLuaControlHandler
---@field prefab_863 UIKmlLuaControlHandler
---@field TopHomeToggleGroup UIKmlLuaControlHandler
---@field LeftSubToggleGroup UIKmlLuaControlHandler
---@field CloseBtn UIKmlLuaControlHandler
---@field ShopMallItems UIKmlLuaControlHandler
---@field ShopMallGoodsList UIKmlLuaControlHandler
---@field panel_18 UIKmlLuaControlHandler
---@field scrollview10 UIKmlLuaControlHandler
---@field layout11 UIKmlLuaControlHandler
---@field money_list UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field dianshuchongzhi_btn UIKmlLuaControlHandler
---@field Label UIKmlLuaControlHandler
---@field img13 UIKmlLuaControlHandler
---@field line UIKmlLuaControlHandler
---@field img12 UIKmlLuaControlHandler
---@field zhigou_btn UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field pageCount UIKmlLuaControlHandler
---@field reduceBtn UIKmlLuaControlHandler
---@field addBtn UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLShopMallPanelView = {}
setmetatable(KLShopMallPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanelKml'
---@param parent UIKmlLuaControlHandler
function KLShopMallPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLShopMallPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/ShopMall/Panel/KLShopMall/KLShopMallPanel']

return KLShopMallPanelView
