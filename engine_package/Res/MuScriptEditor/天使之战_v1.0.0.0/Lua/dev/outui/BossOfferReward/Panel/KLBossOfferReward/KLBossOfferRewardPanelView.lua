---@class KLBossOfferRewardPanelView:UIKmlLuaViewBase
---@field challenge_boss_panel UIKmlLuaControlHandler
---@field trade_bg UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img_10 UIKmlLuaControlHandler
---@field img_interface UIKmlLuaControlHandler
---@field bg_right UIKmlLuaControlHandler
---@field txt_lock UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field levelContent UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field levelList UIKmlLuaControlHandler
---@field boss_panel UIKmlLuaControlHandler
---@field boss_view UIKmlLuaControlHandler
---@field bossDataList UIKmlLuaControlHandler
---@field panel_all_receive UIKmlLuaControlHandler
---@field img_all_receive UIKmlLuaControlHandler
---@field bg_prop UIKmlLuaControlHandler
---@field btn_reward UIKmlLuaControlHandler
---@field boss_reward_view UIKmlLuaControlHandler
---@field gold_boss_reward_layout UIKmlLuaControlHandler
---@field bossRewardList UIKmlLuaControlHandler
local KLBossOfferRewardPanelView = {}
setmetatable(KLBossOfferRewardPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BossOfferReward/Panel/KLBossOfferReward/KLBossOfferRewardPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBossOfferRewardPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBossOfferRewardPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/BossOfferReward/Panel/KLBossOfferReward/KLBossOfferRewardPanel']

return KLBossOfferRewardPanelView
