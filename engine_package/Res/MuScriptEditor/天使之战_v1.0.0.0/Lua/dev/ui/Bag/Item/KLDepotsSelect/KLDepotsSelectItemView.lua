---@class KLDepotsSelectItemView:UIKmlLuaViewBase
---@field Dot UIKmlLuaControlHandler
---@field DotRed UIKmlLuaControlHandler
---@field Button UIKmlLuaControlHandler
local KLDepotsSelectItemView = {}
setmetatable(KLDepotsSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Bag/Item/KLDepotsSelect/KLDepotsSelectItemKml'
---@param parent UIKmlLuaControlHandler
function KLDepotsSelectItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLDepotsSelectItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Bag/Item/KLDepotsSelect/KLDepotsSelectItem']

return KLDepotsSelectItemView
