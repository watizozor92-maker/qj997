---@class KLUISkillTalentPanelView:UIKmlLuaViewBase
---@field LvTitle UIKmlLuaControlHandler
---@field Lv UIKmlLuaControlHandler
---@field loadingbar UIKmlLuaControlHandler
---@field ExpText UIKmlLuaControlHandler
---@field ExchangeExpButton UIKmlLuaControlHandler
---@field ExchangeExpRedDot UIKmlLuaControlHandler
---@field PointTitle UIKmlLuaControlHandler
---@field PointText UIKmlLuaControlHandler
---@field ResetButton UIKmlLuaControlHandler
---@field LeftButton1 UIKmlLuaControlHandler
---@field LeftButton1_Title UIKmlLuaControlHandler
---@field LeftButton1_Icon UIKmlLuaControlHandler
---@field LeftButton1_Enable UIKmlLuaControlHandler
---@field LeftButton1_EnableText UIKmlLuaControlHandler
---@field LeftButton2 UIKmlLuaControlHandler
---@field LeftButton2_Title UIKmlLuaControlHandler
---@field LeftButton2_Icon UIKmlLuaControlHandler
---@field LeftButton2_Enable UIKmlLuaControlHandler
---@field LeftButton2_EnableText UIKmlLuaControlHandler
---@field LineList UIKmlLuaControlHandler
---@field Line UIKmlLuaControlHandler
---@field Line2 UIKmlLuaControlHandler
---@field Line3 UIKmlLuaControlHandler
---@field SkillScrollview UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field SkillDataList UIKmlLuaControlHandler
---@field scrollview2 UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
local KLUISkillTalentPanelView = {}
setmetatable(KLUISkillTalentPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUISkillTalent/KLUISkillTalentPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUISkillTalentPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISkillTalentPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MasterTalent/Panel/KLUISkillTalent/KLUISkillTalentPanel']

return KLUISkillTalentPanelView
