---@class KLUISkillTalentPanelView:UIKmlLuaViewBase
---@field LvTitle UIKmlLuaControl
---@field Lv UIKmlLuaControl
---@field loadingbar UIKmlLuaControl
---@field ExpText UIKmlLuaControl
---@field ExchangeExpButton UIKmlLuaControl
---@field ExchangeExpRedDot UIKmlLuaControl
---@field PointTitle UIKmlLuaControl
---@field PointText UIKmlLuaControl
---@field ResetButton UIKmlLuaControl
---@field LeftButton1 UIKmlLuaControl
---@field LeftButton1_Title UIKmlLuaControl
---@field LeftButton1_Icon UIKmlLuaControl
---@field LeftButton1_Enable UIKmlLuaControl
---@field LeftButton1_EnableText UIKmlLuaControl
---@field LeftButton2 UIKmlLuaControl
---@field LeftButton2_Title UIKmlLuaControl
---@field LeftButton2_Icon UIKmlLuaControl
---@field LeftButton2_Enable UIKmlLuaControl
---@field LeftButton2_EnableText UIKmlLuaControl
---@field LineList UIKmlLuaControl
---@field Line UIKmlLuaControl
---@field Line2 UIKmlLuaControl
---@field Line3 UIKmlLuaControl
---@field SkillScrollview UIKmlLuaControl
---@field layout3 UIKmlLuaControl
---@field SkillDataList UIKmlLuaControl
---@field scrollview2 UIKmlLuaControl
---@field layout4 UIKmlLuaControl
---@field text6 UIKmlLuaControl
---@field text7 UIKmlLuaControl
---@field text8 UIKmlLuaControl
local KLUISkillTalentPanelView = {}
setmetatable(KLUISkillTalentPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUISkillTalent/KLUISkillTalentPanelKml'
---@param parent UIKmlLuaControl
function KLUISkillTalentPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUISkillTalentPanelView
