---@class KLJoinInfoItemView:UIKmlLuaViewBase
---@field datalist_panel_ UIKmlLuaControlHandler
---@field union_choice_bg_ UIKmlLuaControlHandler
---@field datalist_panel_btn_ UIKmlLuaControlHandler
---@field apply_to_join UIKmlLuaControlHandler
---@field btn_grey_bg UIKmlLuaControlHandler
---@field btn_text UIKmlLuaControlHandler
---@field union_name UIKmlLuaControlHandler
---@field union_level UIKmlLuaControlHandler
---@field union_num UIKmlLuaControlHandler
local KLJoinInfoItemView = {}
setmetatable(KLJoinInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Union/Item/KLJoinInfo/KLJoinInfoItemKml'
---@param parent UIKmlLuaControlHandler
function KLJoinInfoItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLJoinInfoItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Union/Item/KLJoinInfo/KLJoinInfoItem']

return KLJoinInfoItemView
