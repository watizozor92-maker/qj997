---@class KLSkillSelectPanelView:UIKmlLuaViewBase
---@field Close UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field listMask UIKmlLuaControl
---@field loopscrollview UIKmlLuaControl
---@field loopscrollviewData UIKmlLuaControl
local KLSkillSelectPanelView = {}
setmetatable(KLSkillSelectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Skill/Panel/KLSkillSelect/KLSkillSelectPanelKml'
---@param parent UIKmlLuaControl
function KLSkillSelectPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLSkillSelectPanelView
