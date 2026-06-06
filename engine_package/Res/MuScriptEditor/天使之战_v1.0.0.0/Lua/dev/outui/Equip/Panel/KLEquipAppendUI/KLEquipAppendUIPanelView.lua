---@class KLEquipAppendUIPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field BGInner_2 UIKmlLuaControlHandler
---@field namePanel UIKmlLuaControlHandler
---@field equipName UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field strengthLevelBg UIKmlLuaControlHandler
---@field strengthIntro UIKmlLuaControlHandler
---@field preLevel UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field nextLevel UIKmlLuaControlHandler
---@field ToggleGroupSource UIKmlLuaControlHandler
---@field equipBtn UIKmlLuaControlHandler
---@field bagBtn UIKmlLuaControlHandler
---@field item_model UIKmlLuaControlHandler
---@field layout_19 UIKmlLuaControlHandler
---@field appendMasterBtn UIKmlLuaControlHandler
---@field successIcon UIKmlLuaControlHandler
---@field CloseButton UIKmlLuaControlHandler
---@field strengthIcon UIKmlLuaControlHandler
---@field equipAttribute UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field arrContent UIKmlLuaControlHandler
---@field gridview3 UIKmlLuaControlHandler
---@field strength_list UIKmlLuaControlHandler
---@field strengthIcon_1 UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field baseSuccessRatioText UIKmlLuaControlHandler
---@field TogGroup_CostSelect UIKmlLuaControlHandler
---@field StrengthCustomScrollView UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field cost_list UIKmlLuaControlHandler
---@field strengthButton UIKmlLuaControlHandler
---@field failTips UIKmlLuaControlHandler
---@field gotoButton UIKmlLuaControlHandler
---@field textPanel UIKmlLuaControlHandler
---@field liuguangInfo UIKmlLuaControlHandler
---@field maxStrengthLevelBg UIKmlLuaControlHandler
---@field maxStrengthIntro UIKmlLuaControlHandler
---@field maxLevel UIKmlLuaControlHandler
---@field maxLevelTips UIKmlLuaControlHandler
---@field noticeText UIKmlLuaControlHandler
---@field bagNoticeText UIKmlLuaControlHandler
---@field append_fail UIKmlLuaControlHandler
---@field append_ok UIKmlLuaControlHandler
---@field Text_StrengthTips UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field Btn_Helper UIKmlLuaControlHandler
local KLEquipAppendUIPanelView = {}
setmetatable(KLEquipAppendUIPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Panel/KLEquipAppendUI/KLEquipAppendUIPanelKml'
---@param parent UIKmlLuaControlHandler
function KLEquipAppendUIPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipAppendUIPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Panel/KLEquipAppendUI/KLEquipAppendUIPanel']

return KLEquipAppendUIPanelView
