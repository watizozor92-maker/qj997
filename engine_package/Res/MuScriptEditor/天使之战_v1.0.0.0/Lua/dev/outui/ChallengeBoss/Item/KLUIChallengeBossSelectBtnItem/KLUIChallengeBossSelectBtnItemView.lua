---@class KLUIChallengeBossSelectBtnItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControlHandler
---@field level_select UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field touxiang UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
local KLUIChallengeBossSelectBtnItemView = {}
setmetatable(KLUIChallengeBossSelectBtnItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossSelectBtnItem/KLUIChallengeBossSelectBtnItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChallengeBossSelectBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChallengeBossSelectBtnItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUIChallengeBossSelectBtnItem/KLUIChallengeBossSelectBtnItem']

return KLUIChallengeBossSelectBtnItemView
