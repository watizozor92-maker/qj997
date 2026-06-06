-- 此文件工具自动生成，不要修改
---@class cfg_newarea_offerreward_column
---id
---@field id number @编号 column=1 A
---同一组显示在同一行中
---@field group number @悬赏分组 column=2 B
---仅客户端展示使用
---@field level number @悬赏分组等级 column=3 C
---目标怪物
---@field monsterId number @目标怪物 column=4 D
---奖励道具
---格式：道具id#数量|道具id#数量
---@field reward IntList @奖励道具 column=5 E
---备注：同一组只能填写相同的奖励
---格式: 道具id#数量|道具id#数量
---@field groupReward IntListList @分组奖励道具 column=6 F

local local_reward = {
    reward_1={10080001,200000},
    reward_2={10080001,400000},
    reward_3={10080001,650000},
    reward_4={10080001,800000},
    reward_5={10080001,1000000},
    reward_6={10080001,1300000},
    reward_7={10080001,2400000},
    reward_8={10080001,4800000},
    reward_9={10080001,8200000},
    reward_10={10080001,13000000},
    reward_11={10080001,20000000},
    reward_12={10080001,28000000},
    reward_13={10080001,37000000},
    reward_14={10080001,46000000},
    reward_15={10080001,56000000},
    reward_16={10080001,69000000},
    reward_17={10080001,81000000},
    reward_18={10080001,91000000},
    reward_19={10080001,110000000},
    reward_20={10080001,114000000},
    reward_21={10080001,125000000},

}

local local_groupReward = {
    groupReward_1={{10020001,2000},{50010005,1},{50010003,1},{60035075,1}},
    groupReward_2={{10020001,2500},{50030003,1},{50030005,1},{60035076,1}},
    groupReward_3={{10020001,3000},{50030014,1},{60035077,1},{50040077,10}},
    groupReward_4={{10020001,3500},{50030005,1},{60035078,1},{50040075,10}},
    groupReward_5={{10020001,4000},{50030004,1},{60035079,1},{50040076,10}},
    groupReward_6={{10020001,4500},{50010005,1},{50010003,1},{60035080,1}},
    groupReward_7={{10020001,5000},{60035081,1},{50040077,20},{50040075,20}},
    groupReward_8={{10020001,5500},{50030002,2},{50030005,2},{50040076,20}},
    groupReward_9={{10020001,6000},{50030003,2},{50030014,2},{50040077,20}},
    groupReward_10={{10020001,6500},{50010005,2},{50010003,2},{50040075,20}},
    groupReward_11={{10020001,7000},{50030003,2},{50030004,2},{50040076,20}},
    groupReward_12={{10020001,8000},{50030003,2},{50030014,2},{50040077,20}},
    groupReward_13={{10020001,9000},{50010005,1},{50010003,1},{50040075,20}},
    groupReward_14={{10020001,10000},{50030003,2},{50030004,2},{50040076,20}},
    groupReward_15={{10020001,11000},{50030003,2},{50030014,2},{50040077,20}},
    groupReward_16={{10020001,12000},{50010005,1},{50010003,1},{50040075,20}},
    groupReward_17={{10020001,13000},{50030003,2},{50030004,2},{50040076,20}},
    groupReward_18={{10020001,14000},{50030003,2},{50030014,2},{50040077,20}},
    groupReward_19={{10020001,15000},{50010005,1},{50010003,1},{50040075,20}},
    groupReward_20={{10020001,16000},{50030003,2},{50030004,2},{50040076,20}},
    groupReward_21={{10020001,17000},{50030003,2},{50030014,2},{50040077,20}},

}

local cfg_newarea_offerreward =
{
	{id=1, monsterId=500025, reward=local_reward.reward_1},
	{id=2, monsterId=500026, reward=local_reward.reward_1},
	{id=3, monsterId=500029, reward=local_reward.reward_1},
	{id=4, monsterId=70008, reward={10080001,600000}},
	{id=5, group=2, level=100, monsterId=500033, reward=local_reward.reward_2, groupReward=local_groupReward.groupReward_2},
	{id=6, group=2, level=100, monsterId=500030, reward=local_reward.reward_2, groupReward=local_groupReward.groupReward_2},
	{id=7, group=2, level=100, monsterId=500031, reward=local_reward.reward_2, groupReward=local_groupReward.groupReward_2},
	{id=8, group=2, level=100, monsterId=80007, reward={10080001,1800000}, groupReward=local_groupReward.groupReward_2},
	{id=9, group=3, level=130, monsterId=500034, reward=local_reward.reward_3, groupReward=local_groupReward.groupReward_3},
	{id=10, group=3, level=130, monsterId=500032, reward=local_reward.reward_3, groupReward=local_groupReward.groupReward_3},
	{id=11, group=3, level=130, monsterId=500023, reward=local_reward.reward_3, groupReward=local_groupReward.groupReward_3},
	{id=12, group=3, level=130, monsterId=16014, reward={10080001,2200000}, groupReward=local_groupReward.groupReward_3},
	{id=13, group=4, level=150, monsterId=500037, reward=local_reward.reward_4, groupReward=local_groupReward.groupReward_4},
	{id=14, group=4, level=150, monsterId=500035, reward=local_reward.reward_4, groupReward=local_groupReward.groupReward_4},
	{id=15, group=4, level=150, monsterId=500036, reward=local_reward.reward_4, groupReward=local_groupReward.groupReward_4},
	{id=16, group=4, level=150, monsterId=11010, reward={10080001,2600000}, groupReward=local_groupReward.groupReward_4},
	{id=17, group=5, level=170, monsterId=500038, reward=local_reward.reward_5, groupReward=local_groupReward.groupReward_5},
	{id=18, group=5, level=170, monsterId=500039, reward=local_reward.reward_5, groupReward=local_groupReward.groupReward_5},
	{id=19, group=5, level=170, monsterId=500040, reward=local_reward.reward_5, groupReward=local_groupReward.groupReward_5},
	{id=20, group=5, level=170, monsterId=90008, reward={10080001,3300000}, groupReward=local_groupReward.groupReward_5},
	{id=21, group=6, level=200, monsterId=500043, reward=local_reward.reward_6, groupReward=local_groupReward.groupReward_6},
	{id=22, group=6, level=200, monsterId=500045, reward=local_reward.reward_6, groupReward=local_groupReward.groupReward_6},
	{id=23, group=6, level=200, monsterId=500047, reward=local_reward.reward_6, groupReward=local_groupReward.groupReward_6},
	{id=24, group=6, level=200, monsterId=12001, reward={10080001,5500000}, groupReward=local_groupReward.groupReward_6},
	{id=25, group=7, level=250, monsterId=500048, reward=local_reward.reward_7, groupReward=local_groupReward.groupReward_7},
	{id=26, group=7, level=250, monsterId=500049, reward=local_reward.reward_7, groupReward=local_groupReward.groupReward_7},
	{id=27, group=7, level=250, monsterId=500050, reward=local_reward.reward_7, groupReward=local_groupReward.groupReward_7},
	{id=28, group=7, level=250, monsterId=13004, reward={10080001,11000000}, groupReward=local_groupReward.groupReward_7},
	{id=29, group=8, level=300, monsterId=500051, reward=local_reward.reward_8, groupReward=local_groupReward.groupReward_8},
	{id=30, group=8, level=300, monsterId=500052, reward=local_reward.reward_8, groupReward=local_groupReward.groupReward_8},
	{id=31, group=8, level=300, monsterId=500055, reward=local_reward.reward_8, groupReward=local_groupReward.groupReward_8},
	{id=32, group=8, level=300, monsterId=14010, groupReward=local_groupReward.groupReward_8},
	{id=33, group=9, level=350, monsterId=500057, reward=local_reward.reward_9, groupReward=local_groupReward.groupReward_9},
	{id=34, group=9, level=350, monsterId=500059, reward=local_reward.reward_9, groupReward=local_groupReward.groupReward_9},
	{id=35, group=9, level=350, monsterId=500060, reward=local_reward.reward_9, groupReward=local_groupReward.groupReward_9},
	{id=36, group=9, level=350, monsterId=16007, reward={10080001,32000000}, groupReward=local_groupReward.groupReward_9},
	{id=37, group=10, level=400, monsterId=500041, reward=local_reward.reward_10, groupReward=local_groupReward.groupReward_10},
	{id=38, group=10, level=400, monsterId=500042, reward=local_reward.reward_10, groupReward=local_groupReward.groupReward_10},
	{id=39, group=10, level=400, monsterId=500044, reward=local_reward.reward_10, groupReward=local_groupReward.groupReward_10},
	{id=40, group=10, level=400, monsterId=16018, reward={10080001,50000000}, groupReward=local_groupReward.groupReward_10},
	{id=41, group=11, level=450, monsterId=500046, groupReward=local_groupReward.groupReward_11},
	{id=42, group=11, level=450, monsterId=500053, groupReward=local_groupReward.groupReward_11},
	{id=43, group=11, level=450, monsterId=500054, groupReward=local_groupReward.groupReward_11},
	{id=44, group=11, level=450, monsterId=18006, reward={10080001,65000000}, groupReward=local_groupReward.groupReward_11},
	{id=45, group=12, level=500, monsterId=500056, reward=local_reward.reward_12, groupReward=local_groupReward.groupReward_12},
	{id=46, group=12, level=500, monsterId=500058, reward=local_reward.reward_12, groupReward=local_groupReward.groupReward_12},
	{id=47, group=12, level=500, monsterId=500061, reward=local_reward.reward_12, groupReward=local_groupReward.groupReward_12},
	{id=48, group=12, level=500, monsterId=24003, reward={10080001,96000000}, groupReward=local_groupReward.groupReward_12},
	{id=49, group=13, level=550, monsterId=500062, reward=local_reward.reward_13, groupReward=local_groupReward.groupReward_13},
	{id=50, group=13, level=550, monsterId=500063, reward=local_reward.reward_13, groupReward=local_groupReward.groupReward_13},
	{id=51, group=13, level=550, monsterId=500067, reward=local_reward.reward_13, groupReward=local_groupReward.groupReward_13},
	{id=52, group=13, level=550, monsterId=18002, reward=local_reward.reward_21, groupReward=local_groupReward.groupReward_13},
	{id=53, group=14, level=600, monsterId=500068, reward=local_reward.reward_14, groupReward=local_groupReward.groupReward_14},
	{id=54, group=14, level=600, monsterId=500069, reward=local_reward.reward_14, groupReward=local_groupReward.groupReward_14},
	{id=55, group=14, level=600, monsterId=500070, reward=local_reward.reward_14, groupReward=local_groupReward.groupReward_14},
	{id=56, group=14, level=600, monsterId=17017, reward={10080001,151000000}, groupReward=local_groupReward.groupReward_14},
	{id=57, group=15, level=650, monsterId=650004, reward=local_reward.reward_15, groupReward=local_groupReward.groupReward_15},
	{id=58, group=15, level=650, monsterId=650005, reward=local_reward.reward_15, groupReward=local_groupReward.groupReward_15},
	{id=59, group=15, level=650, monsterId=650006, reward=local_reward.reward_15, groupReward=local_groupReward.groupReward_15},
	{id=60, group=15, level=650, monsterId=17013, reward={10080001,186000000}, groupReward=local_groupReward.groupReward_15},
	{id=61, group=16, level=700, monsterId=500071, reward=local_reward.reward_16, groupReward=local_groupReward.groupReward_16},
	{id=62, group=16, level=700, monsterId=500072, reward=local_reward.reward_16, groupReward=local_groupReward.groupReward_16},
	{id=63, group=16, level=700, monsterId=500073, reward=local_reward.reward_16, groupReward=local_groupReward.groupReward_16},
	{id=64, group=16, level=700, monsterId=25001, reward={10080001,225000000}, groupReward=local_groupReward.groupReward_16},
	{id=65, group=17, level=750, monsterId=500074, reward=local_reward.reward_17, groupReward=local_groupReward.groupReward_17},
	{id=66, group=17, level=750, monsterId=500075, reward=local_reward.reward_17, groupReward=local_groupReward.groupReward_17},
	{id=67, group=17, level=750, monsterId=500076, reward=local_reward.reward_17, groupReward=local_groupReward.groupReward_17},
	{id=68, group=17, level=750, monsterId=25004, reward={10080001,256000000}, groupReward=local_groupReward.groupReward_17},
	{id=69, group=18, level=800, monsterId=500077, reward=local_reward.reward_18, groupReward=local_groupReward.groupReward_18},
	{id=70, group=18, level=800, monsterId=500078, reward=local_reward.reward_18, groupReward=local_groupReward.groupReward_18},
	{id=71, group=18, level=800, monsterId=500079, reward=local_reward.reward_18, groupReward=local_groupReward.groupReward_18},
	{id=72, group=18, level=800, monsterId=17010, reward={10080001,290000000}, groupReward=local_groupReward.groupReward_18},
	{id=73, group=19, level=850, monsterId=500080, reward=local_reward.reward_19, groupReward=local_groupReward.groupReward_19},
	{id=74, group=19, level=850, monsterId=500081, reward=local_reward.reward_19, groupReward=local_groupReward.groupReward_19},
	{id=75, group=19, level=850, monsterId=500082, reward=local_reward.reward_19, groupReward=local_groupReward.groupReward_19},
	{id=76, group=19, level=850, monsterId=25007, reward={10080001,325000000}, groupReward=local_groupReward.groupReward_19},
	{id=77, group=20, level=900, monsterId=500083, reward=local_reward.reward_20, groupReward=local_groupReward.groupReward_20},
	{id=78, group=20, level=900, monsterId=500084, reward=local_reward.reward_20, groupReward=local_groupReward.groupReward_20},
	{id=79, group=20, level=900, monsterId=500085, reward=local_reward.reward_20, groupReward=local_groupReward.groupReward_20},
	{id=80, group=20, level=900, monsterId=25012, reward={10080001,360000000}, groupReward=local_groupReward.groupReward_20},
	{id=81, group=21, level=950, monsterId=500086, reward=local_reward.reward_21, groupReward=local_groupReward.groupReward_21},
	{id=82, group=21, level=950, monsterId=500087, reward=local_reward.reward_21, groupReward=local_groupReward.groupReward_21},
	{id=83, group=21, level=950, monsterId=500088, reward=local_reward.reward_21, groupReward=local_groupReward.groupReward_21},
	{id=84, group=21, level=950, monsterId=25017, reward={10080001,385000000}, groupReward=local_groupReward.groupReward_21},
}

local defaults = {group=1, level=65, reward={10080001,20000000}, groupReward={{10020001,2000},{50010005,1},{50010003,1},{60035075,1}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_newarea_offerreward) do
	setmetatable(v, mt)
end

return cfg_newarea_offerreward