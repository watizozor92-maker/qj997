---@class KLTaskGuidePanelView:UIKmlLuaViewBase
---@field closeMask UIKmlLuaControlHandler
---@field Content UIKmlLuaControlHandler
---@field task_guide_layout UIKmlLuaControlHandler
---@field task_guide_list UIKmlLuaControlHandler
---@field Arrow UIKmlLuaControlHandler
local KLTaskGuidePanelView = {}
setmetatable(KLTaskGuidePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Task/Panel/KLTaskGuide/KLTaskGuidePanelKml'
---@param parent UIKmlLuaControlHandler
function KLTaskGuidePanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLTaskGuidePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Task/Panel/KLTaskGuide/KLTaskGuidePanel']

return KLTaskGuidePanelView
