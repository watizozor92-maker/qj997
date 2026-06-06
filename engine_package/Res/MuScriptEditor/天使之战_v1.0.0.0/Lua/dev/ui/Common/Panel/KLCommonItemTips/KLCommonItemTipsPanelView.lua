---@class KLCommonItemTipsPanelView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field bgImg UIKmlLuaControlHandler
---@field img_57 UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field tipContent UIKmlLuaControlHandler
---@field showItem UIKmlLuaControlHandler
---@field countInfo UIKmlLuaControlHandler
---@field btn_cancel UIKmlLuaControlHandler
---@field btn_sure UIKmlLuaControlHandler
local KLCommonItemTipsPanelView = {}
setmetatable(KLCommonItemTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Panel/KLCommonItemTips/KLCommonItemTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLCommonItemTipsPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLCommonItemTipsPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Common/Panel/KLCommonItemTips/KLCommonItemTipsPanel']

return KLCommonItemTipsPanelView
