---@class KLUnionModifyFlagPanelView:UIKmlLuaViewBase
---@field img_12 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field info_panel UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field panel_16 UIKmlLuaControlHandler
---@field text_17 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field input_union_name UIKmlLuaControlHandler
---@field log_panel UIKmlLuaControlHandler
---@field text_20 UIKmlLuaControlHandler
---@field union_log_bg UIKmlLuaControlHandler
---@field union_log UIKmlLuaControlHandler
---@field desc_text UIKmlLuaControlHandler
---@field desc_text UIKmlLuaControlHandler
---@field log_list_panel UIKmlLuaControlHandler
---@field log_list_bg1 UIKmlLuaControlHandler
---@field union_log1 UIKmlLuaControlHandler
---@field union_log1_select UIKmlLuaControlHandler
---@field log_list_bg2 UIKmlLuaControlHandler
---@field union_log2 UIKmlLuaControlHandler
---@field union_log2_select UIKmlLuaControlHandler
---@field log_list_bg3 UIKmlLuaControlHandler
---@field union_log3 UIKmlLuaControlHandler
---@field union_log3_select UIKmlLuaControlHandler
---@field log_list_bg4 UIKmlLuaControlHandler
---@field union_log4 UIKmlLuaControlHandler
---@field union_log4_select UIKmlLuaControlHandler
---@field log_list_bg5 UIKmlLuaControlHandler
---@field union_log5 UIKmlLuaControlHandler
---@field union_log5_select UIKmlLuaControlHandler
---@field panel_31 UIKmlLuaControlHandler
---@field text_32 UIKmlLuaControlHandler
---@field cost_bg UIKmlLuaControlHandler
---@field cost_item_id UIKmlLuaControlHandler
---@field cost_item_count UIKmlLuaControlHandler
---@field panel_btn UIKmlLuaControlHandler
---@field cancle_btn UIKmlLuaControlHandler
---@field btn_text UIKmlLuaControlHandler
---@field enter_btn UIKmlLuaControlHandler
---@field btn_text UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
local KLUnionModifyFlagPanelView = {}
setmetatable(KLUnionModifyFlagPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Union/Panel/KLUnionModifyFlag/KLUnionModifyFlagPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionModifyFlagPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUnionModifyFlagPanelView
