---@class KLUISkillPageItemView:UIKmlLuaViewBase
---@field skillItemList UIKmlLuaControlHandler
---@field skillItemGrid UIKmlLuaControlHandler
local KLUISkillPageItemView = {}
setmetatable(KLUISkillPageItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Skill/Item/KLUISkillPage/KLUISkillPageItemKml'
---@param parent UIKmlLuaControlHandler
function KLUISkillPageItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLUISkillPageItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Skill/Item/KLUISkillPage/KLUISkillPageItem']

return KLUISkillPageItemView
