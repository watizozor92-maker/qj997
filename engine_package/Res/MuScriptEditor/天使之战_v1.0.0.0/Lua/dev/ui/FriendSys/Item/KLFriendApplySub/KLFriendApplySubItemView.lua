---@class KLFriendApplySubItemView:UIKmlLuaViewBase
---@field FriendApply_ UIKmlLuaControl
---@field add_friend_scrollview UIKmlLuaControl
---@field ListContent UIKmlLuaControl
local KLFriendApplySubItemView = {}
setmetatable(KLFriendApplySubItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendApplySub/KLFriendApplySubItemKml'
---@param parent UIKmlLuaControl
function KLFriendApplySubItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLFriendApplySubItemView
