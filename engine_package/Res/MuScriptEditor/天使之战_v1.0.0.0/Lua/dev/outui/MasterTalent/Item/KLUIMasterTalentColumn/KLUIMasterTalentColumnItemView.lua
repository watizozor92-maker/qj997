---@class KLUIMasterTalentColumnItemView:UIKmlLuaViewBase
---@field SkillScrollview UIKmlLuaControl
---@field layout5 UIKmlLuaControl
---@field SkillDataList UIKmlLuaControl
local KLUIMasterTalentColumnItemView = {}
setmetatable(KLUIMasterTalentColumnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Item/KLUIMasterTalentColumn/KLUIMasterTalentColumnItemKml'
---@param parent UIKmlLuaControl
function KLUIMasterTalentColumnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIMasterTalentColumnItemView
