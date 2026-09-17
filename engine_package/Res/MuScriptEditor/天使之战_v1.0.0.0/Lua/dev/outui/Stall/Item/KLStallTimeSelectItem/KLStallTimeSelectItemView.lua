---@class KLStallTimeSelectItemView:UIKmlLuaViewBase
---@field select UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
local KLStallTimeSelectItemView = {}
setmetatable(KLStallTimeSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLStallTimeSelectItem/KLStallTimeSelectItemKml'
---@param parent UIKmlLuaControlHandler
function KLStallTimeSelectItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLStallTimeSelectItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Stall/Item/KLStallTimeSelectItem/KLStallTimeSelectItem']

return KLStallTimeSelectItemView
