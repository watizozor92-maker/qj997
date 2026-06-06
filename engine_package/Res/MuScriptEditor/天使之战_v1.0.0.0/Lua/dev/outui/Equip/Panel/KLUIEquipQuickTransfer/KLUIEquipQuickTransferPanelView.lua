---@class KLUIEquipQuickTransferPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field img_78 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field btn_source_item UIKmlLuaControlHandler
---@field panel_equip_source UIKmlLuaControlHandler
---@field img_82 UIKmlLuaControlHandler
---@field btn_target_item UIKmlLuaControlHandler
---@field panel_equip_target UIKmlLuaControlHandler
---@field img_85 UIKmlLuaControlHandler
---@field tipContent UIKmlLuaControlHandler
---@field layout_87 UIKmlLuaControlHandler
---@field tips1 UIKmlLuaControlHandler
---@field tips2 UIKmlLuaControlHandler
---@field tips3 UIKmlLuaControlHandler
---@field text_91 UIKmlLuaControlHandler
---@field img_92 UIKmlLuaControlHandler
---@field item_cost UIKmlLuaControlHandler
---@field text_transfer_cost_name UIKmlLuaControlHandler
---@field img_95 UIKmlLuaControlHandler
---@field text_transfer_cost UIKmlLuaControlHandler
---@field btn_cancel UIKmlLuaControlHandler
---@field btn_transfer UIKmlLuaControlHandler
local KLUIEquipQuickTransferPanelView = {}
setmetatable(KLUIEquipQuickTransferPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLUIEquipQuickTransfer/KLUIEquipQuickTransferPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIEquipQuickTransferPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIEquipQuickTransferPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLUIEquipQuickTransfer/KLUIEquipQuickTransferPanel']

return KLUIEquipQuickTransferPanelView
