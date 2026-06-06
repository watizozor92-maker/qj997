---@class KLActivityComboProgressPanelView:UIKmlLuaViewBase
---@field kml_combotask_root UIKmlLuaControlHandler
---@field img_12 UIKmlLuaControlHandler
---@field title_task UIKmlLuaControlHandler
---@field panel_start UIKmlLuaControlHandler
---@field stageName_task UIKmlLuaControlHandler
---@field rewardTxt_task UIKmlLuaControlHandler
---@field taskName_task UIKmlLuaControlHandler
---@field taskProgress_task UIKmlLuaControlHandler
---@field img_13 UIKmlLuaControlHandler
---@field exitBtn_task UIKmlLuaControlHandler
---@field countDown_in_copy UIKmlLuaControlHandler
---@field rewardItem_layout UIKmlLuaControlHandler
---@field rewardItem_List UIKmlLuaControlHandler
---@field img_14 UIKmlLuaControlHandler
---@field rewardItem_finish_layout UIKmlLuaControlHandler
---@field rewardItem_finish_List UIKmlLuaControlHandler
---@field txt_countDown UIKmlLuaControlHandler
---@field panel_finish UIKmlLuaControlHandler
---@field text_30 UIKmlLuaControlHandler
---@field btn_reward UIKmlLuaControlHandler
local KLActivityComboProgressPanelView = {}
setmetatable(KLActivityComboProgressPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLActivityComboProgress/KLActivityComboProgressPanelKml'
---@param parent UIKmlLuaControlHandler
function KLActivityComboProgressPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLActivityComboProgressPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLActivityComboProgress/KLActivityComboProgressPanel']

return KLActivityComboProgressPanelView
