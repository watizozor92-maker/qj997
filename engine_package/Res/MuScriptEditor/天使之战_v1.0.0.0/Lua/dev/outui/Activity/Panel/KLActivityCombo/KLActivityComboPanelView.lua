---@class KLActivityComboPanelView:UIKmlLuaViewBase
---@field bgClose UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field comboTitleicon UIKmlLuaControlHandler
---@field levelContent UIKmlLuaControlHandler
---@field levelLayout UIKmlLuaControlHandler
---@field levelList UIKmlLuaControlHandler
---@field img45 UIKmlLuaControlHandler
---@field text46 UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field img54 UIKmlLuaControlHandler
---@field text55 UIKmlLuaControlHandler
---@field defense UIKmlLuaControlHandler
---@field img57 UIKmlLuaControlHandler
---@field text58 UIKmlLuaControlHandler
---@field openTime UIKmlLuaControlHandler
---@field img63 UIKmlLuaControlHandler
---@field text64 UIKmlLuaControlHandler
---@field sv_rewardList UIKmlLuaControlHandler
---@field gridview2 UIKmlLuaControlHandler
---@field datalist_reward UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field ticketBtn UIKmlLuaControlHandler
---@field ticketCount UIKmlLuaControlHandler
---@field btn_buyTicket UIKmlLuaControlHandler
---@field ticketItem UIKmlLuaControlHandler
---@field img60 UIKmlLuaControlHandler
---@field text61 UIKmlLuaControlHandler
---@field countTxt UIKmlLuaControlHandler
---@field addCountBtn UIKmlLuaControlHandler
---@field desBtn UIKmlLuaControlHandler
---@field enterBtn UIKmlLuaControlHandler
---@field sweepBtn UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field togglegroup UIKmlLuaControlHandler
---@field text_btnTips UIKmlLuaControlHandler
---@field sweep_panel UIKmlLuaControlHandler
---@field sweep_prefab UIKmlLuaControlHandler
---@field ClickMask UIKmlLuaControlHandler
---@field InputFieldLevel UIKmlLuaControlHandler
---@field Text UIKmlLuaControlHandler
---@field TextTotalPrice UIKmlLuaControlHandler
---@field TotalPrice UIKmlLuaControlHandler
---@field BtnBuy UIKmlLuaControlHandler
---@field BtnText UIKmlLuaControlHandler
---@field BtnLevelMinus UIKmlLuaControlHandler
---@field BtnLevelAdd UIKmlLuaControlHandler
---@field sweepCount UIKmlLuaControlHandler
local KLActivityComboPanelView = {}
setmetatable(KLActivityComboPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLActivityCombo/KLActivityComboPanelKml'
---@param parent UIKmlLuaControlHandler
function KLActivityComboPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLActivityComboPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLActivityCombo/KLActivityComboPanel']

return KLActivityComboPanelView
