---@class KLHuntingDemonsRewardItemView:UIKmlLuaViewBase
---@field img47 UIKmlLuaControl
---@field Reward_Item_RankText UIKmlLuaControl
---@field scrollview48 UIKmlLuaControl
---@field layout49 UIKmlLuaControl
---@field Reward_ItemDataList UIKmlLuaControl
local KLHuntingDemonsRewardItemView = {}
setmetatable(KLHuntingDemonsRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/HuntingDemons/Item/KLHuntingDemonsReward/KLHuntingDemonsRewardItemKml'
---@param parent UIKmlLuaControl
function KLHuntingDemonsRewardItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLHuntingDemonsRewardItemView
