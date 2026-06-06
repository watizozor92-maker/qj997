---@class KLBossOfferRewardBtnItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControl
---@field level_select UIKmlLuaControl
---@field type_name UIKmlLuaControl
---@field img_completed_flag UIKmlLuaControl
local KLBossOfferRewardBtnItemView = {}
setmetatable(KLBossOfferRewardBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BossOfferReward/Item/KLBossOfferRewardBtn/KLBossOfferRewardBtnItemKml'
---@param parent UIKmlLuaControl
function KLBossOfferRewardBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLBossOfferRewardBtnItemView
