---@class KLTalentItemView:UIKmlLuaViewBase
---@field layout1 UIKmlLuaControlHandler
---@field talent_data UIKmlLuaControlHandler
local KLTalentItemView = {}
setmetatable(KLTalentItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Archangel/Item/KLTalent/KLTalentItemKml'
---@param parent UIKmlLuaControlHandler
function KLTalentItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTalentItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Archangel/Item/KLTalent/KLTalentItem']

return KLTalentItemView
