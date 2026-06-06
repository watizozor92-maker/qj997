---@class KLUISystemTopPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field left UIKmlLuaControlHandler
---@field systemContainer UIKmlLuaControlHandler
---@field systemMenu UIKmlLuaControlHandler
---@field expanfBg UIKmlLuaControlHandler
---@field sysExpand UIKmlLuaControlHandler
---@field sysExpandClickBg UIKmlLuaControlHandler
---@field sysFold UIKmlLuaControlHandler
---@field sysFoldClickBg UIKmlLuaControlHandler
---@field bossBtn UIKmlLuaControlHandler
---@field monthCardBtn UIKmlLuaControlHandler
local KLUISystemTopPanelView = {}
setmetatable(KLUISystemTopPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Panel/KLUISystemTop/KLUISystemTopPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUISystemTopPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISystemTopPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Panel/KLUISystemTop/KLUISystemTopPanel']

return KLUISystemTopPanelView
