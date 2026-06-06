---@class KLUISkillUpTips2PanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControl
---@field BG UIKmlLuaControl
---@field SkillIcon UIKmlLuaControl
---@field SkillName UIKmlLuaControl
---@field SkillLvTitle UIKmlLuaControl
---@field SkillLv UIKmlLuaControl
---@field NeedPointTitle UIKmlLuaControl
---@field NeedPoint UIKmlLuaControl
---@field UpButton UIKmlLuaControl
---@field scrollview1 UIKmlLuaControl
---@field layout2 UIKmlLuaControl
---@field SkillInfoDataList UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field img9 UIKmlLuaControl
local KLUISkillUpTips2PanelView = {}
setmetatable(KLUISkillUpTips2PanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/SkillTips/Panel/KLUISkillUpTips2/KLUISkillUpTips2PanelKml'
---@param parent UIKmlLuaControl
function KLUISkillUpTips2PanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUISkillUpTips2PanelView
