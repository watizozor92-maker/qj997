---@class KLPlayVideoPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field mask UIKmlLuaControl
---@field Close UIKmlLuaControl
---@field text3 UIKmlLuaControl
---@field image UIKmlLuaControl
---@field VideoPlayer UIKmlLuaControl
---@field btn_open UIKmlLuaControl
local KLPlayVideoPanelView = {}
setmetatable(KLPlayVideoPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Recharge/Panel/KLPlayVideo/KLPlayVideoPanelKml'
---@param parent UIKmlLuaControl
function KLPlayVideoPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLPlayVideoPanelView
