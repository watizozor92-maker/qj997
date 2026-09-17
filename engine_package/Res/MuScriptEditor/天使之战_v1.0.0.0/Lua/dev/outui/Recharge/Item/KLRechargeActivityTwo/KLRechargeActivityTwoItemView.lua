---@class KLRechargeActivityTwoItemView:UIKmlLuaViewBase
---@field BG UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field buyButton UIKmlLuaControlHandler
---@field Image UIKmlLuaControlHandler
---@field buyCount UIKmlLuaControlHandler
---@field zuanshi UIKmlLuaControlHandler
---@field LockUI UIKmlLuaControlHandler
---@field RedDot UIKmlLuaControlHandler
---@field giveItemScrollView UIKmlLuaControlHandler
---@field giftDataList UIKmlLuaControlHandler
local KLRechargeActivityTwoItemView = {}
setmetatable(KLRechargeActivityTwoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Recharge/Item/KLRechargeActivityTwo/KLRechargeActivityTwoItemKml'
---@param parent UIKmlLuaControlHandler
function KLRechargeActivityTwoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRechargeActivityTwoItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Recharge/Item/KLRechargeActivityTwo/KLRechargeActivityTwoItem']

return KLRechargeActivityTwoItemView
