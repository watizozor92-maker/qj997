---@class KLKuaFuBossInfoItemView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControl
---@field img_90 UIKmlLuaControl
---@field privilege_boss_select UIKmlLuaControl
---@field privilege_boss_type_layout UIKmlLuaControl
---@field privilege_boss_level_data_list UIKmlLuaControl
---@field tequan_boss_right_panel UIKmlLuaControl
---@field img_94 UIKmlLuaControl
---@field privilege_boss_name UIKmlLuaControl
---@field boss_root UIKmlLuaControl
---@field privilege_boss_path UIKmlLuaControl
---@field img_97 UIKmlLuaControl
---@field dropTitleText UIKmlLuaControl
---@field tequan_boss_select UIKmlLuaControl
---@field privilege_reward_list UIKmlLuaControl
---@field privilege_boss_reward_data_list UIKmlLuaControl
---@field tipText UIKmlLuaControl
---@field reviveText UIKmlLuaControl
---@field txt_countDown UIKmlLuaControl
---@field btn_goNow UIKmlLuaControl
---@field img_tip UIKmlLuaControl
---@field text2 UIKmlLuaControl
---@field Integral_BG UIKmlLuaControl
---@field Integral_Text UIKmlLuaControl
local KLKuaFuBossInfoItemView = {}
setmetatable(KLKuaFuBossInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLKuaFuBossInfo/KLKuaFuBossInfoItemKml'
---@param parent UIKmlLuaControl
function KLKuaFuBossInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLKuaFuBossInfoItemView
