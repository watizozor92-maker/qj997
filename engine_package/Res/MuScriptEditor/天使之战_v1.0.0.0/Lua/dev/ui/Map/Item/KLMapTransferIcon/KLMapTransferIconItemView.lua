---@class KLMapTransferIconItemView:UIKmlLuaViewBase
---@field txt_name UIKmlLuaControl
local KLMapTransferIconItemView = {}
setmetatable(KLMapTransferIconItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Item/KLMapTransferIcon/KLMapTransferIconItemKml'
---@param parent UIKmlLuaControl
function KLMapTransferIconItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLMapTransferIconItemView
