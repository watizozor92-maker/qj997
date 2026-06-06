---@class KLBossOfferRewardModelItemView:UIKmlLuaViewBase
---@field modelExp UIKmlLuaControl
---@field img_6 UIKmlLuaControl
---@field name UIKmlLuaControl
---@field img_receive UIKmlLuaControl
---@field btn_go_get UIKmlLuaControl
---@field node UIKmlLuaControl
---@field monster2 UIKmlLuaControl
---@field monster UIKmlLuaControl
local KLBossOfferRewardModelItemView = {}
setmetatable(KLBossOfferRewardModelItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BossOfferReward/Item/KLBossOfferRewardModel/KLBossOfferRewardModelItemKml'
---@param parent UIKmlLuaControl
function KLBossOfferRewardModelItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLBossOfferRewardModelItemView
