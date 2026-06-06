-- 此文件工具自动生成，不要修改
---@class cfg_bigUncharted_column
---副本ID
---@field id number @唯一id column=1 A
---策划备注
---[[客户端不使用]]@field cehua string @备注 column=2 B
---对应钥匙等级可抢网的副本
---@field level number @钥匙等级 column=3 C
---关联cfg_repTask表ID，完成该任务则副本通关
---@field task number @通关任务 column=4 D
---通关时间#通关时间
---单位（分）
---@field time IntList @通关时间 column=5 E
---对应通关时间对副本进行评级
---@field score StringList @通关评价 column=6 F
---对应通关时间对钥匙进行升级或者降级
---@field levelUp IntList @钥匙升级 column=7 G
---通关后可选择是否领取的奖励
---itemID#数量|itemID#数量
---@field reward IntListList @奖励 column=8 H
---中途退出副本后，对钥匙进行降级
---@field penalize number @退出副本惩罚 column=9 I

local local_time = {
    time_1={7,8,9,60},
    time_2={8,9,10,60},

}

local local_score = {
    score_1={"SSS","SS","S","B"},

}

local local_levelUp = {
    levelUp_1={3,2,1,-1},
    levelUp_2={2,2,1,-1},
    levelUp_3={1,1,1,-1},
    levelUp_4={0,0,0,-1},

}

local local_reward = {
    reward_1={{50040901,400}},

}

local cfg_bigUncharted =
{
	{id=19001, level=1, task=19001021, time=local_time.time_1, reward={{50040101,200}}},
	{id=19002, level=2, task=19002021, time=local_time.time_1, reward={{50040101,250}}},
	{id=19003, level=3, task=19003021, time=local_time.time_1, reward={{50040101,300}}},
	{id=19004, level=4, task=19004021, time=local_time.time_1, reward={{50040101,350}}},
	{id=19005, level=5, task=19005021, time=local_time.time_1, reward={{50040101,400}}},
	{id=19006, level=6, task=19006021, time=local_time.time_1, reward={{50040201,200}}},
	{id=19007, level=7, task=19007021, time=local_time.time_1, reward={{50040201,250}}},
	{id=19008, level=8, task=19008021, time=local_time.time_1, reward={{50040201,300}}},
	{id=19009, level=9, task=19009021, time=local_time.time_1, reward={{50040201,350}}},
	{id=19010, level=10, task=19010021, time=local_time.time_1, reward={{50040201,400}}},
	{id=19011, level=11, task=19011021, time=local_time.time_1, reward={{50040301,200}}},
	{id=19012, level=12, task=19012021, time=local_time.time_1, reward={{50040301,250}}},
	{id=19013, level=13, task=19013021, time=local_time.time_1, reward={{50040301,300}}},
	{id=19014, level=14, task=19014021, time=local_time.time_1, reward={{50040301,350}}},
	{id=19015, level=15, task=19015021, time=local_time.time_1, reward={{50040301,400}}},
	{id=19016, level=16, task=19016021, reward={{50040401,200}}},
	{id=19017, level=17, task=19017021, reward={{50040401,250}}},
	{id=19018, level=18, task=19018021, reward={{50040401,300}}},
	{id=19019, level=19, task=19019021, reward={{50040401,350}}},
	{id=19020, level=20, task=19020021, reward={{50040401,400}}},
	{id=19021, level=21, task=19021021, reward={{50040501,200}}},
	{id=19022, level=22, task=19022021, reward={{50040501,250}}},
	{id=19023, level=23, task=19023021, reward={{50040501,300}}},
	{id=19024, level=24, task=19024021, reward={{50040501,350}}},
	{id=19025, level=25, task=19025021, reward={{50040501,400}}},
	{id=19026, level=26, task=19026021, reward={{50040601,200}}},
	{id=19027, level=27, task=19027021, reward={{50040601,250}}},
	{id=19028, level=28, task=19028021, reward={{50040601,300}}},
	{id=19029, level=29, task=19029021, reward={{50040601,350}}},
	{id=19030, level=30, task=19030021, reward={{50040601,400}}},
	{id=19031, level=31, task=19031021, reward={{50040701,200}}},
	{id=19032, level=32, task=19032021, reward={{50040701,250}}},
	{id=19033, level=33, task=19033021, reward={{50040701,300}}},
	{id=19034, level=34, task=19034021, reward={{50040701,350}}},
	{id=19035, level=35, task=19035021, reward={{50040701,400}}},
	{id=19036, level=36, task=19036021, reward={{50040801,200}}},
	{id=19037, level=37, task=19037021, reward={{50040801,250}}},
	{id=19038, level=38, task=19038021, reward={{50040801,300}}},
	{id=19039, level=39, task=19039021, reward={{50040801,350}}},
	{id=19040, level=40, task=19040021, reward={{50040801,400}}},
	{id=19041, level=41, task=19041021, reward={{50040901,200}}},
	{id=19042, level=42, task=19042021, reward={{50040901,250}}},
	{id=19043, level=43, task=19043021, levelUp=local_levelUp.levelUp_2, reward={{50040901,300}}},
	{id=19044, level=44, task=19044021, levelUp=local_levelUp.levelUp_3, reward={{50040901,350}}},
	{id=19045, level=45, task=19045021, levelUp=local_levelUp.levelUp_4},
	{id=19046, level=46, task=19046021},
	{id=19047, level=47, task=19047021},
	{id=19048, level=48, task=19048021, levelUp=local_levelUp.levelUp_2},
	{id=19049, level=49, task=19049021, levelUp=local_levelUp.levelUp_3},
	{id=19050, level=50, task=19050021, levelUp=local_levelUp.levelUp_4},
}

local defaults = {time={8,9,10,60}, score={"SSS","SS","S","B"}, levelUp={3,2,1,-1}, reward={{50040901,400}}, penalize=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_bigUncharted) do
	setmetatable(v, mt)
end

return cfg_bigUncharted