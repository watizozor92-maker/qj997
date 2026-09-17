---@class KLUIItemPreviewItemView:UIKmlLuaViewBase
---@field equip_item UIKmlLuaControlHandler
---@field img_quality UIKmlLuaControlHandler
---@field count_attach UIKmlLuaControlHandler
---@field effect_root UIKmlLuaControlHandler
---@field effect_model UIKmlLuaControlHandler
---@field arrow UIKmlLuaControlHandler
---@field btn UIKmlLuaControlHandler
local KLUIItemPreviewItemView = {}
setmetatable(KLUIItemPreviewItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Tips/Item/KLUIItemPreviewItem/KLUIItemPreviewItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIItemPreviewItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIItemPreviewItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Tips/Item/KLUIItemPreviewItem/KLUIItemPreviewItem']

return KLUIItemPreviewItemView
