---@class KLWolfSoulFortressPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field textTime UIKmlLuaControlHandler
local KLWolfSoulFortressPanelView = {}
setmetatable(KLWolfSoulFortressPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLWolfSoulFortress/KLWolfSoulFortressPanelKml'
---@param parent UIKmlLuaControlHandler
function KLWolfSoulFortressPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLWolfSoulFortressPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLWolfSoulFortress/KLWolfSoulFortressPanel']

return KLWolfSoulFortressPanelView
