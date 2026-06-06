---@class KLHuntingDemonsHallOfFamePanelView:UIKmlLuaViewBase
---@field img_36 UIKmlLuaControl
---@field btn_shop UIKmlLuaControl
---@field btn_go UIKmlLuaControl
---@field item UIKmlLuaControl
---@field NumText UIKmlLuaControl
---@field img_20 UIKmlLuaControl
---@field text_21 UIKmlLuaControl
---@field timeText UIKmlLuaControl
---@field role_mid UIKmlLuaControl
---@field role_left UIKmlLuaControl
---@field role_right UIKmlLuaControl
---@field HelpButton UIKmlLuaControl
---@field roleTitle1 UIKmlLuaControl
---@field role_mid_integral_Text UIKmlLuaControl
---@field role_mid_item_Text UIKmlLuaControl
---@field role_mid_name_Text UIKmlLuaControl
---@field roleTitle2 UIKmlLuaControl
---@field role_left_integral_Text UIKmlLuaControl
---@field role_left_item_Text UIKmlLuaControl
---@field role_left_name_Text UIKmlLuaControl
---@field roleTitle3 UIKmlLuaControl
---@field role_right_integral_Text UIKmlLuaControl
---@field role_right_item_Text UIKmlLuaControl
---@field role_right_name_Text UIKmlLuaControl
local KLHuntingDemonsHallOfFamePanelView = {}
setmetatable(KLHuntingDemonsHallOfFamePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/HuntingDemons/Panel/KLHuntingDemonsHallOfFame/KLHuntingDemonsHallOfFamePanelKml'
---@param parent UIKmlLuaControl
function KLHuntingDemonsHallOfFamePanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLHuntingDemonsHallOfFamePanelView
