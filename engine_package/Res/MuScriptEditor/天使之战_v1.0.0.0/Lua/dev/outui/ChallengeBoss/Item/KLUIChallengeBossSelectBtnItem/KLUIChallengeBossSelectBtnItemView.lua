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
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLUIChallengeBossSelectBtnItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIChallengeBossSelectBtnItemView
