---@class KLAppearPreviewPanelView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field Bg_View UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field role_model_root UIKmlLuaControlHandler
---@field RoleModel UIKmlLuaControlHandler
---@field GuardModel UIKmlLuaControlHandler
---@field TitleModel UIKmlLuaControlHandler
---@field MonsterModle UIKmlLuaControlHandler
---@field TogHideWing UIKmlLuaControlHandler
---@field TogStr UIKmlLuaControlHandler
local KLAppearPreviewPanelView = {}
setmetatable(KLAppearPreviewPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanelKml'
---@param parent UIKmlLuaControlHandler
function KLAppearPreviewPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLAppearPreviewPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/AppearGroup/Panel/KLAppearPreview/KLAppearPreviewPanel']

return KLAppearPreviewPanelView
