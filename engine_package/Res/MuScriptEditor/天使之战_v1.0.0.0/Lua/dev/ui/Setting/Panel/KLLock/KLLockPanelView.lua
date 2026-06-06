---@class KLLockPanelView:UIKmlLuaViewBase
---@field prefab_824 UIKmlLuaControlHandler
---@field Slider UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
local KLLockPanelView = {}
setmetatable(KLLockPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Panel/KLLock/KLLockPanelKml'
---@param parent UIKmlLuaControlHandler
function KLLockPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLLockPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Panel/KLLock/KLLockPanel']

return KLLockPanelView
