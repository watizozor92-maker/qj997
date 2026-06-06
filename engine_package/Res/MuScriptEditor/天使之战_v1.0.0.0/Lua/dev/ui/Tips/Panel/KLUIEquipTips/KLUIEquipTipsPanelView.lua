---@class KLUIEquipTipsPanelView:UIKmlLuaViewBase
---@field background_close UIKmlLuaControlHandler
---@field panel_bg UIKmlLuaControlHandler
---@field title_bg UIKmlLuaControlHandler
---@field text_title UIKmlLuaControlHandler
---@field tem_info UIKmlLuaControlHandler
---@field equippaneltop UIKmlLuaControlHandler
---@field equip_name_bg UIKmlLuaControlHandler
---@field equip_name UIKmlLuaControlHandler
---@field MountShowBtn UIKmlLuaControlHandler
---@field jichu_layout UIKmlLuaControlHandler
---@field text_MU_node UIKmlLuaControlHandler
---@field text_MU UIKmlLuaControlHandler
---@field text_deal_node UIKmlLuaControlHandler
---@field text_deal UIKmlLuaControlHandler
---@field base_list_layout UIKmlLuaControlHandler
---@field base_info_data UIKmlLuaControlHandler
---@field equip_time_node UIKmlLuaControlHandler
---@field equip_time UIKmlLuaControlHandler
---@field equip_need_level_titlt_node UIKmlLuaControlHandler
---@field equip_need_level_titlt UIKmlLuaControlHandler
---@field equip_need_level UIKmlLuaControlHandler
---@field red_equip_need_level_titlt_node UIKmlLuaControlHandler
---@field red_equip_need_level_titlt UIKmlLuaControlHandler
---@field timeShow_text_node UIKmlLuaControlHandler
---@field timeShow_text UIKmlLuaControlHandler
---@field node_career_top_1 UIKmlLuaControlHandler
---@field need_layout UIKmlLuaControlHandler
---@field equipNeedData UIKmlLuaControlHandler
---@field att_level_titlt UIKmlLuaControlHandler
---@field att_need_level UIKmlLuaControlHandler
---@field node_career_bottom UIKmlLuaControlHandler
---@field career_layout UIKmlLuaControlHandler
---@field equipzhiyeNeedData UIKmlLuaControlHandler
---@field node_moveSpeed UIKmlLuaControlHandler
---@field txt_moveSpeed UIKmlLuaControlHandler
---@field guardHp UIKmlLuaControlHandler
---@field exprience_txt UIKmlLuaControlHandler
---@field 品质_titlt UIKmlLuaControlHandler
---@field 品质 UIKmlLuaControlHandler
---@field equip_type_titlt UIKmlLuaControlHandler
---@field equip_type UIKmlLuaControlHandler
---@field equip_jie_root UIKmlLuaControlHandler
---@field equip_jie UIKmlLuaControlHandler
---@field level_txt UIKmlLuaControlHandler
---@field all_list_layout UIKmlLuaControlHandler
---@field all_info_data UIKmlLuaControlHandler
---@field view_info UIKmlLuaControlHandler
---@field top_text UIKmlLuaControlHandler
---@field mid_text UIKmlLuaControlHandler
---@field bottom_text UIKmlLuaControlHandler
---@field origin_list_layout UIKmlLuaControlHandler
---@field origin_info_data UIKmlLuaControlHandler
---@field equippaneltop_bottom UIKmlLuaControlHandler
---@field put_or_out UIKmlLuaControlHandler
---@field put_or_out_t UIKmlLuaControlHandler
---@field bag_root UIKmlLuaControlHandler
---@field left_btn UIKmlLuaControlHandler
---@field left_btn_content UIKmlLuaControlHandler
---@field 属性_left_layout UIKmlLuaControlHandler
---@field left_data_list UIKmlLuaControlHandler
---@field right_btn UIKmlLuaControlHandler
---@field right_btn_content UIKmlLuaControlHandler
---@field 属性_right_layout UIKmlLuaControlHandler
---@field right_data_list UIKmlLuaControlHandler
---@field mail_attachment UIKmlLuaControlHandler
---@field text_1451 UIKmlLuaControlHandler
---@field 叠加_btn UIKmlLuaControlHandler
---@field text_1457 UIKmlLuaControlHandler
---@field equip_root UIKmlLuaControlHandler
---@field duanzaobtn UIKmlLuaControlHandler
---@field breakbtn UIKmlLuaControlHandler
---@field tuoxiabtn UIKmlLuaControlHandler
---@field shengjibtn UIKmlLuaControlHandler
---@field 镶嵌_btn UIKmlLuaControlHandler
---@field text_1453 UIKmlLuaControlHandler
---@field 镶嵌卸下_btn UIKmlLuaControlHandler
---@field text_1455 UIKmlLuaControlHandler
---@field equippaneltop_middle UIKmlLuaControlHandler
---@field model1 UIKmlLuaControlHandler
local KLUIEquipTipsPanelView = {}
setmetatable(KLUIEquipTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIEquipTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIEquipTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Tips/Panel/KLUIEquipTips/KLUIEquipTipsPanel']

return KLUIEquipTipsPanelView
