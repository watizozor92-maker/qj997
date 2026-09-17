---@class KLUIItemTipsPanelView:UIKmlLuaViewBase
---@field background_close UIKmlLuaControlHandler
---@field panel_bg UIKmlLuaControlHandler
---@field title_bg UIKmlLuaControlHandler
---@field text_title UIKmlLuaControlHandler
---@field jichu_layout UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field item_name UIKmlLuaControlHandler
---@field node_name UIKmlLuaControlHandler
---@field text_MU_node UIKmlLuaControlHandler
---@field text_MU UIKmlLuaControlHandler
---@field text_deal_node UIKmlLuaControlHandler
---@field text_deal UIKmlLuaControlHandler
---@field text_gem_node UIKmlLuaControlHandler
---@field text_gem UIKmlLuaControlHandler
---@field task_text_node UIKmlLuaControlHandler
---@field task_text UIKmlLuaControlHandler
---@field attr_txt_node UIKmlLuaControlHandler
---@field attr_txt UIKmlLuaControlHandler
---@field view_node_offset_2 UIKmlLuaControlHandler
---@field view_info UIKmlLuaControlHandler
---@field top_text UIKmlLuaControlHandler
---@field mid_text UIKmlLuaControlHandler
---@field bottom_text UIKmlLuaControlHandler
---@field view_node_offset_1 UIKmlLuaControlHandler
---@field overlyingTxt_node UIKmlLuaControlHandler
---@field overlyingTxt UIKmlLuaControlHandler
---@field bindOverlyingTxt_node UIKmlLuaControlHandler
---@field bindOverlyingTxt UIKmlLuaControlHandler
---@field base_list_layout UIKmlLuaControlHandler
---@field base_info_data UIKmlLuaControlHandler
---@field equip_time UIKmlLuaControlHandler
---@field equip_need_level_titlt_node UIKmlLuaControlHandler
---@field equip_need_level_titlt UIKmlLuaControlHandler
---@field equip_need_level UIKmlLuaControlHandler
---@field need_layout UIKmlLuaControlHandler
---@field equipNeedData UIKmlLuaControlHandler
---@field red_equip_need_level_titlt_node UIKmlLuaControlHandler
---@field red_equip_need_level_titlt UIKmlLuaControlHandler
---@field timeShow_text_node UIKmlLuaControlHandler
---@field timeShow_text UIKmlLuaControlHandler
---@field use_text_node UIKmlLuaControlHandler
---@field use_text UIKmlLuaControlHandler
---@field shop_deal_node UIKmlLuaControlHandler
---@field shop_deal UIKmlLuaControlHandler
---@field att_level_titlt_node UIKmlLuaControlHandler
---@field att_level_titlt UIKmlLuaControlHandler
---@field att_need_level UIKmlLuaControlHandler
---@field yulan_content_node UIKmlLuaControlHandler
---@field yulan_content UIKmlLuaControlHandler
---@field yulan_data_list UIKmlLuaControlHandler
---@field num_select UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Input_PutNum UIKmlLuaControlHandler
---@field Btn_NumberMinus UIKmlLuaControlHandler
---@field Btn_NumberAdd UIKmlLuaControlHandler
---@field text_18 UIKmlLuaControlHandler
---@field Slider_PutNum UIKmlLuaControlHandler
---@field synthesisDesc UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field node_career_top UIKmlLuaControlHandler
---@field career_layout UIKmlLuaControlHandler
---@field equipzhiyeNeedData UIKmlLuaControlHandler
---@field node_career_bottom UIKmlLuaControlHandler
---@field btn_offset_node UIKmlLuaControlHandler
---@field bag_root UIKmlLuaControlHandler
---@field left_btn UIKmlLuaControlHandler
---@field left_btn_content UIKmlLuaControlHandler
---@field 属性_left_layout UIKmlLuaControlHandler
---@field left_data_list UIKmlLuaControlHandler
---@field right_btn UIKmlLuaControlHandler
---@field right_btn_content UIKmlLuaControlHandler
---@field 属性_right_layout UIKmlLuaControlHandler
---@field right_data_list UIKmlLuaControlHandler
---@field item_button UIKmlLuaControlHandler
---@field put_or_out UIKmlLuaControlHandler
---@field put_or_out_t UIKmlLuaControlHandler
---@field pills_put UIKmlLuaControlHandler
---@field text_100 UIKmlLuaControlHandler
---@field mail_attachment UIKmlLuaControlHandler
---@field text_102 UIKmlLuaControlHandler
local KLUIItemTipsPanelView = {}
setmetatable(KLUIItemTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIItemTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIItemTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Tips/Panel/KLIUItemTips/KLUIItemTipsPanel']

return KLUIItemTipsPanelView
