---@class KLGainItemTipsPanelView:UIKmlLuaViewBase
---@field CloseBG UIKmlLuaControlHandler
---@field bgm UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field scrollview UIKmlLuaControlHandler
---@field layout UIKmlLuaControlHandler
---@field rewards UIKmlLuaControlHandler
local KLGainItemTipsPanelView = {}
setmetatable(KLGainItemTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Tips/Panel/KLGainItemTips/KLGainItemTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLGainItemTipsPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLGainItemTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Tips/Panel/KLGainItemTips/KLGainItemTipsPanel']

return KLGainItemTipsPanelView
