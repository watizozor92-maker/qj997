---@class KLMapHookPointItemView:UIKmlLuaViewBase
---@field btnPos UIKmlLuaControlHandler
---@field txtIndex UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field txtPos UIKmlLuaControlHandler
local KLMapHookPointItemView = {}
setmetatable(KLMapHookPointItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Item/KLMapHookPoint/KLMapHookPointItemKml'
---@param parent UIKmlLuaControlHandler
function KLMapHookPointItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMapHookPointItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Item/KLMapHookPoint/KLMapHookPointItem']

return KLMapHookPointItemView
