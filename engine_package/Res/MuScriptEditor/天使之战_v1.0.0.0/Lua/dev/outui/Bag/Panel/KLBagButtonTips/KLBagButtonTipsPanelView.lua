---@class KLBagButtonTipsPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field GoRecycleBtn UIKmlLuaControlHandler
---@field GoAutoRecycleBtn UIKmlLuaControlHandler
---@field leftDataBtn UIKmlLuaControlHandler
---@field leftDataBtnSelectImg UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLBagButtonTipsPanelView = {}
setmetatable(KLBagButtonTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Bag/Panel/KLBagButtonTips/KLBagButtonTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBagButtonTipsPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLBagButtonTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Bag/Panel/KLBagButtonTips/KLBagButtonTipsPanel']

return KLBagButtonTipsPanelView
