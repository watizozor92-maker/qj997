---@class KLActivityTipPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field panelAll UIKmlLuaControlHandler
---@field background UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field ActivitiesPanel UIKmlLuaControlHandler
---@field ActivitiesView UIKmlLuaControlHandler
---@field ActivitiesDataList UIKmlLuaControlHandler
---@field ExpandArrow UIKmlLuaControlHandler
---@field ContractArrow UIKmlLuaControlHandler
---@field ViewAllActivities UIKmlLuaControlHandler
local KLActivityTipPanelView = {}
setmetatable(KLActivityTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Preview/Panel/KLActivityTip/KLActivityTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLActivityTipPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLActivityTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Preview/Panel/KLActivityTip/KLActivityTipPanel']

return KLActivityTipPanelView
