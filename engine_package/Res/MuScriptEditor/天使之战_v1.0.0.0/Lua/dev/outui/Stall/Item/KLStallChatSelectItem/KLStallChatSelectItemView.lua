---@class KLStallChatSelectItemView:UIKmlLuaViewBase
---@field select UIKmlLuaControl
---@field name UIKmlLuaControl
local KLStallChatSelectItemView = {}
setmetatable(KLStallChatSelectItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Stall/Item/KLStallChatSelectItem/KLStallChatSelectItemKml'
---@param parent UIKmlLuaControl
function KLStallChatSelectItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLStallChatSelectItemView
