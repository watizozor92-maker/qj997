---@class KLOpenStallPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field text2 UIKmlLuaControl
---@field shuoming UIKmlLuaControl
---@field btn_start UIKmlLuaControl
---@field view5 UIKmlLuaControl
---@field xiaohao UIKmlLuaControl
---@field kuang_5 UIKmlLuaControl
---@field cost_item UIKmlLuaControl
---@field notice_text_5 UIKmlLuaControl
---@field cost_num UIKmlLuaControl
---@field right5 UIKmlLuaControl
---@field add_btn UIKmlLuaControl
---@field view4 UIKmlLuaControl
---@field chijian UIKmlLuaControl
---@field kuang_4 UIKmlLuaControl
---@field select_view_4 UIKmlLuaControl
---@field select_view_4_btn UIKmlLuaControl
---@field select_view_4_scrol UIKmlLuaControl
---@field select_view_4_grid UIKmlLuaControl
---@field time_data_list UIKmlLuaControl
---@field notice_text_4 UIKmlLuaControl
---@field right4 UIKmlLuaControl
---@field open4 UIKmlLuaControl
---@field close4 UIKmlLuaControl
---@field view3 UIKmlLuaControl
---@field chijian UIKmlLuaControl
---@field kuang_3 UIKmlLuaControl
---@field notice_text_3 UIKmlLuaControl
---@field view2 UIKmlLuaControl
---@field chengshi UIKmlLuaControl
---@field kuang_2 UIKmlLuaControl
---@field select_view_2 UIKmlLuaControl
---@field select_view_2_btn UIKmlLuaControl
---@field select_view_2_scrol UIKmlLuaControl
---@field select_view_2_grid UIKmlLuaControl
---@field city_data_list UIKmlLuaControl
---@field notice_text_2 UIKmlLuaControl
---@field last_num UIKmlLuaControl
---@field right2 UIKmlLuaControl
---@field open2 UIKmlLuaControl
---@field close2 UIKmlLuaControl
---@field view1 UIKmlLuaControl
---@field gonggao UIKmlLuaControl
---@field kuang_1 UIKmlLuaControl
---@field select_view_1 UIKmlLuaControl
---@field select_view_1_btn UIKmlLuaControl
---@field select_view_1_scrol UIKmlLuaControl
---@field select_view_1_grid UIKmlLuaControl
---@field notice_data_list UIKmlLuaControl
---@field notice_text_1 UIKmlLuaControl
---@field right1 UIKmlLuaControl
---@field open1 UIKmlLuaControl
---@field close1 UIKmlLuaControl
local KLOpenStallPanelView = {}
setmetatable(KLOpenStallPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Panel/KLOpenStall/KLOpenStallPanelKml'
---@param parent UIKmlLuaControl
function KLOpenStallPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLOpenStallPanelView
