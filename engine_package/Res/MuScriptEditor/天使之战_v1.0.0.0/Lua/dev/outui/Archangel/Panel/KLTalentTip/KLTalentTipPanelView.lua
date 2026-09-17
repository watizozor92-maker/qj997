---@class KLTalentTipPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field icon UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field dian UIKmlLuaControlHandler
---@field talentpoint UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field panel7 UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field currenttext UIKmlLuaControlHandler
---@field img11 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field nexttext UIKmlLuaControlHandler
---@field UpButton UIKmlLuaControlHandler
local KLTalentTipPanelView = {}
setmetatable(KLTalentTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLTalentTip/KLTalentTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTalentTipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTalentTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Panel/KLTalentTip/KLTalentTipPanel']

return KLTalentTipPanelView
