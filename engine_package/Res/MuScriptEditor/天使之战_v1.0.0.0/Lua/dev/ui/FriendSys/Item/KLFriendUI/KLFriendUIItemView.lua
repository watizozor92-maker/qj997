---@class KLFriendUIItemView:UIKmlLuaViewBase
---@field friendimg1 UIKmlLuaControl
---@field friendimg2 UIKmlLuaControl
---@field friendimg3 UIKmlLuaControl
---@field friendimg UIKmlLuaControl
---@field FriendUI UIKmlLuaControl
---@field FriendUI_Root UIKmlLuaControl
---@field EnemyContent UIKmlLuaControl
---@field enemy_log_data_list UIKmlLuaControl
---@field BgCount UIKmlLuaControl
---@field friend_count UIKmlLuaControl
---@field friend_scrollview UIKmlLuaControl
---@field friend_layout UIKmlLuaControl
---@field friend_line UIKmlLuaControl
---@field BtnAdd UIKmlLuaControl
---@field text1 UIKmlLuaControl
---@field ChatContent UIKmlLuaControl
---@field BlackListContent UIKmlLuaControl
---@field TextBlackInfo UIKmlLuaControl
---@field BtnCancelForbid UIKmlLuaControl
---@field text2 UIKmlLuaControl
local KLFriendUIItemView = {}
setmetatable(KLFriendUIItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendUI/KLFriendUIItemKml'
---@param parent UIKmlLuaControl
function KLFriendUIItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLFriendUIItemView
