---@class KLFriendChatItemView:UIKmlLuaViewBase
---@field bg UIKmlLuaControl
---@field chat_panel UIKmlLuaControl
---@field panel_root UIKmlLuaControl
---@field player_name UIKmlLuaControl
---@field chat_time UIKmlLuaControl
---@field di_panel UIKmlLuaControl
---@field pos_btn UIKmlLuaControl
---@field bag_btn UIKmlLuaControl
---@field biaoqing_btn UIKmlLuaControl
---@field text_input UIKmlLuaControl
---@field fasong UIKmlLuaControl
---@field sendMessageBtnTxt UIKmlLuaControl
---@field emoji_panel UIKmlLuaControl
---@field emoji_mask UIKmlLuaControl
---@field emoji_bg UIKmlLuaControl
---@field emoji UIKmlLuaControl
---@field all_emoji_layout UIKmlLuaControl
---@field emoji_data_list UIKmlLuaControl
---@field item_panel UIKmlLuaControl
---@field item_mask UIKmlLuaControl
---@field item_bg UIKmlLuaControl
---@field layout1 UIKmlLuaControl
---@field btn_bag UIKmlLuaControl
---@field btn_bag_select UIKmlLuaControl
---@field 背包 UIKmlLuaControl
---@field btn_equip UIKmlLuaControl
---@field btn_equip_select UIKmlLuaControl
---@field 穿戴 UIKmlLuaControl
local KLFriendChatItemView = {}
setmetatable(KLFriendChatItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendChat/KLFriendChatItemKml'
---@param parent UIKmlLuaControl
function KLFriendChatItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLFriendChatItemView
