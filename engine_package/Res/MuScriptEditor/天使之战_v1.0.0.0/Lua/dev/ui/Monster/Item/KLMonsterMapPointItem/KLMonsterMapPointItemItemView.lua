---@class KLMonsterMapPointItemItemView:UIKmlLuaViewBase
---@field MainBg UIKmlLuaControl
---@field BG UIKmlLuaControl
---@field GoButtonText UIKmlLuaControl
---@field MonsterName UIKmlLuaControl
---@field last_time UIKmlLuaControl
---@field select UIKmlLuaControl
local KLMonsterMapPointItemItemView = {}
setmetatable(KLMonsterMapPointItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Monster/Item/KLMonsterMapPointItem/KLMonsterMapPointItemItemKml'
---@param parent UIKmlLuaControl
function KLMonsterMapPointItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLMonsterMapPointItemItemView
