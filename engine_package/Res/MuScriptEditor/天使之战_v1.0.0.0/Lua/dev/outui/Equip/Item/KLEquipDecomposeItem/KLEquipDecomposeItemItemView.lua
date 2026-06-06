---@class KLEquipDecomposeItemItemView:UIKmlLuaViewBase
---@field EquipItem UIKmlLuaControlHandler
---@field EquipItem_Quality UIKmlLuaControlHandler
local KLEquipDecomposeItemItemView = {}
setmetatable(KLEquipDecomposeItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Equip/Item/KLEquipDecomposeItem/KLEquipDecomposeItemItemKml'
---@param parent UIKmlLuaControlHandler
function KLEquipDecomposeItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipDecomposeItemItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Equip/Item/KLEquipDecomposeItem/KLEquipDecomposeItemItem']

return KLEquipDecomposeItemItemView
