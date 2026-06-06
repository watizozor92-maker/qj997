---@class KLUIChatViewView:UIKmlLuaViewBase
---@field chat_view UIKmlLuaControlHandler
---@field chat_data_list UIKmlLuaControlHandler
local KLUIChatViewView = {}
setmetatable(KLUIChatViewView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Chat/Item/KLUIChatView/KLUIChatViewKml'
---@param parent UIKmlLuaControlHandler
function KLUIChatViewView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChatView 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Chat/Item/KLUIChatView/KLUIChatView']

return KLUIChatViewView
