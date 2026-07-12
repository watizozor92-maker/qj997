---@class KLUIGoldBossItemView:UIKmlLuaViewBase
---@field gold_boss_panel UIKmlLuaControlHandler
---@field bg_prop UIKmlLuaControlHandler
---@field gold_boss_select UIKmlLuaControlHandler
---@field gold_boss_level UIKmlLuaControlHandler
---@field gold_boss_view UIKmlLuaControlHandler
---@field gold_boss_data_list UIKmlLuaControlHandler
---@field img_39 UIKmlLuaControlHandler
---@field gold_boss_reward_view UIKmlLuaControlHandler
---@field gold_boss_reward UIKmlLuaControlHandler
local KLUIGoldBossItemView = {}
setmetatable(KLUIGoldBossItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIGoldBoss/KLUIGoldBossItemKml'
---@param parent UIKmlLuaControlHandler
function KLUIGoldBossItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUIGoldBossItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLUIGoldBoss/KLUIGoldBossItem']

return KLUIGoldBossItemView
