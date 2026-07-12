---@class KLUISanctuaryBossItemView:UIKmlLuaViewBase
---@field sanctuary_boss_panel UIKmlLuaControlHandler
---@field img_98 UIKmlLuaControlHandler
---@field sanctuary_boss_level_select UIKmlLuaControlHandler
---@field sanctuary_boss_level_data_list UIKmlLuaControlHandler
---@field sanctuary_boss_right_panel UIKmlLuaControlHandler
---@field img_102 UIKmlLuaControlHandler
---@field sanctuary_boss_name UIKmlLuaControlHandler
---@field sanctuary_boss_line UIKmlLuaControlHandler
---@field sanctuary_boss_line_data_list UIKmlLuaControlHandler
---@field sanctuary_boss_path_root UIKmlLuaControlHandler
---@field sanctuary_boss_path UIKmlLuaControlHandler
---@field sanctuary_box_img UIKmlLuaControlHandler
---@field sanctuary_boss_box UIKmlLuaControlHandler
---@field sanctuary_reward_box_data_list UIKmlLuaControlHandler
---@field img_103 UIKmlLuaControlHandler
---@field img_104 UIKmlLuaControlHandler
---@field sanctuary_title UIKmlLuaControlHandler
---@field last_num UIKmlLuaControlHandler
---@field sanctuary_boss_select UIKmlLuaControlHandler
---@field sanctuary_reward_data_list UIKmlLuaControlHandler
---@field sanctuary_last_challenge_count_txt UIKmlLuaControlHandler
---@field sanctuary_box_text UIKmlLuaControlHandler
---@field sanctuary_last_challenge_count UIKmlLuaControlHandler
---@field sanctuary_boss_Integral_BG UIKmlLuaControlHandler
---@field sanctuary_boss_Integral_Text UIKmlLuaControlHandler
local KLUISanctuaryBossItemView = {}
setmetatable(KLUISanctuaryBossItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUISanctuaryBoss/KLUISanctuaryBossItemKml'
---@param parent UIKmlLuaControlHandler
function KLUISanctuaryBossItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISanctuaryBossItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUISanctuaryBoss/KLUISanctuaryBossItem']

return KLUISanctuaryBossItemView
