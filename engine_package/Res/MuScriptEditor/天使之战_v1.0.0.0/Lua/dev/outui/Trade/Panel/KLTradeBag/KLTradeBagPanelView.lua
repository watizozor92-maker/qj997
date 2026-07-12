---@class KLTradeBagPanelView:UIKmlLuaViewBase
---@field cut_area_up1 UIKmlLuaControlHandler
---@field cut_area_up2 UIKmlLuaControlHandler
---@field cut_area_down1 UIKmlLuaControlHandler
---@field cut_area_down2 UIKmlLuaControlHandler
---@field frame UIKmlLuaControlHandler
local KLTradeBagPanelView = {}
setmetatable(KLTradeBagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeBag/KLTradeBagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLTradeBagPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeBagPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Panel/KLTradeBag/KLTradeBagPanel']

return KLTradeBagPanelView
