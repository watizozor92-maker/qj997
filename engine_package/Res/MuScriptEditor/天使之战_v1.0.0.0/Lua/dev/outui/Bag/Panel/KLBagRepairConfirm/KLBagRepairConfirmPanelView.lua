---@class KLBagRepairConfirmPanelView:UIKmlLuaViewBase
---@field img1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field tipsContent UIKmlLuaControlHandler
---@field btn_sure UIKmlLuaControlHandler
---@field btn_cancel UIKmlLuaControlHandler
---@field btn_tog UIKmlLuaControlHandler
---@field img_select UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLBagRepairConfirmPanelView = {}
setmetatable(KLBagRepairConfirmPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Bag/Panel/KLBagRepairConfirm/KLBagRepairConfirmPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBagRepairConfirmPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLBagRepairConfirmPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Bag/Panel/KLBagRepairConfirm/KLBagRepairConfirmPanel']

return KLBagRepairConfirmPanelView
