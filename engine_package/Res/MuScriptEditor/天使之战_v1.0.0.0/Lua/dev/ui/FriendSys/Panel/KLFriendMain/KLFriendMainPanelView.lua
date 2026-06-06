---@class KLFriendMainPanelView:UIKmlLuaViewBase
---@field FriendMain_ UIKmlLuaControlHandler
---@field friend_common_bg UIKmlLuaControlHandler
---@field ImgTitle UIKmlLuaControlHandler
---@field friend_common_kuang UIKmlLuaControlHandler
---@field friend_kuang UIKmlLuaControlHandler
---@field BtnClose UIKmlLuaControlHandler
---@field TextTitleFriend1 UIKmlLuaControlHandler
---@field TextTitleFriendEnemy UIKmlLuaControlHandler
---@field TextTitleBlackList UIKmlLuaControlHandler
---@field friend_head_common_layout UIKmlLuaControlHandler
---@field Options_friend UIKmlLuaControlHandler
---@field Options_archenemy UIKmlLuaControlHandler
---@field Options_blacklist UIKmlLuaControlHandler
---@field add_friend UIKmlLuaControlHandler
---@field BtnHelp UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLFriendMainPanelView = {}
setmetatable(KLFriendMainPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Panel/KLFriendMain/KLFriendMainPanelKml'
---@param parent UIKmlLuaControlHandler
function KLFriendMainPanelView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLFriendMainPanelView
