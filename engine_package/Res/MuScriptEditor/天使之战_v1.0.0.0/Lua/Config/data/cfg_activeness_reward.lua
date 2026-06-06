-- 此文件工具自动生成，不要修改
---@class cfg_activeness_reward_column
---活跃值对应宝箱编号
---@field id number @编号 column=1 A
---再该等级区间得玩家显示该档奖励
---@field level IntList @等级区间 column=2 B
---可以领取的活跃值
---@field axNum number @活跃度值 column=3 C
---道具id#数量|道具id#数量
---@field caxItem IntListList @必得奖励道具 column=4 D
---格式：道具id#数量#权重|道具id#数量#权重
---@field randomReward IntListList @随机奖励道具 column=5 E
---活跃度宝箱图标
---@field chestIcon string @宝箱图标 column=6 F

local local_level = {
    level_1={1,149},
    level_2={150,199},
    level_3={200,249},
    level_4={250,299},
    level_5={300,349},
    level_6={350,399},
    level_7={400,449},
    level_8={450,499},
    level_9={500,549},
    level_10={550,599},
    level_11={600,649},
    level_12={650,699},
    level_13={700,749},
    level_14={750,799},
    level_15={800,849},
    level_16={850,899},
    level_17={900,949},
    level_18={950,999},
    level_19={1000,9999},

}

local local_caxItem = {
    caxItem_1={{10010001,142000},{50040043,1},{50040044,1}},
    caxItem_2={{10010001,152000},{50040011,1},{50040012,1}},
    caxItem_3={{10010001,162000},{50030002,1},{50040074,8}},
    caxItem_4={{10010001,172000},{50030003,1},{50040057,8}},
    caxItem_5={{10010001,182000},{50030004,1},{50040059,8}},

}

local local_randomReward = {
    randomReward_1={},

}

local cfg_activeness_reward =
{
	{id=1, caxItem={{10010001,40000},{50040043,1},{50040044,1}}},
	{id=2, axNum=40, caxItem={{10010001,50000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=3, axNum=60, caxItem={{10010001,60000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=4, axNum=80, caxItem={{10010001,70000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=5, axNum=100, caxItem={{10010001,80000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=11, level=local_level.level_2, caxItem={{10010001,46000},{50040043,1},{50040044,1}}},
	{id=12, level=local_level.level_2, axNum=40, caxItem={{10010001,56000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=13, level=local_level.level_2, axNum=60, caxItem={{10010001,66000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=14, level=local_level.level_2, axNum=80, caxItem={{10010001,76000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=15, level=local_level.level_2, axNum=100, caxItem={{10010001,86000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=21, level=local_level.level_3, caxItem={{10010001,52000},{50040043,1},{50040044,1}}},
	{id=22, level=local_level.level_3, axNum=40, caxItem={{10010001,62000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=23, level=local_level.level_3, axNum=60, caxItem={{10010001,72000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=24, level=local_level.level_3, axNum=80, caxItem={{10010001,82000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=25, level=local_level.level_3, axNum=100, caxItem={{10010001,92000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=31, level=local_level.level_4, caxItem={{10010001,58000},{50040043,1},{50040044,1}}},
	{id=32, level=local_level.level_4, axNum=40, caxItem={{10010001,68000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=33, level=local_level.level_4, axNum=60, caxItem={{10010001,78000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=34, level=local_level.level_4, axNum=80, caxItem={{10010001,88000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=35, level=local_level.level_4, axNum=100, caxItem={{10010001,98000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=41, level=local_level.level_5, caxItem={{10010001,62000},{50040043,1},{50040044,1}}},
	{id=42, level=local_level.level_5, axNum=40, caxItem={{10010001,72000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=43, level=local_level.level_5, axNum=60, caxItem={{10010001,88000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=44, level=local_level.level_5, axNum=80, caxItem={{10010001,96000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=45, level=local_level.level_5, axNum=100, caxItem={{10010001,102000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=51, level=local_level.level_6, caxItem={{10010001,70000},{50040043,1},{50040044,1}}},
	{id=52, level=local_level.level_6, axNum=40, caxItem={{10010001,80000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=53, level=local_level.level_6, axNum=60, caxItem={{10010001,90000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=54, level=local_level.level_6, axNum=80, caxItem={{10010001,100000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=55, level=local_level.level_6, axNum=100, caxItem={{10010001,110000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=61, level=local_level.level_7, caxItem={{10010001,76000},{50040043,1},{50040044,1}}},
	{id=62, level=local_level.level_7, axNum=40, caxItem={{10010001,86000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=63, level=local_level.level_7, axNum=60, caxItem={{10010001,96000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=64, level=local_level.level_7, axNum=80, caxItem={{10010001,106000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=65, level=local_level.level_7, axNum=100, caxItem={{10010001,116000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=71, level=local_level.level_8, caxItem={{10010001,82000},{50040043,1},{50040044,1}}},
	{id=72, level=local_level.level_8, axNum=40, caxItem={{10010001,92000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=73, level=local_level.level_8, axNum=60, caxItem={{10010001,102000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=74, level=local_level.level_8, axNum=80, caxItem={{10010001,112000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=75, level=local_level.level_8, axNum=100, caxItem={{10010001,122000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=81, level=local_level.level_9, caxItem={{10010001,88000},{50040043,1},{50040044,1}}},
	{id=82, level=local_level.level_9, axNum=40, caxItem={{10010001,98000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=83, level=local_level.level_9, axNum=60, caxItem={{10010001,108000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=84, level=local_level.level_9, axNum=80, caxItem={{10010001,118000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=85, level=local_level.level_9, axNum=100, caxItem={{10010001,128000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=86, level=local_level.level_10, caxItem={{10010001,94000},{50040043,1},{50040044,1}}},
	{id=87, level=local_level.level_10, axNum=40, caxItem={{10010001,104000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=88, level=local_level.level_10, axNum=60, caxItem={{10010001,114000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=89, level=local_level.level_10, axNum=80, caxItem={{10010001,124000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=90, level=local_level.level_10, axNum=100, caxItem={{10010001,134000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=91, level=local_level.level_11, caxItem={{10010001,100000},{50040043,1},{50040044,1}}},
	{id=92, level=local_level.level_11, axNum=40, caxItem={{10010001,110000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=93, level=local_level.level_11, axNum=60, caxItem={{10010001,120000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=94, level=local_level.level_11, axNum=80, caxItem={{10010001,130000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=95, level=local_level.level_11, axNum=100, caxItem={{10010001,140000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=96, level=local_level.level_12, caxItem={{10010001,106000},{50040043,1},{50040044,1}}},
	{id=97, level=local_level.level_12, axNum=40, caxItem={{10010001,116000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=98, level=local_level.level_12, axNum=60, caxItem={{10010001,126000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=99, level=local_level.level_12, axNum=80, caxItem={{10010001,136000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=100, level=local_level.level_12, axNum=100, caxItem={{10010001,146000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=101, level=local_level.level_13, caxItem={{10010001,112000},{50040043,1},{50040044,1}}},
	{id=102, level=local_level.level_13, axNum=40, caxItem={{10010001,122000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=103, level=local_level.level_13, axNum=60, caxItem={{10010001,132000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=104, level=local_level.level_13, axNum=80, caxItem={{10010001,142000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=105, level=local_level.level_13, axNum=100, caxItem={{10010001,152000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=106, level=local_level.level_14, caxItem={{10010001,118000},{50040043,1},{50040044,1}}},
	{id=107, level=local_level.level_14, axNum=40, caxItem={{10010001,128000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=108, level=local_level.level_14, axNum=60, caxItem={{10010001,138000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=109, level=local_level.level_14, axNum=80, caxItem={{10010001,148000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=110, level=local_level.level_14, axNum=100, caxItem={{10010001,158000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=111, level=local_level.level_15, caxItem={{10010001,124000},{50040043,1},{50040044,1}}},
	{id=112, level=local_level.level_15, axNum=40, caxItem={{10010001,134000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=113, level=local_level.level_15, axNum=60, caxItem={{10010001,144000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=114, level=local_level.level_15, axNum=80, caxItem={{10010001,154000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=115, level=local_level.level_15, axNum=100, caxItem={{10010001,164000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=116, level=local_level.level_16, caxItem={{10010001,130000},{50040043,1},{50040044,1}}},
	{id=117, level=local_level.level_16, axNum=40, caxItem={{10010001,140000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=118, level=local_level.level_16, axNum=60, caxItem={{10010001,150000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=119, level=local_level.level_16, axNum=80, caxItem={{10010001,160000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=120, level=local_level.level_16, axNum=100, caxItem={{10010001,170000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=121, level=local_level.level_17, caxItem={{10010001,136000},{50040043,1},{50040044,1}}},
	{id=122, level=local_level.level_17, axNum=40, caxItem={{10010001,146000},{50040011,1},{50040012,1}}, chestIcon="img_activity_37"},
	{id=123, level=local_level.level_17, axNum=60, caxItem={{10010001,156000},{50030002,1},{50040074,8}}, chestIcon="img_activity_38"},
	{id=124, level=local_level.level_17, axNum=80, caxItem={{10010001,166000},{50030003,1},{50040057,8}}, chestIcon="img_activity_39"},
	{id=125, level=local_level.level_17, axNum=100, caxItem={{10010001,176000},{50030004,1},{50040059,8}}, chestIcon="img_activity_40"},
	{id=126, level=local_level.level_18},
	{id=127, level=local_level.level_18, axNum=40, caxItem=local_caxItem.caxItem_2, chestIcon="img_activity_37"},
	{id=128, level=local_level.level_18, axNum=60, caxItem=local_caxItem.caxItem_3, chestIcon="img_activity_38"},
	{id=129, level=local_level.level_18, axNum=80, caxItem=local_caxItem.caxItem_4, chestIcon="img_activity_39"},
	{id=130, level=local_level.level_18, axNum=100, caxItem=local_caxItem.caxItem_5, chestIcon="img_activity_40"},
	{id=131, level=local_level.level_19},
	{id=132, level=local_level.level_19, axNum=40, caxItem=local_caxItem.caxItem_2, chestIcon="img_activity_37"},
	{id=133, level=local_level.level_19, axNum=60, caxItem=local_caxItem.caxItem_3, chestIcon="img_activity_38"},
	{id=134, level=local_level.level_19, axNum=80, caxItem=local_caxItem.caxItem_4, chestIcon="img_activity_39"},
	{id=135, level=local_level.level_19, axNum=100, caxItem=local_caxItem.caxItem_5, chestIcon="img_activity_40"},
}

local defaults = {level={1,149}, axNum=20, caxItem={{10010001,142000},{50040043,1},{50040044,1}}, randomReward={}, chestIcon="img_activity_36"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_activeness_reward) do
	setmetatable(v, mt)
end

return cfg_activeness_reward