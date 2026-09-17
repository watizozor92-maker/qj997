---@class KLGoldChallengeRewardItemView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field RewardItem UIKmlLuaControlHandler
---@field btnTips UIKmlLuaControlHandler
local KLGoldChallengeRewardItemView = {}
setmetatable(KLGoldChallengeRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLGoldChallengeReward/KLGoldChallengeRewardItemKml'
---@param parent UIKmlLuaControlHandler
function KLGoldChallengeRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLGoldChallengeRewardItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLGoldChallengeReward/KLGoldChallengeRewardItem']

return KLGoldChallengeRewardItemView
