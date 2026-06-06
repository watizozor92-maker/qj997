---@class KLGrailItemView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControl
---@field xie_btn UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field scroll_text_template UIKmlLuaControl
---@field KmlScrollTextTemplate UIKmlLuaControl
---@field txt_item_name UIKmlLuaControl
---@field add UIKmlLuaControl
---@field select UIKmlLuaControl
---@field gray UIKmlLuaControl
---@field img_lock UIKmlLuaControl
---@field img_red UIKmlLuaControl
local KLGrailItemView = {}
setmetatable(KLGrailItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Item/KLGrail/KLGrailItemKml'
---@param parent UIKmlLuaControl
function KLGrailItemView:Init(parent)
    
    self:InitRoot(parent, kmlPath, KLGrailItemView.content)
end
return KLGrailItemView
