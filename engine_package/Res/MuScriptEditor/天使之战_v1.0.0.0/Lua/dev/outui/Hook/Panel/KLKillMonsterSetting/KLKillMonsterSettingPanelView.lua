---@class KLKillMonsterSettingPanelView:UIKmlLuaViewBase
---@field Node UIKmlLuaControlHandler
---@field panel2 UIKmlLuaControlHandler
---@field togglegMp UIKmlLuaControlHandler
---@field toggleSetting UIKmlLuaControlHandler
---@field toggleHp UIKmlLuaControlHandler
---@field leftNode UIKmlLuaControlHandler
---@field img32 UIKmlLuaControlHandler
---@field layout35 UIKmlLuaControlHandler
---@field toggle_1 UIKmlLuaControlHandler
---@field toggle_pos_1 UIKmlLuaControlHandler
---@field img4 UIKmlLuaControlHandler
---@field toggle_2 UIKmlLuaControlHandler
---@field toggle_pos_2 UIKmlLuaControlHandler
---@field img10 UIKmlLuaControlHandler
---@field toggle_3 UIKmlLuaControlHandler
---@field toggle_pos_3 UIKmlLuaControlHandler
---@field img13 UIKmlLuaControlHandler
---@field toggle_4 UIKmlLuaControlHandler
---@field toggle_pos_4 UIKmlLuaControlHandler
---@field img17 UIKmlLuaControlHandler
---@field toggle_5 UIKmlLuaControlHandler
---@field toggle_pos_5 UIKmlLuaControlHandler
---@field img20 UIKmlLuaControlHandler
---@field toggle_6 UIKmlLuaControlHandler
---@field toggle_pos_6 UIKmlLuaControlHandler
---@field img7 UIKmlLuaControlHandler
---@field toggle_7 UIKmlLuaControlHandler
---@field toggle_pos_7 UIKmlLuaControlHandler
---@field img26 UIKmlLuaControlHandler
---@field toggle_8 UIKmlLuaControlHandler
---@field toggle_pos_8 UIKmlLuaControlHandler
---@field img29 UIKmlLuaControlHandler
---@field input_time UIKmlLuaControlHandler
---@field Text_attach UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field txtPos UIKmlLuaControlHandler
---@field combackHookBtn UIKmlLuaControlHandler
---@field img_monster UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field text2 UIKmlLuaControlHandler
---@field NoNAtt UIKmlLuaControlHandler
---@field noAttackBtn UIKmlLuaControlHandler
---@field topNode UIKmlLuaControlHandler
---@field layout20 UIKmlLuaControlHandler
---@field img12 UIKmlLuaControlHandler
---@field img14 UIKmlLuaControlHandler
---@field text15 UIKmlLuaControlHandler
---@field node_hp UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field sliderHP UIKmlLuaControlHandler
---@field sliderHPText UIKmlLuaControlHandler
---@field ndoe_mp UIKmlLuaControlHandler
---@field sliderMP UIKmlLuaControlHandler
---@field sliderMPText UIKmlLuaControlHandler
---@field text21 UIKmlLuaControlHandler
---@field toggle_skill UIKmlLuaControlHandler
---@field rightNode UIKmlLuaControlHandler
---@field panel10 UIKmlLuaControlHandler
---@field planToggle1 UIKmlLuaControlHandler
---@field text19 UIKmlLuaControlHandler
---@field planToggle2 UIKmlLuaControlHandler
---@field text27 UIKmlLuaControlHandler
---@field HookSkillContainer UIKmlLuaControlHandler
---@field gridview7 UIKmlLuaControlHandler
---@field skill_node_title UIKmlLuaControlHandler
---@field img19 UIKmlLuaControlHandler
---@field text20 UIKmlLuaControlHandler
---@field img5 UIKmlLuaControlHandler
---@field panel1 UIKmlLuaControlHandler
local KLKillMonsterSettingPanelView = {}
setmetatable(KLKillMonsterSettingPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/outui/Hook/Panel/KLKillMonsterSetting/KLKillMonsterSettingPanelKml'
---@param parent UIKmlLuaControlHandler
function KLKillMonsterSettingPanelView:Init(parent)
    self:InitRoot(parent,kmlPath)
end
---@type KLKillMonsterSettingPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/outui/Hook/Panel/KLKillMonsterSetting/KLKillMonsterSettingPanel']

return KLKillMonsterSettingPanelView
