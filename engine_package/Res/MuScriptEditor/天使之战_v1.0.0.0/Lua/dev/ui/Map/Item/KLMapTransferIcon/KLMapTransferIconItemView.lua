---@class KLMapTransferIconItemView:UIKmlLuaViewBase
---@field img_301 UIKmlLuaControlHandler
---@field txt_name UIKmlLuaControlHandler
local KLMapTransferIconItemView = {}
setmetatable(KLMapTransferIconItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Item/KLMapTransferIcon/KLMapTransferIconItemKml'
---@param parent UIKmlLuaControlHandler
function KLMapTransferIconItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLMapTransferIconItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Map/Item/KLMapTransferIcon/KLMapTransferIconItem']

return KLMapTransferIconItemView
