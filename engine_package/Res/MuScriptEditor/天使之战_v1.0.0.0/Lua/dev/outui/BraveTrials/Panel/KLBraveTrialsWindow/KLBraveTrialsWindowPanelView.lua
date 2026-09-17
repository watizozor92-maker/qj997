---@class KLBraveTrialsWindowPanelView:UIKmlLuaViewBase
---@field kml_bravetask_root UIKmlLuaControlHandler
---@field img_12 UIKmlLuaControlHandler
---@field img_13 UIKmlLuaControlHandler
---@field img_14 UIKmlLuaControlHandler
---@field title_task UIKmlLuaControlHandler
---@field exitBtn_task UIKmlLuaControlHandler
---@field panel_start UIKmlLuaControlHandler
---@field stageName_task UIKmlLuaControlHandler
---@field taskName_task UIKmlLuaControlHandler
---@field rewardTxt_task UIKmlLuaControlHandler
---@field taskProgress_task UIKmlLuaControlHandler
---@field rewardItem_layout UIKmlLuaControlHandler
---@field rewardItem_List UIKmlLuaControlHandler
---@field rewardItem_finish_layout UIKmlLuaControlHandler
---@field rewardItem_finish_List UIKmlLuaControlHandler
---@field countDown_in_copy UIKmlLuaControlHandler
---@field text_countdown_tips UIKmlLuaControlHandler
---@field countdown_out_copy UIKmlLuaControlHandler
---@field panel_finish UIKmlLuaControlHandler
---@field text_30 UIKmlLuaControlHandler
---@field btn_reward UIKmlLuaControlHandler
---@field btn_next UIKmlLuaControlHandler
local KLBraveTrialsWindowPanelView = {}
setmetatable(KLBraveTrialsWindowPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BraveTrials/Panel/KLBraveTrialsWindow/KLBraveTrialsWindowPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBraveTrialsWindowPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBraveTrialsWindowPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/BraveTrials/Panel/KLBraveTrialsWindow/KLBraveTrialsWindowPanel']

return KLBraveTrialsWindowPanelView
