---@class KLActivityTipItemView:UIKmlLuaViewBase
---@field activityitem UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field state UIKmlLuaControlHandler
---@field icon UIKmlLuaControlHandler
---@field destimetxt UIKmlLuaControlHandler
---@field endtime UIKmlLuaControlHandler
local KLActivityTipItemView = {}
setmetatable(KLActivityTipItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Preview/Item/KLActivityTip/KLActivityTipItemKml'
---@param parent UIKmlLuaControlHandler
function KLActivityTipItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLActivityTipItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Preview/Item/KLActivityTip/KLActivityTipItem']

return KLActivityTipItemView
