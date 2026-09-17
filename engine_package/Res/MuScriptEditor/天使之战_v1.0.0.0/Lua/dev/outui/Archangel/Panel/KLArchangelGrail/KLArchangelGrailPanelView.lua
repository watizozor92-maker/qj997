---@class KLArchangelGrailPanelView:UIKmlLuaViewBase
---@field BG UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field equip_top UIKmlLuaControlHandler
---@field item_bottom UIKmlLuaControlHandler
---@field item8 UIKmlLuaControlHandler
---@field item_add_img UIKmlLuaControlHandler
---@field item_name UIKmlLuaControlHandler
---@field item_grail_tips UIKmlLuaControlHandler
---@field effectfail UIKmlLuaControlHandler
---@field effectSucceed UIKmlLuaControlHandler
---@field scrollview11 UIKmlLuaControlHandler
---@field gridview12 UIKmlLuaControlHandler
---@field grail_list UIKmlLuaControlHandler
---@field grail_suit_all UIKmlLuaControlHandler
---@field empty_attr_bg UIKmlLuaControlHandler
---@field img_suit_bg UIKmlLuaControlHandler
---@field scrollview_all_suit UIKmlLuaControlHandler
---@field gridview_all_suit UIKmlLuaControlHandler
---@field grail_all_suit_list UIKmlLuaControlHandler
---@field strength_panel UIKmlLuaControlHandler
---@field panel16 UIKmlLuaControlHandler
---@field img17 UIKmlLuaControlHandler
---@field text18 UIKmlLuaControlHandler
---@field StrengthCostScrollView UIKmlLuaControlHandler
---@field gridview15 UIKmlLuaControlHandler
---@field cost_list UIKmlLuaControlHandler
---@field cost_title UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field strengthenBtn UIKmlLuaControlHandler
---@field gridview20 UIKmlLuaControlHandler
---@field grail_att_list UIKmlLuaControlHandler
---@field success_img UIKmlLuaControlHandler
---@field success_rate UIKmlLuaControlHandler
---@field strengthLevelBg UIKmlLuaControlHandler
---@field preLevel UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field nextLevel UIKmlLuaControlHandler
---@field equipatt_panel UIKmlLuaControlHandler
---@field img_attr_title UIKmlLuaControlHandler
---@field scrollview3 UIKmlLuaControlHandler
---@field gridview4 UIKmlLuaControlHandler
---@field equip_att_list UIKmlLuaControlHandler
---@field suit_detail_panel UIKmlLuaControlHandler
---@field detail_bg UIKmlLuaControlHandler
---@field detail_bg_2 UIKmlLuaControlHandler
---@field detail_name UIKmlLuaControlHandler
---@field detail_attr_1 UIKmlLuaControlHandler
---@field detail_attr_2 UIKmlLuaControlHandler
---@field detail_attr_3 UIKmlLuaControlHandler
---@field warning_img UIKmlLuaControlHandler
---@field btn_tips UIKmlLuaControlHandler
local KLArchangelGrailPanelView = {}
setmetatable(KLArchangelGrailPanelView, UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanelKml'
KLArchangelGrailPanelView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath, nil, '.txt')
---@param parent UIKmlLuaControlHandler
function KLArchangelGrailPanelView:Init(parent)
    self:InitRoot(parent, kmlPath, KLArchangelGrailPanelView.content)
end
---@type KLArchangelGrailPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Panel/KLArchangelGrail/KLArchangelGrailPanel']

return KLArchangelGrailPanelView
