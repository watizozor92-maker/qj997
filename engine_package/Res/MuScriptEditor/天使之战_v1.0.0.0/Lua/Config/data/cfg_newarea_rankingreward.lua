-- 此文件工具自动生成，不要修改
---@class cfg_newarea_rankingreward_column
---=挑战组*10000+组内排序*10+序列
---@field index number @编号 column=1 A
---同一个活动一个组
---
---其他竞技活动奖励组别
---1：装备强化
---2：装备追加
---3：装备首爆
---@field group number @全服挑战组编号 column=2 B
---同一个活动组内的排序；
---如果排序相等，说明他们在同一行，按照编号从小到大，从左到右排序
---@field sort number @组内排序 column=3 C
---策划自用
---@field description string @备注 column=4 D
---任务要求值
---20001：全身强化等级
---20002：全身追加等级
---20003：装备item表ID
---20004：角色等级
---20005：装备卓越词条
---20006：首饰等级
---
---不填则代表没有要求，只看排名，活动结束货发放
---@field taskType number @任务要求 column=5 E
---上限名次#下限名次（1#1，排名第1可以获得的奖励；2#5，排名2~5名可以获得的奖励）
---@field ranking IntList @排名挑战 column=6 F
---排名达成奖励
---【对应奖励道具】
---
---道具ID#数量|道具ID#数量|道具ID#数量
---
---此处第一个道具为核心奖励道具
---@field taskReward IntListList @对应的奖励 column=7 G

local local_ranking = {
    ranking_1={1,1},
    ranking_2={2,2},
    ranking_3={3,3},
    ranking_4={4,4},
    ranking_5={5,5},

}

local local_taskReward = {
    taskReward_1={{10030001,100},{10010001,100000}},
    taskReward_2={{10030001,100},{10010001,100000},{20120131,1}},

}

local cfg_newarea_rankingreward =
{
	{index=200010011, taskReward=local_taskReward.taskReward_1},
	{index=200010012, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200010013, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200010021, sort=2, taskType=6, taskReward=local_taskReward.taskReward_1},
	{index=200010022, sort=2, taskType=6, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200010023, sort=2, taskType=6, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200010031, sort=3, taskType=7, taskReward=local_taskReward.taskReward_1},
	{index=200010032, sort=3, taskType=7, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200010033, sort=3, taskType=7, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200010041, sort=4, taskType=8, taskReward=local_taskReward.taskReward_1},
	{index=200010042, sort=4, taskType=8, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200010043, sort=4, taskType=8, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200010051, sort=5, taskType=9, taskReward=local_taskReward.taskReward_1},
	{index=200010052, sort=5, taskType=9, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200010053, sort=5, taskType=9, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200010061, sort=6, taskType=10, taskReward=local_taskReward.taskReward_1},
	{index=200010062, sort=6, taskType=10, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200010063, sort=6, taskType=10, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200010071, sort=7, taskType=11, taskReward=local_taskReward.taskReward_1},
	{index=200010072, sort=7, taskType=11, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200010073, sort=7, taskType=11, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200020011, group=20002, description="装备追加", taskType=3, taskReward=local_taskReward.taskReward_1},
	{index=200020012, group=20002, description="装备追加", taskType=3, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200020013, group=20002, description="装备追加", taskType=3, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200020021, group=20002, sort=2, description="装备追加", taskReward=local_taskReward.taskReward_1},
	{index=200020022, group=20002, sort=2, description="装备追加", ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200020023, group=20002, sort=2, description="装备追加", ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200020031, group=20002, sort=3, description="装备追加", taskType=7, taskReward=local_taskReward.taskReward_1},
	{index=200020032, group=20002, sort=3, description="装备追加", taskType=7, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200020033, group=20002, sort=3, description="装备追加", taskType=7, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200020041, group=20002, sort=4, description="装备追加", taskType=9, taskReward=local_taskReward.taskReward_1},
	{index=200020042, group=20002, sort=4, description="装备追加", taskType=9, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200020043, group=20002, sort=4, description="装备追加", taskType=9, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200020051, group=20002, sort=5, description="装备追加", taskType=11, taskReward=local_taskReward.taskReward_1},
	{index=200020052, group=20002, sort=5, description="装备追加", taskType=11, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200020053, group=20002, sort=5, description="装备追加", taskType=11, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200020061, group=20002, sort=6, description="装备追加", taskType=13, taskReward=local_taskReward.taskReward_1},
	{index=200020062, group=20002, sort=6, description="装备追加", taskType=13, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200020063, group=20002, sort=6, description="装备追加", taskType=13, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200020071, group=20002, sort=7, description="装备追加", taskType=15, taskReward=local_taskReward.taskReward_1},
	{index=200020072, group=20002, sort=7, description="装备追加", taskType=15, ranking=local_ranking.ranking_2, taskReward=local_taskReward.taskReward_1},
	{index=200020073, group=20002, sort=7, description="装备追加", taskType=15, ranking=local_ranking.ranking_3, taskReward=local_taskReward.taskReward_1},
	{index=200030011, group=20003, description="装备首爆", taskType=20120111, taskReward=local_taskReward.taskReward_1},
	{index=200030021, group=20003, sort=2, description="装备首爆", taskType=20120121, taskReward=local_taskReward.taskReward_1},
	{index=200030031, group=20003, sort=3, description="装备首爆", taskType=20120131, taskReward=local_taskReward.taskReward_1},
	{index=200030041, group=20003, sort=4, description="装备首爆", taskType=20120211, taskReward=local_taskReward.taskReward_1},
	{index=200030051, group=20003, sort=5, description="装备首爆", taskType=20120221, taskReward=local_taskReward.taskReward_1},
	{index=200030061, group=20003, sort=6, description="装备首爆", taskType=20120231, taskReward=local_taskReward.taskReward_1},
	{index=200030071, group=20003, sort=7, description="装备首爆", taskType=20120311, taskReward=local_taskReward.taskReward_1},
	{index=200040001, group=20004, description="等级竞技", taskType=30},
	{index=200040002, group=20004, sort=2, description="等级竞技", taskType=30, ranking=local_ranking.ranking_2},
	{index=200040003, group=20004, sort=3, description="等级竞技", taskType=30, ranking=local_ranking.ranking_3},
	{index=200040004, group=20004, sort=4, description="等级竞技", taskType=30, ranking=local_ranking.ranking_4},
	{index=200040005, group=20004, sort=5, description="等级竞技", taskType=30, ranking=local_ranking.ranking_5},
	{index=200040006, group=20004, description="等级竞技", taskType=50},
	{index=200040007, group=20004, sort=2, description="等级竞技", taskType=50, ranking=local_ranking.ranking_2},
	{index=200040008, group=20004, sort=3, description="等级竞技", taskType=50, ranking=local_ranking.ranking_3},
	{index=200040009, group=20004, sort=4, description="等级竞技", taskType=50, ranking=local_ranking.ranking_4},
	{index=200040010, group=20004, sort=5, description="等级竞技", taskType=50, ranking=local_ranking.ranking_5},
	{index=200040011, group=20004, description="等级竞技", taskType=80},
	{index=200040012, group=20004, sort=2, description="等级竞技", taskType=80, ranking=local_ranking.ranking_2},
	{index=200040013, group=20004, sort=3, description="等级竞技", taskType=80, ranking=local_ranking.ranking_3},
	{index=200040014, group=20004, sort=4, description="等级竞技", taskType=80, ranking=local_ranking.ranking_4},
	{index=200040015, group=20004, sort=5, description="等级竞技", taskType=80, ranking=local_ranking.ranking_5},
	{index=200040016, group=20004, description="等级竞技", taskType=100},
	{index=200040017, group=20004, sort=2, description="等级竞技", taskType=100, ranking=local_ranking.ranking_2},
	{index=200040018, group=20004, sort=3, description="等级竞技", taskType=100, ranking=local_ranking.ranking_3},
	{index=200040019, group=20004, sort=4, description="等级竞技", taskType=100, ranking=local_ranking.ranking_4},
	{index=200040020, group=20004, sort=5, description="等级竞技", taskType=100, ranking=local_ranking.ranking_5},
	{index=200050001, group=20005, description="卓越竞技", taskType=3},
	{index=200050002, group=20005, sort=2, description="卓越竞技", taskType=3, ranking=local_ranking.ranking_2},
	{index=200050003, group=20005, sort=3, description="卓越竞技", taskType=3, ranking=local_ranking.ranking_3},
	{index=200050004, group=20005, sort=4, description="卓越竞技", taskType=3, ranking=local_ranking.ranking_4},
	{index=200050005, group=20005, sort=5, description="卓越竞技", taskType=3, ranking=local_ranking.ranking_5},
	{index=200050006, group=20005, description="卓越竞技"},
	{index=200050007, group=20005, sort=2, description="卓越竞技", ranking=local_ranking.ranking_2},
	{index=200050008, group=20005, sort=3, description="卓越竞技", ranking=local_ranking.ranking_3},
	{index=200050009, group=20005, sort=4, description="卓越竞技", ranking=local_ranking.ranking_4},
	{index=200050010, group=20005, sort=5, description="卓越竞技", ranking=local_ranking.ranking_5},
	{index=200050011, group=20005, description="卓越竞技", taskType=7},
	{index=200050012, group=20005, sort=2, description="卓越竞技", taskType=7, ranking=local_ranking.ranking_2},
	{index=200050013, group=20005, sort=3, description="卓越竞技", taskType=7, ranking=local_ranking.ranking_3},
	{index=200050014, group=20005, sort=4, description="卓越竞技", taskType=7, ranking=local_ranking.ranking_4},
	{index=200050015, group=20005, sort=5, description="卓越竞技", taskType=7, ranking=local_ranking.ranking_5},
	{index=200050016, group=20005, description="卓越竞技", taskType=9},
	{index=200050017, group=20005, sort=2, description="卓越竞技", taskType=9, ranking=local_ranking.ranking_2},
	{index=200050018, group=20005, sort=3, description="卓越竞技", taskType=9, ranking=local_ranking.ranking_3},
	{index=200050019, group=20005, sort=4, description="卓越竞技", taskType=9, ranking=local_ranking.ranking_4},
	{index=200050020, group=20005, sort=5, description="卓越竞技", taskType=9, ranking=local_ranking.ranking_5},
	{index=200060001, group=20006, description="首饰竞技", taskType=3},
	{index=200060002, group=20006, sort=2, description="首饰竞技", taskType=3, ranking=local_ranking.ranking_2},
	{index=200060003, group=20006, sort=3, description="首饰竞技", taskType=3, ranking=local_ranking.ranking_3},
	{index=200060004, group=20006, sort=4, description="首饰竞技", taskType=3, ranking=local_ranking.ranking_4},
	{index=200060005, group=20006, sort=5, description="首饰竞技", taskType=3, ranking=local_ranking.ranking_5},
	{index=200060006, group=20006, description="首饰竞技"},
	{index=200060007, group=20006, sort=2, description="首饰竞技", ranking=local_ranking.ranking_2},
	{index=200060008, group=20006, sort=3, description="首饰竞技", ranking=local_ranking.ranking_3},
	{index=200060009, group=20006, sort=4, description="首饰竞技", ranking=local_ranking.ranking_4},
	{index=200060010, group=20006, sort=5, description="首饰竞技", ranking=local_ranking.ranking_5},
	{index=200060011, group=20006, description="首饰竞技", taskType=7},
	{index=200060012, group=20006, sort=2, description="首饰竞技", taskType=7, ranking=local_ranking.ranking_2},
	{index=200060013, group=20006, sort=3, description="首饰竞技", taskType=7, ranking=local_ranking.ranking_3},
	{index=200060014, group=20006, sort=4, description="首饰竞技", taskType=7, ranking=local_ranking.ranking_4},
	{index=200060015, group=20006, sort=5, description="首饰竞技", taskType=7, ranking=local_ranking.ranking_5},
	{index=200060016, group=20006, description="首饰竞技", taskType=9},
	{index=200060017, group=20006, sort=2, description="首饰竞技", taskType=9, ranking=local_ranking.ranking_2},
	{index=200060018, group=20006, sort=3, description="首饰竞技", taskType=9, ranking=local_ranking.ranking_3},
	{index=200060019, group=20006, sort=4, description="首饰竞技", taskType=9, ranking=local_ranking.ranking_4},
	{index=200060020, group=20006, sort=5, description="首饰竞技", taskType=9, ranking=local_ranking.ranking_5},
}

local defaults = {group=20001, sort=1, description="装备强化", taskType=5, ranking={1,1}, taskReward={{10030001,100},{10010001,100000},{20120131,1}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_newarea_rankingreward) do
	setmetatable(v, mt)
end

return cfg_newarea_rankingreward