-- 此文件工具自动生成，不要修改
---@class cfg_MainPanelUI_column
---id
---@field id number @id column=1 A
---每个面板由程序设定
---@field UipanelName string @面板名 column=2 B
---备注：策划参考
---@field dec string @备注 column=3 C
---系统标识
---@field systemId string @系统标识 column=4 D
---格式：x轴#y轴
---按钮位置，中心点为面板中心
---
---无用字段
---@field positionOffset IntList @按钮位置 column=5 E
---格式：贴图名称
---程序定好路径后，告诉策划
---@field BtnImage string @按钮贴图 column=6 F
---按钮显示位置
---1主页功能界面右侧
---2主页功能界面上侧
---3系统界面内
---@field displayLocation number @按钮位置 column=7 G
---从小到大排序
---@field sort number @系统界面内排序 column=8 H
---收缩
---@field shrink number @收缩 column=9 I
---打开按钮展开对应的而界面
---@field command string @快捷指令 column=10 J
---按钮名称由程序定
---@field btnName string @按钮名称 column=11 K
---添加平台标识，用于不同平台的界面切换
---0或不填默认安卓，1=PC
---@field platformTags IntList @平台标识 column=12 L
---1不开启显示
---0或空 开启显示
---@field showon number @是否隐藏显示 column=13 M
---按钮名称偏移会影响字体清晰度
---@field iconOffset IntList @按钮名称偏移 column=14 N

local local_positionOffset = {
    positionOffset_1={},
    positionOffset_2={-40,-490},

}

local local_platformTags = {
    platformTags_1={0,1},
    platformTags_2={},

}

local local_iconOffset = {
    iconOffset_1={},

}

local cfg_MainPanelUI =
{
	{id=101, UipanelName="KLSettingTogglePanel", dec="设置", systemId="设    置", positionOffset=local_positionOffset.positionOffset_2, BtnImage="btn_shezhi", displayLocation=3, sort=9, shrink=0, command="dev/ui/Setting/Panel/KLSettingToggle/KLSettingTogglePanel", btnName="BtnSetting", platformTags=local_platformTags.platformTags_1, showon=1},
	{id=102, UipanelName="KLUISkillInfoPanel", dec="技能", systemId="技能", BtnImage="btn_jineng", displayLocation=3, sort=1, shrink=0, command="dev/ui/Skill/Panel/KLUISkillInfo/KLUISkillInfoPanel", btnName="button_jineng", platformTags=local_platformTags.platformTags_1, showon=1},
	{id=103, UipanelName="KLMailPanel", dec="邮件", systemId="邮    件", positionOffset={-106,-490}, BtnImage="icon_youjian", displayLocation=3, sort=8, shrink=0, command="dev/ui/Mail/Panel/KLMail/KLMailPanel", btnName="BtnMail"},
	{id=104, UipanelName="KLUIForgeGroupPanel", dec="锻造", systemId="锻    造", positionOffset={-40,-292}, BtnImage="icon_duanzao", displayLocation=1, sort=6, shrink=0, command="dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel", btnName="BtnForge", showon=1},
	{id=105, UipanelName="KLUnionToggleListPanel", dec="战盟", systemId="战    盟", positionOffset={-172,-424}, BtnImage="icon_zhanmeng", displayLocation=1, sort=5, shrink=0, command="dev/ui/Union/Panel/KLUnionToggleList/KLUnionToggleListPanel", btnName="BtnUnion"},
	{id=107, UipanelName="KLUIBagPanel", dec="背包", systemId="背包", positionOffset={25,-76}, BtnImage="btn_beibao", displayLocation=0, shrink=0, command="dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel", btnName="BtnBag"},
	{id=108, UipanelName="UIAssistantBtnPanel", dec="好友", systemId="好    友", BtnImage="icon_haoyou", displayLocation=3, sort=3, shrink=0, command="dev/ui/FriendSys/Panel/KLFriendMain/KLFriendMainPanel", btnName="BtnFriend"},
	{id=109, UipanelName="KLAppearGroupPanel", dec="称号", systemId="称    号", BtnImage="btn_chenghao", displayLocation=3, sort=1, shrink=0, command="dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel", btnName="BtnDress", showon=1},
	{id=110, UipanelName="KLUIMasterTalentMainPanel", dec="天赋", systemId="天赋", positionOffset={20,20}, BtnImage="btn_talent", displayLocation=3, sort=2, shrink=0, command="dev/outui/MasterTalent/Panel/KLMasterTalentNew/KLMasterTalentNewPanel", btnName="BtnMasterRoad"},
	{id=111, UipanelName="KLAttrPanel", dec="角色加点", systemId="角色", BtnImage="btn_jiadian", displayLocation=3, sort=1, shrink=0, command="dev/ui/Role/Panel/KLAttr/KLAttrPanel", btnName="BtnRole", showon=1},
	{id=112, UipanelName="KLShapeShiftCardMainPanel", dec="变身卡牌功能按钮", systemId="变身卡牌功能", BtnImage="icon_taitanwuzhuang", displayLocation=1, command="dev/outui/ShapeShiftCard/Panel/KLShapeShiftCardMain/KLShapeShiftCardMainPanel", btnName="BtnCard"},
	{id=113, UipanelName="", dec="变身卡牌变身按钮", systemId="变身卡牌变身", positionOffset={-217,-242}, BtnImage="btn_main_bskp", displayLocation=0, shrink=0, command="", btnName="BtnShapeshift"},
	{id=202, UipanelName="KLShopMallPanel", dec="商城", systemId="商城", positionOffset={424.2,-43.9}, BtnImage="btn_shangcheng", displayLocation=3, sort=11, command="dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel", btnName="BtnShop"},
	{id=204, UipanelName="KLEfficiencyNewPanel", dec="效率", systemId="效率", BtnImage="btn_xiaolv", command="dev/outui/Efficiency/Panel/KLEfficiencyNew/KLEfficiencyNewPanel", btnName="BtnEfficiency"},
	{id=206, UipanelName="KLBossOfferRewardPanel", dec="悬赏", systemId="悬赏", BtnImage="btn_xuanshang", command="dev/outui/BossOfferReward/Panel/KLBossOfferReward/KLBossOfferRewardPanel", btnName="BtnOfferAReward"},
	{id=207, UipanelName="KLSiegeMainPanel", dec="攻城战", systemId="攻城战", BtnImage="btn_gongchengzhan", displayLocation=3, command="dev/outui/LoranSiege/Panel/KLSiegeMain/KLSiegeMainPanel", btnName="BtnCityWar"},
	{id=209, dec="会员", systemId="会员", BtnImage="btn_chaojiVIP2", sort=12, command="dev/outui/VIP/Panel/KLNewVIPMain/KLNewVIPMainPanel", btnName="BtnVIP"},
	{id=211, dec="跨服", systemId="跨服", BtnImage="btn_kuafu", command="dev/outui/CrossServer/Panel/KLCrossServerMain/KLCrossServerPanel", btnName="BtnKuaFu"},
	{id=212, UipanelName="KLDailyGoalMainPanel", dec="每日目标", systemId="每日目标", BtnImage="btn_meirimubiao", command="dev/outui/DailyGoal/Panel/KLDailyGoalMain/KLDailyGoalMainPanel", btnName="BtnDaily"},
	{id=213, dec="排行榜", systemId="排 行 榜", BtnImage="icon_paihang", displayLocation=3, sort=7, command="dev/outui/UIRankList/Panel/KLUIRankList/KLUIRankListPanel", btnName="BtnRankList"},
	{id=214, dec="挂机", systemId="挂机", BtnImage="btn_guaji", sort=4, command="dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel", btnName="BtnOffline"},
	{id=215, UipanelName="KLChallengeBossPanel", dec="挑战首领", systemId="挑战首领", positionOffset={0,0}, BtnImage="Btn_shoulingtiaozhan", displayLocation=3, sort=1, command="dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel", btnName="BtnBoss"},
	{id=218, UipanelName="KLEarningsPanel", dec="三倍收益", systemId="三倍收益", BtnImage="btn_earnings", command="dev/outui/ThreeEarnings/Panel/KLEarnings/KLEarningsPanel", btnName="BtnEarnings"},
	{id=220, UipanelName="KLDragonSoulComboPanel", dec="龙魂连击", systemId="龙魂连击", BtnImage="btn_longhunlianji", command="dev/outui/DragonSoulCombo/Panel/KLDragonSoulCombo/KLDragonSoulComboPanel", btnName="BtnCombo"},
	{id=221, UipanelName="KLMainRechargePanel", dec="福利", systemId="福利", BtnImage="btn_fuli", command="dev/outui/MainRecharge/Panel/KLMainRecharge/KLMainRechargePanel", btnName="BtnRecharge"},
	{id=222, UipanelName="KLMountPreferencePanel", dec="雷刃炎狼兽", systemId="雷刃炎狼兽", BtnImage="button_zuoqitehui", command="dev/outui/MountPreference/Panel/KLMountPreference/KLMountPreferencePanel", btnName="BtnMount"},
	{id=223, UipanelName="KLMainActivityPanel", dec="新服活动", systemId="新服活动", BtnImage="btn_kaifu", command="dev/outui/MainActivity/Panel/KLMainActivity/KLMainActivityPanel", btnName="dev/outui/MainActivity/Panel/KLMainActivity/KLMainActivityPanel"},
	{id=224, UipanelName="KLRechargeActivityPanel", dec="限时礼包", systemId="限时礼包", BtnImage="button_xianshilibao", command="dev/outui/Recharge/Panel/KLRechargeActivity/KLRechargeActivityPanel", btnName="BtnTimeLimitGift"},
	{id=225, UipanelName="KLMountPreferencePanel", dec="特惠礼包", systemId="特惠礼包", BtnImage="button_tuisonglibao", command="dev/outui/Recharge/Panel/KLRechargePush/KLRechargePushPanel", btnName="BtnRechargePush"},
	{id=226, UipanelName="KLHuntingDemonsMainPanel", dec="猎魔积分争霸赛", systemId="猎魔积分争霸赛", BtnImage="btn_liemo", command="dev/outui/HuntingDemons/Panel/KLHuntingDemonsMain/KLHuntingDemonsMainPanel", btnName="BtnHuntingDemons"},
	{id=227, UipanelName="KLMainOperateActivityPanel", dec="运营活动", systemId="运营活动", BtnImage="btn_yueka", command="dev/outui/MainOperateActivity/Panel/KLMainOperateActivity/KLMainOperateActivityPanel", btnName="BtnOperateActivity"},
	{id=228, UipanelName="KLMainOperateActivityPanel", dec="运营活动2", systemId="运营活动2", BtnImage="btn_yueka", command="dev/outui/MainOperateActivity/Panel/KLMainOperateActivitySecond/KLMainOperateActivitySecondPanel", btnName="BtnOperateActivitySecond"},
	{id=229, UipanelName="KLFirstDropPanel", dec="装备首爆", systemId="装备首爆", BtnImage="Btn_zhuangbeishoubao", sort=5, command="dev/outui/FirstDrop/Panel/KLFirstDrop/KLFirstDropPanel", btnName="BtnFirstDrop", iconOffset={0,-0.5}},
	{id=230, UipanelName="KLMonthCardNewPanel", dec="月卡", systemId="月卡", BtnImage="btn_yueka", sort=2, shrink=1, command="dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel", btnName="BtnMonth"},
	{id=232, UipanelName="KLPreviewPanel", dec="攻略", systemId="攻略", BtnImage="Btn_gonglue", displayLocation=3, sort=6, command="dev/ui/Preview/Panel/KLPreview/KLPreviewPanel#togType=1", btnName="Btn_gonglue"},
	{id=234, UipanelName="KLMountStorePanel", dec="坐骑", systemId="坐    骑", BtnImage="icon_zuoqi", displayLocation=1, sort=4, command="dev/outui/Mount/Panel/KLMountStore/KLMountStorePanel", btnName="BtnMountStore"},
	{id=235, UipanelName="KLFashionEquipPanel", dec="时装", systemId="时装", BtnImage="icon_shizhuang", displayLocation=3, sort=2, command="dev/outui/FashionEquip/Panel/KLFashionEquip/KLFashionEquipPanel", btnName="Btnfashion"},
	{id=236, UipanelName="KLPreviewPanel", dec="玩法", systemId="玩法", BtnImage="Btn_wanfa", sort=7, command="dev/ui/Preview/Panel/KLPreview/KLPreviewPanel#togType=2", btnName="Btn_wanfa"},
	{id=237, UipanelName="KLLianJiPanel", dec="连击", systemId="连击", BtnImage="icon_lianji", displayLocation=1, command="dev/outui/LianJi/Panel/KLLianJi/KLLianJiPanel", btnName="btn_lianji"},
	{id=238, UipanelName="KLSystemFunctionPanel", dec="系统", systemId="系统", positionOffset=local_positionOffset.positionOffset_2, BtnImage="icon_lianji", displayLocation=1, command="dev/outui/MainUI/Panel/KLSystemFunction/KLSystemFunctionPanel", btnName="BtnSystem"},
	{id=239, UipanelName="KLTradeMainPanel", dec="交易", systemId="交易", BtnImage="btn_trade", displayLocation=3, sort=3, shrink=1, command="dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel", btnName="btn_trade"},
	{id=240, UipanelName="KLActivityComboPanel", dec="卡利玛神庙", systemId="卡利玛神庙", BtnImage="icon_shenmiao", displayLocation=3, sort=10, command="dev/outui/Activity/Panel/KLActivityCombo/KLActivityComboPanel", btnName="BtnKaLiMa"},
	{id=241, UipanelName="KLArchangelGrailPanel", dec="圣杯", systemId="圣杯", BtnImage="btn_angel_equip", displayLocation=3, sort=3, command="dev/outui/Archangel/Panel/KLArchangelGroup/KLArchangelGroupPanel", btnName="btn_angel_equip"},
}

local defaults = {UipanelName="UIButtonUpPanel", positionOffset={}, displayLocation=2, sort=0, shrink=0, platformTags={}, showon=0, iconOffset={}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_MainPanelUI) do
	setmetatable(v, mt)
end

return cfg_MainPanelUI