---@class KLRedemptionCodeTipsPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field input UIKmlLuaControlHandler
local KLRedemptionCodeTipsPanelView = {}
setmetatable(KLRedemptionCodeTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Tips/Panel/KLRedemptionCodeTips/KLRedemptionCodeTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLRedemptionCodeTipsPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLRedemptionCodeTipsPanelView
