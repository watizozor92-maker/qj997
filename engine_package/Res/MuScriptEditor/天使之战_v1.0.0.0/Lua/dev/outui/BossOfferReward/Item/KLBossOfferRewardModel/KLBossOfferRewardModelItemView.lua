---@class KLBossOfferRewardModelItemView:UIKmlLuaViewBase
---@field modelExp UIKmlLuaControlHandler
---@field img_6 UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field img_receive UIKmlLuaControlHandler
---@field btn_go_get UIKmlLuaControlHandler
---@field node UIKmlLuaControlHandler
---@field monster2 UIKmlLuaControlHandler
---@field monster UIKmlLuaControlHandler
local KLBossOfferRewardModelItemView = {}
setmetatable(KLBossOfferRewardModelItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BossOfferReward/Item/KLBossOfferRewardModel/KLBossOfferRewardModelItemKml'
---@param parent UIKmlLuaControlHandler
function KLBossOfferRewardModelItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBossOfferRewardModelItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/BossOfferReward/Item/KLBossOfferRewardModel/KLBossOfferRewardModelItem']

return KLBossOfferRewardModelItemView
