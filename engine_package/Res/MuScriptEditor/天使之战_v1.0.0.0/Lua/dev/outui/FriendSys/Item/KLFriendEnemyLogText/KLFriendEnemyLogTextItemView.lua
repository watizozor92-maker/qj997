---@class KLFriendEnemyLogTextItemView:UIKmlLuaViewBase
local KLFriendEnemyLogTextItemView = {}
setmetatable(KLFriendEnemyLogTextItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FriendSys/Item/KLFriendEnemyLogText/KLFriendEnemyLogTextItemKml'
---@param parent UIKmlLuaControl
function KLFriendEnemyLogTextItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLFriendEnemyLogTextItemView
