---@class KLArchangelTalentPanelView:UIKmlLuaViewBase
---@field panel_50 UIKmlLuaControl
---@field talent_layout UIKmlLuaControl
---@field talentName_data UIKmlLuaControl
---@field talent_pge UIKmlLuaControl
---@field panel2 UIKmlLuaControl
---@field img21 UIKmlLuaControl
---@field talent_cost_num UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field talent_num UIKmlLuaControl
---@field reset_talent UIKmlLuaControl
---@field layout6 UIKmlLuaControl
---@field talent_data UIKmlLuaControl
---@field panel1 UIKmlLuaControl
---@field loadingbar_lv UIKmlLuaControl
---@field exp_info_text UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field total_level_text UIKmlLuaControl
---@field talent_master UIKmlLuaControl
---@field tip UIKmlLuaControl
---@field tip_mask UIKmlLuaControl
---@field tip_bg UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field point1 UIKmlLuaControl
---@field text4 UIKmlLuaControl
---@field point2 UIKmlLuaControl
---@field text6 UIKmlLuaControl
---@field img7 UIKmlLuaControl
---@field cost_item UIKmlLuaControl
---@field cost_text UIKmlLuaControl
---@field tip_cancel UIKmlLuaControl
---@field tip_sure UIKmlLuaControl
local KLArchangelTalentPanelView = {}
setmetatable(KLArchangelTalentPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelTalent/KLArchangelTalentPanelKml'
---@param parent UIKmlLuaControl
function KLArchangelTalentPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLArchangelTalentPanelView
