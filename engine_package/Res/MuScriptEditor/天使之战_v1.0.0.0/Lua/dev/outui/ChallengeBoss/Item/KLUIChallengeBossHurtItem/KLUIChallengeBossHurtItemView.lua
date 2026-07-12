---@class KLUIChallengeBossHurtItemView:UIKmlLuaViewBase
---@field hurt_panel UIKmlLuaControlHandler
---@field rank_img UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field value UIKmlLuaControlHandler
local KLUIChallengeBossHurtItemView = {}
setmetatable(KLUIChallengeBossHurtItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossHurtItem/KLUIChallengeBossHurtItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChallengeBossHurtItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChallengeBossHurtItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUIChallengeBossHurtItem/KLUIChallengeBossHurtItem']

return KLUIChallengeBossHurtItemView
