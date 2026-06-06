---@class KLMapOtherPointItemView:UIKmlLuaViewBase
---@field icon UIKmlLuaControlHandler
---@field txt_name UIKmlLuaControlHandler
local KLMapOtherPointItemView = {}
setmetatable(KLMapOtherPointItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Map/Item/KLMapOtherPoint/KLMapOtherPointItemKml'
---@param parent UIKmlLuaControlHandler
function KLMapOtherPointItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMapOtherPointItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Map/Item/KLMapOtherPoint/KLMapOtherPointItem']

return KLMapOtherPointItemView
