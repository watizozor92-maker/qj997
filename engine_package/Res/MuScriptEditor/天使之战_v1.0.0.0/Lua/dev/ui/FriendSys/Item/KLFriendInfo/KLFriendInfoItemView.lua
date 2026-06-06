---@class KLFriendInfoItemView:UIKmlLuaViewBase
---@field FriendInfo UIKmlLuaControl
---@field KmlFriendListItem UIKmlLuaControl
---@field friend_select UIKmlLuaControl
---@field Check UIKmlLuaControl
---@field friend_bg UIKmlLuaControl
---@field Mask UIKmlLuaControl
---@field Icon UIKmlLuaControl
---@field friend_level UIKmlLuaControl
---@field friend_name UIKmlLuaControl
---@field friend_union_name UIKmlLuaControl
---@field friend_value UIKmlLuaControl
---@field friend_message UIKmlLuaControl
---@field TextOnline UIKmlLuaControl
local KLFriendInfoItemView = {}
setmetatable(KLFriendInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendInfo/KLFriendInfoItemKml'
---@param parent UIKmlLuaControl
function KLFriendInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLFriendInfoItemView
