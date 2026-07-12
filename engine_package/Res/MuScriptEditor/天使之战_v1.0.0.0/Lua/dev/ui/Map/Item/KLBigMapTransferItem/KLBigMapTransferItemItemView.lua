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
---@type KLBigMapTransferItemItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Map/Item/KLBigMapTransferItem/KLBigMapTransferItemItem']

return KLBigMapTransferItemItemView
