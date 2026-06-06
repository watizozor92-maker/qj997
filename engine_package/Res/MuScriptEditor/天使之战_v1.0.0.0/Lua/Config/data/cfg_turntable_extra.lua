-- 此文件工具自动生成，不要修改
---@class cfg_turntable_extra_column
---唯一id
---@field id number @id column=1 A
---填cfg_turntable的id
---@field relevance number @关联活动 column=2 B
---在对应奖池里累计抽取次数
---@field num number @累计次数 column=3 C
---根职业ID（career表baseCareer字段）#道具ID#数量|根职业ID#道具ID#数量
---@field reward IntListList @奖励 column=4 D
---界面中央大奖展示标记
---大奖填1，按从上到下顺序自动在中间从左到右排列
---
---@field bigReward number @大奖展示 column=5 E

local local_reward = {
    reward_1={{1,40011402,5},{2,40011402,5},{3,40011402,5}},
    reward_2={{1,40011403,3},{2,40011403,3},{3,40011403,3}},
    reward_3={{1,40011404,1},{2,40011404,1},{3,40011404,1}},
    reward_4={{1,40011404,5},{2,40011404,5},{3,40011404,5}},
    reward_5={{1,40011405,3},{2,40011405,3},{3,40011405,3}},
    reward_6={{1,40011406,1},{2,40011406,1},{3,40011406,1}},
    reward_7={{1,40011405,5},{2,40011405,5},{3,40011405,5}},
    reward_8={{1,40011406,3},{2,40011406,3},{3,40011406,3}},
    reward_9={{1,40011407,1},{2,40011407,1},{3,40011407,1}},

}

local cfg_turntable_extra =
{
	{id=1001},
	{id=1002, num=200, reward=local_reward.reward_2},
	{id=1003, num=300, reward=local_reward.reward_3},
	{id=1004, num=400, reward={{1,61300001,1},{2,61300001,1},{3,61300001,1}}, bigReward=1},
	{id=1005, num=550, reward={{1,61400004,1},{2,61400004,1},{3,61400004,1}}, bigReward=1},
	{id=2001, relevance=201},
	{id=2002, relevance=201, num=200, reward=local_reward.reward_2},
	{id=2003, relevance=201, num=300, reward=local_reward.reward_3},
	{id=2004, relevance=201, num=400, reward={{1,61300004,1},{2,61300004,1},{3,61300004,1}}, bigReward=1},
	{id=2005, relevance=201, num=550, reward={{1,61400005,1},{2,61400005,1},{3,61400005,1}}, bigReward=1},
	{id=3001, relevance=301, reward=local_reward.reward_4},
	{id=3002, relevance=301, num=200, reward=local_reward.reward_5},
	{id=3003, relevance=301, num=300, reward=local_reward.reward_6},
	{id=3004, relevance=301, num=400, reward={{1,61300005,1},{2,61300005,1},{3,61300005,1}}, bigReward=1},
	{id=3005, relevance=301, num=550, reward={{1,61400006,1},{2,61400006,1},{3,61400006,1}}, bigReward=1},
	{id=4001, relevance=401, reward=local_reward.reward_4},
	{id=4002, relevance=401, num=200, reward=local_reward.reward_5},
	{id=4003, relevance=401, num=300, reward=local_reward.reward_6},
	{id=4004, relevance=401, num=400, reward={{1,61300006,1},{2,61300006,1},{3,61300006,1}}, bigReward=1},
	{id=4005, relevance=401, num=550, reward={{1,61400007,1},{2,61400007,1},{3,61400007,1}}, bigReward=1},
	{id=5001, relevance=501, reward=local_reward.reward_7},
	{id=5002, relevance=501, num=200, reward=local_reward.reward_8},
	{id=5003, relevance=501, num=300, reward=local_reward.reward_9},
	{id=5004, relevance=501, num=400, reward={{1,61300007,1},{2,61300007,1},{3,61300007,1}}, bigReward=1},
	{id=5005, relevance=501, num=550, reward={{1,61400008,1},{2,61400008,1},{3,61400008,1}}, bigReward=1},
	{id=6001, relevance=601, reward=local_reward.reward_7},
	{id=6002, relevance=601, num=200, reward=local_reward.reward_8},
	{id=6003, relevance=601, num=300, reward=local_reward.reward_9},
	{id=6004, relevance=601, num=400, reward={{1,61300008,1},{2,61300008,1},{3,61300008,1}}, bigReward=1},
	{id=6005, relevance=601, num=550, reward={{1,61400009,1},{2,61400009,1},{3,61400009,1}}, bigReward=1},
}

local defaults = {relevance=101, num=100, reward={{1,40011402,5},{2,40011402,5},{3,40011402,5}}, bigReward=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_turntable_extra) do
	setmetatable(v, mt)
end

return cfg_turntable_extra