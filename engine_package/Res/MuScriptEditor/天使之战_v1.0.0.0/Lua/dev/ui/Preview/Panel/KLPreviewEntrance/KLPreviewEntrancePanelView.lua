---@class KLPreviewEntrancePanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field PreviewUI UIKmlLuaControlHandler
---@field effect UIKmlLuaControlHandler
---@field PreviewUIclick UIKmlLuaControlHandler
---@field icon_bottom UIKmlLuaControlHandler
---@field icon UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
local KLPreviewEntrancePanelView = {}
setmetatable(KLPreviewEntrancePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Preview/Panel/KLPreviewEntrance/KLPreviewEntrancePanelKml'
---@param parent UIKmlLuaControlHandler
function KLPreviewEntrancePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLPreviewEntrancePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Preview/Panel/KLPreviewEntrance/KLPreviewEntrancePanel']

return KLPreviewEntrancePanelView
