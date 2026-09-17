---@class KLUnionApplyListPanelView:UIKmlLuaViewBase
---@field prefab_55 UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field lab_name UIKmlLuaControlHandler
---@field lab_level UIKmlLuaControlHandler
---@field mask UIKmlLuaControlHandler
---@field btn_allAgree UIKmlLuaControlHandler
---@field text_allAgree UIKmlLuaControlHandler
---@field btn_allRefuse UIKmlLuaControlHandler
---@field text_allRefuse UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field table_list UIKmlLuaControlHandler
---@field table_list UIKmlLuaControlHandler
---@field union_list_view UIKmlLuaControlHandler
---@field union_data_list UIKmlLuaControlHandler
---@field lab_operation UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field lab_occupation UIKmlLuaControlHandler
---@field img_bg UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img_list UIKmlLuaControlHandler
---@field InputField_level UIKmlLuaControlHandler
---@field lab_levelEquire UIKmlLuaControlHandler
---@field AutoPass UIKmlLuaControlHandler
---@field AutoLabel UIKmlLuaControlHandler
---@field AutoPassBackground UIKmlLuaControlHandler
---@field AutoPassCheckmark UIKmlLuaControlHandler
---@field applylist_title UIKmlLuaControlHandler
---@field img_bgBg UIKmlLuaControlHandler
---@field img_title UIKmlLuaControlHandler
---@field Text_NoApplyTips UIKmlLuaControlHandler
local KLUnionApplyListPanelView = {}
setmetatable(KLUnionApplyListPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Union/Panel/KLUnionApplyList/KLUnionApplyListPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUnionApplyListPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLUnionApplyListPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Union/Panel/KLUnionApplyList/KLUnionApplyListPanel']

return KLUnionApplyListPanelView
