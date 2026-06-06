---@class KLRechargeActivityTwoItemView:UIKmlLuaViewBase
---@field BG UIKmlLuaControl
---@field text1 UIKmlLuaControl
---@field buyButton UIKmlLuaControl
---@field Image UIKmlLuaControl
---@field buyCount UIKmlLuaControl
---@field zuanshi UIKmlLuaControl
---@field LockUI UIKmlLuaControl
---@field RedDot UIKmlLuaControl
---@field giveItemScrollView UIKmlLuaControl
---@field giftDataList UIKmlLuaControl
local KLRechargeActivityTwoItemView = {}
setmetatable(KLRechargeActivityTwoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Recharge/Item/KLRechargeActivityTwo/KLRechargeActivityTwoItemKml'
---@param parent UIKmlLuaControl
function KLRechargeActivityTwoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLRechargeActivityTwoItemView
