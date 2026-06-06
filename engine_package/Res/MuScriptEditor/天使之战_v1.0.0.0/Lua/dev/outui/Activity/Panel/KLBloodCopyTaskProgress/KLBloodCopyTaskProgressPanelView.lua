---@class KLBloodCopyTaskProgressPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field desBtn UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field prepareRoot UIKmlLuaControlHandler
---@field openActivityBtn UIKmlLuaControlHandler
---@field openDes UIKmlLuaControlHandler
---@field openDesTxt UIKmlLuaControlHandler
---@field openTime UIKmlLuaControlHandler
---@field fightRoot UIKmlLuaControlHandler
---@field waveNumber UIKmlLuaControlHandler
---@field taskName UIKmlLuaControlHandler
---@field taskCount UIKmlLuaControlHandler
---@field rewardRoot UIKmlLuaControlHandler
---@field rewardList1 UIKmlLuaControlHandler
---@field layout67 UIKmlLuaControlHandler
---@field rewardList UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field endRoot UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field exitBtn UIKmlLuaControlHandler
---@field endTime UIKmlLuaControlHandler
---@field noPickUpWeaponTip UIKmlLuaControlHandler
local KLBloodCopyTaskProgressPanelView = {}
setmetatable(KLBloodCopyTaskProgressPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLBloodCopyTaskProgress/KLBloodCopyTaskProgressPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBloodCopyTaskProgressPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLBloodCopyTaskProgressPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLBloodCopyTaskProgress/KLBloodCopyTaskProgressPanel']

return KLBloodCopyTaskProgressPanelView
