---@class KLTransferRingItemView:UIKmlLuaViewBase
---@field Bg UIKmlLuaControlHandler
---@field Item UIKmlLuaControlHandler
---@field SpState UIKmlLuaControlHandler
---@field TxtName UIKmlLuaControlHandler
---@field TxtTime UIKmlLuaControlHandler
---@field TimeDown UIKmlLuaControlHandler
local KLTransferRingItemView = {}
setmetatable(KLTransferRingItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/AppearGroup/Item/KLTransferRing/KLTransferRingItemKml'
---@param parent UIKmlLuaControlHandler
function KLTransferRingItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTransferRingItemView
