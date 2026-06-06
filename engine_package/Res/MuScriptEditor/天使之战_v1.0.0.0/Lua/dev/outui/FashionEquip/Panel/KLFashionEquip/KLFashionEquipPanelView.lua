---@class KLFashionEquipPanelView:UIKmlLuaViewBase
local KLFashionEquipPanelView = {}
setmetatable(KLFashionEquipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FashionEquip/Panel/KLFashionEquip/KLFashionEquipPanelKml'
---@param parent UIKmlLuaControl
function KLFashionEquipPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLFashionEquipPanelView
