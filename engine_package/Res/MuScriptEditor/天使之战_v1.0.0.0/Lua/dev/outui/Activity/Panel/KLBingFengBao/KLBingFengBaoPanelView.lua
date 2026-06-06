---@class KLBingFengBaoPanelView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text4 UIKmlLuaControlHandler
---@field button38 UIKmlLuaControlHandler
---@field text39 UIKmlLuaControlHandler
---@field btn_des UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field layout37 UIKmlLuaControlHandler
---@field reward_node UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field scrollview2 UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field itemDataList UIKmlLuaControlHandler
---@field img15 UIKmlLuaControlHandler
---@field last_win_node UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field text24 UIKmlLuaControlHandler
---@field img23 UIKmlLuaControlHandler
---@field panel29 UIKmlLuaControlHandler
---@field img30 UIKmlLuaControlHandler
---@field text31 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field state_node UIKmlLuaControlHandler
---@field img27 UIKmlLuaControlHandler
---@field text28 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field rule_node UIKmlLuaControlHandler
---@field img34 UIKmlLuaControlHandler
---@field text35 UIKmlLuaControlHandler
---@field text36 UIKmlLuaControlHandler
local KLBingFengBaoPanelView = {}
setmetatable(KLBingFengBaoPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLBingFengBao/KLBingFengBaoPanelKml'
---@param parent UIKmlLuaControlHandler
function KLBingFengBaoPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLBingFengBaoPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLBingFengBao/KLBingFengBaoPanel']

return KLBingFengBaoPanelView
