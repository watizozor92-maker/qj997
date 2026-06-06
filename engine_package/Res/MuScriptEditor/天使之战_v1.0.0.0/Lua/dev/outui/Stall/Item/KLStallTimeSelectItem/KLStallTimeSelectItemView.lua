---@class KLStallTimeSelectItemView:UIKmlLuaViewBase
---@field select UIKmlLuaControl
---@field name UIKmlLuaControl
local KLStallTimeSelectItemView = {}
setmetatable(KLStallTimeSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLStallTimeSelectItem/KLStallTimeSelectItemKml'
---@param parent UIKmlLuaControl
function KLStallTimeSelectItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLStallTimeSelectItemView
