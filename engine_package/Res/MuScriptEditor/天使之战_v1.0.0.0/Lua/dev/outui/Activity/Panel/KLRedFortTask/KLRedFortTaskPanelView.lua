---@class KLRedFortTaskPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field exitBtn UIKmlLuaControlHandler
---@field textFightTime UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field textSetout UIKmlLuaControlHandler
---@field textSetoutTime UIKmlLuaControlHandler
---@field text30 UIKmlLuaControlHandler
---@field textTime UIKmlLuaControlHandler
---@field textJoin UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field textJoinCoun UIKmlLuaControlHandler
---@field textTarget UIKmlLuaControlHandler
---@field textPlayer UIKmlLuaControlHandler
---@field text11 UIKmlLuaControlHandler
---@field textPlayerCount UIKmlLuaControlHandler
---@field textRevive UIKmlLuaControlHandler
---@field text15 UIKmlLuaControlHandler
---@field textReviveCount UIKmlLuaControlHandler
local KLRedFortTaskPanelView = {}
setmetatable(KLRedFortTaskPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLRedFortTask/KLRedFortTaskPanelKml'
---@param parent UIKmlLuaControlHandler
function KLRedFortTaskPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLRedFortTaskPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLRedFortTask/KLRedFortTaskPanel']

return KLRedFortTaskPanelView
