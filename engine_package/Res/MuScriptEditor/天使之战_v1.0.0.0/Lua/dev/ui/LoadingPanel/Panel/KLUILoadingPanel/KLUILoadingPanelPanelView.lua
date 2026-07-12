---@class KLUILoadingPanelPanelView:UIKmlLuaViewBase
---@field UILoadingPanel UIKmlLuaControlHandler
---@field UILoadingPanel_Root UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field RawImage_Background UIKmlLuaControlHandler
---@field Image_ProgressBG UIKmlLuaControlHandler
---@field Image_Progress UIKmlLuaControlHandler
---@field Text_Message UIKmlLuaControlHandler
local KLUILoadingPanelPanelView = {}
setmetatable(KLUILoadingPanelPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/LoadingPanel/Panel/KLUILoadingPanel/KLUILoadingPanelPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUILoadingPanelPanelView:Init(parent)
    --local p = parent and parent.kmlControl
    --self.root = UIKmlLuaControl(CS.KmlResourceManager.Create(p,kmlPath,KLUILoadingPanelPanelView.content))
    self:InitRoot(parent,kmlPath)
end
---@type KLUILoadingPanelPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/LoadingPanel/Panel/KLUILoadingPanel/KLUILoadingPanelPanel']

return KLUILoadingPanelPanelView
