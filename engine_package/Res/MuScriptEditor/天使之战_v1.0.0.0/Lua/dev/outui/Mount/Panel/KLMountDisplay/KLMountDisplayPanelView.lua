---@class KLMountDisplayPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field bg2 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field ownerMountRoot UIKmlLuaControlHandler
---@field model UIKmlLuaControlHandler
---@field rideArea UIKmlLuaControlHandler
---@field attInfoTitle UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field attInfoContainer UIKmlLuaControlHandler
---@field scroll UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field mount_att_info_list UIKmlLuaControlHandler
---@field btn_ride UIKmlLuaControlHandler
---@field Root_LevelUp UIKmlLuaControlHandler
---@field costInfoTitle UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field levelMaxTip UIKmlLuaControlHandler
---@field text_limitTime UIKmlLuaControlHandler
---@field btn_LvUp UIKmlLuaControlHandler
---@field costInfo UIKmlLuaControlHandler
---@field Root_Active UIKmlLuaControlHandler
---@field item_activeCost UIKmlLuaControlHandler
---@field haveItem UIKmlLuaControlHandler
---@field btn_active UIKmlLuaControlHandler
---@field active_Title UIKmlLuaControlHandler
---@field text13 UIKmlLuaControlHandler
---@field btns UIKmlLuaControlHandler
---@field btn_skin UIKmlLuaControlHandler
---@field skin_select UIKmlLuaControlHandler
---@field btn_fashionCollect UIKmlLuaControlHandler
---@field fashionCollect_select UIKmlLuaControlHandler
---@field Root_Skin UIKmlLuaControlHandler
---@field item_skinNeed UIKmlLuaControlHandler
---@field btn_buySkin UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field success UIKmlLuaControlHandler
---@field btn_collect UIKmlLuaControlHandler
---@field desBtn UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
local KLMountDisplayPanelView = {}
setmetatable(KLMountDisplayPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMountDisplayPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMountDisplayPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Mount/Panel/KLMountDisplay/KLMountDisplayPanel']

return KLMountDisplayPanelView
