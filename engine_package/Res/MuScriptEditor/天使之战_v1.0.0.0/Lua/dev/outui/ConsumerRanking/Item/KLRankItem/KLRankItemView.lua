---@class KLRankItemView:UIKmlLuaViewBase
local KLRankItemView = {}
setmetatable(KLRankItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ConsumerRanking/Item/KLRankItem/KLRankItemKml'
---@param parent UIKmlLuaControl
function KLRankItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLRankItemView
