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
---@type KLNavTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Notice/Panel/KLNavTip/KLNavTipPanel']

return KLNavTipPanelView
