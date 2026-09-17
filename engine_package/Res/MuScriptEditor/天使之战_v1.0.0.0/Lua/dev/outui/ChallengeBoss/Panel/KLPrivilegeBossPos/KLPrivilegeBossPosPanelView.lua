---@class KLPrivilegeBossPosPanelView:UIKmlLuaViewBase
---@field Boss UIKmlLuaControlHandler
---@field ActivityName UIKmlLuaControlHandler
---@field line_1 UIKmlLuaControlHandler
---@field line_2 UIKmlLuaControlHandler
---@field pos_root UIKmlLuaControlHandler
---@field boss_pos UIKmlLuaControlHandler
---@field boss_pos_layout UIKmlLuaControlHandler
---@field boss_pos_dl UIKmlLuaControlHandler
---@field exitBtn UIKmlLuaControlHandler
local KLPrivilegeBossPosPanelView = {}
setmetatable(KLPrivilegeBossPosPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLPrivilegeBossPos/KLPrivilegeBossPosPanelKml'
---@param parent UIKmlLuaControlHandler
function KLPrivilegeBossPosPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLPrivilegeBossPosPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Panel/KLPrivilegeBossPos/KLPrivilegeBossPosPanel']

return KLPrivilegeBossPosPanelView
