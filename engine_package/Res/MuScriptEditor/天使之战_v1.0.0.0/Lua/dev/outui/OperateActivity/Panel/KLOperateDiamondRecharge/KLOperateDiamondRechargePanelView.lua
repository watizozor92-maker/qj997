---@class KLOperateDiamondRechargePanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControl
---@field DailyPackMainBG UIKmlLuaControl
---@field DailyPackTitleImg UIKmlLuaControl
---@field DailyPackInfo UIKmlLuaControl
---@field DailyPackInfoScrollView UIKmlLuaControl
---@field gridview2 UIKmlLuaControl
---@field DailyPackItemList UIKmlLuaControl
---@field buyAllGift_btn UIKmlLuaControl
---@field originalPrice UIKmlLuaControl
---@field originalPriceNum UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field allBuyText UIKmlLuaControl
local KLOperateDiamondRechargePanelView = {}
setmetatable(KLOperateDiamondRechargePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/OperateActivity/Panel/KLOperateDiamondRecharge/KLOperateDiamondRechargePanelKml'
---@param parent UIKmlLuaControl
function KLOperateDiamondRechargePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLOperateDiamondRechargePanelView
