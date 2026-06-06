-- 此文件工具自动生成，不要修改
---@class cfg_newarea_rankingboss_column
---索引编号
---编号*1000+序列
---@field index number @编号 column=1 A
---同一个活动一个组
---@field group number @BOSS挑战组编号 column=2 B
---策划备注
---@field decs string @怪物名称 column=3 C
---对应表monster怪物id
---@field rankingBoss IntList @怪物id column=4 D
---BOSS首杀的奖励道具
---
---首杀奖励item表道具ID#数量
---
---
---@field killReward IntList @首杀奖励 column=5 E
---BOSS首次击杀时，计算伤害，排第一的获得。
---
---首杀奖励item表道具ID#数量
---@field mostReward IntList @首杀伤害第一 column=6 F
---BOSS首次击杀时，最后一下对BOSS进行伤害的玩家获得。
---
---首杀奖励item表道具ID#数量
---@field lastReward IntList @首杀致命伤害 column=7 G
---全服前多少位击杀boss可领取个人击杀奖励
---@field personalcondition number @个人击杀奖励条件 column=8 H
---个人击杀的奖励道具
--- 此处设定3个道具奖励
---
---道具ID#数量|道具ID#数量|道具ID#数量
---@field personalReward IntListList @个人击杀奖励 column=9 I

local local_killReward = {
    killReward_1={},

}

local local_mostReward = {
    mostReward_1={10020001,100},

}

local local_lastReward = {
    lastReward_1={10020001,100},

}

local local_personalReward = {
    personalReward_1={{10020001,40}},
    personalReward_2={{50030002,1}},
    personalReward_3={{10020001,100}},

}

local cfg_newarea_rankingboss =
{
	{index=10001001, group=10001, decs="冰后", rankingBoss={40006}, personalReward={{10010001,100000}}},
	{index=10001002, group=10001, decs="魔鬼戈登", rankingBoss={50012}, personalReward={{10010001,150000}}},
	{index=10001003, group=10001, decs="魔王巴洛克", rankingBoss={60008}, personalReward={{10010001,200000}}},
	{index=10001004, group=10001, decs="海魔希特拉", rankingBoss={70007}, personalReward={{10010001,250000}}},
	{index=10001005, group=10001, decs="深渊希特拉", rankingBoss={70008}, personalReward={{10010001,300000}}},
	{index=10001006, group=10001, decs="炽炎魔", rankingBoss={80007}, personalReward={{10010001,500000}}},
	{index=10001007, group=10001, decs="魔王扎坎", rankingBoss={80006}, personalReward=local_personalReward.personalReward_1},
	{index=10001008, group=10001, decs="深渊魔王扎坎魔", rankingBoss={80008}, personalReward=local_personalReward.personalReward_1},
	{index=10002001, decs="黄金地狱猎犬怪", rankingBoss={500007}},
	{index=10002002, decs="黄金骷髅兵", rankingBoss={500011}},
	{index=10002003, decs="黄金暗黑骑士", rankingBoss={500017}},
	{index=10002004, decs="黄金鬼魂", rankingBoss={500101}},
	{index=10002005, decs="黄金牛魔王", rankingBoss={500018}},
	{index=10002006, decs="黄金死神戈登", rankingBoss={500024}, personalReward=local_personalReward.personalReward_3},
	{index=10002007, decs="黄金小巴哈姆特", rankingBoss={500025}, personalReward=local_personalReward.personalReward_3},
	{index=10002008, decs="黄金死亡美人鱼", rankingBoss={500026}, personalReward=local_personalReward.personalReward_3},
	{index=10002009, decs="黄金巫师王", rankingBoss={500029}, personalReward=local_personalReward.personalReward_3},
}

local defaults = {group=10002, killReward={}, mostReward={10020001,100}, lastReward={10020001,100}, personalcondition=2, personalReward={{50030002,1}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_newarea_rankingboss) do
	setmetatable(v, mt)
end

return cfg_newarea_rankingboss