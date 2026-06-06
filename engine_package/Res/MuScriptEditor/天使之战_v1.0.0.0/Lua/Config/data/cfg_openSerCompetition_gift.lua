-- 此文件工具自动生成，不要修改
---@class cfg_openSerCompetition_gift_column
---id规则：活动类型（1-2位）+根职业（1位）+序号（2位）
---@field id number @礼包id column=1 A
---@field name string @礼包名称 column=2 B
---引用Count_count表id
---@field count number @限购key column=3 C
---格式：道具id#道具数量|道具id#道具数量
---@field reward IntListList @礼包奖励 column=4 D
---格式：道具id#道具数量
---@field buyConsume IntList @购买消耗 column=5 E
---策划自用备注
---[[客户端不使用]]@field notes string @备注 column=6 F

local local_reward = {
    reward_1={{50040059,10},{60010002,3}},
    reward_2={{50030005,12},{50040061,50}},
    reward_3={{40030014,3},{40030002,5}},

}

local local_buyConsume = {
    buyConsume_1={10050001,0},
    buyConsume_2={10050001,68},
    buyConsume_3={10050001,168},
    buyConsume_4={10050001,388},
    buyConsume_5={10050001,988},
    buyConsume_6={10050001,1688},
    buyConsume_7={10050001,2988},

}

local cfg_openSerCompetition_gift =
{
	{id=1001, name="免费等级礼包", count=13001, reward={{50030002,1},{50030003,1}}, buyConsume={10040001,0}},
	{id=1002, name="稀有等级礼包", count=13002, reward={{50030002,5},{50030003,5}}, buyConsume={10040001,880}},
	{id=1003, name="豪华等级礼包", count=13003, reward={{50030002,15},{50030003,15}}, buyConsume={10040001,1980}},
	{id=1004, name="典藏等级礼包", count=13004, reward={{50030002,30},{50030003,30}}, buyConsume={10040001,3980}},
	{id=1005, name="至尊等级礼包", count=13005, reward={{50030002,50},{50030003,50}}, buyConsume={10040001,9980}},
	{id=2001, name="免费效率礼包", count=13006, reward={{50010003,1}}},
	{id=2002, name="效率礼包", count=13007, reward=local_reward.reward_1, buyConsume=local_buyConsume.buyConsume_2},
	{id=2003, name="稀有效率礼包", count=13008, reward={{50010008,3},{40030002,5}}, buyConsume=local_buyConsume.buyConsume_3},
	{id=2004, name="豪华效率礼包", count=13009, reward={{50040057,80},{60010002,10}}, buyConsume=local_buyConsume.buyConsume_4},
	{id=2005, name="典藏效率礼包", count=13010, reward={{50010008,12},{40030002,15}}, buyConsume=local_buyConsume.buyConsume_5},
	{id=2006, name="尊享效率礼包", count=13011, reward={{50040074,300},{50040056,30}}, buyConsume=local_buyConsume.buyConsume_6},
	{id=2007, name="至尊效率礼包", count=13012, buyConsume=local_buyConsume.buyConsume_7},
	{id=3001, name="免费活跃礼包", count=13013, reward={{40030013,1}}},
	{id=3002, name="活跃礼包", count=13014, reward=local_reward.reward_1, buyConsume=local_buyConsume.buyConsume_2},
	{id=3003, name="稀有活跃礼包", count=13015, reward=local_reward.reward_3, buyConsume=local_buyConsume.buyConsume_3},
	{id=3004, name="豪华活跃礼包", count=13016, reward={{50040074,80},{60010002,10}}, buyConsume=local_buyConsume.buyConsume_4},
	{id=3005, name="典藏活跃礼包", count=13017, reward={{40030014,12},{40030002,15}}, buyConsume=local_buyConsume.buyConsume_5},
	{id=3006, name="尊享活跃礼包", count=13018, reward={{50040057,300},{50040056,30}}, buyConsume=local_buyConsume.buyConsume_6},
	{id=3007, name="至尊活跃礼包", count=13019, reward={{40030015,500},{50040061,50}}, buyConsume=local_buyConsume.buyConsume_7},
	{id=4001, name="免费连击礼包", count=13020, reward={{10020001,1000}}},
	{id=4002, name="连击礼包", count=13021, reward={{10020001,5000},{60010002,3}}, buyConsume=local_buyConsume.buyConsume_2},
	{id=4003, name="稀有连击礼包", count=13022, reward={{10020001,15000},{40030002,5}}, buyConsume=local_buyConsume.buyConsume_3},
	{id=4004, name="豪华连击礼包", count=13023, reward={{10020001,35000},{60010002,10}}, buyConsume=local_buyConsume.buyConsume_4},
	{id=4005, name="典藏连击礼包", count=13024, reward={{10020001,80000},{40030002,15}}, buyConsume=local_buyConsume.buyConsume_5},
	{id=4006, name="尊享连击礼包", count=13025, reward={{10020001,120000},{50040056,30}}, buyConsume=local_buyConsume.buyConsume_6},
	{id=4007, name="至尊连击礼包", count=13026, reward={{10020001,210000},{50040061,50}}, buyConsume=local_buyConsume.buyConsume_7},
	{id=5001, name="免费强化礼包", count=13027, reward={{50030002,1}}},
	{id=5002, name="强化礼包", count=13028, reward={{50030002,20},{60010002,3}}, buyConsume=local_buyConsume.buyConsume_2},
	{id=5003, name="稀有强化礼包", count=13029, reward={{50030003,20},{40030002,5}}, buyConsume={10050001,198}},
	{id=5004, name="豪华强化礼包", count=13030, reward={{50030003,30},{60010002,10}}, buyConsume={10050001,398}},
	{id=5005, name="典藏强化礼包", count=13031, reward={{50030003,60},{40030002,15}}, buyConsume=local_buyConsume.buyConsume_5},
	{id=5006, name="尊享强化礼包", count=13032, reward={{50030005,8},{50040056,30}}, buyConsume={10050001,1988}},
	{id=5007, name="至尊强化礼包", count=13033, buyConsume=local_buyConsume.buyConsume_7},
	{id=6001, name="免费追加礼包", count=13034, reward={{50030004,1}}},
	{id=6002, name="追加礼包", count=13035, reward={{50030004,2},{60010002,3}}, buyConsume=local_buyConsume.buyConsume_2},
	{id=6003, name="稀有追加礼包", count=13036, reward={{50030004,4},{40030002,5}}, buyConsume=local_buyConsume.buyConsume_3},
	{id=6004, name="豪华追加礼包", count=13037, reward={{50030004,8},{60010002,10}}, buyConsume=local_buyConsume.buyConsume_4},
	{id=6005, name="典藏追加礼包", count=13038, reward={{50030004,20},{40030002,15}}, buyConsume=local_buyConsume.buyConsume_5},
	{id=6006, name="尊享追加礼包", count=13039, reward={{50030004,35},{50040056,30}}, buyConsume=local_buyConsume.buyConsume_6},
	{id=6007, name="至尊追加礼包", count=13040, reward={{50030004,40},{50040061,50}}, buyConsume=local_buyConsume.buyConsume_7},
	{id=7001, name="免费试炼礼包", count=13041, reward={{50030003,2}}},
	{id=7002, name="试炼礼包", count=13042, reward={{40030002,3},{60010002,3}}, buyConsume=local_buyConsume.buyConsume_2},
	{id=7003, name="稀有试炼礼包", count=13043, reward=local_reward.reward_3, buyConsume=local_buyConsume.buyConsume_3},
	{id=7004, name="豪华试炼礼包", count=13044, reward={{50040028,5000},{60010002,10}}, buyConsume=local_buyConsume.buyConsume_4},
	{id=7005, name="典藏试炼礼包", count=13045, reward={{50040061,50},{40030002,15}}, buyConsume=local_buyConsume.buyConsume_5},
	{id=7006, name="尊享试炼礼包", count=13046, reward={{50040097,35},{50040056,30}}, buyConsume=local_buyConsume.buyConsume_6},
	{id=7007, name="至尊试炼礼包", count=13047, buyConsume=local_buyConsume.buyConsume_7},
	{id=8001, name="免费套装礼包", count=13048, reward={{50040028,500}}},
	{id=8002, name="套装礼包", count=13049, reward={{50040028,2000},{60010002,3}}, buyConsume=local_buyConsume.buyConsume_2},
	{id=8003, name="稀有套装礼包", count=13050, reward={{50040028,4000},{40030002,5}}, buyConsume=local_buyConsume.buyConsume_3},
	{id=8004, name="豪华套装礼包", count=13051, reward={{50040028,6000},{60010002,10}}, buyConsume=local_buyConsume.buyConsume_4},
	{id=8005, name="典藏套装礼包", count=13052, reward={{50040028,12000},{40030002,15}}, buyConsume=local_buyConsume.buyConsume_5},
	{id=8006, name="尊享套装礼包", count=13053, reward={{50040028,15000},{50040056,30}}, buyConsume=local_buyConsume.buyConsume_6},
	{id=8007, name="至尊套装礼包", count=13054, reward={{50040028,25000},{50040061,50}}, buyConsume=local_buyConsume.buyConsume_7},
	{id=9001, name="免费变身礼包", count=13055, reward={{50010010,2}}},
	{id=9002, name="变身礼包", count=13056, reward={{50010010,15},{60010002,3}}, buyConsume=local_buyConsume.buyConsume_2},
	{id=9003, name="稀有变身礼包", count=13057, reward={{50010010,40},{40030002,5}}, buyConsume=local_buyConsume.buyConsume_3},
	{id=9004, name="豪华变身礼包", count=13058, reward={{50010010,80},{60010002,10}}, buyConsume=local_buyConsume.buyConsume_4},
	{id=9005, name="典藏变身礼包", count=13059, reward={{50010010,200},{40030002,15}}, buyConsume=local_buyConsume.buyConsume_5},
	{id=9006, name="尊享变身礼包", count=13060, reward={{50010010,300},{50040056,30}}, buyConsume=local_buyConsume.buyConsume_6},
	{id=9007, name="至尊变身礼包", count=13061, reward={{50010010,400},{50040061,50}}, buyConsume=local_buyConsume.buyConsume_7},
	{id=10001, name="免费大天使礼包", count=13062, reward={{50040097,1}}},
	{id=10002, name="大天使礼包", count=13063, reward={{50040097,3},{60010002,3}}, buyConsume=local_buyConsume.buyConsume_2},
	{id=10003, name="稀有大天使礼包", count=13064, reward={{50040097,6},{40030002,5}}, buyConsume=local_buyConsume.buyConsume_3},
	{id=10004, name="豪华大天使礼包", count=13065, reward={{50040097,15},{60010002,10}}, buyConsume=local_buyConsume.buyConsume_4},
	{id=10005, name="典藏大天使礼包", count=13066, reward={{50040097,40},{40030002,15}}, buyConsume=local_buyConsume.buyConsume_5},
	{id=10006, name="尊享大天使礼包", count=13067, reward={{50040097,60},{50040056,30}}, buyConsume=local_buyConsume.buyConsume_6},
	{id=10007, name="至尊大天使礼包", count=13068, reward={{50040097,100},{50040061,50}}, buyConsume=local_buyConsume.buyConsume_7},
}

local defaults = {reward={{50030005,12},{50040061,50}}, buyConsume={10050001,0}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_openSerCompetition_gift) do
	setmetatable(v, mt)
end

return cfg_openSerCompetition_gift