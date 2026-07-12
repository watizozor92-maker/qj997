---@class KLUISkillSettingPanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1231 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img2 UIKmlLuaControlHandler
---@field KmlXWFastSkillUI UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field Title_Str UIKmlLuaControlHandler
---@field ShowTypes UIKmlLuaControlHandler
---@field togShowGroup UIKmlLuaControlHandler
---@field togPattern UIKmlLuaControlHandler
---@field BtnAllTxt UIKmlLuaControlHandler
---@field BtnTurnTxt UIKmlLuaControlHandler
---@field btnAllMask UIKmlLuaControlHandler
---@field btnTurnMask UIKmlLuaControlHandler
---@field toggroup_skill_bagItem UIKmlLuaControlHandler
---@field SkillBtnSetting UIKmlLuaControlHandler
---@field SkillBtnA UIKmlLuaControlHandler
---@field BagItemBtnSetting UIKmlLuaControlHandler
---@field SkillBtnB UIKmlLuaControlHandler
---@field BtnReset UIKmlLuaControlHandler
---@field FastItemList UIKmlLuaControlHandler
---@field FastItemDataList UIKmlLuaControlHandler
---@field groupAll UIKmlLuaControlHandler
---@field BodyAllSkill UIKmlLuaControlHandler
---@field panel_atk UIKmlLuaControlHandler
---@field AttackButton UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field BtnKillMonster UIKmlLuaControlHandler
---@field BtnKillPerson UIKmlLuaControlHandler
---@field TogAllSkill1 UIKmlLuaControlHandler
---@field AllSkillIcon1 UIKmlLuaControlHandler
---@field addIcon1 UIKmlLuaControlHandler
---@field TogAllSkill2 UIKmlLuaControlHandler
---@field AllSkillIcon2 UIKmlLuaControlHandler
---@field addIcon2 UIKmlLuaControlHandler
---@field TogAllSkill3 UIKmlLuaControlHandler
---@field AllSkillIcon3 UIKmlLuaControlHandler
---@field addIcon3 UIKmlLuaControlHandler
---@field TogAllSkill4 UIKmlLuaControlHandler
---@field AllSkillIcon4 UIKmlLuaControlHandler
---@field addIcon4 UIKmlLuaControlHandler
---@field TogAllSkill5 UIKmlLuaControlHandler
---@field AllSkillIcon5 UIKmlLuaControlHandler
---@field addIcon5 UIKmlLuaControlHandler
---@field TogAllSkill6 UIKmlLuaControlHandler
---@field AllSkillIcon6 UIKmlLuaControlHandler
---@field addIcon6 UIKmlLuaControlHandler
---@field TogAllSkill7 UIKmlLuaControlHandler
---@field AllSkillIcon7 UIKmlLuaControlHandler
---@field addIcon7 UIKmlLuaControlHandler
---@field BgMain UIKmlLuaControlHandler
---@field MainSkill UIKmlLuaControlHandler
---@field groupTurn UIKmlLuaControlHandler
---@field img3 UIKmlLuaControlHandler
---@field SpTag UIKmlLuaControlHandler
---@field TxtTitle UIKmlLuaControlHandler
---@field BodyTurnSkill UIKmlLuaControlHandler
---@field TogTurnSkill1 UIKmlLuaControlHandler
---@field TurnSkillIcon1 UIKmlLuaControlHandler
---@field TogTurnSkill2 UIKmlLuaControlHandler
---@field TurnSkillIcon2 UIKmlLuaControlHandler
---@field TogTurnSkill3 UIKmlLuaControlHandler
---@field TurnSkillIcon3 UIKmlLuaControlHandler
---@field TogTurnSkill4 UIKmlLuaControlHandler
---@field TurnSkillIcon4 UIKmlLuaControlHandler
---@field TogTurnSkill5 UIKmlLuaControlHandler
---@field TurnSkillIcon5 UIKmlLuaControlHandler
---@field TogTurnSkill6 UIKmlLuaControlHandler
---@field TurnSkillIcon6 UIKmlLuaControlHandler
---@field TogTurnSkill7 UIKmlLuaControlHandler
---@field TurnSkillIcon7 UIKmlLuaControlHandler
---@field TogTurnSkill8 UIKmlLuaControlHandler
---@field TurnSkillIcon8 UIKmlLuaControlHandler
---@field MainSkill UIKmlLuaControlHandler
local KLUISkillSettingPanelView = {}
setmetatable(KLUISkillSettingPanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanelKml'
---@param parent UIKmlLuaControlHandler
function KLUISkillSettingPanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISkillSettingPanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Skill/Panel/KLUISkillSetting/KLUISkillSettingPanel']

return KLUISkillSettingPanelView
