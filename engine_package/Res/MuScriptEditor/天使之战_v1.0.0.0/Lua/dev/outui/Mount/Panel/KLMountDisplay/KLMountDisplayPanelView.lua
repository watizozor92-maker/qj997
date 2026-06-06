---@class KLMountDisplayPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field bg2 UIKmlLuaControl
---@field title UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
---@field ownerMountRoot UIKmlLuaControl
---@field model UIKmlLuaControl
---@field rideArea UIKmlLuaControl
---@field attInfoTitle UIKmlLuaControl
---@field text10 UIKmlLuaControl
---@field text2 UIKmlLuaControl
---@field attInfoContainer UIKmlLuaControl
---@field scroll UIKmlLuaControl
---@field layout2 UIKmlLuaControl
---@field mount_att_info_list UIKmlLuaControl
---@field btn_ride UIKmlLuaControl
---@field Root_LevelUp UIKmlLuaControl
---@field costInfoTitle UIKmlLuaControl
---@field text4 UIKmlLuaControl
---@field levelMaxTip UIKmlLuaControl
---@field text_limitTime UIKmlLuaControl
---@field btn_LvUp UIKmlLuaControl
---@field costInfo UIKmlLuaControl
---@field Root_Active UIKmlLuaControl
---@field item_activeCost UIKmlLuaControl
---@field haveItem UIKmlLuaControl
---@field btn_active UIKmlLuaControl
---@field active_Title UIKmlLuaControl
---@field text13 UIKmlLuaControl
---@field btns UIKmlLuaControl
---@field btn_skin UIKmlLuaControl
---@field skin_select UIKmlLuaControl
---@field btn_fashionCollect UIKmlLuaControl
---@field fashionCollect_select UIKmlLuaControl
---@field Root_Skin UIKmlLuaControl
---@field item_skinNeed UIKmlLuaControl
---@field btn_buySkin UIKmlLuaControl
---@field text5 UIKmlLuaControl
---@field img6 UIKmlLuaControl
---@field img7 UIKmlLuaControl
---@field success UIKmlLuaControl
---@field btn_collect UIKmlLuaControl
---@field desBtn UIKmlLuaControl
---@field img3 UIKmlLuaControl
local KLMountDisplayPanelView = {}
setmetatable(KLMountDisplayPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanelKml'
---@param parent UIKmlLuaControl
function KLMountDisplayPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMountDisplayPanelView
