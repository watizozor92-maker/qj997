---@class KLStallCitySelectItemView:UIKmlLuaViewBase
---@field select UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
local KLStallCitySelectItemView = {}
setmetatable(KLStallCitySelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLStallCitySelectItem/KLStallCitySelectItemKml'
---@param parent UIKmlLuaControlHandler
function KLStallCitySelectItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLStallCitySelectItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Stall/Item/KLStallCitySelectItem/KLStallCitySelectItem']

return KLStallCitySelectItemView
