---@class KLChallengeBossSanctuaryMapPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field mask UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field btnClose UIKmlLuaControlHandler
---@field textTitle UIKmlLuaControlHandler
---@field scrollview5 UIKmlLuaControlHandler
---@field gridview6 UIKmlLuaControlHandler
---@field dataList UIKmlLuaControlHandler
---@field btnEnter UIKmlLuaControlHandler
local KLChallengeBossSanctuaryMapPanelView = {}
setmetatable(KLChallengeBossSanctuaryMapPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLChallengeBossSanctuaryMap/KLChallengeBossSanctuaryMapPanelKml'
---@param parent UIKmlLuaControlHandler
function KLChallengeBossSanctuaryMapPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
    
end
---@type KLChallengeBossSanctuaryMapPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Panel/KLChallengeBossSanctuaryMap/KLChallengeBossSanctuaryMapPanel']

return KLChallengeBossSanctuaryMapPanelView
