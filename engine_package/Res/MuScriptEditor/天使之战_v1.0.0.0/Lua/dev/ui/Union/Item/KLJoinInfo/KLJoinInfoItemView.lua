---@class KLJoinInfoItemView:UIKmlLuaViewBase
---@field datalist_panel_ UIKmlLuaControlHandler
---@field union_choice_bg_ UIKmlLuaControlHandler
---@field datalist_panel_btn_ UIKmlLuaControlHandler
---@field union_name UIKmlLuaControlHandler
---@field union_level UIKmlLuaControlHandler
---@field union_num UIKmlLuaControlHandler
---@field apply_to_join UIKmlLuaControlHandler
---@field btn_grey_bg UIKmlLuaControlHandler
---@field btn_text UIKmlLuaControlHandler
local KLJoinInfoItemView = {}
setmetatable(KLJoinInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Union/Item/KLJoinInfo/KLJoinInfoItemKml'
---@param parent UIKmlLuaControlHandler
function KLJoinInfoItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLJoinInfoItemView
