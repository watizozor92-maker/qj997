---@class KLRechargePanelView:UIKmlLuaViewBase
---@field Panel UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field scrollview UIKmlLuaControlHandler
---@field gridview11 UIKmlLuaControlHandler
---@field RechargeGoodsList UIKmlLuaControlHandler
---@field countDownRoot UIKmlLuaControlHandler
---@field refreshTime UIKmlLuaControlHandler
---@field bottom UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field BtnReturn UIKmlLuaControlHandler
local KLRechargePanelView = {}
setmetatable(KLRechargePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanelKml'
---@param parent UIKmlLuaControlHandler
function KLRechargePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRechargePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel']

return KLRechargePanelView
