---@class KLHookPointMapItemView:UIKmlLuaViewBase
---@field btnItem UIKmlLuaControlHandler
---@field btnItem2 UIKmlLuaControlHandler
---@field noClick UIKmlLuaControlHandler
---@field imgRecommend UIKmlLuaControlHandler
---@field txtMapName UIKmlLuaControlHandler
---@field txtLevel UIKmlLuaControlHandler
local KLHookPointMapItemView = {}
setmetatable(KLHookPointMapItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Item/KLHookPointMap/KLHookPointMapItemKml'
---@param parent UIKmlLuaControlHandler
function KLHookPointMapItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLHookPointMapItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Item/KLHookPointMap/KLHookPointMapItem']

return KLHookPointMapItemView
