---@class KLChallengeBossPosPanelView:UIKmlLuaViewBase
---@field Boss UIKmlLuaControlHandler
---@field pos_root UIKmlLuaControlHandler
---@field boss_pos UIKmlLuaControlHandler
---@field boss_pos_layout UIKmlLuaControlHandler
---@field boss_pos_dl UIKmlLuaControlHandler
---@field hurt_root UIKmlLuaControlHandler
---@field hurt_root_scrollview UIKmlLuaControlHandler
---@field hurt_root_layout UIKmlLuaControlHandler
---@field hurt_root_dl UIKmlLuaControlHandler
---@field my_ranking_img UIKmlLuaControlHandler
---@field my_ranking UIKmlLuaControlHandler
---@field my_name UIKmlLuaControlHandler
---@field my_value UIKmlLuaControlHandler
---@field exitBtn UIKmlLuaControlHandler
local KLChallengeBossPosPanelView = {}
setmetatable(KLChallengeBossPosPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLChallengeBossPos/KLChallengeBossPosPanelKml'
---@param parent UIKmlLuaControlHandler
function KLChallengeBossPosPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLChallengeBossPosPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Panel/KLChallengeBossPos/KLChallengeBossPosPanel']

return KLChallengeBossPosPanelView
