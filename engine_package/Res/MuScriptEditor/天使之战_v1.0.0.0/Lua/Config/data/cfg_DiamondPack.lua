-- 此文件工具自动生成，不要修改
---@class cfg_DiamondPack_column
---可被调用的唯一id
---@field id number @唯一id column=1 A
---显示在界面中的文本
---@field text string @策划备注 column=2 B
---1、普通购买           2、一键购买           3、免费礼包
---@field type number @购买方式 column=3 C
---1.钻石#10040001
---2.绑钻#10050001
---@field diamond number @消耗道具 column=4 D
---只配置数量，消耗的道具在Diamond字段中
---@field money number @消耗金额 column=5 E
---用于读取cfg_OperateActivity_all中的mainGroup字段
---@field mainGroup number @活动组id column=6 F
---去Count_count表取id
---@field countkey number @限购id column=7 G
---显示在礼包左上角的礼包返利力度           不填则不显示
---@field rebates number @礼包返利 column=8 H
---格式：id#数量|道具id#数量#领取职业id，不填职业就是没有限制（道具id在cfg_item中查找）
---@field reward IntListList @奖励道具 column=9 I
---1、计入一键购买 2、不计入一键购买              （若所有礼包均不计入一键购买，则不显示一键购买按钮）
---@field buyAll number @一键购买 column=10 J

local local_reward = {
    reward_1={{50030002,1},{50030003,1}},
    reward_2={{50030003,5},{50030005,1},{50040061,2},{10020001,5000}},
    reward_3={{50030003,10},{50030005,2},{50040061,5},{10020001,10000}},
    reward_4={{50030003,20},{50030005,4},{50040061,10},{10020001,20000}},
    reward_5={{50030003,50},{50030005,8},{50040061,20},{10020001,50000}},
    reward_6={{50030003,100},{50040097,100},{50040061,50},{10020001,100000}},
    reward_7={{50030003,200},{40030015,100},{50040061,100},{10020001,200000}},
    reward_8={},

}

