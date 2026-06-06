---@class KLTeamInfoItemView:UIKmlLuaViewBase
---@field HeaderIconBg UIKmlLuaControl
---@field playerName UIKmlLuaControl
---@field state UIKmlLuaControl
---@field select UIKmlLuaControl
---@field leaderIcon UIKmlLuaControl
---@field icon UIKmlLuaControl
local KLTeamInfoItemView = {}
setmetatable(KLTeamInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLTeamInfo/KLTeamInfoItemKml'
---@param parent UIKmlLuaControl
function KLTeamInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLTeamInfoItemView
