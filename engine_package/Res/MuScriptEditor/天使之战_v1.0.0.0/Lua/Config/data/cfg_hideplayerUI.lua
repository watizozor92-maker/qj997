-- 此文件工具自动生成，不要修改
---@class cfg_hideplayerUI_column
---id
---@field id number @id column=1 A
---备注：策划参考
---@field dec string @备注 column=2 B
---打开按钮展开对应的而界面
---@field command string @快捷指令 column=3 C
local cfg_hideplayerUI =
{
	{id=2, dec="邮件", command="dev/ui/Mail/Panel/KLMail/KLMailPanel"},
	{id=3, dec="坐骑", command="dev/outui/Mount/Panel/KLMountStore/KLMountStorePanel"},
	{id=4, dec="外观", command="dev/outui/AppearGroup/Panel/KLAppearGroup/KLAppearGroupPanel"},
	{id=5, dec="好友", command="dev/ui/FriendSys/Panel/KLFriendMain/KLFriendMainPanel"},
	{id=6, dec="锻造", command="dev/ui/UIForgeGroup/Panel/KLUIForgeGroup/KLUIForgeGroupPanel"},
	{id=7, dec="天赋", command="dev/outui/MasterTalent/Panel/KLUIMasterTalentMain/KLUIMasterTalentMainPanel"},
	{id=8, dec="交易", command="dev/outui/Trade/Panel/KLTradeMain/KLTradeMainPanel"},
	{id=9, dec="商城", command="dev/outui/ShopMain/Panel/KLShopMain/KLShopMainPanel"},
	{id=10, dec="攻城战", command="dev/outui/LoranSiege/Panel/KLSiegeMain/KLSiegeMainPanel"},
	{id=11, dec="排行榜", command="dev/outui/UIRankList/Panel/KLUIRankList/KLUIRankListPanel"},
	{id=12, dec="挂机", command="dev/outui/Hook/Panel/KLOnHook/KLOnHookPanel"},
	{id=13, dec="挑战首领", command="dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel"},
	{id=15, dec="大地图", command="dev/ui/Map/Panel/KLBigMap/KLBigMapPanel"},
	{id=23, dec="npc界面8", command="dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel"},
	{id=26, dec="npc界面11", command="dev/outui/Activity/Panel/KLActivityDetail/KLActivityDetailPanel"},
	{id=27, dec="npc界面12", command="dev/outui/Activity/Panel/KLBloodTip/KLBloodTipPanel"},
	{id=28, dec="聊天界面", command="dev/ui/Chat/Panel/KLUIChatPanel/KLUIChatPanel"},
	{id=29, dec="幻影导师对话", command="dev/ui/NPC/Panel/KLNPCTalk/KLNPCTalkPanel"},
	{id=30, dec="任务", command="dev/ui/Task/Panel/KLTaskFinish/KLTaskFinishPanel"},
	{id=31, dec="月卡", command="dev/outui/MonthCard/Panel/KLMonthCardNew/KLMonthCardNewPanel"},
	{id=32, dec="玩法攻略", command="dev/ui/Preview/Panel/KLPreview/KLPreviewPanel"},
	{id=33, dec="礼包兑换", command="dev/outui/ShopMain/Panel/KLCDKUse/KLCDKUsePanel"},
	{id=34, dec="连击", command="dev/outui/LianJi/Panel/KLLianJi/KLLianJiPanel"},
	{id=35, dec="地图切线", command="dev/ui/Map/Panel/KLUIMapBranch/KLUIMapBranchPanel"},
	{id=36, dec="npc界面13", command="dev/outui/Activity/Panel/KLRedFort/KLRedFortPanel"},
	{id=37, dec="组队界面", command="dev/ui/Team/Panel/KLUITeamMain/KLUITeamMainPanel"},
	{id=38, dec="挂机界面", command="dev/outui/Hook/Panel/KLHookHelp/KLHookHelpPanel"},
	{id=39, dec="充值", command="dev/outui/ShopMain/Panel/KLRecharge/KLRechargePanel"},
	{id=40, dec="角色", command="dev/ui/Role/Panel/KLAttr/KLAttrPanel"},
	{id=41, dec="背包", command="dev/ui/Bag/Panel/KLUIBag/KLUIBagPanel"},
}
return cfg_hideplayerUI