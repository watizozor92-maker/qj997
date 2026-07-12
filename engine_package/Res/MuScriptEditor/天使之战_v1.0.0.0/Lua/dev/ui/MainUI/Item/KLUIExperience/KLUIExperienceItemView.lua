---@class KLUIExperienceItemView:UIKmlLuaViewBase
---@field experience_item_bg1 UIKmlLuaControlHandler
---@field addBtn UIKmlLuaControlHandler
---@field experienceName UIKmlLuaControlHandler
---@field experienceTxt UIKmlLuaControlHandler
---@field time UIKmlLuaControlHandler
local KLUISystemRightTemplateItemView = {}
setmetatable(KLUISystemRightTemplateItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Item/KLUIExperience/KLUIExperienceItemKml'
KLUISystemRightTemplateItemView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath,nil,'.txt')
---@param parent UIKmlLuaControlHandler
function KLUISystemRightTemplateItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath,KLUISystemRightTemplateItemView.content)
end
---@type KLUIExperienceItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/MainUI/Item/KLUIExperience/KLUIExperienceItem']

return KLUISystemRightTemplateItemView
