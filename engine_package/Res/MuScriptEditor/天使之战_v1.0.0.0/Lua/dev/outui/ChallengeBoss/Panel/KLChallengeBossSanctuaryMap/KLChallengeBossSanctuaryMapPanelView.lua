---@class KLChallengeBossSanctuaryMapPanelView:UIKmlLuaViewBase
---@field root UIKmlLuaControl
---@field mask UIKmlLuaControl
---@field bg UIKmlLuaControl
---@field btnClose UIKmlLuaControl
---@field textTitle UIKmlLuaControl
---@field scrollview5 UIKmlLuaControl
---@field gridview6 UIKmlLuaControl
---@field dataList UIKmlLuaControl
---@field btnEnter UIKmlLuaControl
local KLChallengeBossSanctuaryMapPanelView = {}
setmetatable(KLChallengeBossSanctuaryMapPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLChallengeBossSanctuaryMap/KLChallengeBossSanctuaryMapPanelKml'
---@param parent UIKmlLuaControl
function KLChallengeBossSanctuaryMapPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
    
end
return KLChallengeBossSanctuaryMapPanelView
