---@class KLHookTipsPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field MaskCloseButton UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field tipContent UIKmlLuaControlHandler
---@field txt_title UIKmlLuaControlHandler
local KLHookTipsPanelView = {}
setmetatable(KLHookTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Panel/KLHookTips/KLHookTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLHookTipsPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLHookTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Panel/KLHookTips/KLHookTipsPanel']

return KLHookTipsPanelView
