-- 此文件工具自动生成，不要修改
---@class cfg_newarea_personalreward_column
---=挑战组*10000+组内排序*10+序列
---@field index number @编号 column=1 A
---同一个活动一个组
---
---20001：装备强化
---20002：装备追加
---20003：装备首爆
---20004：等级竞技
---20005：卓越竞技
---20006：首饰竞技
---@field group number @个人挑战组编号 column=2 B
---同一个活动组内的排序；
---如果排序相等，说明他们在同一行，按照编号从小到大，从左到右排序
---@field sort number @组内排序 column=3 C
---策划自用
---@field description string @备注 column=4 D
---任务要求值
---20001：全身强化等级
---20002：全身追加等级
---20003：装备item表ID#排名（数量填0表示无排名要求）
---20004: 角色达到等级
---20005: 角色全身装备卓越词条数和
---20006: 角色全身首饰等级和
---@field taskType IntList @个人挑战 column=5 E
---个人达成奖励
---【对应3个奖励道具】
---
---道具ID#数量|道具ID#数量|道具ID#数量
---@field taskReward IntListList @对应的奖励 column=6 F

local local_taskType = {
    taskType_1={5,2},
    taskType_2={7,2},
    taskType_3={9,2},
    taskType_4={11,2},
    taskType_5={3,6},
    taskType_6={5,6},
    taskType_7={7,6},
    taskType_8={9,6},

}

local local_taskReward = {
    taskReward_1={{10010001,2000000},{10020001,100},{50030002,1}},
    taskReward_2={{10020001,100},{50030002,1}},

}

local cfg_newarea_personalreward =
{
	{index=200010011},
	{index=200010021, sort=2, taskType={6,2}},
	{index=200010031, sort=3, taskType=local_taskType.taskType_2},
	{index=200010041, sort=4, taskType={8,2}},
	{index=200010051, sort=5, taskType=local_taskType.taskType_3},
	{index=200010061, sort=6, taskType={10,2}},
	{index=200010071, sort=7, taskType=local_taskType.taskType_4},
	{index=200020011, group=20002, description="装备追加", taskType={3,2}},
	{index=200020021, group=20002, sort=2, description="装备追加"},
	{index=200020031, group=20002, sort=3, description="装备追加", taskType=local_taskType.taskType_2},
	{index=200020041, group=20002, sort=4, description="装备追加", taskType=local_taskType.taskType_3},
	{index=200020051, group=20002, sort=5, description="装备追加", taskType=local_taskType.taskType_4},
	{index=200020061, group=20002, sort=6, description="装备追加", taskType={13,2}},
	{index=200020071, group=20002, sort=7, description="装备追加", taskType={15,2}},
	{index=200030011, group=20003, description="装备首爆", taskType={20120111,2}},
	{index=200030021, group=20003, sort=2, description="装备首爆", taskType={20120121,2}},
	{index=200030031, group=20003, sort=3, description="装备首爆", taskType={20120131,2}},
	{index=200030041, group=20003, sort=4, description="装备首爆", taskType={20120211,2}},
	{index=200030051, group=20003, sort=5, description="装备首爆", taskType={20120221,2}},
	{index=200030061, group=20003, sort=6, description="装备首爆", taskType={20120231,2}},
	{index=200030071, group=20003, sort=7, description="装备首爆", taskType={20120311,2}},
	{index=200040011, group=20004, description="等级竞技", taskType={30,6}},
	{index=200040021, group=20004, sort=2, description="等级竞技", taskType={50,6}},
	{index=200040031, group=20004, sort=3, description="等级竞技", taskType={80,6}},
	{index=200040041, group=20004, sort=4, description="等级竞技", taskType={100,6}},
	{index=200050011, group=20005, description="卓越竞技", taskType=local_taskType.taskType_5, taskReward=local_taskReward.taskReward_2},
	{index=200050031, group=20005, sort=3, description="卓越竞技", taskType=local_taskType.taskType_6, taskReward=local_taskReward.taskReward_2},
	{index=200050051, group=20005, sort=5, description="卓越竞技", taskType=local_taskType.taskType_7, taskReward=local_taskReward.taskReward_2},
	{index=200050071, group=20005, sort=7, description="卓越竞技", taskType=local_taskType.taskType_8, taskReward=local_taskReward.taskReward_2},
	{index=200060011, group=20006, description="首饰竞技", taskType=local_taskType.taskType_5, taskReward=local_taskReward.taskReward_2},
	{index=200060031, group=20006, sort=3, description="首饰竞技", taskType=local_taskType.taskType_6, taskReward=local_taskReward.taskReward_2},
	{index=200060051, group=20006, sort=5, description="首饰竞技", taskType=local_taskType.taskType_7, taskReward=local_taskReward.taskReward_2},
	{index=200060071, group=20006, sort=7, description="首饰竞技", taskType=local_taskType.taskType_8, taskReward=local_taskReward.taskReward_2},
}

local defaults = {group=20001, sort=1, description="装备强化", taskType={5,2}, taskReward={{10010001,2000000},{10020001,100},{50030002,1}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_newarea_personalreward) do
	setmetatable(v, mt)
end

return cfg_newarea_personalreward