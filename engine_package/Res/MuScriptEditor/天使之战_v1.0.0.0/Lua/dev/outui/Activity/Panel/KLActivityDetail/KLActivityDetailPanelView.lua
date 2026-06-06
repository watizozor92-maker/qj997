---@class KLActivityDetailPanelView:UIKmlLuaViewBase
---@field bgClose UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img_367 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field devilTitle UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field bloodTitle UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field info UIKmlLuaControlHandler
---@field togglegroup UIKmlLuaControlHandler
---@field devilTitleicon UIKmlLuaControlHandler
---@field bloodTitleicon UIKmlLuaControlHandler
---@field levelContent UIKmlLuaControlHandler
---@field levelLayout UIKmlLuaControlHandler
---@field levelList UIKmlLuaControlHandler
---@field img57 UIKmlLuaControlHandler
---@field text58 UIKmlLuaControlHandler
---@field openTime UIKmlLuaControlHandler
---@field img45 UIKmlLuaControlHandler
---@field text46 UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field img54 UIKmlLuaControlHandler
---@field text55 UIKmlLuaControlHandler
---@field defense UIKmlLuaControlHandler
---@field img60 UIKmlLuaControlHandler
---@field text61 UIKmlLuaControlHandler
---@field openTxt UIKmlLuaControlHandler
---@field nextOpenTime UIKmlLuaControlHandler
---@field img63 UIKmlLuaControlHandler
---@field text64 UIKmlLuaControlHandler
---@field rewardList1 UIKmlLuaControlHandler
---@field layout67 UIKmlLuaControlHandler
---@field rewardList UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field ticketBtn3 UIKmlLuaControlHandler
---@field ticketCount3 UIKmlLuaControlHandler
---@field ticketModel3 UIKmlLuaControlHandler
---@field addCountBtn2 UIKmlLuaControlHandler
---@field ticketItem UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field ticketBtn UIKmlLuaControlHandler
---@field ticketCount UIKmlLuaControlHandler
---@field ticketModel UIKmlLuaControlHandler
---@field changeTicketButton UIKmlLuaControlHandler
---@field changeRoot UIKmlLuaControlHandler
---@field ticketBtn2 UIKmlLuaControlHandler
---@field ticketCount2 UIKmlLuaControlHandler
---@field ticketModel2 UIKmlLuaControlHandler
---@field addCountBtn UIKmlLuaControlHandler
---@field desBtn UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field leftcount UIKmlLuaControlHandler
---@field enterBtn UIKmlLuaControlHandler
local KLActivityDetailPanelView = {}
setmetatable(KLActivityDetailPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanelKml'
---@param parent UIKmlLuaControlHandler
function KLActivityDetailPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLActivityDetailPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel']

return KLActivityDetailPanelView
