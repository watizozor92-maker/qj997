---@class KLUISkillItemView:UIKmlLuaViewBase
---@field skillTog UIKmlLuaControl
---@field prefab_55 UIKmlLuaControl
---@field KmlXWSkillItemTemplate UIKmlLuaControl
---@field skillTog1 UIKmlLuaControl
---@field SkillIcon UIKmlLuaControl
---@field SpRed UIKmlLuaControl
---@field Level UIKmlLuaControl
---@field Lock UIKmlLuaControl
---@field BgName UIKmlLuaControl
---@field SkillName UIKmlLuaControl
local KLUISkillItemView = {}
setmetatable(KLUISkillItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Skill/Item/KLUISkill/KLUISkillItemKml'
---@param parent UIKmlLuaControl
function KLUISkillItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUISkillItemView
