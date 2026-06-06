---@class KLEquipQualityEntryItemView:UIKmlLuaViewBase
---@field imgQuality UIKmlLuaControlHandler
local KLEquipQualityEntryItemView = {}
setmetatable(KLEquipQualityEntryItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItemKml'
---@param parent UIKmlLuaControlHandler
function KLEquipQualityEntryItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLEquipQualityEntryItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Common/Item/KLEquipQualityEntry/KLEquipQualityEntryItem']

return KLEquipQualityEntryItemView
