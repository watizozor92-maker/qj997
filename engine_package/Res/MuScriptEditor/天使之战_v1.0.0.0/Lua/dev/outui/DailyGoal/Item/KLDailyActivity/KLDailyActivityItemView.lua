---@class KLDailyActivityItemView:UIKmlLuaViewBase
---@field img_bg UIKmlLuaControl
---@field txt_title UIKmlLuaControl
---@field text_8 UIKmlLuaControl
---@field txt_rule_content UIKmlLuaControl
---@field text_10 UIKmlLuaControl
---@field txt_condition UIKmlLuaControl
---@field list_reward UIKmlLuaControl
---@field btn_go UIKmlLuaControl
---@field monsterInfoRoot UIKmlLuaControl
---@field monsterMapRoot UIKmlLuaControl
---@field monsterCountRoot UIKmlLuaControl
local KLDailyActivityItemView = {}
setmetatable(KLDailyActivityItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DailyGoal/Item/KLDailyActivity/KLDailyActivityItemKml'
---@param parent UIKmlLuaControl
function KLDailyActivityItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLDailyActivityItemView
