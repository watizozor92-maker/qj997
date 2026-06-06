---@class KLMonsterMapPointPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field bgImg UIKmlLuaControl
---@field closeBtn_3 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field loopscrollview UIKmlLuaControl
---@field loopscrollviewData UIKmlLuaControl
---@field MonsterName UIKmlLuaControl
---@field closeBtn_2 UIKmlLuaControl
---@field closeBtn UIKmlLuaControl
local KLMonsterMapPointPanelView = {}
setmetatable(KLMonsterMapPointPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Monster/Panel/KLMonsterMapPoint/KLMonsterMapPointPanelKml'
---@param parent UIKmlLuaControl
function KLMonsterMapPointPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMonsterMapPointPanelView
