---@class KLFriendAddSubItemView:UIKmlLuaViewBase
---@field FriendAdd_ UIKmlLuaControl
---@field panel_56 UIKmlLuaControl
---@field img1 UIKmlLuaControl
---@field head_panel UIKmlLuaControl
---@field shua_xin_img UIKmlLuaControl
---@field TxtCdCountdown UIKmlLuaControl
---@field tui_jian_text UIKmlLuaControl
---@field shua_xin_text UIKmlLuaControl
---@field tu_jian_icon UIKmlLuaControl
---@field add_friend_scrollview UIKmlLuaControl
---@field ListContent UIKmlLuaControl
---@field panel_63 UIKmlLuaControl
---@field IptSearch UIKmlLuaControl
---@field text2 UIKmlLuaControl
---@field BtnSearch UIKmlLuaControl
---@field text3 UIKmlLuaControl
---@field scrollview1 UIKmlLuaControl
---@field layout2 UIKmlLuaControl
---@field datalist3 UIKmlLuaControl
local KLFriendAddSubItemView = {}
setmetatable(KLFriendAddSubItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendAddSub/KLFriendAddSubItemKml'
---@param parent UIKmlLuaControl
function KLFriendAddSubItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLFriendAddSubItemView
