---@class KLQuintonInvasionRankItemView:UIKmlLuaViewBase
---@field pointCount UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field numberIcon UIKmlLuaControlHandler
local KLQuintonInvasionRankItemView = {}
setmetatable(KLQuintonInvasionRankItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLQuintonInvasionRank/KLQuintonInvasionRankItemKml'
---@param parent UIKmlLuaControlHandler
function KLQuintonInvasionRankItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end 
---@type KLQuintonInvasionRankItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLQuintonInvasionRank/KLQuintonInvasionRankItem']

return KLQuintonInvasionRankItemView
