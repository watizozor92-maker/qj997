---@class KLMapMonsterPointItemView:UIKmlLuaViewBase
---@field Icon UIKmlLuaControlHandler
---@field Name UIKmlLuaControlHandler
---@field Lv UIKmlLuaControlHandler
local KLMapMonsterPointItemView = {}
setmetatable(KLMapMonsterPointItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Item/KLMapMonsterPoint/KLMapMonsterPointItemKml'
---@param parent UIKmlLuaControlHandler
function KLMapMonsterPointItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMapMonsterPointItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Map/Item/KLMapMonsterPoint/KLMapMonsterPointItem']

return KLMapMonsterPointItemView
