---@class KLBraveTrialsPanelView:UIKmlLuaViewBase
---@field img_11 UIKmlLuaControl
---@field img_12 UIKmlLuaControl
---@field img_13 UIKmlLuaControl
---@field img_14 UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field osascroll_bravetrials UIKmlLuaControl
---@field list_brave_trials UIKmlLuaControl
---@field img_18 UIKmlLuaControl
---@field img_19 UIKmlLuaControl
---@field item_stage_reward UIKmlLuaControl
---@field img_stage_reward UIKmlLuaControl
---@field img_reward_click UIKmlLuaControl
---@field text_receive_reward UIKmlLuaControl
---@field model_show_monster UIKmlLuaControl
---@field cut_area_up UIKmlLuaControl
---@field img_26 UIKmlLuaControl
---@field img_27 UIKmlLuaControl
---@field text_current_level UIKmlLuaControl
---@field grid_pass_reward UIKmlLuaControl
---@field list_pass_reward UIKmlLuaControl
---@field img_33 UIKmlLuaControl
---@field text_34 UIKmlLuaControl
---@field text_pass_times UIKmlLuaControl
---@field btn_start_challenge UIKmlLuaControl
---@field text_challenge_tips UIKmlLuaControl
local KLBraveTrialsPanelView = {}
setmetatable(KLBraveTrialsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BraveTrials/Panel/KLBraveTrials/KLBraveTrialsPanelKml'
---@param parent UIKmlLuaControl
function KLBraveTrialsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLBraveTrialsPanelView
