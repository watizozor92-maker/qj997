-- 此文件工具自动生成，不要修改
---@class sub_mainActivity_column
---@field id number @id column=1 A
---@field showTogName string @左侧页签需要展示的名称 column=2 B
---@field mainUIPanel string @父界面名称 column=3 C
---找程序要
---@field subUIRoute string @子界面名称 column=4 D
---与cfg_system_switch 里的字段对应
---@field togName string @开关 column=5 E
---@field sortId number @页签排序 column=6 F
---配置conditon条件集
---@field showCondition string @页签显示条件 column=7 G
---0：不显示角标
---1:限时角标
---@field cornerType number @页签角标 column=8 H
---配置condition条件集
---@field actualCondition string @活动开启条件 column=9 I
local sub_mainActivity =
{
	{id=1, showTogName="黄金首杀", subUIRoute="dev/outui/OpenServerActivity/Panel/KLUIOpenServerFirstKill/KLUIOpenServerFirstKillPanel", togName="tog_FirstKill", sortId=1, showCondition="901#1&903#10&101#50"},
	{id=2, showTogName="大天使福利", subUIRoute="dev/outui/OpenServiceArchangelWelfare/Panel/KLUIOpenServiceArchangelWelfare/KLUIOpenServiceArchangelWelfarePanel", togName="tog_2", sortId=2, showCondition="100#999999", actualCondition="100#999999"},
	{id=3, showTogName="开服竞技", subUIRoute="dev/outui/OpenServerAthletics/Panel/KLOpenServerAthletics/KLOpenServerAthleticsPanel", togName="tog_OpenServerAthletics", sortId=3, showCondition="901#1&903#10&101#95", cornerType=1},
	{id=4, showTogName="翅膀任务", subUIRoute="dev/outui/WingTask/Panel/KLOpenServiceWingTask/KLOpenServiceWingTaskPanel", togName="tog_WingTaskActivity", sortId=4, showCondition="100#9999"},
	{id=5, showTogName="大天使武器", subUIRoute="dev/outui/MainActivity/Panel/KLArcWeapActivity/KLArcWeapActivityPanel", togName="tog_ArcWeapActivity", sortId=5, showCondition="101#999999"},
	{id=6, showTogName="七日登录", subUIRoute="dev/outui/OpenService/Panel/KLOpenServiceGiftInner/KLOpenServiceGiftInnerPanel", togName="tog_SevenDayGiftActivity", sortId=6},
	{id=7, showTogName="等级奖励", subUIRoute="dev/outui/LevelReward/Panel/KLLevelReward/KLLevelRewardPanel", togName="tog_LevelReward", sortId=7},
}

local defaults = {mainUIPanel="KLMainActivityPanel", showCondition="901#1&903#10&101#70", cornerType=0, actualCondition="901#1&903#10"}
local mt = {__index = defaults}
for _, v in ipairs(sub_mainActivity) do
	setmetatable(v, mt)
end

return sub_mainActivity