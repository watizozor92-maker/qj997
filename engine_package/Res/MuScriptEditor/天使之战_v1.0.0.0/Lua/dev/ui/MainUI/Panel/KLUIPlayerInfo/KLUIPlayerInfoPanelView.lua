---@class KLUIPlayerInfoPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field left UIKmlLuaControlHandler
---@field hpContainer UIKmlLuaControlHandler
---@field sliderHp UIKmlLuaControlHandler
---@field hpTxt UIKmlLuaControlHandler
---@field experienceMenufoldBtn UIKmlLuaControlHandler
---@field experienceList UIKmlLuaControlHandler
---@field experience_content UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field experience_list UIKmlLuaControlHandler
---@field experienceItem UIKmlLuaControlHandler
---@field experienceBg UIKmlLuaControlHandler
---@field allExperienceTxt UIKmlLuaControlHandler
---@field icon2 UIKmlLuaControlHandler
---@field arrow1 UIKmlLuaControlHandler
---@field experienceMenuexpandBtn UIKmlLuaControlHandler
---@field right UIKmlLuaControlHandler
---@field mpContainer UIKmlLuaControlHandler
---@field sliderMp UIKmlLuaControlHandler
---@field mpTxt UIKmlLuaControlHandler
---@field buffs_listContent UIKmlLuaControlHandler
---@field buffs_list UIKmlLuaControlHandler
---@field leftBg UIKmlLuaControlHandler
---@field fast_grid UIKmlLuaControlHandler
---@field fast_data_list UIKmlLuaControlHandler
---@field Att UIKmlLuaControlHandler
---@field Text_Att1 UIKmlLuaControlHandler
---@field Text_Att2 UIKmlLuaControlHandler
---@field buffMenuBtn UIKmlLuaControlHandler
---@field buffMenufoldBtn UIKmlLuaControlHandler
---@field buffMenuexpandBtn UIKmlLuaControlHandler
---@field gridview15 UIKmlLuaControlHandler
---@field tog_shop_panel UIKmlLuaControlHandler
---@field tog_shop UIKmlLuaControlHandler
---@field tog_setting_panel UIKmlLuaControlHandler
---@field tog_setting UIKmlLuaControlHandler
---@field tog_union_panel UIKmlLuaControlHandler
---@field tog_union UIKmlLuaControlHandler
---@field tog_skill_panel UIKmlLuaControlHandler
---@field tog_skill UIKmlLuaControlHandler
---@field tog_mail_panel UIKmlLuaControlHandler
---@field tog_mail UIKmlLuaControlHandler
---@field tog_masterTalent_panel UIKmlLuaControlHandler
---@field tog_masterTalent UIKmlLuaControlHandler
---@field tog_friend_panel UIKmlLuaControlHandler
---@field tog_friend UIKmlLuaControlHandler
---@field tog_bag_panel UIKmlLuaControlHandler
---@field tog_bag UIKmlLuaControlHandler
---@field icon_bagFull UIKmlLuaControlHandler
---@field tog_role_panel UIKmlLuaControlHandler
---@field tog_role UIKmlLuaControlHandler
---@field icon_AttrPoint UIKmlLuaControlHandler
---@field sdContainer UIKmlLuaControlHandler
---@field sliderSd UIKmlLuaControlHandler
---@field sdTxt UIKmlLuaControlHandler
---@field shieldContainer UIKmlLuaControlHandler
---@field sliderShield UIKmlLuaControlHandler
---@field shieldTxt UIKmlLuaControlHandler
---@field atkModel UIKmlLuaControlHandler
---@field icon1 UIKmlLuaControlHandler
---@field atkModelMenuBtn UIKmlLuaControlHandler
---@field atkModelname UIKmlLuaControlHandler
---@field sliderPower UIKmlLuaControlHandler
---@field txt_server UIKmlLuaControlHandler
---@field AtkModePanel UIKmlLuaControlHandler
---@field Img_AtkModeBg UIKmlLuaControlHandler
---@field atkModelMenu UIKmlLuaControlHandler
---@field sliderExperience UIKmlLuaControlHandler
---@field sliderExperience_ballEndPos UIKmlLuaControlHandler
---@field sliderExpBar UIKmlLuaControlHandler
---@field AtkModeClosePanel UIKmlLuaControlHandler
---@field Btn_AtkModeCloseMask UIKmlLuaControlHandler
---@field TeamWindowClosePanel UIKmlLuaControlHandler
---@field Btn_TeamWindowCloseMask UIKmlLuaControlHandler
---@field teamObjRoot UIKmlLuaControlHandler
---@field experiencePercentage UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field time UIKmlLuaControlHandler
---@field MonthCardBtn UIKmlLuaControlHandler
---@field lianJiToggle UIKmlLuaControlHandler
---@field btn_team UIKmlLuaControlHandler
---@field txt_coord UIKmlLuaControlHandler
---@field txt_mapname UIKmlLuaControlHandler
local KLUIPlayerInfoPanelView = {}
setmetatable(KLUIPlayerInfoPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLUIPlayerInfo/KLUIPlayerInfoPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIPlayerInfoPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end

---@type KLUIPlayerInfoPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLUIPlayerInfo/KLUIPlayerInfoPanel']

return KLUIPlayerInfoPanelView
