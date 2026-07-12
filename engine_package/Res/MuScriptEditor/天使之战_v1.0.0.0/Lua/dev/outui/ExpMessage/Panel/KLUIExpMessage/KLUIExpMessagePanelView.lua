---@class KLUIExpMessagePanelView:UIKmlLuaViewBase
local KLUIExpMessagePanelView = {}
setmetatable(KLUIExpMessagePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ExpMessage/Panel/KLUIExpMessage/KLUIExpMessagePanelKml'
---@param parent UIKmlLuaControlHandler
function KLUIExpMessagePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIExpMessagePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ExpMessage/Panel/KLUIExpMessage/KLUIExpMessagePanel']

return KLUIExpMessagePanelView
