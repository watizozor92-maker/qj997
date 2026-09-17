---@class KLTeamInfoItemView:UIKmlLuaViewBase
---@field HeaderIconBg UIKmlLuaControlHandler
---@field icon UIKmlLuaControlHandler
---@field playerName UIKmlLuaControlHandler
---@field state UIKmlLuaControlHandler
---@field select UIKmlLuaControlHandler
---@field leaderIcon UIKmlLuaControlHandler
local KLTeamInfoItemView = {}
setmetatable(KLTeamInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Activity/Item/KLTeamInfo/KLTeamInfoItemKml'
---@param parent UIKmlLuaControlHandler
function KLTeamInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLTeamInfoItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Activity/Item/KLTeamInfo/KLTeamInfoItem']

return KLTeamInfoItemView
