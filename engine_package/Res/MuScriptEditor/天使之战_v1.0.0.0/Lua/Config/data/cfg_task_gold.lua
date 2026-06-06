-- 此文件工具自动生成，不要修改
---@class cfg_task_gold_column
---@field id number @编号 column=1 A
---引用怪物表id
---@field monsterId number @怪物id column=2 B
---填写怪物所在的地图
---@field mapName string @任务描述 column=3 C
---等级下限#等级上限
---不填则没有等级限制
---@field level IntList @等级 column=4 D
---@field weight number @任务出现的权重 column=5 E
---1星权重#2星权重#3星权重
---（万分比）
---@field probability IntList @星级权重 column=6 F
---1星权重#2星权重#3星权重
---（万分比）
---仅在付费刷新的时候调用
---@field specialProbability IntList @特殊星级权重 column=7 G
---1星数量#2星数量#3星数量
---@field taskGoalNum IntList @任务目标数量 column=8 H
---格式：道具id#道具数量|道具id#道具数量
---修正id为0或空表示不修正
---@field rewardItem1 IntListList @1星任务奖励 column=9 I
---格式：道具id#道具数量#修正id|道具id#道具数量#修正id
---@field rewardItem2 IntListList @2星任务奖励 column=10 J
---格式：道具id#道具数量#修正id|道具id#道具数量#修正id
---@field rewardItem3 IntListList @3星任务奖励 column=11 K
---@field rewardExpNum1 number @1星经验数量 column=12 L
---@field rewardExpNum2 number @2星经验数量 column=13 M
---@field rewardExpNum3 number @3星经验数量 column=14 N
---默认填1
---@field monlist number @怪物列表 column=15 O

local local_level = {
    level_1={65,99},
    level_2={100,149},
    level_3={150,199},
    level_4={200,249},
    level_5={250,299},
    level_6={300,349},
    level_7={350,399},
    level_8={400,449},
    level_9={450,499},
    level_10={500,549},
    level_11={550,599},
    level_12={600,649},
    level_13={650,699},
    level_14={700,749},
    level_15={750,799},
    level_16={800,849},
    level_17={850,899},
    level_18={900,949},
    level_19={950,999},
    level_20={950,1000},

}

local local_probability = {
    probability_1={6667,2500,833},

}

local local_specialProbability = {
    specialProbability_1={6667,2500,833},

}

local local_taskGoalNum = {
    taskGoalNum_1={2,3,4},

}

local local_rewardItem1 = {
    rewardItem1_1={{50040028,100},{50030002,1}},

}

local local_rewardItem2 = {
    rewardItem2_1={{50040028,200},{50030002,2}},

}

local local_rewardItem3 = {
    rewardItem3_1={{50040028,300},{50030002,2},{50030003,1}},

}

local cfg_task_gold =
{
	{id=1, monsterId=500025, level=local_level.level_1},
	{id=2, monsterId=500026, level=local_level.level_1},
	{id=3, monsterId=500029, level=local_level.level_1},
	{id=4, monsterId=500030, mapName="死亡沙漠", level=local_level.level_2},
	{id=5, monsterId=500031, mapName="死亡沙漠", level=local_level.level_2},
	{id=6, monsterId=500033, mapName="死亡沙漠", level=local_level.level_2},
	{id=7, monsterId=500037, mapName="幽暗森林"},
	{id=8, monsterId=500035, mapName="幽暗森林"},
	{id=9, monsterId=500036, mapName="幽暗森林"},
	{id=10, monsterId=500038, mapName="天空之城"},
	{id=11, monsterId=500039, mapName="天空之城"},
	{id=12, monsterId=500040, mapName="天空之城"},
	{id=13, monsterId=500043, mapName="坎特鲁废墟", level=local_level.level_4},
	{id=14, monsterId=500045, mapName="坎特鲁废墟", level=local_level.level_4},
	{id=15, monsterId=500047, mapName="坎特鲁废墟", level=local_level.level_4},
	{id=16, monsterId=500048, mapName="坎特鲁遗迹", level=local_level.level_5},
	{id=17, monsterId=500049, mapName="坎特鲁遗迹", level=local_level.level_5},
	{id=18, monsterId=500050, mapName="坎特鲁遗迹", level=local_level.level_5},
	{id=19, monsterId=500051, mapName="冰霜之城", level=local_level.level_6},
	{id=20, monsterId=500052, mapName="冰霜之城", level=local_level.level_6},
	{id=21, monsterId=500055, mapName="冰霜之城", level=local_level.level_6},
	{id=22, monsterId=500057, mapName="安宁池", level=local_level.level_7},
	{id=23, monsterId=500059, mapName="安宁池", level=local_level.level_7},
	{id=24, monsterId=500060, mapName="安宁池", level=local_level.level_7},
	{id=25, monsterId=500041, mapName="四风平原", level=local_level.level_8},
	{id=26, monsterId=500042, mapName="四风平原", level=local_level.level_8},
	{id=27, monsterId=500044, mapName="四风平原", level=local_level.level_8},
	{id=28, monsterId=500046, mapName="腐蚀之地", level=local_level.level_9},
	{id=29, monsterId=500053, mapName="腐蚀之地", level=local_level.level_9},
	{id=30, monsterId=500054, mapName="腐蚀之地", level=local_level.level_9},
	{id=31, monsterId=500056, mapName="永歌森林", level=local_level.level_10},
	{id=32, monsterId=500058, mapName="永歌森林", level=local_level.level_10},
	{id=33, monsterId=500061, mapName="永歌森林", level=local_level.level_10},
	{id=34, monsterId=500062, mapName="菲利亚", level=local_level.level_11},
	{id=35, monsterId=500063, mapName="菲利亚", level=local_level.level_11},
	{id=36, monsterId=500067, mapName="菲利亚", level=local_level.level_11},
	{id=37, monsterId=500068, mapName="尼克西斯湖", level=local_level.level_12},
	{id=38, monsterId=500069, mapName="尼克西斯湖", level=local_level.level_12},
	{id=39, monsterId=500070, mapName="尼克西斯湖", level=local_level.level_12},
	{id=40, monsterId=650004, mapName="深渊地下城", level=local_level.level_13},
	{id=41, monsterId=650005, mapName="深渊地下城", level=local_level.level_13},
	{id=42, monsterId=650006, mapName="深渊地下城", level=local_level.level_13},
	{id=43, monsterId=500071, mapName="暗魂之森林", level=local_level.level_14},
	{id=44, monsterId=500072, mapName="暗魂之森林", level=local_level.level_14},
	{id=45, monsterId=500073, mapName="暗魂之森林", level=local_level.level_14},
	{id=46, monsterId=500074, mapName="黑暗之沼泽", level=local_level.level_15},
	{id=47, monsterId=500075, mapName="黑暗之沼泽", level=local_level.level_15},
	{id=48, monsterId=500076, mapName="黑暗之沼泽", level=local_level.level_15},
	{id=49, monsterId=500077, mapName="库贝拉矿山", level=local_level.level_16},
	{id=50, monsterId=500078, mapName="库贝拉矿山", level=local_level.level_16},
	{id=51, monsterId=500079, mapName="库贝拉矿山", level=local_level.level_16},
	{id=52, monsterId=500080, mapName="乌尔克山", level=local_level.level_17},
	{id=53, monsterId=500081, mapName="乌尔克山", level=local_level.level_17},
	{id=54, monsterId=500082, mapName="乌尔克山", level=local_level.level_17},
	{id=55, monsterId=500083, mapName="远古地区", level=local_level.level_18},
	{id=56, monsterId=500084, mapName="远古地区", level=local_level.level_18},
	{id=57, monsterId=500085, mapName="远古地区", level=local_level.level_18},
	{id=58, monsterId=500086, mapName="阿卡玛尔", level=local_level.level_19},
	{id=59, monsterId=500087, mapName="阿卡玛尔", level=local_level.level_19},
	{id=60, monsterId=500088, mapName="阿卡玛尔", level=local_level.level_19},
	{id=64, monsterId=500025, level=local_level.level_1},
	{id=65, monsterId=500026, level=local_level.level_1},
	{id=66, monsterId=500029, level=local_level.level_1},
	{id=67, monsterId=500030, mapName="死亡沙漠", level=local_level.level_2},
	{id=68, monsterId=500031, mapName="死亡沙漠", level=local_level.level_2},
	{id=69, monsterId=500033, mapName="死亡沙漠", level=local_level.level_2},
	{id=70, monsterId=500037, mapName="幽暗森林"},
	{id=71, monsterId=500035, mapName="幽暗森林"},
	{id=72, monsterId=500036, mapName="幽暗森林"},
	{id=73, monsterId=500038, mapName="天空之城"},
	{id=74, monsterId=500039, mapName="天空之城"},
	{id=75, monsterId=500040, mapName="天空之城"},
	{id=76, monsterId=500043, mapName="坎特鲁废墟", level=local_level.level_4},
	{id=77, monsterId=500045, mapName="坎特鲁废墟", level=local_level.level_4},
	{id=78, monsterId=500047, mapName="坎特鲁废墟", level=local_level.level_4},
	{id=79, monsterId=500048, mapName="坎特鲁遗迹", level=local_level.level_5},
	{id=80, monsterId=500049, mapName="坎特鲁遗迹", level=local_level.level_5},
	{id=81, monsterId=500050, mapName="坎特鲁遗迹", level=local_level.level_5},
	{id=82, monsterId=500051, mapName="冰霜之城", level=local_level.level_6},
	{id=83, monsterId=500052, mapName="冰霜之城", level=local_level.level_6},
	{id=84, monsterId=500055, mapName="冰霜之城", level=local_level.level_6},
	{id=85, monsterId=500057, mapName="安宁池", level=local_level.level_7},
	{id=86, monsterId=500059, mapName="安宁池", level=local_level.level_7},
	{id=87, monsterId=500060, mapName="安宁池", level=local_level.level_7},
	{id=88, monsterId=500041, mapName="四风平原", level=local_level.level_8},
	{id=89, monsterId=500042, mapName="四风平原", level=local_level.level_8},
	{id=90, monsterId=500044, mapName="四风平原", level=local_level.level_8},
	{id=91, monsterId=500046, mapName="腐蚀之地", level=local_level.level_9},
	{id=92, monsterId=500053, mapName="腐蚀之地", level=local_level.level_9},
	{id=93, monsterId=500054, mapName="腐蚀之地", level=local_level.level_9},
	{id=94, monsterId=500056, mapName="永歌森林", level=local_level.level_10},
	{id=95, monsterId=500058, mapName="永歌森林", level=local_level.level_10},
	{id=96, monsterId=500061, mapName="永歌森林", level=local_level.level_10},
	{id=97, monsterId=500062, mapName="菲利亚", level=local_level.level_11},
	{id=98, monsterId=500063, mapName="菲利亚", level=local_level.level_11},
	{id=99, monsterId=500067, mapName="菲利亚", level=local_level.level_11},
	{id=100, monsterId=500068, mapName="尼克西斯湖", level=local_level.level_12},
	{id=101, monsterId=500069, mapName="尼克西斯湖", level=local_level.level_12},
	{id=102, monsterId=500070, mapName="尼克西斯湖", level=local_level.level_12},
	{id=103, monsterId=650004, mapName="深渊地下城", level=local_level.level_13},
	{id=104, monsterId=650005, mapName="深渊地下城", level=local_level.level_13},
	{id=105, monsterId=650006, mapName="深渊地下城", level=local_level.level_13},
	{id=106, monsterId=500071, mapName="暗魂之森林", level=local_level.level_14},
	{id=107, monsterId=500072, mapName="暗魂之森林", level=local_level.level_14},
	{id=108, monsterId=500073, mapName="暗魂之森林", level=local_level.level_14},
	{id=109, monsterId=500074, mapName="黑暗之沼泽", level=local_level.level_15},
	{id=110, monsterId=500075, mapName="黑暗之沼泽", level=local_level.level_15},
	{id=111, monsterId=500076, mapName="黑暗之沼泽", level=local_level.level_15},
	{id=112, monsterId=500077, mapName="库贝拉矿山", level=local_level.level_16},
	{id=113, monsterId=500078, mapName="库贝拉矿山", level=local_level.level_16},
	{id=114, monsterId=500079, mapName="库贝拉矿山", level=local_level.level_16},
	{id=115, monsterId=500080, mapName="乌尔克山", level=local_level.level_17},
	{id=116, monsterId=500081, mapName="乌尔克山", level=local_level.level_17},
	{id=117, monsterId=500082, mapName="乌尔克山", level=local_level.level_17},
	{id=118, monsterId=500083, mapName="远古地区", level=local_level.level_18},
	{id=119, monsterId=500084, mapName="远古地区", level=local_level.level_18},
	{id=120, monsterId=500085, mapName="远古地区", level=local_level.level_18},
	{id=121, monsterId=500086, mapName="阿卡玛尔", level=local_level.level_20},
	{id=122, monsterId=500087, mapName="阿卡玛尔", level=local_level.level_20},
	{id=123, monsterId=500088, mapName="阿卡玛尔", level=local_level.level_20},
}

local defaults = {mapName="亚特兰蒂斯", level={150,199}, weight=10, probability={6667,2500,833}, specialProbability={6667,2500,833}, taskGoalNum={2,3,4}, rewardItem1={{50040028,100},{50030002,1}}, rewardItem2={{50040028,200},{50030002,2}}, rewardItem3={{50040028,300},{50030002,2},{50030003,1}}, rewardExpNum1=0, rewardExpNum2=0, rewardExpNum3=0, monlist=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_task_gold) do
	setmetatable(v, mt)
end

return cfg_task_gold