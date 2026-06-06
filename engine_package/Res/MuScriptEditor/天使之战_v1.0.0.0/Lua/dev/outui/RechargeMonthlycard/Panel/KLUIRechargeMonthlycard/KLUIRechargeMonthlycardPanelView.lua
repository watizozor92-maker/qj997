---@class KLUIRechargeMonthlycardPanelView:UIKmlLuaViewBase
---@field UIRechargeMonthlycardPanel UIKmlLuaControl
---@field card_bg UIKmlLuaControl
---@field white UIKmlLuaControl
---@field whiteTxt UIKmlLuaControl
---@field MonthCardBtn UIKmlLuaControl
---@field MonthBtnText UIKmlLuaControl
---@field whiteRed UIKmlLuaControl
---@field show UIKmlLuaControl
---@field showtext UIKmlLuaControl
---@field showtext2 UIKmlLuaControl
---@field RewardScrollView UIKmlLuaControl
---@field Viewport UIKmlLuaControl
---@field RewardContent UIKmlLuaControl
---@field NormalRewardViewList UIKmlLuaControl
---@field NormalLayout UIKmlLuaControl
---@field DataNormalRewardList UIKmlLuaControl
---@field TipText UIKmlLuaControl
---@field delete UIKmlLuaControl
---@field EndTimeText UIKmlLuaControl
---@field whiteSelectImg UIKmlLuaControl
---@field whiteCardExpText UIKmlLuaControl
---@field whiteCardHookText UIKmlLuaControl
---@field whiteCoinTxt UIKmlLuaControl
---@field whiteCoinItem UIKmlLuaControl
---@field gold UIKmlLuaControl
---@field goldTxt UIKmlLuaControl
---@field GoldMonthCardBtn UIKmlLuaControl
---@field GoldMonthBtnText UIKmlLuaControl
---@field goldRed UIKmlLuaControl
---@field show_1 UIKmlLuaControl
---@field Goldshowtext UIKmlLuaControl
---@field showtext2_1 UIKmlLuaControl
---@field RewardGoldScrollView UIKmlLuaControl
---@field Viewport_1 UIKmlLuaControl
---@field Gold_RewardContent UIKmlLuaControl
---@field GoldRewardViewList UIKmlLuaControl
---@field layout3 UIKmlLuaControl
---@field DataGoldRewardList UIKmlLuaControl
---@field GoldTipText UIKmlLuaControl
---@field delete_1 UIKmlLuaControl
---@field GoldEndTimeText UIKmlLuaControl
---@field goldSelectImg UIKmlLuaControl
---@field goldCardExpText UIKmlLuaControl
---@field goldCardHookText UIKmlLuaControl
---@field goldCoinTxt UIKmlLuaControl
---@field goldCoinItem UIKmlLuaControl
---@field bg_bottom UIKmlLuaControl
---@field AllCardBtn UIKmlLuaControl
---@field AllCardBtnText UIKmlLuaControl
local KLUIRechargeMonthlycardPanelView = {}
setmetatable(KLUIRechargeMonthlycardPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/RechargeMonthlycard/Panel/KLUIRechargeMonthlycard/KLUIRechargeMonthlycardPanelKml'
---@param parent UIKmlLuaControl
function KLUIRechargeMonthlycardPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIRechargeMonthlycardPanelView
