---@class KLUINewChallengeBossLineItemView:UIKmlLuaViewBase
---@field btn UIKmlLuaControlHandler
---@field name UIKmlLuaControlHandler
---@field num UIKmlLuaControlHandler
---@field level UIKmlLuaControlHandler
---@field end_time UIKmlLuaControlHandler
---@field clickBtnMask UIKmlLuaControlHandler
local KLUINewChallengeBossLineItemView = {}
setmetatable(KLUINewChallengeBossLineItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUINewChallengeBossLineItem/KLUINewChallengeBossLineItemKml'
---@param parent UIKmlLuaControlHandler
function KLUINewChallengeBossLineItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUINewChallengeBossLineItemView
