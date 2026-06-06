---@class KLGoldenTroopsItemView:UIKmlLuaViewBase
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
---@field DropTitle UIKmlLuaControlHandler
---@field img_52 UIKmlLuaControlHandler
---@field 野外_boss掉落title UIKmlLuaControlHandler
---@field 野外_boss_select UIKmlLuaControlHandler
---@field outdoor_boss_reward_data_list UIKmlLuaControlHandler
---@field RefreshTimeTitle UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field text5 UIKmlLuaControlHandler
---@field img6 UIKmlLuaControlHandler
---@field scrollview7 UIKmlLuaControlHandler
---@field DataList_RefreshTime UIKmlLuaControlHandler
---@field outdoor_boss_Integral_BG UIKmlLuaControlHandler
---@field outdoor_boss_Integral_Text UIKmlLuaControlHandler
---@field 野外boss_路线 UIKmlLuaControlHandler
---@field outdoor_boss_line_data_list UIKmlLuaControlHandler
---@field text13 UIKmlLuaControlHandler
---@field recommend_panel UIKmlLuaControlHandler
---@field recommend_def UIKmlLuaControlHandler
---@field recommend_atk UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field isKill_Img UIKmlLuaControlHandler
local KLGoldenTroopsItemView = {}
setmetatable(KLGoldenTroopsItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLGoldenTroops/KLGoldenTroopsItemKml'
---@param parent UIKmlLuaControlHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandlerHandler
function KLGoldenTroopsItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
return KLGoldenTroopsItemView
