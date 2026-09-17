---@class KLItemItemView:UIKmlLuaViewBase
---@field control_item UIKmlLuaControlHandler
local KLItemItemView = {}
setmetatable(KLItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLItem/KLItemItemKml'
---@param parent UIKmlLuaControlHandler
function KLItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLItemItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLItem/KLItemItem']

return KLItemItemView
