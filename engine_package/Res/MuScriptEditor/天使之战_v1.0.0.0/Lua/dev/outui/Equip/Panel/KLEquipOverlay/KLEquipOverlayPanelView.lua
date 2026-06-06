---@class KLEquipOverlayPanelView:UIKmlLuaViewBase
---@field equip_bg UIKmlLuaControlHandler
---@field OverlayPanel UIKmlLuaControlHandler
---@field overlay_title UIKmlLuaControlHandler
---@field closePanel UIKmlLuaControlHandler
---@field helptip UIKmlLuaControlHandler
---@field img_10 UIKmlLuaControlHandler
---@field zhuEquip UIKmlLuaControlHandler
---@field zhu_overlay_itembg UIKmlLuaControlHandler
---@field title_zhuequip UIKmlLuaControlHandler
---@field zhu_item UIKmlLuaControlHandler
---@field zhu_bg_overlay_select UIKmlLuaControlHandler
---@field zhu_add UIKmlLuaControlHandler
---@field zhu_click UIKmlLuaControlHandler
---@field img_19 UIKmlLuaControlHandler
---@field fuEquip UIKmlLuaControlHandler
---@field fu_overlay_itembg UIKmlLuaControlHandler
---@field title_fuequip UIKmlLuaControlHandler
---@field fu_item UIKmlLuaControlHandler
---@field fu_bg_overlay_select UIKmlLuaControlHandler
---@field fu_add UIKmlLuaControlHandler
---@field fu_click UIKmlLuaControlHandler
---@field item_attr_panel UIKmlLuaControlHandler
---@field Luckystone UIKmlLuaControlHandler
---@field LuckystoneCount UIKmlLuaControlHandler
---@field LuckyClick UIKmlLuaControlHandler
---@field Luckystonenull UIKmlLuaControlHandler
---@field successIcon UIKmlLuaControlHandler
---@field success_rate1 UIKmlLuaControlHandler
---@field success_rate2 UIKmlLuaControlHandler
---@field scroll_entry UIKmlLuaControlHandler
---@field grid_entry UIKmlLuaControlHandler
---@field entry_list UIKmlLuaControlHandler
---@field img_34 UIKmlLuaControlHandler
---@field text_35 UIKmlLuaControlHandler
---@field cost_scroll UIKmlLuaControlHandler
---@field gridview2 UIKmlLuaControlHandler
---@field cost_list UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field Overlay_btn UIKmlLuaControlHandler
---@field Add_CostItem_panel UIKmlLuaControlHandler
---@field CostItem_mask UIKmlLuaControlHandler
---@field CostItem_BG UIKmlLuaControlHandler
---@field costItem_successIcon UIKmlLuaControlHandler
---@field rate_text1 UIKmlLuaControlHandler
---@field rate_text2 UIKmlLuaControlHandler
---@field rate_item_add UIKmlLuaControlHandler
---@field rate_item_slider UIKmlLuaControlHandler
---@field rate_item_sub UIKmlLuaControlHandler
---@field rate_CostItem UIKmlLuaControlHandler
---@field costItem_name UIKmlLuaControlHandler
---@field total_CostItem UIKmlLuaControlHandler
---@field use_costItem UIKmlLuaControlHandler
---@field rate_sure_btn UIKmlLuaControlHandler
---@field max_success_rate UIKmlLuaControlHandler
---@field result_panel UIKmlLuaControlHandler
---@field result_success_img UIKmlLuaControlHandler
---@field result_success_text UIKmlLuaControlHandler
---@field result_fail_img UIKmlLuaControlHandler
---@field result_fail_text UIKmlLuaControlHandler
local KLEquipOverlayPanelView = {}
setmetatable(KLEquipOverlayPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLEquipOverlay/KLEquipOverlayPanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipOverlayPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipOverlayPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLEquipOverlay/KLEquipOverlayPanel']

return KLEquipOverlayPanelView
