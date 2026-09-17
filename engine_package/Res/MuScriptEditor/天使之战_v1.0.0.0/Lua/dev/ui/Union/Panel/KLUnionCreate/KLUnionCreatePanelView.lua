---@class KLUnionCreatePanelView:UIKmlLuaViewBase
---@field img_55 UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field one_bg UIKmlLuaControlHandler
---@field info_panel UIKmlLuaControlHandler
---@field panel_59 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field text_60 UIKmlLuaControlHandler
---@field input_union_name UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field log_panel UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field text_63 UIKmlLuaControlHandler
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
---@field panel_84 UIKmlLuaControlHandler
---@field text_85 UIKmlLuaControlHandler
---@field cost_bg UIKmlLuaControlHandler
---@field cost_item_id UIKmlLuaControlHandler
---@field cost_item_count UIKmlLuaControlHandler
---@field panel_btn UIKmlLuaControlHandler
---@field cancle_btn UIKmlLuaControlHandler
---@field btn_text UIKmlLuaControlHandler
---@field enter_btn UIKmlLuaControlHandler
---@field btn_text UIKmlLuaControlHandler
local KLUnionCreatePanelView = {}
setmetatable(KLUnionCreatePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Union/Panel/KLUnionCreate/KLUnionCreatePanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionCreatePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionCreatePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Union/Panel/KLUnionCreate/KLUnionCreatePanel']

return KLUnionCreatePanelView
