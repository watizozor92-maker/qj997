---@class KLRedDotItemView:UIKmlLuaViewBase
---@field redDotItem UIKmlLuaControlHandler
local KLRedDotItemView = {}
setmetatable(KLRedDotItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/RedDot/Item/KLRedDot/KLRedDotItemKml'
---@param parent UIKmlLuaControlHandler
function KLRedDotItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLRedDotItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/RedDot/Item/KLRedDot/KLRedDotItem']

return KLRedDotItemView
