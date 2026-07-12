---@class KLUISkillItemView:UIKmlLuaViewBase
---@field skillTog UIKmlLuaControlHandler
---@field prefab_55 UIKmlLuaControlHandler
---@field KmlXWSkillItemTemplate UIKmlLuaControlHandler
---@field skillTog1 UIKmlLuaControlHandler
---@field SkillIcon UIKmlLuaControlHandler
---@field SpRed UIKmlLuaControlHandler
---@field Level UIKmlLuaControlHandler
---@field Lock UIKmlLuaControlHandler
---@field BgName UIKmlLuaControlHandler
---@field SkillName UIKmlLuaControlHandler
local KLUISkillItemView = {}
setmetatable(KLUISkillItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Skill/Item/KLUISkill/KLUISkillItemKml'
---@param parent UIKmlLuaControlHandler
function KLUISkillItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISkillItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Skill/Item/KLUISkill/KLUISkillItem']

return KLUISkillItemView
