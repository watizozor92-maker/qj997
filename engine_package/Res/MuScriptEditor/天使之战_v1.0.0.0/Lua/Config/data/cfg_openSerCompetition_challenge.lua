-- 此文件工具自动生成，不要修改
---@class cfg_openSerCompetition_challenge_column
---@field id number @id column=1 A
---1等级冲刺；2恶魔效率；3活跃收集；4二连击等级；5强化等级；6追加等级；7勇气试炼；8套装冲榜；9变身打榜；10大天使竞技
---@field challengeGroup number @个人挑战组 column=2 B
---达成挑战目标需求值
---@field typeDemandValue number @挑战目标需求值 column=3 C
---格式：道具id#道具数量|道具id#道具数量
---@field challengeReward IntListList @挑战奖励 column=4 D
---格式：根职业id#道具id#道具数量|根职业id#道具id#道具数量
---@field limitTimeReward IntListList @限时奖励 column=5 E
---挑战目标详细描述
---@field desc string @挑战目标描述 column=6 F

local local_challengeReward = {
    challengeReward_1={{10040001,100},{50030002,5}},
    challengeReward_2={{50030002,2},{50040075,1}},
    challengeReward_3={{50030003,2},{50040076,1}},
    challengeReward_4={{50030002,2},{50040076,1}},
    challengeReward_5={{50030003,2},{50040077,1}},
    challengeReward_6={{10020001,1000},{50040077,1}},
    challengeReward_7={{50030002,2},{50040077,1}},
    challengeReward_8={{50030003,2},{50040075,1}},
    challengeReward_9={{10020001,3000},{50040076,1}},

}

local local_limitTimeReward = {
    limitTimeReward_1={{1,50030305,1},{2,50030504,1},{3,50030604,1}},
    limitTimeReward_2={},
    limitTimeReward_3={{1,50030004,3},{2,50030004,3},{3,50030004,3}},
    limitTimeReward_4={{1,50030005,3},{2,50030005,3},{3,50030005,3}},
    limitTimeReward_5={{1,50040097,20},{2,50040097,20},{3,50040097,20}},
    limitTimeReward_6={{1,50040013,1},{2,50040013,1},{3,50040013,1}},
    limitTimeReward_7={{1,50040014,1},{2,50040014,1},{3,50040014,1}},

}

local cfg_openSerCompetition_challenge =
{
	{id=101, typeDemandValue=60, challengeReward=local_challengeReward.challengeReward_1, desc="等级到达60级"},
	{id=102, typeDemandValue=70, challengeReward=local_challengeReward.challengeReward_1, desc="等级到达70级"},
	{id=103, typeDemandValue=80, challengeReward=local_challengeReward.challengeReward_1, desc="等级到达80级"},
	{id=104, typeDemandValue=90, challengeReward=local_challengeReward.challengeReward_1, desc="等级到达90级"},
	{id=105, typeDemandValue=100, challengeReward=local_challengeReward.challengeReward_1, desc="等级到达100级"},
	{id=106, typeDemandValue=110, challengeReward=local_challengeReward.challengeReward_1, desc="等级到达110级"},
	{id=107, typeDemandValue=120, challengeReward=local_challengeReward.challengeReward_1, desc="等级到达120级"},
	{id=108, typeDemandValue=130, challengeReward=local_challengeReward.challengeReward_1, desc="等级到达130级"},
	{id=109, typeDemandValue=140, challengeReward=local_challengeReward.challengeReward_1, desc="等级到达140级"},
	{id=110, typeDemandValue=150, challengeReward=local_challengeReward.challengeReward_1, desc="等级到达150级"},
	{id=201, challengeGroup=2, typeDemandValue=230000, challengeReward=local_challengeReward.challengeReward_4, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="恶魔广场效率到达23万/分"},
	{id=202, challengeGroup=2, typeDemandValue=450000, challengeReward=local_challengeReward.challengeReward_5, limitTimeReward=local_limitTimeReward.limitTimeReward_3, desc="恶魔广场效率到达45万/分"},
	{id=203, challengeGroup=2, typeDemandValue=810000, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="恶魔广场效率到达81万/分"},
	{id=204, challengeGroup=2, typeDemandValue=1620000, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_4, desc="恶魔广场效率到达162万/分"},
	{id=205, challengeGroup=2, typeDemandValue=2850000, challengeReward=local_challengeReward.challengeReward_6, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="恶魔广场效率到达285万/分"},
	{id=206, challengeGroup=2, typeDemandValue=3180000, limitTimeReward=local_limitTimeReward.limitTimeReward_5, desc="恶魔广场效率到达318万/分"},
	{id=207, challengeGroup=2, typeDemandValue=4420000, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="恶魔广场效率到达442万/分"},
	{id=208, challengeGroup=2, typeDemandValue=5750000, challengeReward=local_challengeReward.challengeReward_7, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="恶魔广场效率到达575万/分"},
	{id=209, challengeGroup=2, typeDemandValue=8680000, challengeReward=local_challengeReward.challengeReward_8, limitTimeReward=local_limitTimeReward.limitTimeReward_6, desc="恶魔广场效率到达868万/分"},
	{id=210, challengeGroup=2, typeDemandValue=11280000, challengeReward=local_challengeReward.challengeReward_9, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="恶魔广场效率到达1128万/分"},
	{id=301, challengeGroup=3, typeDemandValue=300, challengeReward=local_challengeReward.challengeReward_4, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="累计收集300活跃点"},
	{id=302, challengeGroup=3, typeDemandValue=600, challengeReward=local_challengeReward.challengeReward_5, limitTimeReward=local_limitTimeReward.limitTimeReward_3, desc="累计收集600活跃点"},
	{id=303, challengeGroup=3, typeDemandValue=900, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="累计收集900活跃点"},
	{id=304, challengeGroup=3, typeDemandValue=1000, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_4, desc="累计收集1000活跃点"},
	{id=305, challengeGroup=3, typeDemandValue=1200, challengeReward=local_challengeReward.challengeReward_6, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="累计收集1200活跃点"},
	{id=306, challengeGroup=3, typeDemandValue=1300, limitTimeReward=local_limitTimeReward.limitTimeReward_5, desc="累计收集1300活跃点"},
	{id=307, challengeGroup=3, typeDemandValue=1400, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="累计收集1400活跃点"},
	{id=308, challengeGroup=3, typeDemandValue=1500, challengeReward=local_challengeReward.challengeReward_7, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="累计收集1500活跃点"},
	{id=309, challengeGroup=3, typeDemandValue=1550, challengeReward=local_challengeReward.challengeReward_8, limitTimeReward=local_limitTimeReward.limitTimeReward_6, desc="累计收集1550活跃点"},
	{id=310, challengeGroup=3, typeDemandValue=1600, challengeReward=local_challengeReward.challengeReward_9, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="累计收集1600活跃点"},
	{id=401, challengeGroup=4, typeDemandValue=1, challengeReward=local_challengeReward.challengeReward_4, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="连击等级到达1级"},
	{id=402, challengeGroup=4, typeDemandValue=2, challengeReward=local_challengeReward.challengeReward_5, limitTimeReward=local_limitTimeReward.limitTimeReward_3, desc="连击等级到达2级"},
	{id=403, challengeGroup=4, typeDemandValue=3, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="连击等级到达3级"},
	{id=404, challengeGroup=4, typeDemandValue=4, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_4, desc="连击等级到达4级"},
	{id=405, challengeGroup=4, typeDemandValue=5, challengeReward=local_challengeReward.challengeReward_6, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="连击等级到达5级"},
	{id=406, challengeGroup=4, typeDemandValue=6, limitTimeReward=local_limitTimeReward.limitTimeReward_5, desc="连击等级到达6级"},
	{id=407, challengeGroup=4, typeDemandValue=7, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="连击等级到达7级"},
	{id=408, challengeGroup=4, typeDemandValue=8, challengeReward=local_challengeReward.challengeReward_5, limitTimeReward=local_limitTimeReward.limitTimeReward_7, desc="连击等级到达8级"},
	{id=409, challengeGroup=4, typeDemandValue=9, challengeReward={{10020001,3000},{50040075,1}}, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="连击等级到达9级"},
	{id=501, challengeGroup=5, typeDemandValue=24, challengeReward=local_challengeReward.challengeReward_4, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备强化总等级到达24级"},
	{id=502, challengeGroup=5, typeDemandValue=36, challengeReward=local_challengeReward.challengeReward_5, limitTimeReward=local_limitTimeReward.limitTimeReward_3, desc="装备强化总等级到达36级"},
	{id=503, challengeGroup=5, typeDemandValue=48, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备强化总等级到达48级"},
	{id=504, challengeGroup=5, typeDemandValue=60, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_4, desc="装备强化总等级到达60级"},
	{id=505, challengeGroup=5, typeDemandValue=72, challengeReward=local_challengeReward.challengeReward_6, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备强化总等级到达72级"},
	{id=506, challengeGroup=5, typeDemandValue=108, limitTimeReward=local_limitTimeReward.limitTimeReward_5, desc="装备强化总等级到达108级"},
	{id=507, challengeGroup=5, typeDemandValue=120, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备强化总等级到达120级"},
	{id=508, challengeGroup=5, typeDemandValue=144, challengeReward=local_challengeReward.challengeReward_7, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备强化总等级到达144级"},
	{id=509, challengeGroup=5, typeDemandValue=168, challengeReward=local_challengeReward.challengeReward_8, limitTimeReward=local_limitTimeReward.limitTimeReward_7, desc="装备强化总等级到达168级"},
	{id=510, challengeGroup=5, typeDemandValue=192, challengeReward=local_challengeReward.challengeReward_9, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备强化总等级到达192级"},
	{id=601, challengeGroup=6, typeDemandValue=13, challengeReward=local_challengeReward.challengeReward_4, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备追加总等级到达13级"},
	{id=602, challengeGroup=6, typeDemandValue=19, challengeReward=local_challengeReward.challengeReward_5, limitTimeReward=local_limitTimeReward.limitTimeReward_3, desc="装备追加总等级到达19级"},
	{id=603, challengeGroup=6, typeDemandValue=26, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备追加总等级到达26级"},
	{id=604, challengeGroup=6, typeDemandValue=39, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_4, desc="装备追加总等级到达39级"},
	{id=605, challengeGroup=6, typeDemandValue=52, challengeReward=local_challengeReward.challengeReward_6, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备追加总等级到达52级"},
	{id=606, challengeGroup=6, typeDemandValue=65, limitTimeReward=local_limitTimeReward.limitTimeReward_5, desc="装备追加总等级到达65级"},
	{id=607, challengeGroup=6, typeDemandValue=78, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备追加总等级到达78级"},
	{id=608, challengeGroup=6, typeDemandValue=91, challengeReward=local_challengeReward.challengeReward_7, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备追加总等级到达91级"},
	{id=609, challengeGroup=6, typeDemandValue=104, challengeReward=local_challengeReward.challengeReward_8, limitTimeReward=local_limitTimeReward.limitTimeReward_6, desc="装备追加总等级到达104级"},
	{id=610, challengeGroup=6, typeDemandValue=117, challengeReward=local_challengeReward.challengeReward_9, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="装备追加总等级到达117级"},
	{id=701, challengeGroup=7, typeDemandValue=5, challengeReward=local_challengeReward.challengeReward_4, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="勇气试炼通关层数到达5层"},
	{id=702, challengeGroup=7, typeDemandValue=10, challengeReward=local_challengeReward.challengeReward_5, limitTimeReward=local_limitTimeReward.limitTimeReward_3, desc="勇气试炼通关层数到达10层"},
	{id=703, challengeGroup=7, typeDemandValue=15, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="勇气试炼通关层数到达15层"},
	{id=704, challengeGroup=7, typeDemandValue=20, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_4, desc="勇气试炼通关层数到达20层"},
	{id=705, challengeGroup=7, typeDemandValue=25, challengeReward=local_challengeReward.challengeReward_6, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="勇气试炼通关层数到达25层"},
	{id=706, challengeGroup=7, typeDemandValue=35, limitTimeReward=local_limitTimeReward.limitTimeReward_5, desc="勇气试炼通关层数到达35层"},
	{id=707, challengeGroup=7, typeDemandValue=40, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="勇气试炼通关层数到达40层"},
	{id=708, challengeGroup=7, typeDemandValue=45, challengeReward=local_challengeReward.challengeReward_7, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="勇气试炼通关层数到达45层"},
	{id=709, challengeGroup=7, typeDemandValue=50, challengeReward=local_challengeReward.challengeReward_8, limitTimeReward=local_limitTimeReward.limitTimeReward_6, desc="勇气试炼通关层数到达50层"},
	{id=710, challengeGroup=7, typeDemandValue=55, challengeReward=local_challengeReward.challengeReward_9, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="勇气试炼通关层数到达55层"},
	{id=801, challengeGroup=8, typeDemandValue=24, challengeReward=local_challengeReward.challengeReward_4, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴套装装备总阶数到达24阶"},
	{id=802, challengeGroup=8, typeDemandValue=31, challengeReward=local_challengeReward.challengeReward_5, limitTimeReward=local_limitTimeReward.limitTimeReward_3, desc="穿戴套装装备总阶数到达31阶"},
	{id=803, challengeGroup=8, typeDemandValue=38, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴套装装备总阶数到达38阶"},
	{id=804, challengeGroup=8, typeDemandValue=42, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_4, desc="穿戴套装装备总阶数到达42阶"},
	{id=805, challengeGroup=8, typeDemandValue=45, challengeReward=local_challengeReward.challengeReward_6, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴套装装备总阶数到达45阶"},
	{id=806, challengeGroup=8, typeDemandValue=48, limitTimeReward=local_limitTimeReward.limitTimeReward_5, desc="穿戴套装装备总阶数到达48阶"},
	{id=807, challengeGroup=8, typeDemandValue=50, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴套装装备总阶数到达50阶"},
	{id=808, challengeGroup=8, typeDemandValue=52, challengeReward=local_challengeReward.challengeReward_7, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴套装装备总阶数到达52阶"},
	{id=809, challengeGroup=8, typeDemandValue=54, challengeReward=local_challengeReward.challengeReward_8, limitTimeReward=local_limitTimeReward.limitTimeReward_6, desc="穿戴套装装备总阶数到达54阶"},
	{id=810, challengeGroup=8, typeDemandValue=56, challengeReward=local_challengeReward.challengeReward_9, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴套装装备总阶数到达56阶"},
	{id=901, challengeGroup=9, typeDemandValue=4000, challengeReward=local_challengeReward.challengeReward_4, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="变身评分到达4000点"},
	{id=902, challengeGroup=9, typeDemandValue=7500, challengeReward=local_challengeReward.challengeReward_5, limitTimeReward=local_limitTimeReward.limitTimeReward_3, desc="变身评分到达7500点"},
	{id=903, challengeGroup=9, typeDemandValue=11000, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="变身评分到达11000点"},
	{id=904, challengeGroup=9, typeDemandValue=14000, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_4, desc="变身评分到达14000点"},
	{id=905, challengeGroup=9, typeDemandValue=15500, challengeReward=local_challengeReward.challengeReward_6, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="变身评分到达15500点"},
	{id=906, challengeGroup=9, typeDemandValue=17000, limitTimeReward=local_limitTimeReward.limitTimeReward_5, desc="变身评分到达17000点"},
	{id=907, challengeGroup=9, typeDemandValue=18500, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="变身评分到达18500点"},
	{id=908, challengeGroup=9, typeDemandValue=20000, challengeReward=local_challengeReward.challengeReward_7, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="变身评分到达20000点"},
	{id=909, challengeGroup=9, typeDemandValue=21000, challengeReward=local_challengeReward.challengeReward_8, limitTimeReward=local_limitTimeReward.limitTimeReward_6, desc="变身评分到达21000点"},
	{id=910, challengeGroup=9, typeDemandValue=22000, challengeReward=local_challengeReward.challengeReward_9, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="变身评分到达22000点"},
	{id=1001, challengeGroup=10, typeDemandValue=210, challengeReward=local_challengeReward.challengeReward_4, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴大天使装备到达210级"},
	{id=1002, challengeGroup=10, typeDemandValue=273, challengeReward=local_challengeReward.challengeReward_5, limitTimeReward=local_limitTimeReward.limitTimeReward_3, desc="穿戴大天使装备到达273级"},
	{id=1003, challengeGroup=10, typeDemandValue=336, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴大天使装备到达336级"},
	{id=1004, challengeGroup=10, typeDemandValue=403, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_4, desc="穿戴大天使装备到达403级"},
	{id=1005, challengeGroup=10, typeDemandValue=470, challengeReward=local_challengeReward.challengeReward_6, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴大天使装备到达470级"},
	{id=1006, challengeGroup=10, typeDemandValue=537, limitTimeReward=local_limitTimeReward.limitTimeReward_5, desc="穿戴大天使装备到达537级"},
	{id=1007, challengeGroup=10, typeDemandValue=604, challengeReward=local_challengeReward.challengeReward_3, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴大天使装备到达604级"},
	{id=1008, challengeGroup=10, typeDemandValue=672, challengeReward=local_challengeReward.challengeReward_7, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴大天使装备到达672级"},
	{id=1009, challengeGroup=10, typeDemandValue=707, challengeReward=local_challengeReward.challengeReward_8, limitTimeReward=local_limitTimeReward.limitTimeReward_6, desc="穿戴大天使装备到达707级"},
	{id=1010, challengeGroup=10, typeDemandValue=742, challengeReward=local_challengeReward.challengeReward_9, limitTimeReward=local_limitTimeReward.limitTimeReward_2, desc="穿戴大天使装备到达742级"},
}

local defaults = {challengeGroup=1, challengeReward={{50030002,2},{50040075,1}}, limitTimeReward={{1,50030305,1},{2,50030504,1},{3,50030604,1}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_openSerCompetition_challenge) do
	setmetatable(v, mt)
end

return cfg_openSerCompetition_challenge