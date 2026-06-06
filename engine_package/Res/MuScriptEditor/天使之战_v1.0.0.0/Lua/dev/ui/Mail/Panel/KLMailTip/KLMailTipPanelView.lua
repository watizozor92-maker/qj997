---@class KLMailTipPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field text_bg UIKmlLuaControl
---@field close_btn UIKmlLuaControl
---@field text UIKmlLuaControl
local KLMailTipPanelView = {}
setmetatable(KLMailTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Mail/Panel/KLMailTip/KLMailTipPanelKml'
---@param parent UIKmlLuaControl
function KLMailTipPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLMailTipPanelView
