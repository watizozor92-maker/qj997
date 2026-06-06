-- 此文件工具自动生成，不要修改
---@class cfg_VIP_Pack_column
---第一位总表recharge VIP类型；第二位子表类型；第三位序号
---@field id number @id column=1 A
---@field Packagename string @礼包名称 column=2 B
---1、VIP特权
---2、VIP专属礼包
---3、VIP超值礼包
---@field Packagetype number @类型 column=3 C
---道具id#数量
---@field Price IntList @价格 column=4 D
---1201#n：vip等级待遇等级n级
---207#m：充值总金额大于m元
---@field conditionid string @条件 column=5 E
---@field totalcharge number @累充金额 column=6 F
---表Count_count唯一id
---@field Limitedid number @限购id column=7 G
---格式：职业id#道具id#数量|职业id#道具id#数量|职业id#道具id#数量|职业id#道具id#数量
---职业id关联career表
---道具id关联item表
---@field Rewards IntListList @奖励 column=8 H

local local_Price = {
    Price_1={10050001,0},

}

local local_Rewards = {
    Rewards_1={},

}

local cfg_VIP_Pack =
{
	{id=811, Packagename="VIP1", Price={10050001,1280}, conditionid="207#100", totalcharge=100, Limitedid=20, Rewards=local_Rewards.Rewards_1},
	{id=812, Packagename="VIP2", Price={10050001,5280}, conditionid="1201#1&207#200", totalcharge=200, Limitedid=21, Rewards=local_Rewards.Rewards_1},
	{id=813, Packagename="VIP3", Price={10050001,9980}, conditionid="1201#2&207#400", totalcharge=400, Limitedid=22, Rewards=local_Rewards.Rewards_1},
	{id=814, Packagename="VIP4", Price={10050001,15580}, conditionid="1201#3&207#1000", totalcharge=1000, Limitedid=23, Rewards=local_Rewards.Rewards_1},
	{id=815, Packagename="VIP5", Price={10050001,23880}, conditionid="1201#4&207#2000", totalcharge=2000, Limitedid=24, Rewards=local_Rewards.Rewards_1},
	{id=816, Packagename="VIP6", Price={10050001,38880}, conditionid="1201#5&207#5000", totalcharge=5000, Limitedid=25, Rewards=local_Rewards.Rewards_1},
	{id=817, Packagename="VIP7", Price={10050001,58880}, conditionid="1201#6&207#10000", totalcharge=10000, Limitedid=26, Rewards=local_Rewards.Rewards_1},
	{id=821, Packagename="VIP1专属礼包", Packagetype=2, Limitedid=28, Rewards={{1,10010001,5000000},{2,10010001,5000000},{3,10010001,5000000}}},
	{id=822, Packagename="VIP2专属礼包", Packagetype=2, conditionid="1201#2", Limitedid=29, Rewards={{1,10010001,8000000},{2,10010001,8000000},{3,10010001,8000000}}},
	{id=823, Packagename="VIP3专属礼包", Packagetype=2, conditionid="1201#3", Limitedid=30, Rewards={{1,10010001,10000000},{2,10010001,10000000},{3,10010001,10000000}}},
	{id=824, Packagename="VIP4专属礼包", Packagetype=2, conditionid="1201#4", Limitedid=31, Rewards={{1,10010001,12000000},{2,10010001,12000000},{3,10010001,12000000}}},
	{id=825, Packagename="VIP5专属礼包", Packagetype=2, conditionid="1201#5", Limitedid=32, Rewards={{1,10010001,15000000},{2,10010001,15000000},{3,10010001,15000000}}},
	{id=826, Packagename="VIP6专属礼包", Packagetype=2, conditionid="1201#6", Limitedid=33, Rewards={{1,10010001,20000000},{2,10010001,20000000},{3,10010001,20000000}}},
	{id=827, Packagename="VIP7专属礼包", Packagetype=2, conditionid="1201#7", Limitedid=34, Rewards={{1,10010001,25000000},{2,10010001,25000000},{3,10010001,25000000}}},
	{id=831, Packagename="VIP1超值礼包", Packagetype=3, Price={10050001,680}, Limitedid=36},
	{id=832, Packagename="VIP2超值礼包", Packagetype=3, Price={10050001,1680}, conditionid="1201#2", Limitedid=37, Rewards={{1,50040059,50},{1,50030005,10},{1,10020001,22880},{2,50040059,50},{2,50030005,10},{2,10020001,22880},{3,50040059,50},{3,50030005,10},{3,10020001,22880}}},
	{id=833, Packagename="VIP3超值礼包", Packagetype=3, Price={10050001,3280}, conditionid="1201#3", Limitedid=38, Rewards={{1,21325011,1},{1,50010010,100},{1,10020001,26880},{2,21325021,1},{2,50010010,100},{2,10020001,26880},{3,21325031,1},{3,50010010,100},{3,10020001,26880}}},
	{id=834, Packagename="VIP4超值礼包", Packagetype=3, Price={10050001,6880}, conditionid="1201#4", Limitedid=39, Rewards={{1,50010010,600},{1,50040061,300},{1,10020001,39800},{2,50010010,600},{2,50040061,300},{2,10020001,39800},{3,50010010,600},{3,50040061,300},{3,10020001,39800}}},
	{id=835, Packagename="VIP5超值礼包", Packagetype=3, Price={10050001,13800}, conditionid="1201#5", Limitedid=40, Rewards={{1,21400011,1},{1,50040097,50},{1,10020001,50880},{2,21400011,1},{2,50040097,50},{2,10020001,50880},{3,21400011,1},{3,50040097,50},{3,10020001,50880}}},
	{id=836, Packagename="VIP6超值礼包", Packagetype=3, Price={10050001,18800}, conditionid="1201#6", Limitedid=41, Rewards={{1,50040015,1},{1,50030003,35},{1,10020001,62800},{2,50040015,1},{2,50030003,35},{2,10020001,62800},{3,50040015,1},{3,50030003,35},{3,10020001,62800}}},
	{id=837, Packagename="VIP7超值礼包", Packagetype=3, Price={10050001,25800}, conditionid="1201#7", Limitedid=42, Rewards={{1,21600019,1},{1,50040097,200},{1,10020001,69880},{2,21600019,1},{2,50040097,200},{2,10020001,69880},{3,21600019,1},{3,50040097,200},{3,10020001,69880}}},
}

local defaults = {Packagetype=1, Price={10050001,0}, conditionid="1201#1", totalcharge=0, Rewards={{1,50030003,50},{1,50030005,5},{1,10020001,19880},{2,50030003,50},{2,50030005,5},{2,10020001,19880},{3,50030003,50},{3,50030005,5},{3,10020001,19880}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_VIP_Pack) do
	setmetatable(v, mt)
end

return cfg_VIP_Pack