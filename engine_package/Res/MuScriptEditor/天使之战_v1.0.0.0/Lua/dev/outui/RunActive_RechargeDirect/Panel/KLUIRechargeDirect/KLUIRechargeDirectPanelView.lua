---@class KLUIRechargeDirectPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field giftDataList UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field refreshTime UIKmlLuaControlHandler
---@field buyAllBtn UIKmlLuaControlHandler
---@field priceText UIKmlLuaControlHandler
---@field oldText UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
local KLUIRechargeDirectPanelView = {}
setmetatable(KLUIRechargeDirectPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/RunActive_RechargeDirect/Panel/KLUIRechargeDirect/KLUIRechargeDirectPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIRechargeDirectPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLUIRechargeDirectPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/RunActive_RechargeDirect/Panel/KLUIRechargeDirect/KLUIRechargeDirectPanel']

return KLUIRechargeDirectPanelView
