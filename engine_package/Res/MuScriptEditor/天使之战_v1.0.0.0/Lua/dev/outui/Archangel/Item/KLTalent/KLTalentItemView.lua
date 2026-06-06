---@class KLTalentItemView:UIKmlLuaViewBase
---@field layout1 UIKmlLuaControl
---@field talent_data UIKmlLuaControl
local KLTalentItemView = {}
setmetatable(KLTalentItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Item/KLTalent/KLTalentItemKml'
---@param parent UIKmlLuaControl
function KLTalentItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTalentItemView
