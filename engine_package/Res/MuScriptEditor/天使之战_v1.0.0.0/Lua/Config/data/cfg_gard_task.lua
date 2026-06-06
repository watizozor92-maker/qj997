-- 此文件工具自动生成，不要修改
---@class cfg_gard_task_column
---@field id number @唯一id column=1 A
---@field taskName string @任务名称 column=2 B
---奖励道具组以及奖励道具组的数量
---格式：道具id#道具数量|道具id#道具数量
---@field rewardItem IntListList @奖励道具信息 column=3 C
---特殊奖励，完成任务后自动增加到战盟中，只可获得1次
---@field rewardSpecial IntListList @特殊奖励 column=4 D
---1、击杀某种类型的怪物
---2、击杀指定怪物
---3、完成指定副本
---4、击杀敌方玩家
---@field taskType number @任务类别 column=5 E
---1、怪物类型#怪物数量
---2、怪物id#怪物id#...#杀怪数量
---3、活动id#次数
---4、数量
---@field taskContent IntList @任务内容 column=6 F
---战盟创建后，每X天后的0点刷新任务。例如填3，则第4天的0天刷新任务。
---@field taskRefreshes number @任务刷新时间 column=7 G
---从上往下排列 ，数字越小 排序越靠前
---@field sorting number @排序主次 column=8 H
---加入战盟后X小时才可领取该任务
---@field hour number @领取时间 column=9 I
---transfer#传送ID#X坐标#Y坐标
---未填坐标则传送到该地图的默认传送点
---传送ID参考mapMove表id
---
---transferNPC#NPCID
---传送到NPC位置，并交互
---NPCID参考npc_list表ID
---
---moveTo#传送ID#X坐标#Y坐标
---寻路，并将坐标设为主动目标
---传送ID参考mapMove表id
---
---moveToNPC#NPCID
---寻路至该NPC位置，并交互
---NPCID参考npc_list表ID
---
---unfoldUI#界面名称
---填界面名称，直接打开该界面
---@field panel StringList @快捷指令 column=10 J

local local_rewardItem = {
    rewardItem_1={{10010002,125000}},

}

local local_rewardSpecial = {
    rewardSpecial_1={{10090001,4000}},

}

local cfg_gard_task =
{
	{id=1, taskName="全员消灭5只野外BOSS", taskType=2, sorting=1},
	{id=2, taskName="全员通关40次恶魔广场", taskType=3, taskContent={10001,40}, sorting=2, panel={"transferNPC","100406"}},
	{id=3, taskName="全员通关40次血色城堡", taskType=3, taskContent={11001,40}, sorting=3, panel={"transferNPC","100306"}},
	{id=4, taskName="全员消灭100名敌方玩家", rewardSpecial={{10090001,3000}}, taskType=4, taskContent={100}, sorting=4, panel={"openUIPanel","dev/ui/Map/Panel/KLBigMap/KLBigMapPanel"}},
}

local defaults = {rewardItem={{10010002,125000}}, rewardSpecial={{10090001,4000}}, taskContent={40006,50012,60008,70007,80006,80007,11010,90008,14012,5}, taskRefreshes=3, hour=3, panel={"openUIPanel","dev/outui/ChallengeBoss/Panel/KLChallengeBoss/KLChallengeBossPanel","1","monsterType=2"}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_gard_task) do
	setmetatable(v, mt)
end

return cfg_gard_task