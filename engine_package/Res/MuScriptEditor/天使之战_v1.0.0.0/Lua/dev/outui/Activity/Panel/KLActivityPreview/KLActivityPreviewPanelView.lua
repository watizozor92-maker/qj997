---@class KLActivityPreviewPanelView:UIKmlLuaViewBase
---@field move_root UIKmlLuaControlHandler
---@field btnClose UIKmlLuaControlHandler
---@field panelRoot UIKmlLuaControlHandler
---@field bgRoot UIKmlLuaControlHandler
---@field bg UIKmlLuaControlHandler
---@field title3 UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field title2 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field text9 UIKmlLuaControlHandler
---@field text10 UIKmlLuaControlHandler
---@field title1 UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field text13 UIKmlLuaControlHandler
---@field text14 UIKmlLuaControlHandler
---@field scrollview5 UIKmlLuaControlHandler
---@field layout6 UIKmlLuaControlHandler
---@field previewItems UIKmlLuaControlHandler
local KLActivityPreviewPanelView = {}
setmetatable(KLActivityPreviewPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Panel/KLActivityPreview/KLActivityPreviewPanelKml'
---@param parent UIKmlLuaControlHandler
function KLActivityPreviewPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLActivityPreviewPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Panel/KLActivityPreview/KLActivityPreviewPanel']

return KLActivityPreviewPanelView
