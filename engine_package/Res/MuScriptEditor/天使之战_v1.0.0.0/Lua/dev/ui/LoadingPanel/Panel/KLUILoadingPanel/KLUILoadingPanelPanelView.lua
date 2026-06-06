---@class KLUILoadingPanelPanelView:UIKmlLuaViewBase
---@field UILoadingPanel UIKmlLuaControl
---@field UILoadingPanel_Root UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field img2 UIKmlLuaControl
---@field RawImage_Background UIKmlLuaControl
---@field Image_ProgressBG UIKmlLuaControl
---@field Image_Progress UIKmlLuaControl
---@field Text_Message UIKmlLuaControl
local KLUILoadingPanelPanelView = {}
setmetatable(KLUILoadingPanelPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/LoadingPanel/Panel/KLUILoadingPanel/KLUILoadingPanelPanelKml'
---@param parent UIKmlLuaControl
function KLUILoadingPanelPanelView:Init(parent)
    --local p = parent and parent.kmlControl
    --self.root = UIKmlLuaControl(CS.KmlResourceManager.Create(p,kmlPath,KLUILoadingPanelPanelView.content))
    self:InitRoot(parent,kmlPath)
end
return KLUILoadingPanelPanelView
