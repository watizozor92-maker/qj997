---@class KLWolfSoulFortressScoreItemView:UIKmlLuaViewBase
---@field root UIKmlLuaControl
---@field rankBg UIKmlLuaControl
---@field rankImg UIKmlLuaControl
---@field myRank UIKmlLuaControl
---@field myName UIKmlLuaControl
---@field myCareer UIKmlLuaControl
---@field myLevel UIKmlLuaControl
---@field myScore UIKmlLuaControl
---@field itemList UIKmlLuaControl
---@field layout1 UIKmlLuaControl
---@field itemDataList UIKmlLuaControl
local KLWolfSoulFortressScoreItemView = {}
setmetatable(KLWolfSoulFortressScoreItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLWolfSoulFortressScore/KLWolfSoulFortressScoreItemKml'
---@param parent UIKmlLuaControl
function KLWolfSoulFortressScoreItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLWolfSoulFortressScoreItemView
