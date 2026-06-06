---@class KLDevilCopyTaskProgressPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field prepareRoot UIKmlLuaControlHandler
---@field openActivityBtn UIKmlLuaControlHandler
---@field openDes UIKmlLuaControlHandler
---@field openDesTxt UIKmlLuaControlHandler
---@field openTime UIKmlLuaControlHandler
---@field fightRoot UIKmlLuaControlHandler
---@field waveNumber UIKmlLuaControlHandler
---@field taskName UIKmlLuaControlHandler
---@field taskCount UIKmlLuaControlHandler
---@field countdown_copy UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field score UIKmlLuaControlHandler
---@field desBtn UIKmlLuaControlHandler
---@field rewardModel UIKmlLuaControlHandler
---@field exitBtn UIKmlLuaControlHandler
---@field endTime UIKmlLuaControlHandler
local KLDevilCopyTaskProgressPanelView = {}
setmetatable(KLDevilCopyTaskProgressPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLDevilCopyTaskProgress/KLDevilCopyTaskProgressPanelKml'
---@param parent UIKmlLuaControlHandler
function KLDevilCopyTaskProgressPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLDevilCopyTaskProgressPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLDevilCopyTaskProgress/KLDevilCopyTaskProgressPanel']

return KLDevilCopyTaskProgressPanelView
