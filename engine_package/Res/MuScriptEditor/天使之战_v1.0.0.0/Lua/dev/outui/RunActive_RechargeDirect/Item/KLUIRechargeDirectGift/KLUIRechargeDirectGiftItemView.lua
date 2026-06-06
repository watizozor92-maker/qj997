---@class KLUIRechargeDirectGiftItemView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field nameText UIKmlLuaControlHandler
---@field items UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field itemsDataList UIKmlLuaControlHandler
---@field buyBtn UIKmlLuaControlHandler
---@field priceText UIKmlLuaControlHandler
---@field countText UIKmlLuaControlHandler
---@field redDot UIKmlLuaControlHandler
local KLUIRechargeDirectGiftItemView = {}
setmetatable(KLUIRechargeDirectGiftItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/RunActive_RechargeDirect/Item/KLUIRechargeDirectGift/KLUIRechargeDirectGiftItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIRechargeDirectGiftItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLUIRechargeDirectGiftItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/RunActive_RechargeDirect/Item/KLUIRechargeDirectGift/KLUIRechargeDirectGiftItem']

return KLUIRechargeDirectGiftItemView
