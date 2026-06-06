---@class KLRedFortCounterPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field killCount UIKmlLuaControlHandler
---@field textKillCount UIKmlLuaControlHandler
---@field dieCount UIKmlLuaControlHandler
---@field textDieCount UIKmlLuaControlHandler
local KLRedFortCounterPanelView = {}
setmetatable(KLRedFortCounterPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLRedFortCounter/KLRedFortCounterPanelKml'
---@param parent UIKmlLuaControlHandler
function KLRedFortCounterPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRedFortCounterPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLRedFortCounter/KLRedFortCounterPanel']

return KLRedFortCounterPanelView
