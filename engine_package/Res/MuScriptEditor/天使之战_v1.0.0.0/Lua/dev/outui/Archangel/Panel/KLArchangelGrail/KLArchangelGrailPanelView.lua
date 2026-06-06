---@class KLArchangelGrailPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControl
---@field BG UIKmlLuaControl
---@field title UIKmlLuaControl
---@field CloseButton UIKmlLuaControl
---@field equip_top UIKmlLuaControl
---@field item_bottom UIKmlLuaControl
---@field item8 UIKmlLuaControl
---@field item_add_img UIKmlLuaControl
---@field item_name UIKmlLuaControl
---@field item_grail_tips UIKmlLuaControl
---@field effectfail UIKmlLuaControl
---@field effectSucceed UIKmlLuaControl
---@field scrollview11 UIKmlLuaControl
---@field gridview12 UIKmlLuaControl
---@field grail_list UIKmlLuaControl
---@field grail_suit_all UIKmlLuaControl
---@field empty_attr_bg UIKmlLuaControl
---@field img_suit_bg UIKmlLuaControl
---@field scrollview_all_suit UIKmlLuaControl
---@field gridview_all_suit UIKmlLuaControl
---@field grail_all_suit_list UIKmlLuaControl
---@field strength_panel UIKmlLuaControl
---@field panel16 UIKmlLuaControl
---@field img17 UIKmlLuaControl
---@field text18 UIKmlLuaControl
---@field StrengthCostScrollView UIKmlLuaControl
---@field gridview15 UIKmlLuaControl
---@field cost_list UIKmlLuaControl
---@field cost_title UIKmlLuaControl
---@field img3 UIKmlLuaControl
---@field text4 UIKmlLuaControl
---@field strengthenBtn UIKmlLuaControl
---@field gridview20 UIKmlLuaControl
---@field grail_att_list UIKmlLuaControl
---@field success_img UIKmlLuaControl
---@field success_rate UIKmlLuaControl
---@field strengthLevelBg UIKmlLuaControl
---@field preLevel UIKmlLuaControl
---@field arrow UIKmlLuaControl
---@field nextLevel UIKmlLuaControl
---@field equipatt_panel UIKmlLuaControl
---@field img_attr_title UIKmlLuaControl
---@field scrollview3 UIKmlLuaControl
---@field gridview4 UIKmlLuaControl
---@field equip_att_list UIKmlLuaControl
---@field suit_detail_panel UIKmlLuaControl
---@field detail_bg UIKmlLuaControl
---@field detail_bg_2 UIKmlLuaControl
---@field detail_name UIKmlLuaControl
---@field detail_attr_1 UIKmlLuaControl
---@field detail_attr_2 UIKmlLuaControl
---@field detail_attr_3 UIKmlLuaControl
---@field warning_img UIKmlLuaControl
---@field btn_tips UIKmlLuaControl
local KLArchangelGrailPanelView = {}
setmetatable(KLArchangelGrailPanelView, UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanelKml'
KLArchangelGrailPanelView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath, nil, '.txt')
---@param parent UIKmlLuaControl
function KLArchangelGrailPanelView:Init(parent)
    self:InitRoot(parent, kmlPath, KLArchangelGrailPanelView.content)
end
return KLArchangelGrailPanelView
