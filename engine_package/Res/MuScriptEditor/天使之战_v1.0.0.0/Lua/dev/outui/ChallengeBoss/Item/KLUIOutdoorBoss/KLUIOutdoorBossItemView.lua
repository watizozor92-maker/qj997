---@class KLUIOutdoorBossItemView:UIKmlLuaViewBase
---@field outdoor_boss_panel UIKmlLuaControlHandler
---@field img_43 UIKmlLuaControlHandler
---@field outdoor_boss_select UIKmlLuaControlHandler
---@field outdoor_boss_level_data_list UIKmlLuaControlHandler
---@field 野外_boss_right_panel UIKmlLuaControlHandler
---@field namePanel UIKmlLuaControlHandler
---@field img_47 UIKmlLuaControlHandler
---@field outdoor_boss_name UIKmlLuaControlHandler
---@field outdoor_boss_path_root UIKmlLuaControlHandler
---@field outdoor_boss_path UIKmlLuaControlHandler
---@field RewardTitle UIKmlLuaControlHandler
---@field img_52 UIKmlLuaControlHandler
---@field 野外_boss掉落title UIKmlLuaControlHandler
---@field 野外_boss_select UIKmlLuaControlHandler
---@field outdoor_boss_reward_data_list UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field img_522 UIKmlLuaControlHandler
---@field title22 UIKmlLuaControlHandler
---@field die_time UIKmlLuaControlHandler
---@field 野外boss_路线 UIKmlLuaControlHandler
---@field outdoor_boss_line_data_list UIKmlLuaControlHandler
---@field outdoor_boss_Integral_BG UIKmlLuaControlHandler
---@field outdoor_boss_Integral_Text UIKmlLuaControlHandler
---@field recommend_panel UIKmlLuaControlHandler
---@field recommend_def UIKmlLuaControlHandler
---@field recommend_atk UIKmlLuaControlHandler
local KLUIOutdoorBossItemView = {}
setmetatable(KLUIOutdoorBossItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLUIOutdoorBoss/KLUIOutdoorBossItemKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLUIOutdoorBossItemView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
return KLUIOutdoorBossItemView
