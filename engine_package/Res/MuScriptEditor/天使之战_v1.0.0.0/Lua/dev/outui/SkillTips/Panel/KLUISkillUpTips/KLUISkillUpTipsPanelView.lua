---@class KLUISkillUpTipsPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControl
---@field BG UIKmlLuaControl
---@field SkillIcon UIKmlLuaControl
---@field SkillLvTitle UIKmlLuaControl
---@field SkillLv UIKmlLuaControl
---@field SkillName UIKmlLuaControl
---@field NeedPointTitle UIKmlLuaControl
---@field NeedPoint UIKmlLuaControl
---@field UpButton UIKmlLuaControl
---@field scrollview3 UIKmlLuaControl
---@field layout4 UIKmlLuaControl
---@field nowInfo UIKmlLuaControl
---@field img7 UIKmlLuaControl
---@field img9 UIKmlLuaControl
---@field NowSkillInfo UIKmlLuaControl
---@field nextInfo UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field NextSkillInfo UIKmlLuaControl
local KLUISkillUpTipsPanelView = {}
setmetatable(KLUISkillUpTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/SkillTips/Panel/KLUISkillUpTips/KLUISkillUpTipsPanelKml'
---@param parent UIKmlLuaControl
function KLUISkillUpTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUISkillUpTipsPanelView
