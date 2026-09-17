---@class KLFriendChatItemView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field chat_panel UIKmlLuaControlHandler
---@field di_panel UIKmlLuaControlHandler
---@field pos_btn UIKmlLuaControlHandler
---@field bag_btn UIKmlLuaControlHandler
---@field biaoqing_btn UIKmlLuaControlHandler
---@field fasong UIKmlLuaControlHandler
---@field sendMessageBtnTxt UIKmlLuaControlHandler
---@field text_input UIKmlLuaControlHandler
---@field player_name UIKmlLuaControlHandler
---@field chat_time UIKmlLuaControlHandler
---@field panel_root UIKmlLuaControlHandler
---@field item_panel UIKmlLuaControlHandler
---@field layout1 UIKmlLuaControlHandler
---@field btn_bag UIKmlLuaControlHandler
---@field btn_bag_select UIKmlLuaControlHandler
---@field 背包 UIKmlLuaControlHandler
---@field btn_equip UIKmlLuaControlHandler
---@field btn_equip_select UIKmlLuaControlHandler
---@field 穿戴 UIKmlLuaControlHandler
---@field item_mask UIKmlLuaControlHandler
---@field item_bg UIKmlLuaControlHandler
---@field emoji_panel UIKmlLuaControlHandler
---@field emoji_bg UIKmlLuaControlHandler
---@field emoji_mask UIKmlLuaControlHandler
---@field emoji UIKmlLuaControlHandler
---@field all_emoji_layout UIKmlLuaControlHandler
---@field emoji_data_list UIKmlLuaControlHandler
local KLFriendChatItemView = {}
setmetatable(KLFriendChatItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/FriendSys/Item/KLFriendChat/KLFriendChatItemKml'
---@param parent UIKmlLuaControlHandler
function KLFriendChatItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFriendChatItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/FriendSys/Item/KLFriendChat/KLFriendChatItem']

return KLFriendChatItemView
