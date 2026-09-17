---@class KLBossOfferRewardBtnItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControlHandler
---@field level_select UIKmlLuaControlHandler
---@field type_name UIKmlLuaControlHandler
---@field img_completed_flag UIKmlLuaControlHandler
local KLBossOfferRewardBtnItemView = {}
setmetatable(KLBossOfferRewardBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BossOfferReward/Item/KLBossOfferRewardBtn/KLBossOfferRewardBtnItemKml'
---@param parent UIKmlLuaControlHandler
function KLBossOfferRewardBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBossOfferRewardBtnItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/BossOfferReward/Item/KLBossOfferRewardBtn/KLBossOfferRewardBtnItem']

return KLBossOfferRewardBtnItemView
