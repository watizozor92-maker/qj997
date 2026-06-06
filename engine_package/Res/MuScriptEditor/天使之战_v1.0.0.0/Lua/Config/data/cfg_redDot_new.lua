-- 此文件工具自动生成，不要修改
---@class cfg_redDot_new_column
---@field id number @序号 column=1 A
---作为备注使用
---[[客户端不使用]]@field name string @名称 column=2 B
---对应conditions表内的条件格式
---@field condition string @条件 column=3 C
---控件路径
---格式：界面位置#界面按钮#1或者界面名称#界面按钮#1
---界面按钮从mainpaneui里
---
---@field windowsWidgetID StringListList @红点主窗口控件ID column=4 D
---红点位置偏移 偏移中心点为控件中心
---格式：x轴偏移#y轴偏移|x轴偏移#y轴偏移
---@field positionOffset IntListList @红点位置偏移 column=5 E
---0，不开启
---1，开启
---@field active number @红点是否开启 column=6 F

local local_windowsWidgetID = {
    windowsWidgetID_1={{"KLMainOperateActivityPanel","tog_lottery","1"},{"KLUISystemTopPanel","BtnOperateActivity","1"}},
    windowsWidgetID_2={{"KLMainOperateActivityPanel","tog_lottery","1"},{"KLUISystemTopPanel","BtnOperateActivitySecond","1"}},
    windowsWidgetID_3={{"KLUISystemTopPanel","BtnOperateActivitySecond","1"}},

}

local local_positionOffset = {
    positionOffset_1={{20,20}},
    positionOffset_2={{20,25},{25,30}},
    positionOffset_3={{20,20},{20,20}},
    positionOffset_4={{20,25}},

}

local cfg_redDot_new =
{
	{id=80, condition="checkFruitItem=1", windowsWidgetID={{"KLUISystemLeftPanel","BtnRole","1"},{"KLAttrPanel","appleButton","1"}}, positionOffset={{20,20},{20,20},{20,20},{20,20}}},
	{id=81, condition="checkBossOfferReward=1", windowsWidgetID={{"KLUISystemTopPanel","BtnOfferAReward","1"}}},
	{id=82, condition="checkHookNewMapAndReward=1", windowsWidgetID={{"KLUISystemTopPanel","BtnOffline","1"}}},
	{id=83, condition="checkHookReward=1", windowsWidgetID={{"KLOnHookPanel","HookInfoToggle","1"}}, positionOffset={{55,14}}},
	{id=86, condition="checkEquipStrength=1", windowsWidgetID={{"KLUIPlayerInfoPanel","tog_trade","1"},{"KLUIForgeGroupPanel","strengthToggle","1"}}, positionOffset=local_positionOffset.positionOffset_2},
	{id=89, condition="checkEquipAppend=1", windowsWidgetID={{"KLUIPlayerInfoPanel","tog_trade","1"},{"KLUIForgeGroupPanel","appendToggle","1"}}, positionOffset=local_positionOffset.positionOffset_2},
	{id=90, condition="checkMainRechargeRed=1", windowsWidgetID={{"KLUISystemTopPanel","BtnRecharge","1"}}},
	{id=91, condition="checkMainActivityRed=1", windowsWidgetID={{"KLUISystemTopPanel","BtnMainActivity","1"}}},
	{id=92, condition="checkEfficiencyNewRed=1", windowsWidgetID={{"KLUISystemTopPanel","BtnEfficiency","1"}}},
	{id=93, condition="checkVIPRedDot=1", windowsWidgetID={{"KLUISystemTopPanel","BtnVIP","1"}}},
	{id=94, condition="checkMail>0", windowsWidgetID={{"KLUIPlayerInfoPanel","tog_mail","1"}}, positionOffset=local_positionOffset.positionOffset_4},
	{id=95, condition="checkComboSkillUpgrade=1", windowsWidgetID={{"KLUISystemTopPanel","BtnCombo","1"}}},
	{id=96, condition="serverControl=96", windowsWidgetID={{"KLUISystemTopPanel","BtnDaily","1"},{"KLDailyGoalMainPanel","toggle_tab_daily_active","1"}}, positionOffset={{20,20},{54,7}}},
	{id=100, condition="serverControl=100", windowsWidgetID={{"KLUISystemTopPanel","BtnDaily","1"},{"KLDailyGoalMainPanel","toggle_tab_daily_active","1"},{"KLDailyActivePanel","daily_activity_6","1"}}, positionOffset={{20,20},{54,7},{175,10}}},
	{id=101, condition="serverControl=101", windowsWidgetID={{"KLUISystemTopPanel","BtnDaily","1"},{"KLDailyGoalMainPanel","toggle_tab_activity","1"},{"KLDailyActivityPanel","daily_activity_item_24001","1"}}, positionOffset={{20,20},{54,7},{54,-180}}},
	{id=104, condition="checkMainOperateActivityRed=1", windowsWidgetID={{"KLUISystemTopPanel","BtnOperateActivity","1"}}},
	{id=105, condition="serverControl=105", positionOffset=local_positionOffset.positionOffset_3, active=0},
	{id=106, condition="serverControl=106", positionOffset=local_positionOffset.positionOffset_3, active=0},
	{id=107, condition="serverControl=107", windowsWidgetID={{"KLUISystemTopPanel","BtnRankList","1"},{"KLUIRankListPanel","LeftButton_1_4","1"},{"KLUIRankListPanel","LeftButton_2_4","1"},{"KLUIRankListPanel","WorshipButton","1"}}, positionOffset={{20,20},{65,12},{65,12},{50,15}}},
	{id=108, condition="checkReceiveAddFriend>0", windowsWidgetID={{"KLUIPlayerInfoPanel","tog_friend","1"},{"KLFriendMainPanelKml","add_friend","1"},{"KLFriendAddPanel","friend_applay_butten","1"}}, positionOffset={{20,25},{50,10},{45,10}}},
	{id=109, condition="checkMainOperateActivityRed=1", windowsWidgetID=local_windowsWidgetID.windowsWidgetID_3},
	{id=110, condition="serverControl=110", windowsWidgetID=local_windowsWidgetID.windowsWidgetID_2, positionOffset=local_positionOffset.positionOffset_3, active=0},
	{id=111, condition="serverControl=111", windowsWidgetID=local_windowsWidgetID.windowsWidgetID_2, positionOffset=local_positionOffset.positionOffset_3, active=0},
	{id=112, condition="checkMainOperateActivitySecondRed=1", windowsWidgetID=local_windowsWidgetID.windowsWidgetID_3},
	{id=113, condition="checkGameGuide=1", windowsWidgetID={{"KLUISystemTopPanel","Btn_gonglue","1"}}},
	{id=114, condition="checkGamePlay=1", windowsWidgetID={{"KLUISystemTopPanel","Btn_wanfa","1"}}},
	{id=115, condition="checkEquipLucky=1", windowsWidgetID={{"KLUIPlayerInfoPanel","tog_trade","1"},{"KLUIForgeGroupPanel","luckyToggle","1"}}, positionOffset=local_positionOffset.positionOffset_2},
	{id=116, condition="checkUnusedAbility>9", windowsWidgetID={}, positionOffset=local_positionOffset.positionOffset_4},
	{id=117, condition="checkBagSize<19", windowsWidgetID={{"KLUIPlayerInfoPanel","tog_bag","1"},{"KLUIBagPanel","btn_sell","1"}}, positionOffset={{20,25},{30,10}}, active=0},
	{id=118, condition="checkSkillCanLearn=1", windowsWidgetID={{"KLUIPlayerInfoPanel","tog_skill","1"}}, positionOffset=local_positionOffset.positionOffset_4},
	{id=119, condition="checkUnionReq=1", windowsWidgetID={{"KLUIPlayerInfoPanel","tog_union","1"},{"KLUnionMemberListPanel","shen_he","1"}}, positionOffset={{20,25},{47,15}}},
	{id=120, condition="checkUnionTask=1", windowsWidgetID={{"KLUIPlayerInfoPanel","tog_union","1"},{"KLUnionToggleListPanel","taskToggle","1"}}, positionOffset={{20,25},{24,28}}},
}

local defaults = {windowsWidgetID={{"KLMainOperateActivityPanel","tog_lottery","1"},{"KLUISystemTopPanel","BtnOperateActivity","1"}}, positionOffset={{20,20}}, active=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_redDot_new) do
	setmetatable(v, mt)
end

return cfg_redDot_new