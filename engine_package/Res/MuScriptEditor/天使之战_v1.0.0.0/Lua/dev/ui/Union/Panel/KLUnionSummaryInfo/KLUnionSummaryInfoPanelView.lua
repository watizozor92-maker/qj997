---@class KLUnionSummaryInfoPanelView:UIKmlLuaViewBase
---@field img_70 UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field info_panel UIKmlLuaControlHandler
---@field flag_bg UIKmlLuaControlHandler
---@field flag_img UIKmlLuaControlHandler
---@field info_text_panel UIKmlLuaControlHandler
---@field name_bg UIKmlLuaControlHandler
---@field name_text UIKmlLuaControlHandler
---@field info_level_panel UIKmlLuaControlHandler
---@field exp_text UIKmlLuaControlHandler
---@field exp_text_value UIKmlLuaControlHandler
---@field info_num_panel UIKmlLuaControlHandler
---@field exp_num UIKmlLuaControlHandler
---@field exp_num_value UIKmlLuaControlHandler
---@field info_owner_panel UIKmlLuaControlHandler
---@field exp_owner UIKmlLuaControlHandler
---@field exp_owner_value UIKmlLuaControlHandler
---@field content_bg UIKmlLuaControlHandler
---@field panel_89 UIKmlLuaControlHandler
---@field content_bg_l UIKmlLuaControlHandler
---@field content_title UIKmlLuaControlHandler
---@field content_bg_r UIKmlLuaControlHandler
---@field union_content UIKmlLuaControlHandler
---@field Text_JoinCondition UIKmlLuaControlHandler
local KLUnionSummaryInfoPanelView = {}
setmetatable(KLUnionSummaryInfoPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Union/Panel/KLUnionSummaryInfo/KLUnionSummaryInfoPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionSummaryInfoPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUnionSummaryInfoPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Union/Panel/KLUnionSummaryInfo/KLUnionSummaryInfoPanel']

return KLUnionSummaryInfoPanelView
