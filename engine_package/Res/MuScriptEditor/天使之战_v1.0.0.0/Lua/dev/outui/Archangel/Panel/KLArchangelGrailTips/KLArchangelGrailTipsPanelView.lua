---@class KLArchangelGrailTipsPanelView:UIKmlLuaViewBase
---@field background_close UIKmlLuaControl
---@field panel_bg UIKmlLuaControl
---@field top UIKmlLuaControl
---@field item_name UIKmlLuaControl
---@field item5 UIKmlLuaControl
---@field layout6 UIKmlLuaControl
---@field bing_text UIKmlLuaControl
---@field score_text UIKmlLuaControl
---@field rant_text UIKmlLuaControl
---@field quality_text UIKmlLuaControl
---@field fusion_pos UIKmlLuaControl
---@field middle UIKmlLuaControl
---@field info_view UIKmlLuaControl
---@field all_list_layout UIKmlLuaControl
---@field all_info_data UIKmlLuaControl
---@field equippaneltop_bottom UIKmlLuaControl
---@field put_or_out UIKmlLuaControl
---@field put_or_out_t UIKmlLuaControl
---@field bag_root UIKmlLuaControl
---@field left_btn UIKmlLuaControl
---@field left_btn_content UIKmlLuaControl
---@field 属性_left_layout UIKmlLuaControl
---@field left_data_list UIKmlLuaControl
---@field right_btn UIKmlLuaControl
---@field right_btn_content UIKmlLuaControl
---@field 属性_right_layout UIKmlLuaControl
---@field right_data_list UIKmlLuaControl
---@field equip_root UIKmlLuaControl
---@field duanzaobtn UIKmlLuaControl
---@field tuoxiabtn UIKmlLuaControl
---@field shengjibtn UIKmlLuaControl
---@field mail_attachment UIKmlLuaControl
---@field text_1451 UIKmlLuaControl
---@field 镶嵌_btn UIKmlLuaControl
---@field text_1453 UIKmlLuaControl
---@field 镶嵌卸下_btn UIKmlLuaControl
---@field text_1455 UIKmlLuaControl
---@field 叠加_btn UIKmlLuaControl
---@field text_1457 UIKmlLuaControl
local KLArchangelGrailTipsPanelView = {}
setmetatable(KLArchangelGrailTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelGrailTips/KLArchangelGrailTipsPanelKml'
---@param parent UIKmlLuaControl
function KLArchangelGrailTipsPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLArchangelGrailTipsPanelView
