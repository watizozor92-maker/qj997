---@class KLUIChallengeBossBtnItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControlHandler
---@field level_select UIKmlLuaControlHandler
---@field type_name UIKmlLuaControlHandler
local KLUIChallengeBossBtnItemView = {}
setmetatable(KLUIChallengeBossBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossBtnItem/KLUIChallengeBossBtnItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChallengeBossBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChallengeBossBtnItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUIChallengeBossBtnItem/KLUIChallengeBossBtnItem']

return KLUIChallengeBossBtnItemView
