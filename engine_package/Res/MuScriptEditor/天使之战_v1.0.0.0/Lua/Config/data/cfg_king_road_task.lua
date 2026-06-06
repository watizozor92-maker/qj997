-- 此文件工具自动生成，不要修改
---@class cfg_king_road_task_column
---第1位为任务组；
---第23位为编号
---@field id number @id column=1 A
---只有设定职业才能接到该任务
---参考career表，多个职业|分隔
---0表示全职业
---@field careerLimit IntListList @职业限制 column=2 B
---@field group number @任务组 column=3 C
---调用cfg_task_target表id
---@field taskTargetId number @任务目标ID column=4 D
---任务显示文本
---@field text string @任务描述 column=5 E
---道具ID#道具数量
---@field rewardItem IntList @奖励道具 column=6 F
---备注说明
---@field notes string @奖励备注 column=7 G

local local_careerLimit = {
    careerLimit_1={{0}},

}

local local_rewardItem = {
    rewardItem_1={50030002,1},
    rewardItem_2={50030002,2},
    rewardItem_3={50030002,3},
    rewardItem_4={50030002,4},
    rewardItem_5={50030002,6},

}

local cfg_king_road_task =
{
	{id=101, group=1, taskTargetId=4000002, text="完成一次血色城堡"},
	{id=102, group=1, taskTargetId=4000003, text="装备强化5次"},
	{id=103, group=1, taskTargetId=4000004, text="击杀10只黄金怪"},
	{id=104, group=1, taskTargetId=4000005, text="穿戴4阶卓越防具"},
	{id=105, group=1, taskTargetId=4000006, text="等级达到60"},
	{id=201, group=2, taskTargetId=4000007, text="击杀3只野外或秘境BOSS"},
	{id=202, group=2, taskTargetId=4000008, text="穿戴4阶卓越防具"},
	{id=203, group=2, taskTargetId=4000009, text="5件装备强化+6"},
	{id=204, group=2, taskTargetId=4000039, text="进行1次装备追加"},
	{id=205, group=2, taskTargetId=4000011, text="等级达到80"},
	{id=206, group=2, taskTargetId=4000001, text="完成一次恶魔广场"},
	{id=301, taskTargetId=4000012, text="击杀1次100级以上BOSS", rewardItem=local_rewardItem.rewardItem_2},
	{id=302, taskTargetId=4000013, text="加入战盟", rewardItem=local_rewardItem.rewardItem_2},
	{id=303, taskTargetId=4000014, text="进行2次装备追加", rewardItem=local_rewardItem.rewardItem_2},
	{id=304, taskTargetId=4000015, text="商城兑换2次祝福宝石", rewardItem=local_rewardItem.rewardItem_2},
	{id=305, taskTargetId=4000016, text="商城兑换2次灵魂宝石", rewardItem=local_rewardItem.rewardItem_2},
	{id=306, taskTargetId=4000040, text="通关勇气试炼第5层", rewardItem=local_rewardItem.rewardItem_2},
	{id=307, taskTargetId=4000018, text="穿戴4阶卓越套装", rewardItem=local_rewardItem.rewardItem_2},
	{id=308, taskTargetId=4000019, text="进行2次装备叠加", rewardItem=local_rewardItem.rewardItem_2},
	{id=309, taskTargetId=4000020, text="5件装备强化+9", rewardItem=local_rewardItem.rewardItem_2},
	{id=310, taskTargetId=4000021, text="等级达到100", rewardItem=local_rewardItem.rewardItem_2},
	{id=401, group=4, taskTargetId=4000022, text="击杀5次100级以上BOSS", rewardItem=local_rewardItem.rewardItem_3},
	{id=402, group=4, taskTargetId=4000023, text="追加总等级达到16", rewardItem=local_rewardItem.rewardItem_3},
	{id=403, group=4, taskTargetId=4000024, text="套装词条总数达到12条", rewardItem=local_rewardItem.rewardItem_3},
	{id=404, group=4, taskTargetId=4000025, text="穿戴5阶卓越套装", rewardItem=local_rewardItem.rewardItem_3},
	{id=405, group=4, taskTargetId=4000026, text="5件装备强化+13", rewardItem=local_rewardItem.rewardItem_3},
	{id=406, group=4, taskTargetId=4000027, text="等级达到120", rewardItem=local_rewardItem.rewardItem_3},
	{id=501, group=5, taskTargetId=4000028, text="击杀10次150级以上BOSS", rewardItem=local_rewardItem.rewardItem_4},
	{id=502, group=5, taskTargetId=4000029, text="镶嵌萤石5颗", rewardItem=local_rewardItem.rewardItem_4},
	{id=503, group=5, taskTargetId=4000030, text="累计使用任意果实4颗", rewardItem=local_rewardItem.rewardItem_4},
	{id=504, group=5, taskTargetId=4000031, text="穿戴5阶卓越套装", rewardItem=local_rewardItem.rewardItem_4},
	{id=505, group=5, taskTargetId=4000032, text="12件装备强化+13", rewardItem=local_rewardItem.rewardItem_4},
	{id=506, group=5, taskTargetId=4000033, text="等级达到160", rewardItem=local_rewardItem.rewardItem_4},
	{id=601, group=6, taskTargetId=4000034, text="击杀10次200级以上BOSS", rewardItem=local_rewardItem.rewardItem_5},
	{id=602, group=6, taskTargetId=4000035, text="镶嵌萤石10颗", rewardItem=local_rewardItem.rewardItem_5},
	{id=603, group=6, taskTargetId=4000036, text="穿戴6阶卓越套装", rewardItem=local_rewardItem.rewardItem_5},
	{id=604, group=6, taskTargetId=4000037, text="12件装备强化+17", rewardItem=local_rewardItem.rewardItem_5},
	{id=605, group=6, taskTargetId=4000038, text="等级达到200", rewardItem=local_rewardItem.rewardItem_5},
}

local defaults = {careerLimit={{0}}, group=3, rewardItem={50030002,1}, notes="祝福宝石"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_king_road_task) do
	setmetatable(v, mt)
end

return cfg_king_road_task