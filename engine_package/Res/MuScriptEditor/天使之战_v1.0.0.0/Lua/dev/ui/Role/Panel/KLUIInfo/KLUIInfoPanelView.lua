---@class KLUIInfoPanelView:UIKmlLuaViewBase
---@field attr_layout UIKmlLuaControlHandler
---@field attr_datalist UIKmlLuaControlHandler
local KLUIInfoPanelView = {}
setmetatable(KLUIInfoPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Role/Panel/KLUIInfo/KLUIInfoPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIInfoPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLUIInfoPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Role/Panel/KLUIInfo/KLUIInfoPanel']

return KLUIInfoPanelView
