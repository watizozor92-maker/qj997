---@class KLUISanctuaryBossItemView:UIKmlLuaViewBase
local KLUISanctuaryBossItemView = {}
setmetatable(KLUISanctuaryBossItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUISanctuaryBoss/KLUISanctuaryBossItemKml'
---@param parent UIKmlLuaControl
function KLUISanctuaryBossItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUISanctuaryBossItemView
