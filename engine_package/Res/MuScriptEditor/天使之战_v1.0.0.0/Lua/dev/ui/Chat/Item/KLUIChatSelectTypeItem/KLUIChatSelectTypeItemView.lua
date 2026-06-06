---@class KLUIChatSelectTypeItemView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
local KLUIChatSelectTypeItemView = {}
setmetatable(KLUIChatSelectTypeItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Chat/Item/KLUIChatSelectTypeItem/KLUIChatSelectTypeItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChatSelectTypeItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChatSelectTypeItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Chat/Item/KLUIChatSelectTypeItem/KLUIChatSelectTypeItem']

return KLUIChatSelectTypeItemView
