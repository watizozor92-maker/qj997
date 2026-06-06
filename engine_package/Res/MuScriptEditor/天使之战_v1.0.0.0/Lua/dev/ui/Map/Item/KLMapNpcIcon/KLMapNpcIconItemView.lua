---@class KLMapNpcIconItemView:UIKmlLuaViewBase
---@field icon UIKmlLuaControl
---@field txt_name UIKmlLuaControl
local KLMapNpcIconItemView = {}
setmetatable(KLMapNpcIconItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Item/KLMapNpcIcon/KLMapNpcIconItemKml'
---@param parent UIKmlLuaControl
function KLMapNpcIconItemView:Init(parent)

    self:InitRoot(parent,kmlPath)
end
return KLMapNpcIconItemView
