---@class KLUIMasterTalentColumnItemView:UIKmlLuaViewBase
---@field SkillScrollview UIKmlLuaControlHandler
---@field layout5 UIKmlLuaControlHandler
---@field SkillDataList UIKmlLuaControlHandler
local KLUIMasterTalentColumnItemView = {}
setmetatable(KLUIMasterTalentColumnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Item/KLUIMasterTalentColumn/KLUIMasterTalentColumnItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIMasterTalentColumnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIMasterTalentColumnItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MasterTalent/Item/KLUIMasterTalentColumn/KLUIMasterTalentColumnItem']

return KLUIMasterTalentColumnItemView
