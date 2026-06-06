---@class KLClickNPCTransferTipsPanelView:UIKmlLuaViewBase
local KLClickNPCTransferTipsPanelView = {}
setmetatable(KLClickNPCTransferTipsPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Tips/Panel/KLClickNPCTransferTips/KLClickNPCTransferTipsPanelKml'
---@param parent UIKmlLuaControlHandler
function KLClickNPCTransferTipsPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLClickNPCTransferTipsPanelView
