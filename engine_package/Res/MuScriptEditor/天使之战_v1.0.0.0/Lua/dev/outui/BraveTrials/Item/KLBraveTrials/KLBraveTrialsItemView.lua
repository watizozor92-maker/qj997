---@class KLBraveTrialsItemView:UIKmlLuaViewBase
local KLBraveTrialsItemView = {}
setmetatable(KLBraveTrialsItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/BraveTrials/Item/KLBraveTrials/KLBraveTrialsItemKml'
---@param parent UIKmlLuaControl
function KLBraveTrialsItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLBraveTrialsItemView
