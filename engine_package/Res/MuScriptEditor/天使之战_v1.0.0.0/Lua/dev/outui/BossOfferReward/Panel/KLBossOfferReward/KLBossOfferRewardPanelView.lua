---@class KLBossOfferRewardPanelView:UIKmlLuaViewBase
---@field challenge_boss_panel UIKmlLuaControl
---@field trade_bg UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field img_10 UIKmlLuaControl
---@field img_interface UIKmlLuaControl
---@field bg_right UIKmlLuaControl
---@field txt_lock UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field levelContent UIKmlLuaControl
---@field layout4 UIKmlLuaControl
---@field levelList UIKmlLuaControl
---@field boss_panel UIKmlLuaControl
---@field boss_view UIKmlLuaControl
---@field bossDataList UIKmlLuaControl
---@field img_all_receive UIKmlLuaControl
---@field bg_prop UIKmlLuaControl
---@field btn_reward UIKmlLuaControl
---@field boss_reward_view UIKmlLuaControl
---@field gold_boss_reward_layout UIKmlLuaControl
---@field bossRewardList UIKmlLuaControl
local KLBossOfferRewardPanelView = {}
setmetatable(KLBossOfferRewardPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BossOfferReward/Panel/KLBossOfferReward/KLBossOfferRewardPanelKml'
---@param parent UIKmlLuaControl
function KLBossOfferRewardPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLBossOfferRewardPanelView
