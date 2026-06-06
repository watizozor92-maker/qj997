---@class KLMapMonsterPointCircleItemView:UIKmlLuaViewBase
---@field bg UIKmlLuaControlHandler
---@field text UIKmlLuaControlHandler
local KLMapMonsterPointCircleItemView = {}
setmetatable(KLMapMonsterPointCircleItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Map/Item/KLMapMonsterPointCircle/KLMapMonsterPointCircleItemKml'
---@param parent UIKmlLuaControlHandler
function KLMapMonsterPointCircleItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLMapMonsterPointCircleItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Map/Item/KLMapMonsterPointCircle/KLMapMonsterPointCircleItem']

return KLMapMonsterPointCircleItemView
