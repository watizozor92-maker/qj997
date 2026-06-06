---@class KLCardShapeShiftPanelView:UIKmlLuaViewBase
---@field img_close UIKmlLuaControl
---@field img_13 UIKmlLuaControl
---@field title UIKmlLuaControl
---@field img_bg UIKmlLuaControl
---@field today_show_toggle UIKmlLuaControl
---@field text_17 UIKmlLuaControl
---@field btn_left UIKmlLuaControl
---@field img7 UIKmlLuaControl
---@field btn_left_tips UIKmlLuaControl
---@field btn_right UIKmlLuaControl
---@field img9 UIKmlLuaControl
---@field btn_right_tips UIKmlLuaControl
---@field btn_close UIKmlLuaControl
local KLCardShapeShiftPanelView = {}
setmetatable(KLCardShapeShiftPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CardShapeShift/Panel/KLCardShapeShift/KLCardShapeShiftPanelKml'
---@param parent UIKmlLuaControl
function KLCardShapeShiftPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLCardShapeShiftPanelView
