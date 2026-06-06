---@class KLUICommonStrTipsPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field MaskCloseButton UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field tipContent UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
local KLUICommonTipsPanelView = {}
setmetatable(KLUICommonTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Panel/KLUICommonStrTips/KLUICommonStrTipsPanelKml'
KLUICommonTipsPanelView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath,nil,'.txt')
---@param parent UIKmlLuaControlHandler
function KLUICommonTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath,KLUICommonTipsPanelView.content)
end
---@type KLUICommonStrTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Common/Panel/KLUICommonStrTips/KLUICommonStrTipsPanel']

return KLUICommonTipsPanelView
