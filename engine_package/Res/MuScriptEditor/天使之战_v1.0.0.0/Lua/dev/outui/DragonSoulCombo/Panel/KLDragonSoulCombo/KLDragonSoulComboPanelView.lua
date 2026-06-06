---@class KLDragonSoulComboPanelView:UIKmlLuaViewBase
---@field img_11 UIKmlLuaControl
---@field img_13 UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field panel_upgrade UIKmlLuaControl
---@field panel_15 UIKmlLuaControl
---@field img_left_unActive UIKmlLuaControl
---@field img_left_active UIKmlLuaControl
---@field text_left_lv UIKmlLuaControl
---@field img_18 UIKmlLuaControl
---@field text_19 UIKmlLuaControl
---@field text_left_detail UIKmlLuaControl
---@field panel_21 UIKmlLuaControl
---@field img_22 UIKmlLuaControl
---@field text_right_lv UIKmlLuaControl
---@field img_24 UIKmlLuaControl
---@field text_25 UIKmlLuaControl
---@field text_right_detail UIKmlLuaControl
---@field panel_27 UIKmlLuaControl
---@field img_soul_type UIKmlLuaControl
---@field img_29 UIKmlLuaControl
---@field layout UIKmlLuaControl
---@field datalist_cost UIKmlLuaControl
---@field role UIKmlLuaControl
---@field role_effect UIKmlLuaControl
---@field btn_upgrade UIKmlLuaControl
---@field btn_max UIKmlLuaControl
---@field btn_back UIKmlLuaControl
---@field panel_max UIKmlLuaControl
---@field img_37 UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field text3 UIKmlLuaControl
---@field text_max_detail UIKmlLuaControl
---@field role_max UIKmlLuaControl
---@field role_effect_max UIKmlLuaControl
---@field strength_ok UIKmlLuaControl
local KLDragonSoulComboPanelView = {}
setmetatable(KLDragonSoulComboPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DragonSoulCombo/Panel/KLDragonSoulCombo/KLDragonSoulComboPanelKml'
---@param parent UIKmlLuaControl
function KLDragonSoulComboPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLDragonSoulComboPanelView
