---@class KLSkillSelectItemView:UIKmlLuaViewBase
---@field button1 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field img3 UIKmlLuaControl
local KLSkillSelectItemView = {}
setmetatable(KLSkillSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Skill/Item/KLSkillSelect/KLSkillSelectItemKml'
---@param parent UIKmlLuaControl
function KLSkillSelectItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLSkillSelectItemView
