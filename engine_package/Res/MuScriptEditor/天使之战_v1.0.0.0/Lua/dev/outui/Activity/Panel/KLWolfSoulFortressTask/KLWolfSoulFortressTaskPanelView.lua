---@class KLWolfSoulFortressTaskPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field btnHelp UIKmlLuaControlHandler
---@field timerTitle UIKmlLuaControlHandler
---@field timeText UIKmlLuaControlHandler
---@field textRoot UIKmlLuaControlHandler
---@field text_1 UIKmlLuaControlHandler
---@field text_2 UIKmlLuaControlHandler
---@field textSummonCount UIKmlLuaControlHandler
---@field btnSummon UIKmlLuaControlHandler
---@field textRoot_2 UIKmlLuaControlHandler
---@field textKey_1 UIKmlLuaControlHandler
---@field textWolfHp UIKmlLuaControlHandler
---@field textKey_2 UIKmlLuaControlHandler
---@field textScore UIKmlLuaControlHandler
---@field textKey_3 UIKmlLuaControlHandler
---@field textRank UIKmlLuaControlHandler
---@field textKey_4 UIKmlLuaControlHandler
---@field textFightCount UIKmlLuaControlHandler
---@field btnExit UIKmlLuaControlHandler
---@field timeText_2 UIKmlLuaControlHandler
local KLWolfSoulFortressTaskPanelView = {}
setmetatable(KLWolfSoulFortressTaskPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLWolfSoulFortressTask/KLWolfSoulFortressTaskPanelKml'
---@param parent UIKmlLuaControlHandler
function KLWolfSoulFortressTaskPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLWolfSoulFortressTaskPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLWolfSoulFortressTask/KLWolfSoulFortressTaskPanel']

return KLWolfSoulFortressTaskPanelView
