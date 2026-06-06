---@class KLBingFengBaoButtonPanelView:UIKmlLuaViewBase
---@field button_ZhanLing UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field btnGo UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
local KLBingFengBaoButtonPanelView = {}
setmetatable(KLBingFengBaoButtonPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLBingFengBaoButton/KLBingFengBaoButtonPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBingFengBaoButtonPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLBingFengBaoButtonPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLBingFengBaoButton/KLBingFengBaoButtonPanel']

return KLBingFengBaoButtonPanelView
