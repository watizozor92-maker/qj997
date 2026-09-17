---@class KLGrailItemView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field xie_btn UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field scroll_text_template UIKmlLuaControlHandler
---@field KmlScrollTextTemplate UIKmlLuaControlHandler
---@field txt_item_name UIKmlLuaControlHandler
---@field add UIKmlLuaControlHandler
---@field select UIKmlLuaControlHandler
---@field gray UIKmlLuaControlHandler
---@field img_lock UIKmlLuaControlHandler
---@field img_red UIKmlLuaControlHandler
local KLGrailItemView = {}
setmetatable(KLGrailItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Item/KLGrail/KLGrailItemKml'
---@param parent UIKmlLuaControlHandler
function KLGrailItemView:Init(parent)
    
    self:InitRoot(parent, kmlPath, KLGrailItemView.content)
end
---@type KLGrailItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Item/KLGrail/KLGrailItem']

return KLGrailItemView
