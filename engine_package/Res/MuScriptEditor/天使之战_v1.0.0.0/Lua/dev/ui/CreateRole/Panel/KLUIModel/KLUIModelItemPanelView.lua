---@class KLUIModelItemPanelView:UIKmlLuaViewBase
---@field UIModelItemTemplate UIKmlLuaControlHandler
---@field Image UIKmlLuaControlHandler
---@field ImageSelect UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field NameNew UIKmlLuaControlHandler
---@field UnionPos UIKmlLuaControlHandler
---@field LevelNew UIKmlLuaControlHandler
---@field ImageCareer UIKmlLuaControlHandler
---@field DeleteBtn UIKmlLuaControlHandler
---@field Name UIKmlLuaControlHandler
---@field Level UIKmlLuaControlHandler
---@field ModelBtn UIKmlLuaControlHandler
local KLUIModelItemPanelView = {}
setmetatable(KLUIModelItemPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/CreateRole/Panel/KLUIModel/KLUIModelItemPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIModelItemPanelView:Init(parent)
    self:InitRoot(parent,kmlPath, KLUIModelItemPanelView.content)
end
---@type KLUIModelItemPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/CreateRole/Panel/KLUIModel/KLUIModelItemPanel']

return KLUIModelItemPanelView
