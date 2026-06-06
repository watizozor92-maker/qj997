---@class KLNewVIPMainPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field bg_vip UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field vipLevelTp UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field textDec UIKmlLuaControlHandler
---@field DIY_Text UIKmlLuaControlHandler
---@field SpLine UIKmlLuaControlHandler
---@field icon_vip UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field vip_level UIKmlLuaControlHandler
---@field img_ranklistbgR UIKmlLuaControlHandler
---@field VipLevelReward1 UIKmlLuaControlHandler
---@field img_free UIKmlLuaControlHandler
---@field VipLevel2 UIKmlLuaControlHandler
---@field RewardScrollViewUp UIKmlLuaControlHandler
---@field layout10 UIKmlLuaControlHandler
---@field UpRewardDataList UIKmlLuaControlHandler
---@field VipLevelReward2 UIKmlLuaControlHandler
---@field img_pay UIKmlLuaControlHandler
---@field VipLevel3 UIKmlLuaControlHandler
---@field RewardScrollViewDown UIKmlLuaControlHandler
---@field layout14 UIKmlLuaControlHandler
---@field DownRewardDataList UIKmlLuaControlHandler
---@field UpBtnGroup UIKmlLuaControlHandler
---@field button17 UIKmlLuaControlHandler
---@field btn_GetFree UIKmlLuaControlHandler
---@field freeRedPoint UIKmlLuaControlHandler
---@field DownBtnGroup UIKmlLuaControlHandler
---@field button18 UIKmlLuaControlHandler
---@field btn_GetPay UIKmlLuaControlHandler
---@field GetPayText UIKmlLuaControlHandler
---@field PayIcon UIKmlLuaControlHandler
---@field btn_up UIKmlLuaControlHandler
---@field priceRoot UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field txt_VipPrice UIKmlLuaControlHandler
---@field txt_limitBuyCondition UIKmlLuaControlHandler
---@field img_ranklistbgL UIKmlLuaControlHandler
---@field VipLevelImg UIKmlLuaControlHandler
---@field img_txt_vip UIKmlLuaControlHandler
---@field img_txt_tequan UIKmlLuaControlHandler
---@field vipLevel1 UIKmlLuaControlHandler
---@field VipBuffScrollView UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field buffDataList UIKmlLuaControlHandler
---@field LeftPageBtn UIKmlLuaControlHandler
---@field LeftDot UIKmlLuaControlHandler
---@field RightPageBtn UIKmlLuaControlHandler
---@field RightDot UIKmlLuaControlHandler
local KLNewVIPMainPanelView = {}
setmetatable(KLNewVIPMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/VIP/Panel/KLNewVIPMain/KLNewVIPMainPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNewVIPMainPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLNewVIPMainPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/VIP/Panel/KLNewVIPMain/KLNewVIPMainPanel']

return KLNewVIPMainPanelView
