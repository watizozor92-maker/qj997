---@class KLCardShapeArchangelPanelView:UIKmlLuaViewBase
---@field img_bg UIKmlLuaControlHandler
---@field item_model UIKmlLuaControlHandler
---@field today_show_toggle UIKmlLuaControlHandler
---@field text_15 UIKmlLuaControlHandler
---@field btn_go UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
local KLCardShapeArchangelPanelView = {}
setmetatable(KLCardShapeArchangelPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/CardShapeShift/Panel/KLCardShapeArchangel/KLCardShapeArchangelPanelKml'
---@param parent UIKmlLuaControlHandler
function KLCardShapeArchangelPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLCardShapeArchangelPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/CardShapeShift/Panel/KLCardShapeArchangel/KLCardShapeArchangelPanel']

return KLCardShapeArchangelPanelView
