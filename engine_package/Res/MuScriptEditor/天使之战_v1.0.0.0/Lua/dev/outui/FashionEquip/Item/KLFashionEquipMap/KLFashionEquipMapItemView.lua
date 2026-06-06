---@class KLFashionEquipMapItemView:UIKmlLuaViewBase
---@field itemBg UIKmlLuaControl
---@field txt_title UIKmlLuaControl
---@field img4 UIKmlLuaControl
---@field layout2 UIKmlLuaControl
---@field datalist3 UIKmlLuaControl
local KLFashionEquipMapItemView = {}
setmetatable(KLFashionEquipMapItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FashionEquip/Item/KLFashionEquipMap/KLFashionEquipMapItemKml'
---@param parent UIKmlLuaControl
function KLFashionEquipMapItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLFashionEquipMapItemView
