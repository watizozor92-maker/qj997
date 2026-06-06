---@class KLUIEquipTransferPanelView:UIKmlLuaViewBase
---@field equip_bg UIKmlLuaControlHandler
---@field panel_main UIKmlLuaControlHandler
---@field title_transfer UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field img_36 UIKmlLuaControlHandler
---@field panel_equip_source UIKmlLuaControlHandler
---@field panel_equip_source_item UIKmlLuaControlHandler
---@field img_equip_source_select UIKmlLuaControlHandler
---@field img_equip_source_add UIKmlLuaControlHandler
---@field img_41 UIKmlLuaControlHandler
---@field btn_equip_source_takeoff UIKmlLuaControlHandler
---@field panel_equip_target UIKmlLuaControlHandler
---@field panel_equip_target_item UIKmlLuaControlHandler
---@field img_equip_target_select UIKmlLuaControlHandler
---@field img_equip_target_add UIKmlLuaControlHandler
---@field img_equip_target_select_text UIKmlLuaControlHandler
---@field btn_equip_target_takeoff UIKmlLuaControlHandler
---@field img_49 UIKmlLuaControlHandler
---@field img_50 UIKmlLuaControlHandler
---@field toggle_transfer_strengthen UIKmlLuaControlHandler
---@field img_transfer_strengthen UIKmlLuaControlHandler
---@field toggle_transfer_append UIKmlLuaControlHandler
---@field img_transfer_append UIKmlLuaControlHandler
---@field panel_55 UIKmlLuaControlHandler
---@field img_56 UIKmlLuaControlHandler
---@field text_57 UIKmlLuaControlHandler
---@field cost_panel UIKmlLuaControlHandler
---@field item_cost UIKmlLuaControlHandler
---@field text_cost_item_name UIKmlLuaControlHandler
---@field text_item_bag_count UIKmlLuaControlHandler
---@field success_anim UIKmlLuaControlHandler
---@field successText UIKmlLuaControlHandler
---@field btn_transfer UIKmlLuaControlHandler
---@field text_reborn_tips UIKmlLuaControlHandler
local KLUIEquipTransferPanelView = {}
setmetatable(KLUIEquipTransferPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLUIEquipTransfer/KLUIEquipTransferPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIEquipTransferPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIEquipTransferPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLUIEquipTransfer/KLUIEquipTransferPanel']

return KLUIEquipTransferPanelView
