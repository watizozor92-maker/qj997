---@class KLUIItemPreviewItemView:UIKmlLuaViewBase
---@field equip_item UIKmlLuaControl
---@field img_quality UIKmlLuaControl
---@field effect_root UIKmlLuaControl
---@field effect_model UIKmlLuaControl
---@field arrow UIKmlLuaControl
---@field btn UIKmlLuaControl
local KLUIItemPreviewItemView = {}
setmetatable(KLUIItemPreviewItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Tips/Item/KLUIItemPreviewItem/KLUIItemPreviewItemKml'
---@param parent UIKmlLuaControl
function KLUIItemPreviewItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIItemPreviewItemView
