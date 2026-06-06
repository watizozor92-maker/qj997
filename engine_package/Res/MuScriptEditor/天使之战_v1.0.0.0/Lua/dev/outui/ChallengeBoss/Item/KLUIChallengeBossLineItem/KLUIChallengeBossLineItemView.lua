---@class KLUIChallengeBossLineItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field num UIKmlLuaControlHandler
---@field end_time UIKmlLuaControlHandler
local KLUIChallengeBossLineItemView = {}
setmetatable(KLUIChallengeBossLineItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIChallengeBossLineItem/KLUIChallengeBossLineItemKml'
---@param parent UIKmlLuaControlHandlerHandler
function KLUIChallengeBossLineItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIChallengeBossLineItemView
