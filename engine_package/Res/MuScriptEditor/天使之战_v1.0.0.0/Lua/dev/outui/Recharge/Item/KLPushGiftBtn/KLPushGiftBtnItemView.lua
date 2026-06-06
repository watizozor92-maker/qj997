---@class KLPushGiftBtnItemView:UIKmlLuaViewBase
---@field GiftBtn UIKmlLuaControl
---@field Time UIKmlLuaControl
---@field BtnText UIKmlLuaControl
local KLPushGiftBtnItemView = {}
setmetatable(KLPushGiftBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Recharge/Item/KLPushGiftBtn/KLPushGiftBtnItemKml'
---@param parent UIKmlLuaControl
function KLPushGiftBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLPushGiftBtnItemView
