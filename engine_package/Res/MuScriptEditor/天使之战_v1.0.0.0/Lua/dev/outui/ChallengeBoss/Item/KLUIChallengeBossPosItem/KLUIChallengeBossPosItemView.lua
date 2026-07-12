---@class KLUIChallengeBossPosItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field pos_str UIKmlLuaControlHandler
---@field info UIKmlLuaControlHandler
---@field revive_time UIKmlLuaControlHandler
local KLUIChallengeBossBtnItemView = {}
setmetatable(KLUIChallengeBossBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossPosItem/KLUIChallengeBossPosItemKml'
KLUIChallengeBossBtnItemView.content = CS.TCFramework.LuaManager.LoadFileText(kmlPath,nil,'.txt')
---@param parent UIKmlLuaControlHandler
function KLUIChallengeBossBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath,KLUIChallengeBossBtnItemView.content)
end
---@type KLUIChallengeBossPosItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUIChallengeBossPosItem/KLUIChallengeBossPosItem']

return KLUIChallengeBossBtnItemView
