---@class KLUIChallengeBossRewardItemView:UIKmlLuaViewBase
---@field equip_item UIKmlLuaControlHandler
---@field img_quality UIKmlLuaControlHandler
---@field effect_root UIKmlLuaControlHandler
---@field effect_model UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field btn UIKmlLuaControlHandler
local KLUIChallengeBossRewardItemView = {}
setmetatable(KLUIChallengeBossRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChallengeBossRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChallengeBossRewardItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItem']

return KLUIChallengeBossRewardItemView
