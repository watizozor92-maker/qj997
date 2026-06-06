---@class KLMapMonsterPointItemView:UIKmlLuaViewBase
---@field Icon UIKmlLuaControl
---@field Name UIKmlLuaControl
---@field Lv UIKmlLuaControl
local KLMapMonsterPointItemView = {}
setmetatable(KLMapMonsterPointItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Map/Item/KLMapMonsterPoint/KLMapMonsterPointItemKml'
---@param parent UIKmlLuaControl
function KLMapMonsterPointItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMapMonsterPointItemView
