---@class KLMapNpcIconItemView:UIKmlLuaViewBase
---@field icon UIKmlLuaControlHandler
---@field txt_name UIKmlLuaControlHandler
local KLMapNpcIconItemView = {}
setmetatable(KLMapNpcIconItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Item/KLMapNpcIcon/KLMapNpcIconItemKml'
---@param parent UIKmlLuaControlHandler
function KLMapNpcIconItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
---@type KLMapNpcIconItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Map/Item/KLMapNpcIcon/KLMapNpcIconItem']

return KLMapNpcIconItemView
