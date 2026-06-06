---@class KLUIPrivilegeBossItemView:UIKmlLuaViewBase
---@field privilege_boss_panel UIKmlLuaControl
---@field img_59 UIKmlLuaControl
---@field privilege_boss_select UIKmlLuaControl
---@field privilege_boss_level_data_list UIKmlLuaControl
---@field tequan_boss_right_panel UIKmlLuaControl
---@field img_63 UIKmlLuaControl
---@field privilege_boss_name UIKmlLuaControl
---@field privilege_boss_path_root UIKmlLuaControl
---@field privilege_boss_path UIKmlLuaControl
---@field img_67 UIKmlLuaControl
---@field tequan_boss掉落title UIKmlLuaControl
---@field tequan_boss_select UIKmlLuaControl
---@field privilege_boss_reward_data_list UIKmlLuaControl
---@field tishi UIKmlLuaControl
---@field privilege_boss_join_btn UIKmlLuaControl
---@field shengyu UIKmlLuaControl
---@field privilege_boss_last_num UIKmlLuaControl
---@field tequan_boss_Integral_BG UIKmlLuaControl
---@field tequan_boss_Integral_Text UIKmlLuaControl
local KLUIPrivilegeBossItemView = {}
setmetatable(KLUIPrivilegeBossItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIPrivilegeBoss/KLUIPrivilegeBossItemKml'
---@param parent UIKmlLuaControl
function KLUIPrivilegeBossItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIPrivilegeBossItemView
