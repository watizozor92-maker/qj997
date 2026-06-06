---@class KLAppearCostPanelView:UIKmlLuaViewBase
---@field WndTitle UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field WndBg UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field CostGrid UIKmlLuaControlHandler
---@field datalist1 UIKmlLuaControlHandler
---@field BtnActive UIKmlLuaControlHandler
---@field WndTitle UIKmlLuaControlHandler
local KLAppearCostPanelView = {}
setmetatable(KLAppearCostPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Panel/KLAppearCost/KLAppearCostPanelKml'
---@param parent UIKmlLuaControlHandler
function KLAppearCostPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLAppearCostPanelView
