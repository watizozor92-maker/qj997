---@class KLFashionEquipMapItemView:UIKmlLuaViewBase
---@field itemBg UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field datalist3 UIKmlLuaControlHandler
local KLFashionEquipMapItemView = {}
setmetatable(KLFashionEquipMapItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FashionEquip/Item/KLFashionEquipMap/KLFashionEquipMapItemKml'
---@param parent UIKmlLuaControlHandler
function KLFashionEquipMapItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLFashionEquipMapItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/FashionEquip/Item/KLFashionEquipMap/KLFashionEquipMapItem']

return KLFashionEquipMapItemView
