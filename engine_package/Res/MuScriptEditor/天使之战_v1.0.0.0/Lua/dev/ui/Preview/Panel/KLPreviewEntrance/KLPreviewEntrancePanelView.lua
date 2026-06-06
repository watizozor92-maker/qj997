---@class KLPreviewEntrancePanelView:UIKmlLuaViewBase
---@field PreviewUI UIKmlLuaControl
---@field effect UIKmlLuaControl
---@field PreviewUIclick UIKmlLuaControl
---@field icon_bottom UIKmlLuaControl
---@field icon UIKmlLuaControl
---@field name UIKmlLuaControl
local KLPreviewEntrancePanelView = {}
setmetatable(KLPreviewEntrancePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Preview/Panel/KLPreviewEntrance/KLPreviewEntrancePanelKml'
---@param parent UIKmlLuaControl
function KLPreviewEntrancePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLPreviewEntrancePanelView
