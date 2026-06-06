---@class KLDepotsSelectItemView:UIKmlLuaViewBase
---@field Dot UIKmlLuaControlHandler
---@field DotRed UIKmlLuaControlHandler
---@field Button UIKmlLuaControlHandler
local KLDepotsSelectItemView = {}
setmetatable(KLDepotsSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Bag/Item/KLDepotsSelect/KLDepotsSelectItemKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLDepotsSelectItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLDepotsSelectItemView
