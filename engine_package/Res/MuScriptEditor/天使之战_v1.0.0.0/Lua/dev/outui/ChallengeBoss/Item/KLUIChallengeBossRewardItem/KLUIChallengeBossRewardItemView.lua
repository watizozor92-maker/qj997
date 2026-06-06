---@class KLUIChallengeBossRewardItemView:UIKmlLuaViewBase
---@field equip_item UIKmlLuaControl
---@field img_quality UIKmlLuaControl
---@field effect_root UIKmlLuaControl
---@field effect_model UIKmlLuaControl
---@field arrow UIKmlLuaControl
---@field btn UIKmlLuaControl
local KLUIChallengeBossRewardItemView = {}
setmetatable(KLUIChallengeBossRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossRewardItem/KLUIChallengeBossRewardItemKml'
---@param parent UIKmlLuaControl
function KLUIChallengeBossRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIChallengeBossRewardItemView
