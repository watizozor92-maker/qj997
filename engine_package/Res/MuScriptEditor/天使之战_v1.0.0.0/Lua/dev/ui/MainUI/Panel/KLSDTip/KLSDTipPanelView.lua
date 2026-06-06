---@class KLSDTipPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field des UIKmlLuaControlHandler
local KLSDTipPanelView = {}
setmetatable(KLSDTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLSDTip/KLSDTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLSDTipPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSDTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLSDTip/KLSDTipPanel']

return KLSDTipPanelView
