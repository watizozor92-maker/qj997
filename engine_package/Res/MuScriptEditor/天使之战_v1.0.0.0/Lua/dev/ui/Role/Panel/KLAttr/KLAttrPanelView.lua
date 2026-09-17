---@class KLAttrPanelView:UIKmlLuaViewBase
---@field btn_exchange_point UIKmlLuaControlHandler
---@field BG_Templete1 UIKmlLuaControlHandler
---@field ReMask1 UIKmlLuaControlHandler
---@field img1121 UIKmlLuaControlHandler
---@field Frame1 UIKmlLuaControlHandler
---@field Frame1Title UIKmlLuaControlHandler
---@field attr_panel_content UIKmlLuaControlHandler
---@field AttrInfo UIKmlLuaControlHandler
---@field attrName_1 UIKmlLuaControlHandler
---@field attrName_2 UIKmlLuaControlHandler
---@field attrName_3 UIKmlLuaControlHandler
---@field attrName_4 UIKmlLuaControlHandler
---@field attrName_5 UIKmlLuaControlHandler
---@field plusButton_agility UIKmlLuaControlHandler
---@field plusButton_a_Light UIKmlLuaControlHandler
---@field minusButton_agility UIKmlLuaControlHandler
---@field attrInfo_5 UIKmlLuaControlHandler
---@field FruitRedPoint UIKmlLuaControlHandler
---@field panelName UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field regionAndCareer UIKmlLuaControlHandler
---@field attInfoContent_intelligence UIKmlLuaControlHandler
---@field attInfoContent_intelligence_content UIKmlLuaControlHandler
---@field minusButton_stamina UIKmlLuaControlHandler
---@field attInfoContent_agility UIKmlLuaControlHandler
---@field attInfoContent_agility_content UIKmlLuaControlHandler
---@field attInfoContent_command UIKmlLuaControlHandler
---@field attInfoContent_command_content UIKmlLuaControlHandler
---@field plusButton_command UIKmlLuaControlHandler
---@field plusButton_c_Light UIKmlLuaControlHandler
---@field minusButton_command UIKmlLuaControlHandler
---@field num_command UIKmlLuaControlHandler
---@field AttrEffect UIKmlLuaControlHandler
---@field titleName UIKmlLuaControlHandler
---@field levelText UIKmlLuaControlHandler
---@field sureButton UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field light_btn1 UIKmlLuaControlHandler
---@field attrContent UIKmlLuaControlHandler
---@field attr_data_list UIKmlLuaControlHandler
---@field attrScrollView UIKmlLuaControlHandler
---@field attInfoScrollView UIKmlLuaControlHandler
---@field top UIKmlLuaControlHandler
---@field attInfoContent_dc UIKmlLuaControlHandler
---@field attInfoContent_dc_content UIKmlLuaControlHandler
---@field commandButton_text UIKmlLuaControlHandler
---@field bg_1 UIKmlLuaControlHandler
---@field bg_2 UIKmlLuaControlHandler
---@field CloseButton2 UIKmlLuaControlHandler
---@field levelBg UIKmlLuaControlHandler
---@field attrInfo_1 UIKmlLuaControlHandler
---@field attrInfo_2 UIKmlLuaControlHandler
---@field attrInfo_3 UIKmlLuaControlHandler
---@field num_agility UIKmlLuaControlHandler
---@field plusButton_intelligence UIKmlLuaControlHandler
---@field plusButton_i_Light UIKmlLuaControlHandler
---@field minusButton_intelligence UIKmlLuaControlHandler
---@field num_intelligence UIKmlLuaControlHandler
---@field attInfoContent_stamina UIKmlLuaControlHandler
---@field attInfoContent_stamina_content UIKmlLuaControlHandler
---@field plusButton_stamina UIKmlLuaControlHandler
---@field plusButton_s_Light UIKmlLuaControlHandler
---@field attrInfo_4 UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field remainPointText UIKmlLuaControlHandler
---@field canUseText UIKmlLuaControlHandler
---@field expText UIKmlLuaControlHandler
---@field resetPointButton UIKmlLuaControlHandler
---@field commandButton UIKmlLuaControlHandler
---@field light_btn UIKmlLuaControlHandler
---@field num_stamina UIKmlLuaControlHandler
---@field appleTog UIKmlLuaControlHandler
---@field num_dc UIKmlLuaControlHandler
---@field plusButton_dc UIKmlLuaControlHandler
---@field plusButton_d_Light UIKmlLuaControlHandler
---@field minusButton_dc UIKmlLuaControlHandler
---@field attrCloseButton UIKmlLuaControlHandler
---@field appleButton UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1231 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
local KLAttrPanelView = {}
setmetatable(KLAttrPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Role/Panel/KLAttr/KLAttrPanelKml'
---@param parent UIKmlLuaControlHandler
function KLAttrPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLAttrPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Role/Panel/KLAttr/KLAttrPanel']

return KLAttrPanelView
