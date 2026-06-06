---@class KLDescribeDetailPanelView:UIKmlLuaViewBase
---@field bg1 UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field ContentTxt UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
local KLDescribeDetailPanelView = {}
setmetatable(KLDescribeDetailPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLDescribeDetail/KLDescribeDetailPanelKml'
---@param parent UIKmlLuaControlHandler
function KLDescribeDetailPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLDescribeDetailPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLDescribeDetail/KLDescribeDetailPanel']

return KLDescribeDetailPanelView
