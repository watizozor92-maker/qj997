---@class KLFriendAddPanelView:UIKmlLuaViewBase
---@field FriendAdd_ UIKmlLuaControlHandler
---@field add_friend_bg UIKmlLuaControlHandler
---@field add_friend_kuang UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field add_friend_head_layout UIKmlLuaControlHandler
---@field add_friend_butten UIKmlLuaControlHandler
---@field TextAddFriend UIKmlLuaControlHandler
---@field friend_applay_butten UIKmlLuaControlHandler
---@field TextFriendApply UIKmlLuaControlHandler
---@field SubRoot UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLFriendAddPanelView = {}
setmetatable(KLFriendAddPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Panel/KLFriendAdd/KLFriendAddPanelKml'
---@param parent UIKmlLuaControlHandler
function KLFriendAddPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLFriendAddPanelView
