---@class KLQuestionnairePanelView:UIKmlLuaViewBase
local KLQuestionnairePanelView = {}
setmetatable(KLQuestionnairePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/DailyRaffle/Panel/KLQuestionnaire/KLQuestionnairePanelKml'
---@param parent UIKmlLuaControl
function KLQuestionnairePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLQuestionnairePanelView
