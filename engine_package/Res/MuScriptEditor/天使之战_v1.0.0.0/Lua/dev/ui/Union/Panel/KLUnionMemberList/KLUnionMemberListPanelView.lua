---@class KLUnionMemberListPanelView:UIKmlLuaViewBase
---@field img_12 UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field table_title_bg UIKmlLuaControlHandler
---@field title_name UIKmlLuaControlHandler
---@field title_level UIKmlLuaControlHandler
---@field text_18 UIKmlLuaControlHandler
---@field level_sort_up UIKmlLuaControlHandler
---@field level_sort_up_black UIKmlLuaControlHandler
---@field level_sort_down UIKmlLuaControlHandler
---@field level_sort_down_black UIKmlLuaControlHandler
---@field title_position UIKmlLuaControlHandler
---@field text_24 UIKmlLuaControlHandler
---@field position_sort_up UIKmlLuaControlHandler
---@field position_sort_up_black UIKmlLuaControlHandler
---@field position_sort_down UIKmlLuaControlHandler
---@field position_sort_down_black UIKmlLuaControlHandler
---@field title_state UIKmlLuaControlHandler
---@field text_30 UIKmlLuaControlHandler
---@field state_sort_up UIKmlLuaControlHandler
---@field state_sort_up_black UIKmlLuaControlHandler
---@field state_sort_down UIKmlLuaControlHandler
---@field state_sort_down_black UIKmlLuaControlHandler
---@field table_panel UIKmlLuaControlHandler
---@field table_list UIKmlLuaControlHandler
---@field union_list_view UIKmlLuaControlHandler
---@field union_data_list UIKmlLuaControlHandler
---@field shen_he UIKmlLuaControlHandler
---@field btn_text UIKmlLuaControlHandler
---@field shen_heTip UIKmlLuaControlHandler
---@field tips UIKmlLuaControlHandler
---@field on_line_tips UIKmlLuaControlHandler
local KLUnionMemberListPanelView = {}
setmetatable(KLUnionMemberListPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionMemberListPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionMemberListPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Union/Panel/KLUnionMemberList/KLUnionMemberListPanel']

return KLUnionMemberListPanelView
