---@class KLUIChallengeBossHurtItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControl
---@field level_select UIKmlLuaControl
---@field type_name UIKmlLuaControl
local KLUIChallengeBossHurtItemView = {}
setmetatable(KLUIChallengeBossHurtItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossHurtItem/KLUIChallengeBossHurtItemKml'
---@param parent UIKmlLuaControl
function KLUIChallengeBossHurtItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIChallengeBossHurtItemView
