---@class KLUISkillTipsPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControl
---@field BG UIKmlLuaControl
---@field SkillIcon UIKmlLuaControl
---@field SkillName UIKmlLuaControl
---@field SkillLvTitle UIKmlLuaControl
---@field SkillLv UIKmlLuaControl
---@field img5 UIKmlLuaControl
---@field img9 UIKmlLuaControl
---@field SkillInfo UIKmlLuaControl
---@field CloseButton UIKmlLuaControl
local KLUISkillTipsPanelView = {}
setmetatable(KLUISkillTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/SkillTips/Panel/KLUISkillTips/KLUISkillTipsPanelKml'
---@param parent UIKmlLuaControl
function KLUISkillTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUISkillTipsPanelView
