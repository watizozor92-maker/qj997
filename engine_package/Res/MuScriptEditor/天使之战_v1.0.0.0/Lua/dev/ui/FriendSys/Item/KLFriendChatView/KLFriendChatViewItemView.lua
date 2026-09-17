---@class KLFriendChatViewItemView:UIKmlLuaViewBase
---@field chat_view UIKmlLuaControlHandler
---@field chat_data_list UIKmlLuaControlHandler
local KLFriendChatViewItemView = {}
setmetatable(KLFriendChatViewItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendChatView/KLFriendChatViewItemKml'
---@param parent UIKmlLuaControlHandler
function KLFriendChatViewItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFriendChatViewItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/FriendSys/Item/KLFriendChatView/KLFriendChatViewItem']

return KLFriendChatViewItemView
