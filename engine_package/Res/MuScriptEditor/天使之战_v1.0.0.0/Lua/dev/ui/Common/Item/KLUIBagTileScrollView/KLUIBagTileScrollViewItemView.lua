---@class KLUIBagTileScrollViewItemView:UIKmlLuaViewBase
---@field BagTileScrollViewPrefab UIKmlLuaControlHandler
---@field prefabBagTileScrollView_ UIKmlLuaControlHandler
---@field BagTileContent UIKmlLuaControlHandler
---@field item_list_ UIKmlLuaControlHandler
---@field forbid_list_ UIKmlLuaControlHandler
---@field red_list_ UIKmlLuaControlHandler
---@field red_grid_ UIKmlLuaControlHandler
---@field green_grid_ UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
local KLUIBagTileScrollViewItemView = {}
setmetatable(KLUIBagTileScrollViewItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIBagTileScrollViewItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIBagTileScrollViewItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Common/Item/KLUIBagTileScrollView/KLUIBagTileScrollViewItem']

return KLUIBagTileScrollViewItemView
