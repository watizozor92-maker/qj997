---@class KLQuintonInvasionJoinPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field mask UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field img_kundun UIKmlLuaControlHandler
---@field btnClose UIKmlLuaControlHandler
---@field Title UIKmlLuaControlHandler
---@field btnEnter UIKmlLuaControlHandler
local KLQuintonInvasionJoinPanelView = {}
setmetatable(KLQuintonInvasionJoinPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLQuintonInvasionJoin/KLQuintonInvasionJoinPanelKml'
---@param parent UIKmlLuaControlHandler
function KLQuintonInvasionJoinPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLQuintonInvasionJoinPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLQuintonInvasionJoin/KLQuintonInvasionJoinPanel']

return KLQuintonInvasionJoinPanelView
