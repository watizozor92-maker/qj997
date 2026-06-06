---@class KLWolfSoulFortressSummonPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img11 UIKmlLuaControlHandler
---@field img10 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field btnClose UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field textGuildMoney UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field textSummonCount UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field textTime UIKmlLuaControlHandler
---@field summonList UIKmlLuaControlHandler
---@field summonDataList UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
local KLWolfSoulFortressSummonPanelView = {}
setmetatable(KLWolfSoulFortressSummonPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonPanelKml'
---@param parent UIKmlLuaControlHandler
function KLWolfSoulFortressSummonPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLWolfSoulFortressSummonPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLWolfSoulFortressSummon/KLWolfSoulFortressSummonPanel']

return KLWolfSoulFortressSummonPanelView
