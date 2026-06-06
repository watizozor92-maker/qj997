---@class KLUIGoldBossItemView:UIKmlLuaViewBase
---@field gold_boss_panel UIKmlLuaControl
---@field bg_prop UIKmlLuaControl
---@field gold_boss_select UIKmlLuaControl
---@field gold_boss_level UIKmlLuaControl
---@field gold_boss_view UIKmlLuaControl
---@field gold_boss_data_list UIKmlLuaControl
---@field img_39 UIKmlLuaControl
---@field gold_boss_reward_view UIKmlLuaControl
---@field gold_boss_reward UIKmlLuaControl
local KLUIGoldBossItemView = {}
setmetatable(KLUIGoldBossItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIGoldBoss/KLUIGoldBossItemKml'
---@param parent UIKmlLuaControl
function KLUIGoldBossItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIGoldBossItemView
