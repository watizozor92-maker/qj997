---@class KLArchangelTalentPanelView:UIKmlLuaViewBase
---@field panel_50 UIKmlLuaControlHandler
---@field talent_layout UIKmlLuaControlHandler
---@field talentName_data UIKmlLuaControlHandler
---@field talent_pge UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field img21 UIKmlLuaControlHandler
---@field talent_cost_num UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field talent_num UIKmlLuaControlHandler
---@field reset_talent UIKmlLuaControlHandler
---@field layout6 UIKmlLuaControlHandler
---@field talent_data UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field loadingbar_lv UIKmlLuaControlHandler
---@field exp_info_text UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field total_level_text UIKmlLuaControlHandler
---@field talent_master UIKmlLuaControlHandler
---@field tip UIKmlLuaControlHandler
---@field tip_mask UIKmlLuaControlHandler
---@field tip_bg UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field point1 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field point2 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field cost_item UIKmlLuaControlHandler
---@field cost_text UIKmlLuaControlHandler
---@field tip_cancel UIKmlLuaControlHandler
---@field tip_sure UIKmlLuaControlHandler
local KLArchangelTalentPanelView = {}
setmetatable(KLArchangelTalentPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelTalent/KLArchangelTalentPanelKml'
---@param parent UIKmlLuaControlHandler
function KLArchangelTalentPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLArchangelTalentPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Panel/KLArchangelTalent/KLArchangelTalentPanel']

return KLArchangelTalentPanelView
