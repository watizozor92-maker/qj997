---@class KLHuntingDemonsMainPanelView:UIKmlLuaViewBase
---@field MaskButton UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field togglegroup3 UIKmlLuaControl
---@field toggle_HallOfFame UIKmlLuaControl
---@field text5 UIKmlLuaControl
---@field toggle_Reward UIKmlLuaControl
---@field text7 UIKmlLuaControl
---@field button_close UIKmlLuaControl
---@field img3 UIKmlLuaControl
local KLHuntingDemonsMainPanelView = {}
setmetatable(KLHuntingDemonsMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/HuntingDemons/Panel/KLHuntingDemonsMain/KLHuntingDemonsMainPanelKml'
---@param parent UIKmlLuaControl
function KLHuntingDemonsMainPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLHuntingDemonsMainPanelView
