---@class KLDailyActiveItemView:UIKmlLuaViewBase
---@field icon UIKmlLuaControl
---@field name UIKmlLuaControl
---@field active_per_time UIKmlLuaControl
---@field active_info UIKmlLuaControl
---@field btn_goto UIKmlLuaControl
---@field txt_tip UIKmlLuaControl
---@field txt_done UIKmlLuaControl
local KLDailyActiveItemView = {}
setmetatable(KLDailyActiveItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DailyGoal/Item/KLDailyActiveItem/KLDailyActiveItemKml'
---@param parent UIKmlLuaControl
function KLDailyActiveItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLDailyActiveItemView
