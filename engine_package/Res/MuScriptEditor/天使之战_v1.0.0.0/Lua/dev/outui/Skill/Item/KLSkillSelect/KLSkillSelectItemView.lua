---@class KLSkillSelectItemView:UIKmlLuaViewBase
---@field button1 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
local KLSkillSelectItemView = {}
setmetatable(KLSkillSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Skill/Item/KLSkillSelect/KLSkillSelectItemKml'
---@param parent UIKmlLuaControlHandler
function KLSkillSelectItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLSkillSelectItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Skill/Item/KLSkillSelect/KLSkillSelectItem']

return KLSkillSelectItemView
