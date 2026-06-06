---@class KLChallengeBossPosPanelView:UIKmlLuaViewBase
---@field challenge_boss_panel UIKmlLuaControl
---@field trade_bg UIKmlLuaControl
---@field img_interface UIKmlLuaControl
---@field btn_close UIKmlLuaControl
---@field boss_type_toggle_group UIKmlLuaControl
---@field butten_layout UIKmlLuaControl
---@field boss_1 UIKmlLuaControl
---@field boss_1_toggle UIKmlLuaControl
---@field boss_2 UIKmlLuaControl
---@field boss_2_toggle UIKmlLuaControl
---@field boss_3 UIKmlLuaControl
---@field boss_3_toggle UIKmlLuaControl
---@field gold_boss_panel UIKmlLuaControl
---@field gold_boss_select UIKmlLuaControl
---@field gold_boss_type_layout UIKmlLuaControl
---@field gold_boss_level UIKmlLuaControl
---@field gold_boss_view UIKmlLuaControl
---@field gold_boss_layout UIKmlLuaControl
---@field gold_boss_data_list UIKmlLuaControl
---@field bg_prop UIKmlLuaControl
---@field gold_boss_reward_view UIKmlLuaControl
---@field gold_boss_reward_layout UIKmlLuaControl
---@field gold_boss_reward UIKmlLuaControl
---@field outdoor_boss_panel UIKmlLuaControl
---@field outdoor_boss_select UIKmlLuaControl
---@field outdoor_boss_type_layout UIKmlLuaControl
---@field outdoor_boss_level_data_list UIKmlLuaControl
---@field 野外_boss_right_panel UIKmlLuaControl
---@field outdoor_boss_name UIKmlLuaControl
---@field outdoor_boss_path UIKmlLuaControl
---@field 野外_boss掉落title UIKmlLuaControl
---@field 野外_boss_select UIKmlLuaControl
---@field 野外_reward_list UIKmlLuaControl
---@field outdoor_boss_reward_data_list UIKmlLuaControl
---@field 野外boss_路线 UIKmlLuaControl
---@field 野外boss_路线_list UIKmlLuaControl
---@field outdoor_boss_line_data_list UIKmlLuaControl
---@field mi_boss_panel UIKmlLuaControl
---@field secret_boss_level_select UIKmlLuaControl
---@field 秘境_boss_type_layout UIKmlLuaControl
---@field secret_boss_level_data_list UIKmlLuaControl
---@field 秘境_boss_right_panel UIKmlLuaControl
---@field secret_boss_name UIKmlLuaControl
---@field secret_boss_path UIKmlLuaControl
---@field 掉落title UIKmlLuaControl
---@field 剩余 UIKmlLuaControl
---@field 剩余挑战次数num UIKmlLuaControl
---@field 秘境_boss_select UIKmlLuaControl
---@field 秘境_reward_list UIKmlLuaControl
---@field 秘境_reward_data_list UIKmlLuaControl
local KLPrivilegeBossPosPanelView = {}
setmetatable(KLPrivilegeBossPosPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Panel/KLPrivilegeBossPos/KLPrivilegeBossPosPanelKml'
---@param parent UIKmlLuaControl
function KLPrivilegeBossPosPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLPrivilegeBossPosPanelView
