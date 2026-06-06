---@class KLNavTipPanelView:UIKmlLuaViewBase
---@field panel_content UIKmlLuaControlHandler
---@field text_tip UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
local KLNavTipPanelView = {}
setmetatable(KLNavTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Notice/Panel/KLNavTip/KLNavTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLNavTipPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLNavTipPanelView
