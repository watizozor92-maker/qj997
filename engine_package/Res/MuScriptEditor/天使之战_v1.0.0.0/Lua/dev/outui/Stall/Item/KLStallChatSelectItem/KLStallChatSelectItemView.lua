---@class KLStallChatSelectItemView:UIKmlLuaViewBase
---@field select UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
local KLStallChatSelectItemView = {}
setmetatable(KLStallChatSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLStallChatSelectItem/KLStallChatSelectItemKml'
---@param parent UIKmlLuaControlHandler
function KLStallChatSelectItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLStallChatSelectItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Stall/Item/KLStallChatSelectItem/KLStallChatSelectItem']

return KLStallChatSelectItemView
