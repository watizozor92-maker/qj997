---@class KLDailyBoxRewardPanelView:UIKmlLuaViewBase
---@field item_group UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field img_title UIKmlLuaControl
---@field btn_get_reward UIKmlLuaControl
local KLDailyBoxRewardPanelView = {}
setmetatable(KLDailyBoxRewardPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DailyGoal/Panel/KLDailyBoxReward/KLDailyBoxRewardPanelKml'
---@param parent UIKmlLuaControl
function KLDailyBoxRewardPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLDailyBoxRewardPanelView
