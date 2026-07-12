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
---@type KLMasterTalentIconItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/MasterTalent/Item/KLMasterTalentIcon/KLMasterTalentIconItem']

return KLMasterTalentIconItemView
