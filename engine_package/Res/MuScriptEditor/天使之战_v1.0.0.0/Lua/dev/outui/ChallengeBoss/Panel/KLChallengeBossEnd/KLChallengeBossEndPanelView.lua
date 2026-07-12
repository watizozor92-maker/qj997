---@class KLChallengeBossEndPanelView:UIKmlLuaViewBase
---@field end_time UIKmlLuaControlHandler
local KLChallengeBossEndPanelView = {}
setmetatable(KLChallengeBossEndPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLChallengeBossEnd/KLChallengeBossEndPanelKml'
---@param parent UIKmlLuaControlHandler
function KLChallengeBossEndPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLChallengeBossEndPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Panel/KLChallengeBossEnd/KLChallengeBossEndPanel']

return KLChallengeBossEndPanelView