local cfg_DiamondPack =
{
	{id=40001, type=3, mainGroup=2, countkey=17001, reward=local_reward.reward_1, buyAll=2},
	{id=40002, text="钻石礼包68", money=68, mainGroup=2, countkey=17002},
	{id=40003, text="钻石礼包128", money=128, mainGroup=2, countkey=17003, reward=local_reward.reward_3},
	{id=40004, text="钻石礼包388", money=388, mainGroup=2, countkey=17004, reward=local_reward.reward_4},
	{id=40005, text="钻石礼包988", money=988, mainGroup=2, countkey=17005, reward=local_reward.reward_5},
	{id=40006, text="钻石礼包1688", money=1688, mainGroup=2, countkey=17006, reward=local_reward.reward_6},
	{id=40007, text="钻石礼包2988", money=2988, mainGroup=2, countkey=17007, reward=local_reward.reward_7},
	{id=40008, text="12496", type=2, money=8888, mainGroup=2, countkey=17008, reward=local_reward.reward_8, buyAll=0},
	{id=40009, type=3, mainGroup=3, countkey=17009, reward=local_reward.reward_1, buyAll=2},
	{id=40010, text="钻石礼包68", money=68, mainGroup=3, countkey=17010},
	{id=40011, text="钻石礼包128", money=128, mainGroup=3, countkey=17011, reward=local_reward.reward_3},
	{id=40012, text="钻石礼包388", money=388, mainGroup=3, countkey=17012, reward=local_reward.reward_4},
	{id=40013, text="钻石礼包988", money=988, mainGroup=3, countkey=17013, reward=local_reward.reward_5},
	{id=40014, text="钻石礼包1688", money=1688, mainGroup=3, countkey=17014, reward=local_reward.reward_6},
	{id=40015, text="钻石礼包2988", money=2988, mainGroup=3, countkey=17015, reward=local_reward.reward_7},
	{id=40016, text="12496", type=2, money=8888, mainGroup=3, countkey=17016, reward=local_reward.reward_8, buyAll=0},
	{id=40017, type=3, mainGroup=4, countkey=17017, reward=local_reward.reward_1, buyAll=2},
	{id=40018, text="钻石礼包68", money=68, mainGroup=4, countkey=17018},
	{id=40019, text="钻石礼包128", money=128, mainGroup=4, countkey=17019, reward=local_reward.reward_3},
	{id=40020, text="钻石礼包388", money=388, mainGroup=4, countkey=17020, reward=local_reward.reward_4},
	{id=40021, text="钻石礼包988", money=988, mainGroup=4, countkey=17021, reward=local_reward.reward_5},
	{id=40022, text="钻石礼包1688", money=1688, mainGroup=4, countkey=17022, reward=local_reward.reward_6},
	{id=40023, text="钻石礼包2988", money=2988, mainGroup=4, countkey=17023, reward=local_reward.reward_7},
	{id=40024, text="12496", type=2, money=8888, mainGroup=4, countkey=17024, reward=local_reward.reward_8, buyAll=0},
	{id=40025, type=3, mainGroup=5, countkey=17025, reward=local_reward.reward_1, buyAll=2},
	{id=40026, text="钻石礼包68", money=68, mainGroup=5, countkey=17026},
	{id=40027, text="钻石礼包128", money=128, mainGroup=5, countkey=17027, reward=local_reward.reward_3},
	{id=40028, text="钻石礼包388", money=388, mainGroup=5, countkey=17028, reward=local_reward.reward_4},
	{id=40029, text="钻石礼包988", money=988, mainGroup=5, countkey=17029, reward=local_reward.reward_5},
	{id=40030, text="钻石礼包1688", money=1688, mainGroup=5, countkey=17030, reward=local_reward.reward_6},
	{id=40031, text="钻石礼包2988", money=2988, mainGroup=5, countkey=17031, reward=local_reward.reward_7},
	{id=40032, text="12496", type=2, money=8888, mainGroup=5, countkey=17032, reward=local_reward.reward_8, buyAll=0},
	{id=40033, type=3, mainGroup=6, countkey=17033, reward=local_reward.reward_1, buyAll=2},
	{id=40034, text="钻石礼包68", money=68, mainGroup=6, countkey=17034},
	{id=40035, text="钻石礼包128", money=128, mainGroup=6, countkey=17035, reward=local_reward.reward_3},
	{id=40036, text="钻石礼包388", money=388, mainGroup=6, countkey=17036, reward=local_reward.reward_4},
	{id=40037, text="钻石礼包988", money=988, mainGroup=6, countkey=17037, reward=local_reward.reward_5},
	{id=40038, text="钻石礼包1688", money=1688, mainGroup=6, countkey=17038, reward=local_reward.reward_6},
	{id=40039, text="钻石礼包2988", money=2988, mainGroup=6, countkey=17039, reward=local_reward.reward_7},
	{id=40040, text="12496", type=2, money=8888, mainGroup=6, countkey=17040, reward=local_reward.reward_8, buyAll=0},
	{id=40041, type=3, mainGroup=7, countkey=17041, reward=local_reward.reward_1, buyAll=2},
	{id=40042, text="钻石礼包68", money=68, mainGroup=7, countkey=17042},
	{id=40043, text="钻石礼包128", money=128, mainGroup=7, countkey=17043, reward=local_reward.reward_3},
	{id=40044, text="钻石礼包388", money=388, mainGroup=7, countkey=17044, reward=local_reward.reward_4},
	{id=40045, text="钻石礼包988", money=988, mainGroup=7, countkey=17045, reward=local_reward.reward_5},
	{id=40046, text="钻石礼包1688", money=1688, mainGroup=7, countkey=17046, reward=local_reward.reward_6},
	{id=40047, text="钻石礼包2988", money=2988, mainGroup=7, countkey=17047, reward=local_reward.reward_7},
	{id=40048, text="12496", type=2, money=8888, mainGroup=7, countkey=17048, reward=local_reward.reward_8, buyAll=0},
	{id=40049, type=3, mainGroup=8, countkey=17049, reward=local_reward.reward_1, buyAll=2},
	{id=40050, text="钻石礼包68", money=68, mainGroup=8, countkey=17050},
	{id=40051, text="钻石礼包128", money=128, mainGroup=8, countkey=17051, reward=local_reward.reward_3},
	{id=40052, text="钻石礼包388", money=388, mainGroup=8, countkey=17052, reward=local_reward.reward_4},
	{id=40053, text="钻石礼包988", money=988, mainGroup=8, countkey=17053, reward=local_reward.reward_5},
	{id=40054, text="钻石礼包1688", money=1688, mainGroup=8, countkey=17054, reward=local_reward.reward_6},
	{id=40055, text="钻石礼包2988", money=2988, mainGroup=8, countkey=17055, reward=local_reward.reward_7},
	{id=40056, text="12496", type=2, money=8888, mainGroup=8, countkey=17056, reward=local_reward.reward_8, buyAll=0},
	{id=40057, type=3, mainGroup=9, countkey=17057, reward=local_reward.reward_1, buyAll=2},
	{id=40058, text="钻石礼包68", money=68, mainGroup=9, countkey=17058},
	{id=40059, text="钻石礼包128", money=128, mainGroup=9, countkey=17059, reward=local_reward.reward_3},
	{id=40060, text="钻石礼包388", money=388, mainGroup=9, countkey=17060, reward=local_reward.reward_4},
	{id=40061, text="钻石礼包988", money=988, mainGroup=9, countkey=17061, reward=local_reward.reward_5},
	{id=40062, text="钻石礼包1688", money=1688, mainGroup=9, countkey=17062, reward=local_reward.reward_6},
	{id=40063, text="钻石礼包2988", money=2988, mainGroup=9, countkey=17063, reward=local_reward.reward_7},
	{id=40064, text="12496", type=2, money=8888, mainGroup=9, countkey=17064, reward=local_reward.reward_8, buyAll=0},
	{id=40065, type=3, mainGroup=10, countkey=17065, reward=local_reward.reward_1, buyAll=2},
	{id=40066, text="钻石礼包68", money=68, mainGroup=10, countkey=17066},
	{id=40067, text="钻石礼包128", money=128, mainGroup=10, countkey=17067, reward=local_reward.reward_3},
	{id=40068, text="钻石礼包388", money=388, mainGroup=10, countkey=17068, reward=local_reward.reward_4},
	{id=40069, text="钻石礼包988", money=988, mainGroup=10, countkey=17069, reward=local_reward.reward_5},
	{id=40070, text="钻石礼包1688", money=1688, mainGroup=10, countkey=17070, reward=local_reward.reward_6},
	{id=40071, text="钻石礼包2988", money=2988, mainGroup=10, countkey=17071, reward=local_reward.reward_7},
	{id=40072, text="12496", type=2, money=8888, mainGroup=10, countkey=17072, reward=local_reward.reward_8, buyAll=0},
	{id=40073, type=3, mainGroup=11, countkey=17073, reward=local_reward.reward_1, buyAll=2},
	{id=40074, text="钻石礼包68", money=68, mainGroup=11, countkey=17074},
	{id=40075, text="钻石礼包128", money=128, mainGroup=11, countkey=17075, reward=local_reward.reward_3},
	{id=40076, text="钻石礼包388", money=388, mainGroup=11, countkey=17076, reward=local_reward.reward_4},
	{id=40077, text="钻石礼包988", money=988, mainGroup=11, countkey=17077, reward=local_reward.reward_5},
	{id=40078, text="钻石礼包1688", money=1688, mainGroup=11, countkey=17078, reward=local_reward.reward_6},
	{id=40079, text="钻石礼包2988", money=2988, mainGroup=11, countkey=17079, reward=local_reward.reward_7},
	{id=40080, text="12496", type=2, money=8888, mainGroup=11, countkey=17080, reward=local_reward.reward_8, buyAll=0},
	{id=40081, type=3, mainGroup=12, countkey=17081, reward=local_reward.reward_1, buyAll=2},
	{id=40082, text="钻石礼包68", money=68, mainGroup=12, countkey=17082},
	{id=40083, text="钻石礼包128", money=128, mainGroup=12, countkey=17083, reward=local_reward.reward_3},
	{id=40084, text="钻石礼包388", money=388, mainGroup=12, countkey=17084, reward=local_reward.reward_4},
	{id=40085, text="钻石礼包988", money=988, mainGroup=12, countkey=17085, reward=local_reward.reward_5},
	{id=40086, text="钻石礼包1688", money=1688, mainGroup=12, countkey=17086, reward=local_reward.reward_6},
	{id=40087, text="钻石礼包2988", money=2988, mainGroup=12, countkey=17087, reward=local_reward.reward_7},
	{id=40088, text="12496", type=2, money=8888, mainGroup=12, countkey=17088, reward=local_reward.reward_8, buyAll=0},
	{id=40089, type=3, mainGroup=13, countkey=17089, reward=local_reward.reward_1, buyAll=2},
	{id=40090, text="钻石礼包68", money=68, mainGroup=13, countkey=17090},
	{id=40091, text="钻石礼包128", money=128, mainGroup=13, countkey=17091, reward=local_reward.reward_3},
	{id=40092, text="钻石礼包388", money=388, mainGroup=13, countkey=17092, reward=local_reward.reward_4},
	{id=40093, text="钻石礼包988", money=988, mainGroup=13, countkey=17093, reward=local_reward.reward_5},
	{id=40094, text="钻石礼包1688", money=1688, mainGroup=13, countkey=17094, reward=local_reward.reward_6},
	{id=40095, text="钻石礼包2988", money=2988, mainGroup=13, countkey=17095, reward=local_reward.reward_7},
	{id=40096, text="12496", type=2, money=8888, mainGroup=13, countkey=17096, reward=local_reward.reward_8, buyAll=0},
	{id=40097, type=3, countkey=17097, reward={{50030003,1},{10020001,1000}}, buyAll=2},
	{id=40098, text="初级传送礼包", money=89, countkey=17098, reward={{60010002,10},{50030002,5},{50030003,5},{50030001,10}}},
	{id=40099, text="初级变身礼包", money=399, countkey=17099, reward={{50010010,200},{50030004,1},{50030002,5},{50030003,5}}},
	{id=40100, text="初级大天使礼包", money=399, countkey=17100, reward={{50040097,40},{50030004,1},{50030002,5},{50030003,5}}},
	{id=40101, text="中级礼包", money=1099, countkey=17101, reward={{50010010,400},{50040028,50},{50040074,30},{50030002,10}}},
	{id=40102, text="中级礼包", money=1099, countkey=17102, reward={{50040097,80},{50040028,50},{50040057,30},{50030003,10}}},
	{id=40103, text="高级礼包", money=1899, countkey=17103, reward={{50010010,600},{50040061,50},{50040077,10},{50030004,2}}},
	{id=40104, text="高级礼包", money=2199, countkey=17104, reward={{50040097,120},{50040061,50},{50040075,10},{50030004,2}}},
	{id=40105, text="终极礼包", money=3099, countkey=17105, reward={{50010010,1000},{50040097,100},{50040061,50},{50030005,1}}},
	{id=40106, text="12496", type=2, money=8888, countkey=17106, reward=local_reward.reward_8, buyAll=0},
}

local defaults = {text="钻石礼包0", type=1, diamond=2, money=0, mainGroup=14, rebates=0, reward={{50030003,5},{50030005,1},{50040061,2},{10020001,5000}}, buyAll=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_DiamondPack) do
	setmetatable(v, mt)
end

return cfg_DiamondPack