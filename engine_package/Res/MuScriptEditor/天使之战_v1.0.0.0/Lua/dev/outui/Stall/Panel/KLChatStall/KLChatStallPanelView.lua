---@class KLChatStallPanelView:UIKmlLuaViewBase
---@field mask UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field pos_text UIKmlLuaControlHandler
---@field costimg UIKmlLuaControlHandler
---@field cost_item UIKmlLuaControlHandler
---@field cost_text UIKmlLuaControlHandler
---@field btn_send UIKmlLuaControlHandler
---@field view3 UIKmlLuaControlHandler
---@field chengshi UIKmlLuaControlHandler
---@field kuang_3 UIKmlLuaControlHandler
---@field select_view_3 UIKmlLuaControlHandler
---@field select_view_3_scrol UIKmlLuaControlHandler
---@field select_view_3_grid UIKmlLuaControlHandler
---@field data_list_3 UIKmlLuaControlHandler
---@field notice_text_3 UIKmlLuaControlHandler
---@field last_num UIKmlLuaControlHandler
---@field right3 UIKmlLuaControlHandler
---@field open3 UIKmlLuaControlHandler
---@field close3 UIKmlLuaControlHandler
---@field view2 UIKmlLuaControlHandler
---@field chengshi UIKmlLuaControlHandler
---@field kuang_2 UIKmlLuaControlHandler
---@field select_view_2 UIKmlLuaControlHandler
---@field select_view_2_scrol UIKmlLuaControlHandler
---@field select_view_2_grid UIKmlLuaControlHandler
---@field data_list_2 UIKmlLuaControlHandler
---@field notice_text_2 UIKmlLuaControlHandler
---@field last_num UIKmlLuaControlHandler
---@field right2 UIKmlLuaControlHandler
---@field open2 UIKmlLuaControlHandler
---@field close2 UIKmlLuaControlHandler
---@field view1 UIKmlLuaControlHandler
---@field chengshi UIKmlLuaControlHandler
---@field kuang_1 UIKmlLuaControlHandler
---@field select_view_1 UIKmlLuaControlHandler
---@field select_view_1_scrol UIKmlLuaControlHandler
---@field select_view_1_grid UIKmlLuaControlHandler
---@field data_list_1 UIKmlLuaControlHandler
---@field notice_text_1 UIKmlLuaControlHandler
---@field last_num UIKmlLuaControlHandler
---@field right1 UIKmlLuaControlHandler
---@field open1 UIKmlLuaControlHandler
---@field close1 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLChatStallPanelView = {}
setmetatable(KLChatStallPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Panel/KLChatStall/KLChatStallPanelKml'
---@param parent UIKmlLuaControlHandler
function KLChatStallPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLChatStallPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Stall/Panel/KLChatStall/KLChatStallPanel']

return KLChatStallPanelView
