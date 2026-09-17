---@class KLFriendUIItemView:UIKmlLuaViewBase
---@field friendimg1 UIKmlLuaControlHandler
---@field friendimg2 UIKmlLuaControlHandler
---@field friendimg3 UIKmlLuaControlHandler
---@field FriendUI UIKmlLuaControlHandler
---@field BtnAdd UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
---@field BlackListContent UIKmlLuaControlHandler
---@field BtnCancelForbid UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field TextBlackInfo UIKmlLuaControlHandler
---@field FriendUI_Root UIKmlLuaControlHandler
---@field EnemyContent UIKmlLuaControlHandler
---@field enemy_log_data_list UIKmlLuaControlHandler
---@field BgCount UIKmlLuaControlHandler
---@field friend_count UIKmlLuaControlHandler
---@field friend_scrollview UIKmlLuaControlHandler
---@field friend_layout UIKmlLuaControlHandler
---@field friend_line UIKmlLuaControlHandler
---@field ChatContent UIKmlLuaControlHandler
---@field friendimg UIKmlLuaControlHandler
local KLFriendUIItemView = {}
setmetatable(KLFriendUIItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendUI/KLFriendUIItemKml'
---@param parent UIKmlLuaControlHandler
function KLFriendUIItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFriendUIItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/FriendSys/Item/KLFriendUI/KLFriendUIItem']

return KLFriendUIItemView
