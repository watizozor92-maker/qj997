---@class KLWolfSoulFortressScoreItemView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field rankBg UIKmlLuaControlHandler
---@field rankImg UIKmlLuaControlHandler
---@field myRank UIKmlLuaControlHandler
---@field myName UIKmlLuaControlHandler
---@field myCareer UIKmlLuaControlHandler
---@field myLevel UIKmlLuaControlHandler
---@field myScore UIKmlLuaControlHandler
---@field itemList UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field itemDataList UIKmlLuaControlHandler
local KLWolfSoulFortressScoreItemView = {}
setmetatable(KLWolfSoulFortressScoreItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLWolfSoulFortressScore/KLWolfSoulFortressScoreItemKml'
---@param parent UIKmlLuaControlHandler
function KLWolfSoulFortressScoreItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLWolfSoulFortressScoreItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLWolfSoulFortressScore/KLWolfSoulFortressScoreItem']

return KLWolfSoulFortressScoreItemView
