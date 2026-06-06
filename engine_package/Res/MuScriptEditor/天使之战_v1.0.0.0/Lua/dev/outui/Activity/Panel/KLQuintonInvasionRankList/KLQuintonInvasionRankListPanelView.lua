---@class KLQuintonInvasionRankListPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field togglegroup2 UIKmlLuaControlHandler
---@field teamBtn UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field personBtn UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field desBtn UIKmlLuaControlHandler
---@field rankList1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field rankList UIKmlLuaControlHandler
local KLQuintonInvasionRankListPanelView = {}
setmetatable(KLQuintonInvasionRankListPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLQuintonInvasionRankList/KLQuintonInvasionRankListPanelKml'
---@param parent UIKmlLuaControlHandler
function KLQuintonInvasionRankListPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLQuintonInvasionRankListPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLQuintonInvasionRankList/KLQuintonInvasionRankListPanel']

return KLQuintonInvasionRankListPanelView
