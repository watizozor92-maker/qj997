---@class KLUIChatEmojiItemView:UIKmlLuaViewBase
---@field chat_view UIKmlLuaControlHandler
---@field chat_data_list UIKmlLuaControlHandler
local KLUIChatEmojiItemView = {}
setmetatable(KLUIChatEmojiItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Chat/Item/KLUIChatEmojiItem/KLUIChatEmojiItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChatEmojiItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChatEmojiItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Chat/Item/KLUIChatEmojiItem/KLUIChatEmojiItem']

return KLUIChatEmojiItemView
