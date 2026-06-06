---@class KLActivityTipPanelView:UIKmlLuaViewBase
---@field panelAll UIKmlLuaControl
---@field background UIKmlLuaControl
---@field Title UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
---@field ActivitiesPanel UIKmlLuaControl
---@field ActivitiesView UIKmlLuaControl
---@field ActivitiesDataList UIKmlLuaControl
---@field ExpandArrow UIKmlLuaControl
---@field ContractArrow UIKmlLuaControl
---@field ViewAllActivities UIKmlLuaControl
local KLActivityTipPanelView = {}
setmetatable(KLActivityTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Preview/Panel/KLActivityTip/KLActivityTipPanelKml'
---@param parent UIKmlLuaControl
function KLActivityTipPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLActivityTipPanelView
