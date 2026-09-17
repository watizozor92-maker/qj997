---@class KLPersonalRewardItemView:UIKmlLuaViewBase
---@field img47 UIKmlLuaControlHandler
---@field Reward_Item_RankText UIKmlLuaControlHandler
---@field scrollview48 UIKmlLuaControlHandler
---@field layout49 UIKmlLuaControlHandler
---@field Reward_ItemDataList UIKmlLuaControlHandler
local KLPersonalRewardItemView = {}
setmetatable(KLPersonalRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/LoranSiege/Item/KLPersonalReward/KLPersonalRewardItemKml'
---@param parent UIKmlLuaControlHandler
function KLPersonalRewardItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLPersonalRewardItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/LoranSiege/Item/KLPersonalReward/KLPersonalRewardItem']

return KLPersonalRewardItemView
