-- 此文件工具自动生成，不要修改
---@class cfg_equip_strengthenCost_column
---排列序号
---@field id number @id column=1 A
---cfg_equip_strengthen表内costId列调用该分组ID
---@field costGroupId number @消耗组 column=2 B
---描写装备信息，方便查看
---@field description string @描述 column=3 C
---强化等级
---@field level number @强化等级 column=4 D
---根据当前追加等级进行判断，若：
---1——继续在锻造界面执行追加操作
---2——在合成界面执行追加操作
---@field muneType number @操作界面 column=5 E
---万分比
---@field rate number @强化成功率（服务端） column=6 F
---(前端被100整除)万分比
---@field rateClient number @强化成功率（客户端） column=7 G
---强化失败后的等级
---@field failLevel number @强化失败后的等级 column=8 H
---格式：0（否）/ 1（是）
---备注：当玩家此装备首次强化到该等级时，全服展示跑马灯，玩家个人前端弹窗
---填0则在强化成功时，仅弹出 强化成功的动效
---@field firstRate number @是否开启特效 column=9 I
---备注：不填表示该强化等级不显示文字提示
---@field tips string @下一阶段文字提示(前端) column=10 J
---消耗道具：道具id#数量|道具id#数量
---@field cost IntListList @消耗道具 column=11 K
---消耗道具：道具id#数量
---@field coincost IntList @背包非显示道具的消耗 column=12 L
---索引cfg_equip_strengthenCost_v2表id，当muneType=1时，使用本字段的消耗
---若使用多个宝石进行强化，则通过“#”链接
---@field strengthenCost IntList @消耗道具（锻造） column=13 M

local local_cost = {
    cost_1={},
    cost_2={{50030002,4},{50030003,4},{50030001,2}},
    cost_3={{50030002,10},{50030003,10},{50030001,2}},
    cost_4={{50030002,15},{50030003,15},{50030001,2}},
    cost_5={{50030002,20},{50030003,20},{50030001,2}},
    cost_6={{50030002,30},{50030003,30},{50030001,2}},
    cost_7={{50030002,40},{50030003,40},{50030001,2}},

}

local local_coincost = {
    coincost_1={},
    coincost_2={10010002,2000000},

}

local local_strengthenCost = {
    strengthenCost_1={1,10},
    strengthenCost_2={2,11},
    strengthenCost_3={},
    strengthenCost_4={5,14},
    strengthenCost_5={7,16},
    strengthenCost_6={9,18},

}

local cfg_equip_strengthenCost =
{
	{id=10001, coincost=local_coincost.coincost_1},
	{id=10002, level=2, coincost=local_coincost.coincost_1},
	{id=10003, level=3, coincost=local_coincost.coincost_1},
	{id=10004, level=4, coincost=local_coincost.coincost_1},
	{id=10005, level=5, coincost=local_coincost.coincost_1},
	{id=10006, level=6, coincost=local_coincost.coincost_1},
	{id=10007, level=7, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=10008, level=8, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=10009, level=9, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=10010, level=10, muneType=2, rate=6000, rateClient=6000, firstRate=0, tips="本次失败装备消失", cost={{50030002,4},{50030003,4},{50030001,1}}, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10011, level=11, muneType=2, rate=6000, rateClient=6000, failLevel=9, firstRate=0, tips="本次失败装备消失", cost={{50030002,10},{50030003,10},{50030001,1}}, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10012, level=12, muneType=2, rate=5500, rateClient=5500, failLevel=10, firstRate=0, tips="本次失败装备消失", cost={{50030002,15},{50030003,15},{50030001,1}}, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10013, level=13, muneType=2, rate=5500, rateClient=5500, failLevel=11, firstRate=0, tips="本次失败装备消失", cost={{50030002,20},{50030003,20},{50030001,1}}, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10014, level=14, muneType=2, rate=5000, rateClient=5000, failLevel=12, firstRate=0, tips="本次失败装备消失", cost={{50030002,30},{50030003,30},{50030001,1}}, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10015, level=15, muneType=2, rate=5000, rateClient=5000, failLevel=13, firstRate=0, tips="本次失败装备消失", cost={{50030002,40},{50030003,40},{50030001,1}}, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10064, costGroupId=4, description="卓越消耗", coincost=local_coincost.coincost_1},
	{id=10065, costGroupId=4, description="卓越消耗", level=2, coincost=local_coincost.coincost_1},
	{id=10066, costGroupId=4, description="卓越消耗", level=3, coincost=local_coincost.coincost_1},
	{id=10067, costGroupId=4, description="卓越消耗", level=4, coincost=local_coincost.coincost_1},
	{id=10068, costGroupId=4, description="卓越消耗", level=5, coincost=local_coincost.coincost_1},
	{id=10069, costGroupId=4, description="卓越消耗", level=6, coincost=local_coincost.coincost_1},
	{id=10070, costGroupId=4, description="卓越消耗", level=7, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_4},
	{id=10071, costGroupId=4, description="卓越消耗", level=8, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_4},
	{id=10072, costGroupId=4, description="卓越消耗", level=9, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_4},
	{id=10073, costGroupId=4, description="卓越消耗", level=10, muneType=2, rate=5000, rateClient=5000, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_2, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10074, costGroupId=4, description="卓越消耗", level=11, muneType=2, rate=5000, rateClient=5000, failLevel=9, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_3, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10075, costGroupId=4, description="卓越消耗", level=12, muneType=2, rate=4500, rateClient=4500, failLevel=10, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_4, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10076, costGroupId=4, description="卓越消耗", level=13, muneType=2, rate=4500, rateClient=4500, failLevel=11, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_5, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10077, costGroupId=4, description="卓越消耗", level=14, muneType=2, rate=4000, rateClient=4000, failLevel=12, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_6, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10078, costGroupId=4, description="卓越消耗", level=15, muneType=2, rate=4000, rateClient=4000, failLevel=13, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_7, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10127, costGroupId=5, description="套装消耗", coincost=local_coincost.coincost_1},
	{id=10128, costGroupId=5, description="套装消耗", level=2, coincost=local_coincost.coincost_1},
	{id=10129, costGroupId=5, description="套装消耗", level=3, coincost=local_coincost.coincost_1},
	{id=10130, costGroupId=5, description="套装消耗", level=4, coincost=local_coincost.coincost_1},
	{id=10131, costGroupId=5, description="套装消耗", level=5, coincost=local_coincost.coincost_1},
	{id=10132, costGroupId=5, description="套装消耗", level=6, coincost=local_coincost.coincost_1},
	{id=10133, costGroupId=5, description="套装消耗", level=7, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_5},
	{id=10134, costGroupId=5, description="套装消耗", level=8, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_5},
	{id=10135, costGroupId=5, description="套装消耗", level=9, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_5},
	{id=10136, costGroupId=5, description="套装消耗", level=10, muneType=2, rate=5000, rateClient=5000, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_2, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10137, costGroupId=5, description="套装消耗", level=11, muneType=2, rate=5000, rateClient=5000, failLevel=9, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_3, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10138, costGroupId=5, description="套装消耗", level=12, muneType=2, rate=4500, rateClient=4500, failLevel=10, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_4, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10139, costGroupId=5, description="套装消耗", level=13, muneType=2, rate=4500, rateClient=4500, failLevel=11, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_5, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10140, costGroupId=5, description="套装消耗", level=14, muneType=2, rate=4000, rateClient=4000, failLevel=12, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_6, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10141, costGroupId=5, description="套装消耗", level=15, muneType=2, rate=4000, rateClient=4000, failLevel=13, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_7, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10190, costGroupId=6, description="镶宝消耗", coincost=local_coincost.coincost_1},
	{id=10191, costGroupId=6, description="镶宝消耗", level=2, coincost=local_coincost.coincost_1},
	{id=10192, costGroupId=6, description="镶宝消耗", level=3, coincost=local_coincost.coincost_1},
	{id=10193, costGroupId=6, description="镶宝消耗", level=4, coincost=local_coincost.coincost_1},
	{id=10194, costGroupId=6, description="镶宝消耗", level=5, coincost=local_coincost.coincost_1},
	{id=10195, costGroupId=6, description="镶宝消耗", level=6, coincost=local_coincost.coincost_1},
	{id=10196, costGroupId=6, description="镶宝消耗", level=7, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_6},
	{id=10197, costGroupId=6, description="镶宝消耗", level=8, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_6},
	{id=10198, costGroupId=6, description="镶宝消耗", level=9, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_6},
	{id=10199, costGroupId=6, description="镶宝消耗", level=10, muneType=2, rate=5000, rateClient=5000, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_2, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10200, costGroupId=6, description="镶宝消耗", level=11, muneType=2, rate=5000, rateClient=5000, failLevel=9, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_3, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10201, costGroupId=6, description="镶宝消耗", level=12, muneType=2, rate=4500, rateClient=4500, failLevel=10, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_4, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10202, costGroupId=6, description="镶宝消耗", level=13, muneType=2, rate=4500, rateClient=4500, failLevel=11, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_5, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10203, costGroupId=6, description="镶宝消耗", level=14, muneType=2, rate=4000, rateClient=4000, failLevel=12, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_6, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=10204, costGroupId=6, description="镶宝消耗", level=15, muneType=2, rate=4000, rateClient=4000, failLevel=13, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_7, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=2001, costGroupId=2, description="翅膀消耗（1代）", coincost=local_coincost.coincost_1},
	{id=2002, costGroupId=2, description="翅膀消耗（1代）", level=2, coincost=local_coincost.coincost_1},
	{id=2003, costGroupId=2, description="翅膀消耗（1代）", level=3, coincost=local_coincost.coincost_1},
	{id=2004, costGroupId=2, description="翅膀消耗（1代）", level=4, coincost=local_coincost.coincost_1},
	{id=2005, costGroupId=2, description="翅膀消耗（1代）", level=5, coincost=local_coincost.coincost_1},
	{id=2006, costGroupId=2, description="翅膀消耗（1代）", level=6, coincost=local_coincost.coincost_1},
	{id=2007, costGroupId=2, description="翅膀消耗（1代）", level=7, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=2008, costGroupId=2, description="翅膀消耗（1代）", level=8, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=2009, costGroupId=2, description="翅膀消耗（1代）", level=9, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=2010, costGroupId=2, description="翅膀消耗（1代）", level=10, muneType=2, rate=5000, rateClient=5000, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_2, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=2011, costGroupId=2, description="翅膀消耗（1代）", level=11, muneType=2, rate=5000, rateClient=5000, failLevel=9, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_3, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=2012, costGroupId=2, description="翅膀消耗（1代）", level=12, muneType=2, rate=4500, rateClient=4500, failLevel=10, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_4, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=2013, costGroupId=2, description="翅膀消耗（1代）", level=13, muneType=2, rate=4500, rateClient=4500, failLevel=11, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_5, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=2014, costGroupId=2, description="翅膀消耗（1代）", level=14, muneType=2, rate=4000, rateClient=4000, failLevel=12, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_6, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=2015, costGroupId=2, description="翅膀消耗（1代）", level=15, muneType=2, rate=4000, rateClient=4000, failLevel=13, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_7, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=7001, costGroupId=7, description="翅膀消耗（2代）", coincost=local_coincost.coincost_1},
	{id=7002, costGroupId=7, description="翅膀消耗（2代）", level=2, coincost=local_coincost.coincost_1},
	{id=7003, costGroupId=7, description="翅膀消耗（2代）", level=3, coincost=local_coincost.coincost_1},
	{id=7004, costGroupId=7, description="翅膀消耗（2代）", level=4, coincost=local_coincost.coincost_1},
	{id=7005, costGroupId=7, description="翅膀消耗（2代）", level=5, coincost=local_coincost.coincost_1},
	{id=7006, costGroupId=7, description="翅膀消耗（2代）", level=6, coincost=local_coincost.coincost_1},
	{id=7007, costGroupId=7, description="翅膀消耗（2代）", level=7, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=7008, costGroupId=7, description="翅膀消耗（2代）", level=8, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=7009, costGroupId=7, description="翅膀消耗（2代）", level=9, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=7010, costGroupId=7, description="翅膀消耗（2代）", level=10, muneType=2, rate=5000, rateClient=5000, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_2, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=7011, costGroupId=7, description="翅膀消耗（2代）", level=11, muneType=2, rate=5000, rateClient=5000, failLevel=9, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_3, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=7012, costGroupId=7, description="翅膀消耗（2代）", level=12, muneType=2, rate=4500, rateClient=4500, failLevel=10, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_4, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=7013, costGroupId=7, description="翅膀消耗（2代）", level=13, muneType=2, rate=4500, rateClient=4500, failLevel=11, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_5, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=7014, costGroupId=7, description="翅膀消耗（2代）", level=14, muneType=2, rate=4000, rateClient=4000, failLevel=12, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_6, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=7015, costGroupId=7, description="翅膀消耗（2代）", level=15, muneType=2, rate=4000, rateClient=4000, failLevel=13, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_7, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=8001, costGroupId=8, description="翅膀消耗（2.5代）", coincost=local_coincost.coincost_1},
	{id=8002, costGroupId=8, description="翅膀消耗（2.5代）", level=2, coincost=local_coincost.coincost_1},
	{id=8003, costGroupId=8, description="翅膀消耗（2.5代）", level=3, coincost=local_coincost.coincost_1},
	{id=8004, costGroupId=8, description="翅膀消耗（2.5代）", level=4, coincost=local_coincost.coincost_1},
	{id=8005, costGroupId=8, description="翅膀消耗（2.5代）", level=5, coincost=local_coincost.coincost_1},
	{id=8006, costGroupId=8, description="翅膀消耗（2.5代）", level=6, coincost=local_coincost.coincost_1},
	{id=8007, costGroupId=8, description="翅膀消耗（2.5代）", level=7, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=8008, costGroupId=8, description="翅膀消耗（2.5代）", level=8, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=8009, costGroupId=8, description="翅膀消耗（2.5代）", level=9, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=8010, costGroupId=8, description="翅膀消耗（2.5代）", level=10, muneType=2, rate=5000, rateClient=5000, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_2, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=8011, costGroupId=8, description="翅膀消耗（2.5代）", level=11, muneType=2, rate=5000, rateClient=5000, failLevel=9, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_3, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=8012, costGroupId=8, description="翅膀消耗（2.5代）", level=12, muneType=2, rate=4500, rateClient=4500, failLevel=10, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_4, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=8013, costGroupId=8, description="翅膀消耗（2.5代）", level=13, muneType=2, rate=4500, rateClient=4500, failLevel=11, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_5, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=8014, costGroupId=8, description="翅膀消耗（2.5代）", level=14, muneType=2, rate=4000, rateClient=4000, failLevel=12, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_6, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=8015, costGroupId=8, description="翅膀消耗（2.5代）", level=15, muneType=2, rate=4000, rateClient=4000, failLevel=13, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_7, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=9001, costGroupId=9, description="翅膀消耗（3代）", coincost=local_coincost.coincost_1},
	{id=9002, costGroupId=9, description="翅膀消耗（3代）", level=2, coincost=local_coincost.coincost_1},
	{id=9003, costGroupId=9, description="翅膀消耗（3代）", level=3, coincost=local_coincost.coincost_1},
	{id=9004, costGroupId=9, description="翅膀消耗（3代）", level=4, coincost=local_coincost.coincost_1},
	{id=9005, costGroupId=9, description="翅膀消耗（3代）", level=5, coincost=local_coincost.coincost_1},
	{id=9006, costGroupId=9, description="翅膀消耗（3代）", level=6, coincost=local_coincost.coincost_1},
	{id=9007, costGroupId=9, description="翅膀消耗（3代）", level=7, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=9008, costGroupId=9, description="翅膀消耗（3代）", level=8, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=9009, costGroupId=9, description="翅膀消耗（3代）", level=9, coincost=local_coincost.coincost_1, strengthenCost=local_strengthenCost.strengthenCost_2},
	{id=9010, costGroupId=9, description="翅膀消耗（3代）", level=10, muneType=2, rate=5000, rateClient=5000, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_2, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=9011, costGroupId=9, description="翅膀消耗（3代）", level=11, muneType=2, rate=5000, rateClient=5000, failLevel=9, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_3, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=9012, costGroupId=9, description="翅膀消耗（3代）", level=12, muneType=2, rate=4500, rateClient=4500, failLevel=10, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_4, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=9013, costGroupId=9, description="翅膀消耗（3代）", level=13, muneType=2, rate=4500, rateClient=4500, failLevel=11, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_5, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=9014, costGroupId=9, description="翅膀消耗（3代）", level=14, muneType=2, rate=4000, rateClient=4000, failLevel=12, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_6, strengthenCost=local_strengthenCost.strengthenCost_3},
	{id=9015, costGroupId=9, description="翅膀消耗（3代）", level=15, muneType=2, rate=4000, rateClient=4000, failLevel=13, firstRate=0, tips="本次失败装备消失", cost=local_cost.cost_7, strengthenCost=local_strengthenCost.strengthenCost_3},
}

local defaults = {costGroupId=1, description="普通消耗", level=1, muneType=1, rate=0, rateClient=0, failLevel=0, firstRate=0, tips="本次失败不掉级", cost={}, coincost={10010002,2000000}, strengthenCost={1,10}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_strengthenCost) do
	setmetatable(v, mt)
end

return cfg_equip_strengthenCost