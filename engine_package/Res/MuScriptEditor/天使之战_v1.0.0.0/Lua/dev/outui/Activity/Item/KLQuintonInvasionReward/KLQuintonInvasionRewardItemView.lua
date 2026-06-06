---@class KLQuintonInvasionRewardItemView:UIKmlLuaViewBase
---@field number UIKmlLuaControl
---@field rewardList UIKmlLuaControl
local KLQuintonInvasionRewardItemView = {}
setmetatable(KLQuintonInvasionRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLQuintonInvasionReward/KLQuintonInvasionRewardItemKml'
---@param parent UIKmlLuaControl
function KLQuintonInvasionRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLQuintonInvasionRewardItemView
