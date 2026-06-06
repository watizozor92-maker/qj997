---@class KLSkillInfoItemView:UIKmlLuaViewBase
---@field ImageSkillIcon UIKmlLuaControl
---@field TextSkillName UIKmlLuaControl
---@field Bg UIKmlLuaControl
local KLSkillInfoItemView = {}
setmetatable(KLSkillInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Career/Item/KLSkillInfoItem/KLSkillInfoItemKml'
---@param parent UIKmlLuaControl
function KLSkillInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLSkillInfoItemView
