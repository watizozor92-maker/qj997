---@class KLMapHookPointsPanelView:UIKmlLuaViewBase
---@field btnBG UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field scroll UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
local KLMapHookPointsPanelView = {}
setmetatable(KLMapHookPointsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Panel/KLMapHookPoints/KLMapHookPointsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMapHookPointsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMapHookPointsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Panel/KLMapHookPoints/KLMapHookPointsPanel']

return KLMapHookPointsPanelView
