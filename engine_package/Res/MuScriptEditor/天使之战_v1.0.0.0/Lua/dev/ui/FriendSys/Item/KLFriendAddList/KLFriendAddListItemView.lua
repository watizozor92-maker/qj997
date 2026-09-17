---@class KLFriendAddListItemView:UIKmlLuaViewBase
---@field FriendItem UIKmlLuaControlHandler
---@field BtnForbid UIKmlLuaControlHandler
---@field friend_select UIKmlLuaControlHandler
---@field BtnForbid1 UIKmlLuaControlHandler
---@field friend_bg UIKmlLuaControlHandler
---@field Mask UIKmlLuaControlHandler
---@field Icon UIKmlLuaControlHandler
---@field friend_level UIKmlLuaControlHandler
---@field friend_name UIKmlLuaControlHandler
---@field BtnAdd UIKmlLuaControlHandler
---@field BtnAlreadyAdd UIKmlLuaControlHandler
---@field BtnRefuse UIKmlLuaControlHandler
---@field BtnRefuse1 UIKmlLuaControlHandler
---@field BtnAgree UIKmlLuaControlHandler
local KLFriendAddListItemView = {}
setmetatable(KLFriendAddListItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendAddList/KLFriendAddListItemKml'
---@param parent UIKmlLuaControlHandler
function KLFriendAddListItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFriendAddListItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/FriendSys/Item/KLFriendAddList/KLFriendAddListItem']

return KLFriendAddListItemView
