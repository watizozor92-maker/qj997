---@class KLFriendEnemyLogTextItemView:UIKmlLuaViewBase
---@field textContent UIKmlLuaControlHandler
local KLFriendEnemyLogTextItemView = {}
setmetatable(KLFriendEnemyLogTextItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/FriendSys/Item/KLFriendEnemyLogText/KLFriendEnemyLogTextItemKml'
---@param parent UIKmlLuaControlHandler
function KLFriendEnemyLogTextItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLFriendEnemyLogTextItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/FriendSys/Item/KLFriendEnemyLogText/KLFriendEnemyLogTextItem']

return KLFriendEnemyLogTextItemView
