---@class KLFriendAddListItemView:UIKmlLuaViewBase
---@field FriendItem UIKmlLuaControlHandler
---@field friend_select UIKmlLuaControlHandler
---@field friend_bg UIKmlLuaControlHandler
---@field Mask UIKmlLuaControlHandler
---@field Icon UIKmlLuaControlHandler
---@field friend_level UIKmlLuaControlHandler
---@field friend_name UIKmlLuaControlHandler
---@field BtnForbid UIKmlLuaControlHandler
---@field BtnForbid1 UIKmlLuaControlHandler
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
return KLFriendAddListItemView
