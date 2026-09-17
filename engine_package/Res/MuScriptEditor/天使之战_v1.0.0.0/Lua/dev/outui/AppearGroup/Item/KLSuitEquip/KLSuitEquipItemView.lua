---@class KLSuitEquipItemView:UIKmlLuaViewBase
---@field BtnEquip UIKmlLuaControlHandler
---@field EquipItem UIKmlLuaControlHandler
---@field img_quality UIKmlLuaControlHandler
---@field topPanel UIKmlLuaControlHandler
---@field SpMask UIKmlLuaControlHandler
---@field SpLock UIKmlLuaControlHandler
---@field SpState UIKmlLuaControlHandler
---@field SpState2 UIKmlLuaControlHandler
local KLSuitEquipItemView = {}
setmetatable(KLSuitEquipItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Item/KLSuitEquip/KLSuitEquipItemKml'
---@param parent UIKmlLuaControlHandler
function KLSuitEquipItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLSuitEquipItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/AppearGroup/Item/KLSuitEquip/KLSuitEquipItem']

return KLSuitEquipItemView
