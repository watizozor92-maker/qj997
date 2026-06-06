---@class KLStallCitySelectItemView:UIKmlLuaViewBase
---@field select UIKmlLuaControl
---@field name UIKmlLuaControl
local KLStallCitySelectItemView = {}
setmetatable(KLStallCitySelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLStallCitySelectItem/KLStallCitySelectItemKml'
---@param parent UIKmlLuaControl
function KLStallCitySelectItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLStallCitySelectItemView
