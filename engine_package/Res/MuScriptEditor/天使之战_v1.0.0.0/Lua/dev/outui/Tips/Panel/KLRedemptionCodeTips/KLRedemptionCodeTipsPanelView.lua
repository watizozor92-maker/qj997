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
---@type KLRedemptionCodeTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Tips/Panel/KLRedemptionCodeTips/KLRedemptionCodeTipsPanel']

return KLRedemptionCodeTipsPanelView
