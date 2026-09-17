---@class KLEquipLuckyPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field BGInner_2 UIKmlLuaControlHandler
---@field namePanel UIKmlLuaControlHandler
---@field equipName UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field strengthLevelBg UIKmlLuaControlHandler
---@field strengthIntro UIKmlLuaControlHandler
---@field preLevel UIKmlLuaControlHandler
---@field nextLevel UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field ToggleGroupSource UIKmlLuaControlHandler
---@field equipBtn UIKmlLuaControlHandler
---@field bagBtn UIKmlLuaControlHandler
---@field item_model UIKmlLuaControlHandler
---@field baseSuccessRatioText UIKmlLuaControlHandler
---@field bagNoticeText UIKmlLuaControlHandler
---@field strengthIcon UIKmlLuaControlHandler
---@field equipAttribute UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field TogGroup_CostSelect UIKmlLuaControlHandler
---@field layout_19 UIKmlLuaControlHandler
---@field panel_20 UIKmlLuaControlHandler
---@field strengthMasterBtn UIKmlLuaControlHandler
---@field panel_22 UIKmlLuaControlHandler
---@field liuGuangBtn UIKmlLuaControlHandler
---@field successIcon UIKmlLuaControlHandler
---@field StrengthCustomScrollView UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field cost_list UIKmlLuaControlHandler
---@field strengthButton UIKmlLuaControlHandler
---@field failTips UIKmlLuaControlHandler
---@field strengthIcon_1 UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field arrContent UIKmlLuaControlHandler
---@field gridview3 UIKmlLuaControlHandler
---@field strength_list UIKmlLuaControlHandler
---@field gotoButton UIKmlLuaControlHandler
---@field maxStrengthLevelBg UIKmlLuaControlHandler
---@field maxStrengthIntro UIKmlLuaControlHandler
---@field maxLevel UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field Btn_Helper UIKmlLuaControlHandler
---@field strength_fail UIKmlLuaControlHandler
---@field strength_ok UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field maxLevelTips UIKmlLuaControlHandler
---@field Text_StrengthTips UIKmlLuaControlHandler
---@field textPanel UIKmlLuaControlHandler
---@field liuguangInfo UIKmlLuaControlHandler
---@field noticeText UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field equip_show_tips UIKmlLuaControlHandler
---@field strength_suc_bg UIKmlLuaControlHandler
---@field closeMask UIKmlLuaControlHandler
---@field mask_item UIKmlLuaControlHandler
---@field mask_text UIKmlLuaControlHandler
local KLEquipLuckyPanelView = {}
setmetatable(KLEquipLuckyPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLEquipLucky/KLEquipLuckyPanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipLuckyPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipLuckyPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLEquipLucky/KLEquipLuckyPanel']

return KLEquipLuckyPanelView
