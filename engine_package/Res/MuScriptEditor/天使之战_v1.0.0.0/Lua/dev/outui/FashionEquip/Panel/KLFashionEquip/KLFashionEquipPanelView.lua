---@class KLFashionEquipPanelView:UIKmlLuaViewBase
local KLFashionEquipPanelView = {}
setmetatable(KLFashionEquipPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FashionEquip/Panel/KLFashionEquip/KLFashionEquipPanelKml'
---@param parent UIKmlLuaControlHandler
function KLFashionEquipPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLFashionEquipPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/FashionEquip/Panel/KLFashionEquip/KLFashionEquipPanel']

return KLFashionEquipPanelView
