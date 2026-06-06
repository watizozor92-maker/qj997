---@class KLUISkillPageItemView:UIKmlLuaViewBase
---@field skillItemList UIKmlLuaControl
---@field skillItemGrid UIKmlLuaControl
local KLUISkillPageItemView = {}
setmetatable(KLUISkillPageItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Skill/Item/KLUISkillPage/KLUISkillPageItemKml'
---@param parent UIKmlLuaControl
function KLUISkillPageItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLUISkillPageItemView
