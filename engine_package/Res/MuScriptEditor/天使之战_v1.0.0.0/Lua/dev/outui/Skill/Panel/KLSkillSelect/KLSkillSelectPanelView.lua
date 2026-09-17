---@class KLSkillSelectPanelView:UIKmlLuaViewBase
---@field Close UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field listMask UIKmlLuaControlHandler
---@field loopscrollview UIKmlLuaControlHandler
---@field loopscrollviewData UIKmlLuaControlHandler
local KLSkillSelectPanelView = {}
setmetatable(KLSkillSelectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Skill/Panel/KLSkillSelect/KLSkillSelectPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSkillSelectPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLSkillSelectPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Skill/Panel/KLSkillSelect/KLSkillSelectPanel']

return KLSkillSelectPanelView
