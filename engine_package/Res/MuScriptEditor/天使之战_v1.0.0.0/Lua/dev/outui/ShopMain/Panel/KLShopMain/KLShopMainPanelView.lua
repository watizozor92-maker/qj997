---@class KLShopMainPanelView:UIKmlLuaViewBase
---@field shopMainPanel UIKmlLuaControlHandler
---@field img_bg UIKmlLuaControlHandler
---@field img_title UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field togGroup UIKmlLuaControlHandler
---@field togList UIKmlLuaControlHandler
---@field tog_shop UIKmlLuaControlHandler
---@field tog_recharge UIKmlLuaControlHandler
local KLShopMainPanelView = {}
setmetatable(KLShopMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanelKml'
---@param parent UIKmlLuaControlHandler
function KLShopMainPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLShopMainPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel']

return KLShopMainPanelView
