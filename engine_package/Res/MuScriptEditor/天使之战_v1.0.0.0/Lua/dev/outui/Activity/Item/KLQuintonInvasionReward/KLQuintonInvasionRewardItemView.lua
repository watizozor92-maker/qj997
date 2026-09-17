---@class KLQuintonInvasionRewardItemView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field img26 UIKmlLuaControlHandler
---@field number UIKmlLuaControlHandler
---@field rewardList1 UIKmlLuaControlHandler
---@field layout31 UIKmlLuaControlHandler
---@field rewardList UIKmlLuaControlHandler
local KLQuintonInvasionRewardItemView = {}
setmetatable(KLQuintonInvasionRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLQuintonInvasionReward/KLQuintonInvasionRewardItemKml'
---@param parent UIKmlLuaControlHandler
function KLQuintonInvasionRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLQuintonInvasionRewardItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLQuintonInvasionReward/KLQuintonInvasionRewardItem']

return KLQuintonInvasionRewardItemView
