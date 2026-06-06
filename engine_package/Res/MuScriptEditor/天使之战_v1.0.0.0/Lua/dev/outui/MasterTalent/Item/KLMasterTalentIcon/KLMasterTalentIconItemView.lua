---@class KLMasterTalentIconItemView:UIKmlLuaViewBase
---@field icon UIKmlLuaControlHandler
---@field info UIKmlLuaControlHandler
---@field mask UIKmlLuaControlHandler
---@field lock UIKmlLuaControlHandler
---@field click UIKmlLuaControlHandler
local KLMasterTalentIconItemView = {}
setmetatable(KLMasterTalentIconItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/MasterTalent/Item/KLMasterTalentIcon/KLMasterTalentIconItemKml'
---@param parent UIKmlLuaControlHandler
function KLMasterTalentIconItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLMasterTalentIconItemView
