---@class KLAppearEquipItemView:UIKmlLuaViewBase
---@field BtnEquip UIKmlLuaControlHandler
---@field EquipItem UIKmlLuaControlHandler
---@field img_quality UIKmlLuaControlHandler
---@field strengthLevel UIKmlLuaControlHandler
---@field appendLevel UIKmlLuaControlHandler
---@field SpState UIKmlLuaControlHandler
---@field SpState2 UIKmlLuaControlHandler
local KLAppearEquipItemView = {}
setmetatable(KLAppearEquipItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Item/KLAppearEquip/KLAppearEquipItemKml'
---@param parent UIKmlLuaControlHandler
function KLAppearEquipItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLAppearEquipItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/AppearGroup/Item/KLAppearEquip/KLAppearEquipItem']

return KLAppearEquipItemView
