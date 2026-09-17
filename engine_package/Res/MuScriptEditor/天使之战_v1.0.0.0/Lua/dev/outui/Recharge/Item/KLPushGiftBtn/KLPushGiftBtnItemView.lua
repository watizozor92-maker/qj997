---@class KLPushGiftBtnItemView:UIKmlLuaViewBase
---@field GiftBtn UIKmlLuaControlHandler
---@field Time UIKmlLuaControlHandler
---@field BtnText UIKmlLuaControlHandler
local KLPushGiftBtnItemView = {}
setmetatable(KLPushGiftBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Recharge/Item/KLPushGiftBtn/KLPushGiftBtnItemKml'
---@param parent UIKmlLuaControlHandler
function KLPushGiftBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLPushGiftBtnItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Recharge/Item/KLPushGiftBtn/KLPushGiftBtnItem']

return KLPushGiftBtnItemView
