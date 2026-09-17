---@class KLUISkillTipsPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field SkillIcon UIKmlLuaControlHandler
---@field SkillName UIKmlLuaControlHandler
---@field SkillLvTitle UIKmlLuaControlHandler
---@field SkillLv UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field SkillInfo UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
local KLUISkillTipsPanelView = {}
setmetatable(KLUISkillTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/SkillTips/Panel/KLUISkillTips/KLUISkillTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUISkillTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISkillTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/SkillTips/Panel/KLUISkillTips/KLUISkillTipsPanel']

return KLUISkillTipsPanelView
