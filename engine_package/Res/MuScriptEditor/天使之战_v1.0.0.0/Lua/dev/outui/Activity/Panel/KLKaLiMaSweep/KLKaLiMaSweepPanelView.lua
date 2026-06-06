---@class KLKaLiMaSweepPanelView:UIKmlLuaViewBase
---@field button9 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field img8 UIKmlLuaControlHandler
---@field panel_sweep UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field btn_sweepClose UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text46 UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text64 UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout67 UIKmlLuaControlHandler
---@field rewardList UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field ticketBtn UIKmlLuaControlHandler
---@field ticketCount UIKmlLuaControlHandler
---@field ticketItem UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field text6 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field lab_sweepExtraAlready UIKmlLuaControlHandler
---@field btn_ticketGet UIKmlLuaControlHandler
---@field img_extraSweepItemItem UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text61 UIKmlLuaControlHandler
---@field countTxt UIKmlLuaControlHandler
---@field sweepBtn UIKmlLuaControlHandler
local KLKaLiMaSweepPanelView = {}
setmetatable(KLKaLiMaSweepPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLKaLiMaSweep/KLKaLiMaSweepPanelKml'
---@param parent UIKmlLuaControlHandler
function KLKaLiMaSweepPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLKaLiMaSweepPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLKaLiMaSweep/KLKaLiMaSweepPanel']

return KLKaLiMaSweepPanelView
