---@class KLUIChallengeBossBtnItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControl
---@field level_select UIKmlLuaControl
---@field type_name UIKmlLuaControl
local KLUIChallengeBossBtnItemView = {}
setmetatable(KLUIChallengeBossBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossPosItem/KLUIChallengeBossPosItemKml'
KLUIChallengeBossBtnItemView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath,nil,'.txt')
---@param parent UIKmlLuaControl
function KLUIChallengeBossBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath,KLUIChallengeBossBtnItemView.content)
end
return KLUIChallengeBossBtnItemView
