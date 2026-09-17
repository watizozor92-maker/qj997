---@class KLMonsterMapPointItemItemView:UIKmlLuaViewBase
---@field MainBg UIKmlLuaControlHandler
---@field BG UIKmlLuaControlHandler
---@field GoButtonText UIKmlLuaControlHandler
---@field MonsterName UIKmlLuaControlHandler
---@field last_time UIKmlLuaControlHandler
---@field select UIKmlLuaControlHandler
local KLMonsterMapPointItemItemView = {}
setmetatable(KLMonsterMapPointItemItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Monster/Item/KLMonsterMapPointItem/KLMonsterMapPointItemItemKml'
---@param parent UIKmlLuaControlHandler
function KLMonsterMapPointItemItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLMonsterMapPointItemItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Monster/Item/KLMonsterMapPointItem/KLMonsterMapPointItemItem']

return KLMonsterMapPointItemItemView
