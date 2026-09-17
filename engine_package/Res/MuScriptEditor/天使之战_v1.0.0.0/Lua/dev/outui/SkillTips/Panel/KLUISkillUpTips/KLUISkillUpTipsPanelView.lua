---@class KLUISkillUpTipsPanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field SkillIcon UIKmlLuaControlHandler
---@field SkillLvTitle UIKmlLuaControlHandler
---@field SkillLv UIKmlLuaControlHandler
---@field SkillName UIKmlLuaControlHandler
---@field NeedPointTitle UIKmlLuaControlHandler
---@field NeedPoint UIKmlLuaControlHandler
---@field UpButton UIKmlLuaControlHandler
---@field scrollview3 UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field nowInfo UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field NowSkillInfo UIKmlLuaControlHandler
---@field nextInfo UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field NextSkillInfo UIKmlLuaControlHandler
local KLUISkillUpTipsPanelView = {}
setmetatable(KLUISkillUpTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/SkillTips/Panel/KLUISkillUpTips/KLUISkillUpTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUISkillUpTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISkillUpTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/SkillTips/Panel/KLUISkillUpTips/KLUISkillUpTipsPanel']

return KLUISkillUpTipsPanelView
