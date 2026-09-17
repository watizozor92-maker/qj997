---@class KLFriendAddPanelView:UIKmlLuaViewBase
---@field FriendAdd_ UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field add_friend_kuang UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field add_friend_butten UIKmlLuaControlHandler
---@field friend_applay_butten UIKmlLuaControlHandler
---@field SubRoot UIKmlLuaControlHandler
---@field TextAddFriend UIKmlLuaControlHandler
---@field add_friend_head_layout UIKmlLuaControlHandler
---@field TextFriendApply UIKmlLuaControlHandler
---@field add_friend_bg UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLFriendAddPanelView = {}
setmetatable(KLFriendAddPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Panel/KLFriendAdd/KLFriendAddPanelKml'
---@param parent UIKmlLuaControlHandler
function KLFriendAddPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFriendAddPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/FriendSys/Panel/KLFriendAdd/KLFriendAddPanel']

return KLFriendAddPanelView
