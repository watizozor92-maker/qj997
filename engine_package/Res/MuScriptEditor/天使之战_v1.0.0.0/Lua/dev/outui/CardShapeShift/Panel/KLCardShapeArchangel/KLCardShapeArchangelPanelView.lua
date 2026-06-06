---@class KLCardShapeArchangelPanelView:UIKmlLuaViewBase
---@field img_bg UIKmlLuaControl
---@field item_model UIKmlLuaControl
---@field today_show_toggle UIKmlLuaControl
---@field text_15 UIKmlLuaControl
---@field btn_go UIKmlLuaControl
---@field btn_close UIKmlLuaControl
local KLCardShapeArchangelPanelView = {}
setmetatable(KLCardShapeArchangelPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CardShapeShift/Panel/KLCardShapeArchangel/KLCardShapeArchangelPanelKml'
---@param parent UIKmlLuaControl
function KLCardShapeArchangelPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLCardShapeArchangelPanelView
