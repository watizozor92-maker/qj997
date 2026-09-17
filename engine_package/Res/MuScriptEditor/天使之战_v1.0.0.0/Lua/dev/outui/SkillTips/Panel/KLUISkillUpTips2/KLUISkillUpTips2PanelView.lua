---@class KLUISkillUpTips2PanelView:UIKmlLuaViewBase
---@field MaskCloseButton UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field SkillIcon UIKmlLuaControlHandler
---@field SkillName UIKmlLuaControlHandler
---@field SkillLvTitle UIKmlLuaControlHandler
---@field SkillLv UIKmlLuaControlHandler
---@field NeedPointTitle UIKmlLuaControlHandler
---@field NeedPoint UIKmlLuaControlHandler
---@field UpButton UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field SkillInfoDataList UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
local KLUISkillUpTips2PanelView = {}
setmetatable(KLUISkillUpTips2PanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/SkillTips/Panel/KLUISkillUpTips2/KLUISkillUpTips2PanelKml'
---@param parent UIKmlLuaControlHandler
function KLUISkillUpTips2PanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISkillUpTips2Panel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/SkillTips/Panel/KLUISkillUpTips2/KLUISkillUpTips2Panel']

return KLUISkillUpTips2PanelView
