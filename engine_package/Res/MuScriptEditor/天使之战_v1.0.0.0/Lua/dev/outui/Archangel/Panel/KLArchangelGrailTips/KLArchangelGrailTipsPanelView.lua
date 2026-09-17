---@class KLArchangelGrailTipsPanelView:UIKmlLuaViewBase
---@field background_close UIKmlLuaControlHandler
---@field panel_bg UIKmlLuaControlHandler
---@field top UIKmlLuaControlHandler
---@field item_name UIKmlLuaControlHandler
---@field item5 UIKmlLuaControlHandler
---@field layout6 UIKmlLuaControlHandler
---@field bing_text UIKmlLuaControlHandler
---@field score_text UIKmlLuaControlHandler
---@field rant_text UIKmlLuaControlHandler
---@field quality_text UIKmlLuaControlHandler
---@field fusion_pos UIKmlLuaControlHandler
---@field middle UIKmlLuaControlHandler
---@field info_view UIKmlLuaControlHandler
---@field all_list_layout UIKmlLuaControlHandler
---@field all_info_data UIKmlLuaControlHandler
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
---@field equip_root UIKmlLuaControlHandler
---@field duanzaobtn UIKmlLuaControlHandler
---@field tuoxiabtn UIKmlLuaControlHandler
---@field shengjibtn UIKmlLuaControlHandler
---@field mail_attachment UIKmlLuaControlHandler
---@field text_1451 UIKmlLuaControlHandler
---@field 镶嵌_btn UIKmlLuaControlHandler
---@field text_1453 UIKmlLuaControlHandler
---@field 镶嵌卸下_btn UIKmlLuaControlHandler
---@field text_1455 UIKmlLuaControlHandler
---@field 叠加_btn UIKmlLuaControlHandler
---@field text_1457 UIKmlLuaControlHandler
local KLArchangelGrailTipsPanelView = {}
setmetatable(KLArchangelGrailTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelGrailTips/KLArchangelGrailTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLArchangelGrailTipsPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLArchangelGrailTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Panel/KLArchangelGrailTips/KLArchangelGrailTipsPanel']

return KLArchangelGrailTipsPanelView
