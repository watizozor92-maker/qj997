---@class KLChallengeBossPanelView:UIKmlLuaViewBase
---@field challenge_boss_panel UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field trade_bg UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field img_interface UIKmlLuaControlHandler
---@field btn_close UIKmlLuaControlHandler
---@field boss_type_toggle_group UIKmlLuaControlHandler
---@field butten_layout UIKmlLuaControlHandler
---@field boss_1 UIKmlLuaControlHandler
---@field boss_1_toggle UIKmlLuaControlHandler
---@field boss_1_toggle_t UIKmlLuaControlHandler
---@field boss_2 UIKmlLuaControlHandler
---@field boss_2_toggle UIKmlLuaControlHandler
---@field boss_2_toggle_t UIKmlLuaControlHandler
---@field boss_4 UIKmlLuaControlHandler
---@field boss_4_toggle UIKmlLuaControlHandler
---@field boss_4_toggle_t UIKmlLuaControlHandler
---@field boss_5 UIKmlLuaControlHandler
---@field boss_5_toggle UIKmlLuaControlHandler
---@field boss_5_toggle_t UIKmlLuaControlHandler
---@field boss_6 UIKmlLuaControlHandler
---@field boss_6_toggle UIKmlLuaControlHandler
---@field boss_6_toggle_t UIKmlLuaControlHandler
---@field boss_7 UIKmlLuaControlHandler
---@field boss_7_toggle UIKmlLuaControlHandler
---@field boss_7_toggle_t UIKmlLuaControlHandler
---@field boss_8 UIKmlLuaControlHandler
---@field boss_8_toggle UIKmlLuaControlHandler
---@field boss_8_toggle_t UIKmlLuaControlHandler
---@field text1 UIKmlLuaControlHandler
local KLChallengeBossPanelView = {}
setmetatable(KLChallengeBossPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanelKml'
---@param parent UIKmlLuaControlHandler
function KLChallengeBossPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLChallengeBossPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel']

return KLChallengeBossPanelView
