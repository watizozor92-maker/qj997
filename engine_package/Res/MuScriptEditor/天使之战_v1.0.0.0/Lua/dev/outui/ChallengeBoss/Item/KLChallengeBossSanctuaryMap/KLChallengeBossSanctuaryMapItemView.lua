---@class KLChallengeBossSanctuaryMapItemView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field textMapName UIKmlLuaControlHandler
---@field textLevel UIKmlLuaControlHandler
---@field btnSelect UIKmlLuaControlHandler
---@field select UIKmlLuaControlHandler
local KLChallengeBossSanctuaryMapItemView = {}
setmetatable(KLChallengeBossSanctuaryMapItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLChallengeBossSanctuaryMap/KLChallengeBossSanctuaryMapItemKml'
---@param parent UIKmlLuaControlHandler
function KLChallengeBossSanctuaryMapItemView:Init(parent) 
    self:InitRoot(parent,kmlPath)
end
---@type KLChallengeBossSanctuaryMapItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLChallengeBossSanctuaryMap/KLChallengeBossSanctuaryMapItem']

return KLChallengeBossSanctuaryMapItemView
