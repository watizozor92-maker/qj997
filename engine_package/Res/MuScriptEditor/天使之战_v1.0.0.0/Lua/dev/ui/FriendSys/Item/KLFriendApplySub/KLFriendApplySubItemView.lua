---@class KLFriendApplySubItemView:UIKmlLuaViewBase
---@field FriendApply_ UIKmlLuaControlHandler
---@field add_friend_scrollview UIKmlLuaControlHandler
---@field ListContent UIKmlLuaControlHandler
local KLFriendApplySubItemView = {}
setmetatable(KLFriendApplySubItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendApplySub/KLFriendApplySubItemKml'
---@param parent UIKmlLuaControlHandler
function KLFriendApplySubItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLFriendApplySubItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/FriendSys/Item/KLFriendApplySub/KLFriendApplySubItem']

return KLFriendApplySubItemView
