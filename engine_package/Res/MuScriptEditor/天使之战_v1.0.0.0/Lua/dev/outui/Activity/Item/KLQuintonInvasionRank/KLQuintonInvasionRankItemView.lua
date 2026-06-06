---@class KLQuintonInvasionRankItemView:UIKmlLuaViewBase
---@field pointCount UIKmlLuaControl
---@field name UIKmlLuaControl
---@field numberIcon UIKmlLuaControl
---@field unionName UIKmlLuaControl
local KLQuintonInvasionRankItemView = {}
setmetatable(KLQuintonInvasionRankItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLQuintonInvasionRank/KLQuintonInvasionRankItemKml'
---@param parent UIKmlLuaControl
function KLQuintonInvasionRankItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end 
return KLQuintonInvasionRankItemView
