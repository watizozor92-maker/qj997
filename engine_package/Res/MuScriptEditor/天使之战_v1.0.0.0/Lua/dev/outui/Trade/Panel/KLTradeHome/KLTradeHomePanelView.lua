---@class KLTradeHomePanelView:UIKmlLuaViewBase
---@field scrollview_catalogue UIKmlLuaControlHandler
---@field datalist_138 UIKmlLuaControlHandler
---@field layout_143 UIKmlLuaControlHandler
---@field panel_154 UIKmlLuaControlHandler
---@field dropdown_list_level UIKmlLuaControlHandler
---@field scrollview_156 UIKmlLuaControlHandler
---@field layout_level UIKmlLuaControlHandler
---@field btn_filter_level UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field img_158 UIKmlLuaControlHandler
---@field btn_filter_level_txt UIKmlLuaControlHandler
---@field panel_144 UIKmlLuaControlHandler
---@field dropdown_list_quality UIKmlLuaControlHandler
---@field layout_146 UIKmlLuaControlHandler
---@field btn_filter_quality UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field img_153 UIKmlLuaControlHandler
---@field btn_filter_quality_txt UIKmlLuaControlHandler
---@field panel_169 UIKmlLuaControlHandler
---@field dropdown_list_career UIKmlLuaControlHandler
---@field layout_171 UIKmlLuaControlHandler
---@field btn_filter_career UIKmlLuaControlHandler
---@field layout4 UIKmlLuaControlHandler
---@field img_177 UIKmlLuaControlHandler
---@field btn_filter_career_txt UIKmlLuaControlHandler
---@field panel_159 UIKmlLuaControlHandler
---@field dropdown_list_order UIKmlLuaControlHandler
---@field layout_161 UIKmlLuaControlHandler
---@field btn_sort UIKmlLuaControlHandler
---@field layout5 UIKmlLuaControlHandler
---@field img_168 UIKmlLuaControlHandler
---@field btn_sort_txt UIKmlLuaControlHandler
---@field btn_dropdown_mask UIKmlLuaControlHandler
local KLTradeHomePanelView = {}
setmetatable(KLTradeHomePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanelKml'
---@param parent UIKmlLuaControlHandler
function KLTradeHomePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTradeHomePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Trade/Panel/KLTradeHome/KLTradeHomePanel']

return KLTradeHomePanelView
