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
return KLGainItemTipsPanelView
