---@class KLChallengeBossSanctuaryMapItemView:UIKmlLuaViewBase
---@field root UIKmlLuaControl
---@field textMapName UIKmlLuaControl
---@field textLevel UIKmlLuaControl
---@field btnSelect UIKmlLuaControl
---@field select UIKmlLuaControl
local KLChallengeBossSanctuaryMapItemView = {}
setmetatable(KLChallengeBossSanctuaryMapItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLChallengeBossSanctuaryMap/KLChallengeBossSanctuaryMapItemKml'
---@param parent UIKmlLuaControl
function KLChallengeBossSanctuaryMapItemView:Init(parent) 
    self:InitRoot(parent,kmlPath)
end
return KLChallengeBossSanctuaryMapItemView
