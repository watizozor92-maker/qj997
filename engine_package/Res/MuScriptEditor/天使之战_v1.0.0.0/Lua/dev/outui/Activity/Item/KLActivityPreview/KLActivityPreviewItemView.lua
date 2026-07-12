---@class KLActivityPreviewItemView:UIKmlLuaViewBase
---@field root UIKmlLuaControlHandler
---@field Bg UIKmlLuaControlHandler
---@field activityName UIKmlLuaControlHandler
---@field textTime UIKmlLuaControlHandler
---@field btnGoNpc UIKmlLuaControlHandler
local KLActivityPreviewItemView = {}
setmetatable(KLActivityPreviewItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLActivityPreview/KLActivityPreviewItemKml'
---@param parent UIKmlLuaControlHandler
function KLActivityPreviewItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLActivityPreviewItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLActivityPreview/KLActivityPreviewItem']

return KLActivityPreviewItemView
