---@class KLResetPointItemView:UIKmlLuaViewBase
---@field MaskBtn UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field img_679 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field layout_681 UIKmlLuaControlHandler
---@field text_682 UIKmlLuaControlHandler
---@field cost_item UIKmlLuaControlHandler
---@field item_click_img UIKmlLuaControlHandler
---@field layout_684 UIKmlLuaControlHandler
---@field common_lf_btn UIKmlLuaControlHandler
---@field common_rt_btn UIKmlLuaControlHandler
local KLResetPointItemView = {}
setmetatable(KLResetPointItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Role/Item/KLResetPoint/KLResetPointItemKml'
---@param parent UIKmlLuaControlHandler
function KLResetPointItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLResetPointItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Role/Item/KLResetPoint/KLResetPointItem']

return KLResetPointItemView
