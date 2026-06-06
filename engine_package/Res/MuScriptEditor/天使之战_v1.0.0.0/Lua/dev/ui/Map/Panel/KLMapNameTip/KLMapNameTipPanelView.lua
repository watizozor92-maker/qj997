---@class KLMapNameTipPanelView:UIKmlLuaViewBase
---@field prefab_455 UIKmlLuaControlHandler
---@field ImgMapName UIKmlLuaControlHandler
local KLMapNameTipPanelView = {}
setmetatable(KLMapNameTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Panel/KLMapNameTip/KLMapNameTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMapNameTipPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLMapNameTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Map/Panel/KLMapNameTip/KLMapNameTipPanel']

return KLMapNameTipPanelView
