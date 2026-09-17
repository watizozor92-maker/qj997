---@class KLFriendInfoItemView:UIKmlLuaViewBase
---@field FriendInfo UIKmlLuaControlHandler
---@field KmlFriendListItem UIKmlLuaControlHandler
---@field friend_select UIKmlLuaControlHandler
---@field Check UIKmlLuaControlHandler
---@field friend_bg UIKmlLuaControlHandler
---@field Mask UIKmlLuaControlHandler
---@field Icon UIKmlLuaControlHandler
---@field friend_level UIKmlLuaControlHandler
---@field friend_name UIKmlLuaControlHandler
---@field friend_union_name UIKmlLuaControlHandler
---@field friend_value UIKmlLuaControlHandler
---@field friend_message UIKmlLuaControlHandler
---@field TextOnline UIKmlLuaControlHandler
local KLFriendInfoItemView = {}
setmetatable(KLFriendInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendInfo/KLFriendInfoItemKml'
---@param parent UIKmlLuaControlHandler
function KLFriendInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFriendInfoItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/FriendSys/Item/KLFriendInfo/KLFriendInfoItem']

return KLFriendInfoItemView
