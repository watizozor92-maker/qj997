---@class KLFriendAddSubItemView:UIKmlLuaViewBase
---@field FriendAdd_ UIKmlLuaControlHandler
---@field panel_63 UIKmlLuaControlHandler
---@field BtnSearch UIKmlLuaControlHandler
---@field text3 UIKmlLuaControlHandler
---@field IptSearch UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field add_friend_scrollview UIKmlLuaControlHandler
---@field ListContent UIKmlLuaControlHandler
---@field panel_56 UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field head_panel UIKmlLuaControlHandler
---@field shua_xin_img UIKmlLuaControlHandler
---@field TxtCdCountdown UIKmlLuaControlHandler
---@field tui_jian_text UIKmlLuaControlHandler
---@field shua_xin_text UIKmlLuaControlHandler
---@field tu_jian_icon UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field datalist3 UIKmlLuaControlHandler
local KLFriendAddSubItemView = {}
setmetatable(KLFriendAddSubItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendAddSub/KLFriendAddSubItemKml'
---@param parent UIKmlLuaControlHandler
function KLFriendAddSubItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFriendAddSubItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/FriendSys/Item/KLFriendAddSub/KLFriendAddSubItem']

return KLFriendAddSubItemView
