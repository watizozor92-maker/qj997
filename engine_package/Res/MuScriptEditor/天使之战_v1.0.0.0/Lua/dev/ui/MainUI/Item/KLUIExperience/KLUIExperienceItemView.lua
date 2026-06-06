---@class KLUIExperienceItemView:UIKmlLuaViewBase
---@field experience_item_bg1 UIKmlLuaControl
---@field addBtn UIKmlLuaControl
---@field experienceName UIKmlLuaControl
---@field experienceTxt UIKmlLuaControl
---@field time UIKmlLuaControl
local KLUISystemRightTemplateItemView = {}
setmetatable(KLUISystemRightTemplateItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/MainUI/Item/KLUIExperience/KLUIExperienceItemKml'
KLUISystemRightTemplateItemView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath,nil,'.txt')
---@param parent UIKmlLuaControl
function KLUISystemRightTemplateItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath,KLUISystemRightTemplateItemView.content)
end
return KLUISystemRightTemplateItemView
