---@class KLKuaFuBossInfoItemView:UIKmlLuaViewBase
---@field panel1 UIKmlLuaControlHandler
---@field img_90 UIKmlLuaControlHandler
---@field privilege_boss_select UIKmlLuaControlHandler
---@field privilege_boss_level_data_list UIKmlLuaControlHandler
---@field tequan_boss_right_panel UIKmlLuaControlHandler
---@field img_94 UIKmlLuaControlHandler
---@field privilege_boss_name UIKmlLuaControlHandler
---@field boss_root UIKmlLuaControlHandler
---@field privilege_boss_path UIKmlLuaControlHandler
---@field img_97 UIKmlLuaControlHandler
---@field dropTitleText UIKmlLuaControlHandler
---@field tequan_boss_select UIKmlLuaControlHandler
---@field privilege_boss_reward_data_list UIKmlLuaControlHandler
---@field tipText UIKmlLuaControlHandler
---@field reviveText UIKmlLuaControlHandler
---@field txt_countDown UIKmlLuaControlHandler
---@field btn_goNow UIKmlLuaControlHandler
---@field img_tip UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field Integral_BG UIKmlLuaControlHandler
---@field Integral_Text UIKmlLuaControlHandler
local KLKuaFuBossInfoItemView = {}
setmetatable(KLKuaFuBossInfoItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLKuaFuBossInfo/KLKuaFuBossInfoItemKml'
---@param parent UIKmlLuaControlHandler
function KLKuaFuBossInfoItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLKuaFuBossInfoItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLKuaFuBossInfo/KLKuaFuBossInfoItem']

return KLKuaFuBossInfoItemView
