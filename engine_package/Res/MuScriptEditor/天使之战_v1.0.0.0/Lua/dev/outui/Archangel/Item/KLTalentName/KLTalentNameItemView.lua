---@class KLTalentNameItemView:UIKmlLuaViewBase
---@field name_bg UIKmlLuaControl
---@field talent_icon UIKmlLuaControl
---@field talent_name UIKmlLuaControl
---@field select UIKmlLuaControl
local KLTalentNameItemView = {}
setmetatable(KLTalentNameItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Item/KLTalentName/KLTalentNameItemKml'
---@param parent UIKmlLuaControl
function KLTalentNameItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTalentNameItemView
