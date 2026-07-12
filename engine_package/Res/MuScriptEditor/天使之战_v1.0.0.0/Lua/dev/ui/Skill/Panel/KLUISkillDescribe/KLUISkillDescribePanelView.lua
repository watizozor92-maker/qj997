---@class KLUISkillDescribePanelView:UIKmlLuaViewBase
---@field BG_Templete UIKmlLuaControlHandler
---@field ReMask UIKmlLuaControlHandler
---@field img1231 UIKmlLuaControlHandler
---@field Frame UIKmlLuaControlHandler
---@field img1 UIKmlLuaControlHandler
---@field BgWnd UIKmlLuaControlHandler
---@field closeBtn UIKmlLuaControlHandler
---@field beijing1 UIKmlLuaControlHandler
---@field BgSkill UIKmlLuaControlHandler
---@field skillIcon UIKmlLuaControlHandler
---@field left UIKmlLuaControlHandler
---@field right UIKmlLuaControlHandler
---@field title_str UIKmlLuaControlHandler
---@field SkillName UIKmlLuaControlHandler
---@field showCondition UIKmlLuaControlHandler
---@field SpTag1 UIKmlLuaControlHandler
---@field TxtTitle1 UIKmlLuaControlHandler
---@field skilldesNode UIKmlLuaControlHandler
---@field SpTag2 UIKmlLuaControlHandler
---@field TxtTitle2 UIKmlLuaControlHandler
---@field tips UIKmlLuaControlHandler
---@field scrollview1 UIKmlLuaControlHandler
---@field layout2 UIKmlLuaControlHandler
---@field desc1 UIKmlLuaControlHandler
---@field Unlearned UIKmlLuaControlHandler
---@field SpTag5 UIKmlLuaControlHandler
---@field SpTag7 UIKmlLuaControlHandler
---@field levelTxt1 UIKmlLuaControlHandler
---@field skillDes1 UIKmlLuaControlHandler
---@field nextLevel UIKmlLuaControlHandler
---@field desc2 UIKmlLuaControlHandler
---@field maxLevelTips UIKmlLuaControlHandler
---@field SpTag6 UIKmlLuaControlHandler
---@field levelTxt2 UIKmlLuaControlHandler
---@field skillDes2 UIKmlLuaControlHandler
---@field CostShow UIKmlLuaControlHandler
---@field CostTips UIKmlLuaControlHandler
---@field TxtPrefix UIKmlLuaControlHandler
---@field costCount UIKmlLuaControlHandler
---@field costItem UIKmlLuaControlHandler
---@field BtnLearn UIKmlLuaControlHandler
---@field bgCondition UIKmlLuaControlHandler
---@field conditionList UIKmlLuaControlHandler
---@field ConditionLayout_1 UIKmlLuaControlHandler
---@field bingo1 UIKmlLuaControlHandler
---@field Condition_1 UIKmlLuaControlHandler
---@field ConditionLayout_2 UIKmlLuaControlHandler
---@field bingo2 UIKmlLuaControlHandler
---@field Condition_2 UIKmlLuaControlHandler
---@field ConditionLayout_3 UIKmlLuaControlHandler
---@field bingo3 UIKmlLuaControlHandler
---@field Condition_3 UIKmlLuaControlHandler
---@field ConditionLayout_4 UIKmlLuaControlHandler
---@field btnArrow UIKmlLuaControlHandler
---@field bgAttr UIKmlLuaControlHandler
---@field attrList UIKmlLuaControlHandler
---@field attrData UIKmlLuaControlHandler
---@field bingo4 UIKmlLuaControlHandler
---@field Condition_4 UIKmlLuaControlHandler
---@field scrollview2 UIKmlLuaControlHandler
---@field layout3 UIKmlLuaControlHandler
---@field newDesc UIKmlLuaControlHandler
---@field layout6 UIKmlLuaControlHandler
---@field text7 UIKmlLuaControlHandler
---@field gridview1 UIKmlLuaControlHandler
---@field layout9 UIKmlLuaControlHandler
---@field text8 UIKmlLuaControlHandler
---@field Text_SkillAtk UIKmlLuaControlHandler
---@field layout11 UIKmlLuaControlHandler
---@field text12 UIKmlLuaControlHandler
---@field Text_RangeValue UIKmlLuaControlHandler
---@field layout14 UIKmlLuaControlHandler
---@field text15 UIKmlLuaControlHandler
---@field Text_MpValue UIKmlLuaControlHandler
---@field layout17 UIKmlLuaControlHandler
---@field text18 UIKmlLuaControlHandler
---@field Text_AGValue UIKmlLuaControlHandler
local KLUISkillDescribePanelView = {}
setmetatable(KLUISkillDescribePanelView,UIKmlLuaViewBase)
local kmlPath = 'dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanelKml'
---@param parent UIKmlLuaControlHandler
function KLUISkillDescribePanelView:Init(parent)
    
    self:InitRoot(parent,kmlPath)
end
---@type KLUISkillDescribePanel 这里可以添加界面的数据处理
local this = SL:Get_Package().loaded['dev/ui/Skill/Panel/KLUISkillDescribe/KLUISkillDescribePanel']

return KLUISkillDescribePanelView
