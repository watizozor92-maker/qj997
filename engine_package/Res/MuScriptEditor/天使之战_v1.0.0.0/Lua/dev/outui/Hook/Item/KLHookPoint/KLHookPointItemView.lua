---@class KLHookPointItemView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field mapScroll UIKmlLuaControlHandler
---@field mapDataList UIKmlLuaControlHandler
---@field scrollview2 UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
local KLHookPointItemView = {}
setmetatable(KLHookPointItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Item/KLHookPoint/KLHookPointItemKml'
---@param parent UIKmlLuaControlHandler
function KLHookPointItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLHookPointItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Item/KLHookPoint/KLHookPointItem']

return KLHookPointItemView
