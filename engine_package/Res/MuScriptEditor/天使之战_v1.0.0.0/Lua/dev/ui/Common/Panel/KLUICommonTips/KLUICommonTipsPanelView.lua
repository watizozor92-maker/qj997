---@class KLUICommonTipsPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field img_title UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field tipsContent UIKmlLuaControlHandler
---@field btn_sure UIKmlLuaControlHandler
---@field btn_cancel UIKmlLuaControlHandler
---@field slider UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field tipsItemCount UIKmlLuaControlHandler
---@field input UIKmlLuaControlHandler
---@field toggle UIKmlLuaControlHandler
local KLUICommonTipsPanelView = {}
setmetatable(KLUICommonTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUICommonTipsPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUICommonTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Common/Panel/KLUICommonTips/KLUICommonTipsPanel']

return KLUICommonTipsPanelView
