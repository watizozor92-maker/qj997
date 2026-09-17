---@class KLCardShapeShiftPanelView:UIKmlLuaViewBase
---@field img_close UIKmlLuaControlHandler
---@field img_13 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field img_bg UIKmlLuaControlHandler
---@field today_show_toggle UIKmlLuaControlHandler
---@field text_17 UIKmlLuaControlHandler
---@field btn_left UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field btn_left_tips UIKmlLuaControlHandler
---@field btn_right UIKmlLuaControlHandler
---@field img9 UIKmlLuaControlHandler
---@field btn_right_tips UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
local KLCardShapeShiftPanelView = {}
setmetatable(KLCardShapeShiftPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CardShapeShift/Panel/KLCardShapeShift/KLCardShapeShiftPanelKml'
---@param parent UIKmlLuaControlHandler
function KLCardShapeShiftPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLCardShapeShiftPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/CardShapeShift/Panel/KLCardShapeShift/KLCardShapeShiftPanel']

return KLCardShapeShiftPanelView
