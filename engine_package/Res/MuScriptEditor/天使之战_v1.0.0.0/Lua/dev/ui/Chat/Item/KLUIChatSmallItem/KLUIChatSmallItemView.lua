---@class KLUIChatSmallItemView:UIKmlLuaViewBase
---@field smallPanel UIKmlLuaControlHandler
---@field bgRoot UIKmlLuaControlHandler
---@field richSmall UIKmlLuaControlHandler
local KLUIChatSmallItemView = {}
setmetatable(KLUIChatSmallItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Chat/Item/KLUIChatSmallItem/KLUIChatSmallItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChatSmallItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChatSmallItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Chat/Item/KLUIChatSmallItem/KLUIChatSmallItem']

return KLUIChatSmallItemView
