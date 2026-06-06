---@class KLGoldChallengeRewardItemView:UIKmlLuaViewBase
---@field root UIKmlLuaControl
---@field RewardItem UIKmlLuaControl
---@field btnTips UIKmlLuaControl
local KLGoldChallengeRewardItemView = {}
setmetatable(KLGoldChallengeRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLGoldChallengeReward/KLGoldChallengeRewardItemKml'
---@param parent UIKmlLuaControl
function KLGoldChallengeRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLGoldChallengeRewardItemView
