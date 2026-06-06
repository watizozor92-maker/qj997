---@class KLUICommonTalentPanelView:UIKmlLuaViewBase
---@field PointTitle UIKmlLuaControl
---@field PointText UIKmlLuaControl
---@field ResetButton UIKmlLuaControl
---@field SkillScrollview UIKmlLuaControl
---@field layout3 UIKmlLuaControl
---@field SkillDataList UIKmlLuaControl
---@field Tips UIKmlLuaControl
local KLUICommonTalentPanelView = {}
setmetatable(KLUICommonTalentPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUICommonTalent/KLUICommonTalentPanelKml'
---@param parent UIKmlLuaControl
function KLUICommonTalentPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUICommonTalentPanelView
