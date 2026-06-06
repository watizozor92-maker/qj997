---@class KLUIChatItemView:UIKmlLuaViewBase
---@field icon_root UIKmlLuaControlHandler
---@field icon UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field qipao UIKmlLuaControlHandler
---@field richT UIKmlLuaControlHandler
local KLUIChatItemView = {}
setmetatable(KLUIChatItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Chat/Item/KLUIChatItem/KLUIChatItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChatItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChatItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Chat/Item/KLUIChatItem/KLUIChatItem']

return KLUIChatItemView
