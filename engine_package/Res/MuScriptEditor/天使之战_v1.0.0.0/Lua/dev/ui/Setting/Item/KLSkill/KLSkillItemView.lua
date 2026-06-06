---@class KLSkillItemView:UIKmlLuaViewBase
---@field selectSkillBtn UIKmlLuaControlHandler
---@field skillDes UIKmlLuaControlHandler
---@field skillBg UIKmlLuaControlHandler
---@field SkillIcon UIKmlLuaControlHandler
---@field line UIKmlLuaControlHandler
local KLSkillItemView = {}
setmetatable(KLSkillItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Item/KLSkill/KLSkillItemKml'
---@param parent UIKmlLuaControlHandler
function KLSkillItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSkillItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Item/KLSkill/KLSkillItem']

return KLSkillItemView
