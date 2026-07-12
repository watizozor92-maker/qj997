---@class KLUIPrivilegeBossItemView:UIKmlLuaViewBase
---@field privilege_boss_panel UIKmlLuaControlHandler
---@field img_59 UIKmlLuaControlHandler
---@field privilege_boss_select UIKmlLuaControlHandler
---@field privilege_boss_level_data_list UIKmlLuaControlHandler
---@field tequan_boss_right_panel UIKmlLuaControlHandler
---@field img_63 UIKmlLuaControlHandler
---@field privilege_boss_name UIKmlLuaControlHandler
---@field privilege_boss_path_root UIKmlLuaControlHandler
---@field privilege_boss_path UIKmlLuaControlHandler
---@field img_67 UIKmlLuaControlHandler
---@field tequan_boss掉落title UIKmlLuaControlHandler
---@field tequan_boss_select UIKmlLuaControlHandler
---@field privilege_boss_reward_data_list UIKmlLuaControlHandler
---@field tishi UIKmlLuaControlHandler
---@field privilege_boss_join_btn UIKmlLuaControlHandler
---@field shengyu UIKmlLuaControlHandler
---@field privilege_boss_last_num UIKmlLuaControlHandler
---@field tequan_boss_Integral_BG UIKmlLuaControlHandler
---@field tequan_boss_Integral_Text UIKmlLuaControlHandler
local KLUIPrivilegeBossItemView = {}
setmetatable(KLUIPrivilegeBossItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIPrivilegeBoss/KLUIPrivilegeBossItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIPrivilegeBossItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIPrivilegeBossItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUIPrivilegeBoss/KLUIPrivilegeBossItem']

return KLUIPrivilegeBossItemView
