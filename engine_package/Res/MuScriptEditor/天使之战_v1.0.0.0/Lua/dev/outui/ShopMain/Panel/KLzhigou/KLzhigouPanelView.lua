---@class KLzhigouPanelView:UIKmlLuaViewBase
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
local KLzhigouPanelView = {}
setmetatable(KLzhigouPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ShopMain/Panel/KLzhigou/KLzhigouPanelKml'
---@param parent UIKmlLuaControlHandler
function KLzhigouPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end

---@type KLzhigouPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ShopMain/Panel/KLzhigou/KLzhigouPanel']

return KLzhigouPanelView
