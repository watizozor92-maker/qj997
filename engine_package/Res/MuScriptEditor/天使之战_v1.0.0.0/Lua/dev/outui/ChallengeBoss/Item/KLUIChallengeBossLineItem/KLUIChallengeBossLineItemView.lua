---@class KLUIChallengeBossLineItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field num UIKmlLuaControlHandler
---@field end_time UIKmlLuaControlHandler
local KLUIChallengeBossLineItemView = {}
setmetatable(KLUIChallengeBossLineItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossLineItem/KLUIChallengeBossLineItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIChallengeBossLineItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIChallengeBossLineItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUIChallengeBossLineItem/KLUIChallengeBossLineItem']

return KLUIChallengeBossLineItemView
