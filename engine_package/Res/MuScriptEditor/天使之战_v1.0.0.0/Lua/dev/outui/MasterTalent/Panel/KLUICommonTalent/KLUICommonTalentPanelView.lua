---@class KLUICommonTalentPanelView:UIKmlLuaViewBase
---@field PointTitle UIKmlLuaControlHandler
---@field PointText UIKmlLuaControlHandler
---@field ResetButton UIKmlLuaControlHandler
---@field SkillScrollview UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field SkillDataList UIKmlLuaControlHandler
---@field Tips UIKmlLuaControlHandler
local KLUICommonTalentPanelView = {}
setmetatable(KLUICommonTalentPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Panel/KLUICommonTalent/KLUICommonTalentPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUICommonTalentPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUICommonTalentPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MasterTalent/Panel/KLUICommonTalent/KLUICommonTalentPanel']

return KLUICommonTalentPanelView
