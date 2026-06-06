---@class KLQuintonInvasionTaskProgressPanelView:UIKmlLuaViewBase
---@field fightRoot UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field waveNumber UIKmlLuaControlHandler
---@field taskName UIKmlLuaControlHandler
---@field taskCount UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field desBtn UIKmlLuaControlHandler
---@field rewardList1 UIKmlLuaControlHandler
---@field layout67 UIKmlLuaControlHandler
---@field rewardList UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field countDownTime UIKmlLuaControlHandler
---@field exitBtn UIKmlLuaControlHandler
local KLQuintonInvasionTaskProgressPanelView = {}
setmetatable(KLQuintonInvasionTaskProgressPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLQuintonInvasionTaskProgress/KLQuintonInvasionTaskProgressPanelKml'
---@param parent UIKmlLuaControlHandler
function KLQuintonInvasionTaskProgressPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLQuintonInvasionTaskProgressPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLQuintonInvasionTaskProgress/KLQuintonInvasionTaskProgressPanel']

return KLQuintonInvasionTaskProgressPanelView
