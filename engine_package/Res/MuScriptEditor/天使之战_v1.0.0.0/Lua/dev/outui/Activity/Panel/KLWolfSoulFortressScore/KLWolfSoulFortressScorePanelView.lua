---@class KLWolfSoulFortressScorePanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field img10 UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field bgTitle UIKmlLuaControlHandler
---@field btnClose UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field myInfos UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field myRank UIKmlLuaControlHandler
---@field myName UIKmlLuaControlHandler
---@field myCareer UIKmlLuaControlHandler
---@field myLevel UIKmlLuaControlHandler
---@field myScore UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field itemDataList UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field rankList UIKmlLuaControlHandler
local KLWolfSoulFortressScorePanelView = {}
setmetatable(KLWolfSoulFortressScorePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLWolfSoulFortressScore/KLWolfSoulFortressScorePanelKml'
---@param parent UIKmlLuaControlHandler
function KLWolfSoulFortressScorePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLWolfSoulFortressScorePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLWolfSoulFortressScore/KLWolfSoulFortressScorePanel']

return KLWolfSoulFortressScorePanelView
