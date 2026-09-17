---@class KLMailTipPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field text_bg UIKmlLuaControlHandler
---@field close_btn UIKmlLuaControlHandler
---@field text UIKmlLuaControlHandler
local KLMailTipPanelView = {}
setmetatable(KLMailTipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Mail/Panel/KLMailTip/KLMailTipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLMailTipPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLMailTipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Mail/Panel/KLMailTip/KLMailTipPanel']

return KLMailTipPanelView
