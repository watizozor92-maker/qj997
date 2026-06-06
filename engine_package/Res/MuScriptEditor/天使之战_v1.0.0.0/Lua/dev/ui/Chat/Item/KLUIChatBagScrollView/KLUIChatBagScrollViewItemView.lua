---@class KLUIChatBagScrollViewItemView:UIKmlLuaViewBase
---@field BagTileScrollViewPrefab UIKmlLuaControlHandler
---@field prefabBagTileScrollView_ UIKmlLuaControlHandler
---@field BagTileContent UIKmlLuaControlHandler
---@field item_list_ UIKmlLuaControlHandler
---@field forbid_list_ UIKmlLuaControlHandler
---@field red_grid_ UIKmlLuaControlHandler
---@field green_grid_ UIKmlLuaControlHandler
---@field CheckAreaUp UIKmlLuaControlHandler
---@field CheckAreaBottom UIKmlLuaControlHandler
local KLUIChatBagScrollViewItemView = {}
setmetatable(KLUIChatBagScrollViewItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Chat/Item/KLUIChatBagScrollView/KLUIChatBagScrollViewItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChatBagScrollViewItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChatBagScrollViewItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Chat/Item/KLUIChatBagScrollView/KLUIChatBagScrollViewItem']

return KLUIChatBagScrollViewItemView
