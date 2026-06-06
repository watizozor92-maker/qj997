---@class KLSkillBtnItemView:UIKmlLuaViewBase
---@field BtnSkill UIKmlLuaControlHandler
---@field SkillIcon UIKmlLuaControlHandler
---@field Img_cdTime UIKmlLuaControlHandler
---@field selectBg UIKmlLuaControlHandler
---@field cdTime UIKmlLuaControlHandler
---@field lockImg UIKmlLuaControlHandler
---@field lockText UIKmlLuaControlHandler
---@field img_add UIKmlLuaControlHandler
local KLSkillBtnItemView = {}
setmetatable(KLSkillBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Item/KLSkillBtn/KLSkillBtnItemKml'
---@param parent UIKmlLuaControlHandler
function KLSkillBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSkillBtnItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Item/KLSkillBtn/KLSkillBtnItem']

return KLSkillBtnItemView
