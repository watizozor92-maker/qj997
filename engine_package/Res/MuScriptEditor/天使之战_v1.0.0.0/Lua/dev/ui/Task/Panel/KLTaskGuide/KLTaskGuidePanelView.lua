---@class KLTaskGuidePanelView:UIKmlLuaViewBase
---@field closeMask UIKmlLuaControl
---@field Content UIKmlLuaControl
---@field task_guide_layout UIKmlLuaControl
---@field task_guide_list UIKmlLuaControl
---@field Arrow UIKmlLuaControl
local KLTaskGuidePanelView = {}
setmetatable(KLTaskGuidePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Task/Panel/KLTaskGuide/KLTaskGuidePanelKml'
---@param parent UIKmlLuaControl
function KLTaskGuidePanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLTaskGuidePanelView
