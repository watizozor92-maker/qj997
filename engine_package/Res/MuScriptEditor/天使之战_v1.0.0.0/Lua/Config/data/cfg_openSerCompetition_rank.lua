-- 此文件工具自动生成，不要修改
---@class cfg_openSerCompetition_rank_column
---唯一id
---@field id number @id column=1 A
---1等级冲刺；2恶魔效率；3活跃收集；4二连击等级；5强化等级；6追加等级；7勇气试炼；8套装冲榜；9变身；10大天使装备
---@field rankGroup number @竞技排行组 column=2 B
---同一竞技排行组中的排行名次
---@field rank number @排行名次 column=3 C
---格式：根职业id#道具id#道具数量|根职业id#道具id#道具数量（同一根职业多个id道具，就配置多个相同的根职业id）
---@field rankReward IntListList @排行奖励 column=4 D

local local_rankReward = {
    rankReward_1={{1,50040041,1},{1,10020001,2000},{1,50040059,3},{2,50040041,1},{2,10020001,2000},{2,50040059,3},{3,50040041,1},{3,10020001,2000},{3,50040059,3}},
    rankReward_2={{1,50040097,50},{1,10020001,1000},{1,50030003,3},{2,50040097,50},{2,10020001,1000},{2,50030003,3},{3,50040097,50},{3,10020001,1000},{3,50030003,3}},
    rankReward_3={{1,50040097,30},{1,10020001,1000},{1,50030003,3},{2,50040097,30},{2,10020001,1000},{2,50030003,3},{3,50040097,30},{3,10020001,1000},{3,50030003,3}},
    rankReward_4={{1,50040041,1},{1,10020001,5000},{1,50040061,3},{2,50040041,1},{2,10020001,5000},{2,50040061,3},{3,50040041,1},{3,10020001,5000},{3,50040061,3}},
    rankReward_5={{1,50040015,1},{1,10020001,2000},{1,50040059,3},{2,50040015,1},{2,10020001,2000},{2,50040059,3},{3,50040015,1},{3,10020001,2000},{3,50040059,3}},
    rankReward_6={{1,50040015,1},{1,10020001,5000},{1,50040061,3},{2,50040015,1},{2,10020001,5000},{2,50040061,3},{3,50040015,1},{3,10020001,5000},{3,50040061,3}},

}

local cfg_openSerCompetition_rank =
{
	{id=101, rankReward={{1,10040001,10000},{1,20310431,1},{1,50030002,1},{2,10040001,10000},{2,20120431,1},{2,50030002,1},{3,10040001,10000},{3,20230431,1},{3,50030002,1}}},
	{id=102, rank=2, rankReward={{1,10040001,9000},{1,20310431,1},{1,50030002,1},{2,10040001,9000},{2,20120431,1},{2,50030002,1},{3,10040001,9000},{3,20230431,1},{3,50030002,1}}},
	{id=103, rank=3, rankReward={{1,10040001,8000},{1,20310431,1},{1,50030002,1},{2,10040001,8000},{2,20120431,1},{2,50030002,1},{3,10040001,8000},{3,20230431,1},{3,50030002,1}}},
	{id=104, rank=4, rankReward={{1,10040001,7000},{1,20310431,1},{1,50030002,1},{2,10040001,7000},{2,20120431,1},{2,50030002,1},{3,10040001,7000},{3,20230431,1},{3,50030002,1}}},
	{id=105, rank=5, rankReward={{1,10040001,6000},{1,20310431,1},{1,50030002,1},{2,10040001,6000},{2,20120431,1},{2,50030002,1},{3,10040001,6000},{3,20230431,1},{3,50030002,1}}},
	{id=106, rank=6, rankReward={{1,10040001,5000},{1,20310431,1},{1,50030002,1},{2,10040001,5000},{2,20120431,1},{2,50030002,1},{3,10040001,5000},{3,20230431,1},{3,50030002,1}}},
	{id=107, rank=7, rankReward={{1,10040001,4000},{1,20310431,1},{1,50030002,1},{2,10040001,4000},{2,20120431,1},{2,50030002,1},{3,10040001,4000},{3,20230431,1},{3,50030002,1}}},
	{id=108, rank=8, rankReward={{1,10040001,3000},{1,20310431,1},{1,50030002,1},{2,10040001,3000},{2,20120431,1},{2,50030002,1},{3,10040001,3000},{3,20230431,1},{3,50030002,1}}},
	{id=109, rank=9, rankReward={{1,10040001,2000},{1,20310431,1},{1,50030002,1},{2,10040001,2000},{2,20120431,1},{2,50030002,1},{3,10040001,2000},{3,20230431,1},{3,50030002,1}}},
	{id=110, rank=10, rankReward={{1,10040001,1000},{1,20310431,1},{1,50030002,1},{2,10040001,1000},{2,20120431,1},{2,50030002,1},{3,10040001,1000},{3,20230431,1},{3,50030002,1}}},
	{id=201, rankGroup=2, rankReward=local_rankReward.rankReward_4},
	{id=202, rankGroup=2, rank=2, rankReward=local_rankReward.rankReward_1},
	{id=203, rankGroup=2, rank=3, rankReward=local_rankReward.rankReward_1},
	{id=204, rankGroup=2, rank=4, rankReward=local_rankReward.rankReward_2},
	{id=205, rankGroup=2, rank=5, rankReward=local_rankReward.rankReward_2},
	{id=206, rankGroup=2, rank=6},
	{id=207, rankGroup=2, rank=7},
	{id=208, rankGroup=2, rank=8},
	{id=209, rankGroup=2, rank=9},
	{id=210, rankGroup=2, rank=10},
	{id=301, rankGroup=3, rankReward=local_rankReward.rankReward_4},
	{id=302, rankGroup=3, rank=2, rankReward=local_rankReward.rankReward_1},
	{id=303, rankGroup=3, rank=3, rankReward=local_rankReward.rankReward_1},
	{id=304, rankGroup=3, rank=4, rankReward=local_rankReward.rankReward_2},
	{id=305, rankGroup=3, rank=5, rankReward=local_rankReward.rankReward_2},
	{id=306, rankGroup=3, rank=6},
	{id=307, rankGroup=3, rank=7},
	{id=308, rankGroup=3, rank=8},
	{id=309, rankGroup=3, rank=9},
	{id=310, rankGroup=3, rank=10},
	{id=401, rankGroup=4, rankReward=local_rankReward.rankReward_4},
	{id=402, rankGroup=4, rank=2, rankReward=local_rankReward.rankReward_1},
	{id=403, rankGroup=4, rank=3, rankReward=local_rankReward.rankReward_1},
	{id=404, rankGroup=4, rank=4, rankReward=local_rankReward.rankReward_2},
	{id=405, rankGroup=4, rank=5, rankReward=local_rankReward.rankReward_2},
	{id=406, rankGroup=4, rank=6},
	{id=407, rankGroup=4, rank=7},
	{id=408, rankGroup=4, rank=8},
	{id=409, rankGroup=4, rank=9},
	{id=410, rankGroup=4, rank=10},
	{id=501, rankGroup=5, rankReward=local_rankReward.rankReward_4},
	{id=502, rankGroup=5, rank=2, rankReward=local_rankReward.rankReward_1},
	{id=503, rankGroup=5, rank=3, rankReward=local_rankReward.rankReward_1},
	{id=504, rankGroup=5, rank=4, rankReward=local_rankReward.rankReward_2},
	{id=505, rankGroup=5, rank=5, rankReward=local_rankReward.rankReward_2},
	{id=506, rankGroup=5, rank=6},
	{id=507, rankGroup=5, rank=7},
	{id=508, rankGroup=5, rank=8},
	{id=509, rankGroup=5, rank=9},
	{id=510, rankGroup=5, rank=10},
	{id=601, rankGroup=6, rankReward=local_rankReward.rankReward_6},
	{id=602, rankGroup=6, rank=2, rankReward=local_rankReward.rankReward_5},
	{id=603, rankGroup=6, rank=3, rankReward=local_rankReward.rankReward_5},
	{id=604, rankGroup=6, rank=4, rankReward=local_rankReward.rankReward_2},
	{id=605, rankGroup=6, rank=5, rankReward=local_rankReward.rankReward_2},
	{id=606, rankGroup=6, rank=6},
	{id=607, rankGroup=6, rank=7},
	{id=608, rankGroup=6, rank=8},
	{id=609, rankGroup=6, rank=9},
	{id=610, rankGroup=6, rank=10},
	{id=701, rankGroup=7, rankReward=local_rankReward.rankReward_6},
	{id=702, rankGroup=7, rank=2, rankReward=local_rankReward.rankReward_5},
	{id=703, rankGroup=7, rank=3, rankReward=local_rankReward.rankReward_5},
	{id=704, rankGroup=7, rank=4, rankReward=local_rankReward.rankReward_2},
	{id=705, rankGroup=7, rank=5, rankReward=local_rankReward.rankReward_2},
	{id=706, rankGroup=7, rank=6},
	{id=707, rankGroup=7, rank=7},
	{id=708, rankGroup=7, rank=8},
	{id=709, rankGroup=7, rank=9},
	{id=710, rankGroup=7, rank=10},
	{id=801, rankGroup=8, rankReward=local_rankReward.rankReward_6},
	{id=802, rankGroup=8, rank=2, rankReward=local_rankReward.rankReward_5},
	{id=803, rankGroup=8, rank=3, rankReward=local_rankReward.rankReward_5},
	{id=804, rankGroup=8, rank=4, rankReward=local_rankReward.rankReward_2},
	{id=805, rankGroup=8, rank=5, rankReward=local_rankReward.rankReward_2},
	{id=806, rankGroup=8, rank=6},
	{id=807, rankGroup=8, rank=7},
	{id=808, rankGroup=8, rank=8},
	{id=809, rankGroup=8, rank=9},
	{id=810, rankGroup=8, rank=10},
	{id=901, rankGroup=9, rankReward=local_rankReward.rankReward_6},
	{id=902, rankGroup=9, rank=2, rankReward=local_rankReward.rankReward_5},
	{id=903, rankGroup=9, rank=3, rankReward=local_rankReward.rankReward_5},
	{id=904, rankGroup=9, rank=4, rankReward=local_rankReward.rankReward_2},
	{id=905, rankGroup=9, rank=5, rankReward=local_rankReward.rankReward_2},
	{id=906, rankGroup=9, rank=6},
	{id=907, rankGroup=9, rank=7},
	{id=908, rankGroup=9, rank=8},
	{id=909, rankGroup=9, rank=9},
	{id=910, rankGroup=9, rank=10},
	{id=1001, rankGroup=10, rankReward=local_rankReward.rankReward_6},
	{id=1002, rankGroup=10, rank=2, rankReward=local_rankReward.rankReward_5},
	{id=1003, rankGroup=10, rank=3, rankReward=local_rankReward.rankReward_5},
	{id=1004, rankGroup=10, rank=4, rankReward=local_rankReward.rankReward_2},
	{id=1005, rankGroup=10, rank=5, rankReward=local_rankReward.rankReward_2},
	{id=1006, rankGroup=10, rank=6},
	{id=1007, rankGroup=10, rank=7},
	{id=1008, rankGroup=10, rank=8},
	{id=1009, rankGroup=10, rank=9},
	{id=1010, rankGroup=10, rank=10},
}

local defaults = {rankGroup=1, rank=1, rankReward={{1,50040097,30},{1,10020001,1000},{1,50030003,3},{2,50040097,30},{2,10020001,1000},{2,50030003,3},{3,50040097,30},{3,10020001,1000},{3,50030003,3}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_openSerCompetition_rank) do
	setmetatable(v, mt)
end

return cfg_openSerCompetition_rank