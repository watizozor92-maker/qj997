---@class KLBraveTrialsWindowPanelView:UIKmlLuaViewBase
---@field kml_bravetask_root UIKmlLuaControl
---@field title_task UIKmlLuaControl
---@field exitBtn_task UIKmlLuaControl
---@field stageName_task UIKmlLuaControl
---@field taskName_task UIKmlLuaControl
---@field rewardTxt_task UIKmlLuaControl
---@field taskProgress_task UIKmlLuaControl
---@field rewardItem_layout UIKmlLuaControl
---@field rewardItem_List UIKmlLuaControl
---@field countDown_in_copy UIKmlLuaControl
---@field text_countdown_tips UIKmlLuaControl
---@field countdown_out_copy UIKmlLuaControl
---@field panel_finish UIKmlLuaControl
---@field btn_reward UIKmlLuaControl
---@field btn_next UIKmlLuaControl
local KLBraveTrialsWindowPanelView = {}
setmetatable(KLBraveTrialsWindowPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BraveTrials/Panel/KLBraveTrialsWindow/KLBraveTrialsWindowPanelKml'
---@param parent UIKmlLuaControl
function KLBraveTrialsWindowPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLBraveTrialsWindowPanelView
