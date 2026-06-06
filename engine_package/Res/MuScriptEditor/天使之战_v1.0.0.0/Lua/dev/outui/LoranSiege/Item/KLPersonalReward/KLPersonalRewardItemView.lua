---@class KLPersonalRewardItemView:UIKmlLuaViewBase
---@field img47 UIKmlLuaControl
---@field Reward_Item_RankText UIKmlLuaControl
---@field scrollview48 UIKmlLuaControl
---@field layout49 UIKmlLuaControl
---@field Reward_ItemDataList UIKmlLuaControl
local KLPersonalRewardItemView = {}
setmetatable(KLPersonalRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/LoranSiege/Item/KLPersonalReward/KLPersonalRewardItemKml'
---@param parent UIKmlLuaControl
function KLPersonalRewardItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLPersonalRewardItemView
