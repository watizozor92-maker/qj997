---@class KLBigMapTransferItemItemView:UIKmlLuaViewBase
---@field ButtonCommon UIKmlLuaControlHandler
---@field Label UIKmlLuaControlHandler
---@field TextLevel UIKmlLuaControlHandler
---@field ImgVip UIKmlLuaControlHandler
---@field TextCost UIKmlLuaControlHandler
local KLBigMapTransferItemItemView = {}
setmetatable(KLBigMapTransferItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Item/KLBigMapTransferItem/KLBigMapTransferItemItemKml'
---@param parent UIKmlLuaControlHandler
function KLBigMapTransferItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLBigMapTransferItemItemView
