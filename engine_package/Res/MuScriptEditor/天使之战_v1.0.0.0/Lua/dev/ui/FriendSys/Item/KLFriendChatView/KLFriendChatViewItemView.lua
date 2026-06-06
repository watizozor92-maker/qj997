---@class KLFriendChatViewItemView:UIKmlLuaViewBase
---@field chat_view UIKmlLuaControl
---@field chat_data_list UIKmlLuaControl
local KLFriendChatViewItemView = {}
setmetatable(KLFriendChatViewItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendChatView/KLFriendChatViewItemKml'
---@param parent UIKmlLuaControl
function KLFriendChatViewItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLFriendChatViewItemView
