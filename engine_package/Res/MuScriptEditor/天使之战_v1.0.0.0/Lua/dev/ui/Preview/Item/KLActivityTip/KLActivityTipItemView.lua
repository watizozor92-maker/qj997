---@class KLActivityTipItemView:UIKmlLuaViewBase
---@field activityitem UIKmlLuaControl
---@field name UIKmlLuaControl
---@field state UIKmlLuaControl
---@field icon UIKmlLuaControl
---@field destimetxt UIKmlLuaControl
---@field endtime UIKmlLuaControl
local KLActivityTipItemView = {}
setmetatable(KLActivityTipItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Preview/Item/KLActivityTip/KLActivityTipItemKml'
---@param parent UIKmlLuaControl
function KLActivityTipItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLActivityTipItemView
