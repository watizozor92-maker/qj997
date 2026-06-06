---@class KLActivityPreviewItemView:UIKmlLuaViewBase
---@field root UIKmlLuaControl
---@field Bg UIKmlLuaControl
---@field activityName UIKmlLuaControl
---@field textTime UIKmlLuaControl
---@field btnGoNpc UIKmlLuaControl
local KLActivityPreviewItemView = {}
setmetatable(KLActivityPreviewItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLActivityPreview/KLActivityPreviewItemKml'
---@param parent UIKmlLuaControl
function KLActivityPreviewItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLActivityPreviewItemView
