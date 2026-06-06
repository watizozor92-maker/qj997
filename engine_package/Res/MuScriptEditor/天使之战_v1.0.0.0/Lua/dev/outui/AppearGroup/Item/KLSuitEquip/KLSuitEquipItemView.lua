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
return KLSuitEquipItemView
