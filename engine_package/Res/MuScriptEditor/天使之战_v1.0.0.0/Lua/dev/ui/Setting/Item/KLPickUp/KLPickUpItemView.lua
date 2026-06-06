---@class KLPickUpItemView:UIKmlLuaViewBase
---@field pick_toggle UIKmlLuaControlHandler
---@field pickItemName UIKmlLuaControlHandler
local KLPickUpItemView = {}
setmetatable(KLPickUpItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Setting/Item/KLPickUp/KLPickUpItemKml'
---@param parent UIKmlLuaControlHandler
function KLPickUpItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLPickUpItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Setting/Item/KLPickUp/KLPickUpItem']

return KLPickUpItemView
