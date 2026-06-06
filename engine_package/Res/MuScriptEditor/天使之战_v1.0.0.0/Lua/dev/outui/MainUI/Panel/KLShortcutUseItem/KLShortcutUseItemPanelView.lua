---@class KLShortcutUseItemPanelView:UIKmlLuaViewBase
---@field fast_grid UIKmlLuaControlHandler
---@field fast_data_list UIKmlLuaControlHandler
local KLShortcutUseItemPanelView = {}
setmetatable(KLShortcutUseItemPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MainUI/Panel/KLShortcutUseItem/KLShortcutUseItemPanelKml'
---@param parent UIKmlLuaControlHandler
function KLShortcutUseItemPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLShortcutUseItemPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MainUI/Panel/KLShortcutUseItem/KLShortcutUseItemPanel']

return KLShortcutUseItemPanelView
