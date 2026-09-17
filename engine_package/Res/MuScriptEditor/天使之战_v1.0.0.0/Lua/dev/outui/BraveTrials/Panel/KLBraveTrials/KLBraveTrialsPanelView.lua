---@class KLBraveTrialsPanelView:UIKmlLuaViewBase
---@field img_11 UIKmlLuaControlHandler
---@field img_12 UIKmlLuaControlHandler
---@field img_13 UIKmlLuaControlHandler
---@field img_14 UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field osascroll_bravetrials UIKmlLuaControlHandler
---@field list_brave_trials UIKmlLuaControlHandler
---@field img_18 UIKmlLuaControlHandler
---@field img_19 UIKmlLuaControlHandler
---@field item_stage_reward UIKmlLuaControlHandler
---@field img_stage_reward UIKmlLuaControlHandler
---@field img_reward_click UIKmlLuaControlHandler
---@field text_receive_reward UIKmlLuaControlHandler
---@field model_show_monster UIKmlLuaControlHandler
---@field cut_area_up UIKmlLuaControlHandler
---@field img_26 UIKmlLuaControlHandler
---@field img_27 UIKmlLuaControlHandler
---@field text_current_level UIKmlLuaControlHandler
---@field grid_pass_reward UIKmlLuaControlHandler
---@field list_pass_reward UIKmlLuaControlHandler
---@field img_33 UIKmlLuaControlHandler
---@field text_34 UIKmlLuaControlHandler
---@field text_pass_times UIKmlLuaControlHandler
---@field btn_start_challenge UIKmlLuaControlHandler
---@field text_challenge_tips UIKmlLuaControlHandler
local KLBraveTrialsPanelView = {}
setmetatable(KLBraveTrialsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BraveTrials/Panel/KLBraveTrials/KLBraveTrialsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBraveTrialsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBraveTrialsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/BraveTrials/Panel/KLBraveTrials/KLBraveTrialsPanel']

return KLBraveTrialsPanelView
