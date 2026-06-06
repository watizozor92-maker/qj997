---@class KLDailyBoxRewardItemView:UIKmlLuaViewBase
---@field item UIKmlLuaControl
---@field txt_count UIKmlLuaControl
---@field btn_item UIKmlLuaControl
local KLDailyBoxRewardItemView = {}
setmetatable(KLDailyBoxRewardItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DailyGoal/Item/KLDailyBoxReward/KLDailyBoxRewardItemKml'
---@param parent UIKmlLuaControl
function KLDailyBoxRewardItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLDailyBoxRewardItemView
