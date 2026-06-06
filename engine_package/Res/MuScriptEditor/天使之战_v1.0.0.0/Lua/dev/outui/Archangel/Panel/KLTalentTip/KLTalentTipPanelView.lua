---@class KLTalentTipPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field panel2 UIKmlLuaControl
---@field icon UIKmlLuaControl
---@field name UIKmlLuaControl
---@field text2 UIKmlLuaControl
---@field level UIKmlLuaControl
---@field text5 UIKmlLuaControl
---@field dian UIKmlLuaControl
---@field talentpoint UIKmlLuaControl
---@field text6 UIKmlLuaControl
---@field panel7 UIKmlLuaControl
---@field img8 UIKmlLuaControl
---@field img9 UIKmlLuaControl
---@field currenttext UIKmlLuaControl
---@field img11 UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field nexttext UIKmlLuaControl
---@field UpButton UIKmlLuaControl
local KLTalentTipPanelView = {}
setmetatable(KLTalentTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLTalentTip/KLTalentTipPanelKml'
---@param parent UIKmlLuaControl
function KLTalentTipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTalentTipPanelView
