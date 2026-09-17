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
---@type KLTransferRingItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/AppearGroup/Item/KLTransferRing/KLTransferRingItem']

return KLTransferRingItemView
