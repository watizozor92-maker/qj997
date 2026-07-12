---@class KLKunDunDevilItemView:UIKmlLuaViewBase
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
---@field Text_Tips UIKmlLuaControlHandler
---@field recommend_panel UIKmlLuaControlHandler
---@field recommend_def UIKmlLuaControlHandler
---@field recommend_atk UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field isKill_Img UIKmlLuaControlHandler
local KLKunDunDevilItemView = {}
setmetatable(KLKunDunDevilItemView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/ChallengeBoss/Item/KLKunDunDevil/KLKunDunDevilItemKml'
---@param parent UIKmlLuaControlHandler
function KLKunDunDevilItemView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLKunDunDevilItem 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/ChallengeBoss/Item/KLKunDunDevil/KLKunDunDevilItem']

return KLKunDunDevilItemView
