---@class KLMapTransferAnimPanelPanelView:UIKmlLuaViewBase
---@field prefab_457 UIKmlLuaControlHandler
---@field img_trans_anim UIKmlLuaControlHandler
local KLMapTransferAnimPanelPanelView = {}
setmetatable(KLMapTransferAnimPanelPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Panel/KLMapTransferAnimPanel/KLMapTransferAnimPanelPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMapTransferAnimPanelPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLMapTransferAnimPanelPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Map/Panel/KLMapTransferAnimPanel/KLMapTransferAnimPanelPanel']

return KLMapTransferAnimPanelPanelView
