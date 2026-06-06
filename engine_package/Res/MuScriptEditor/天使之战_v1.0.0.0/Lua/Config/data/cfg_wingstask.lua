-- 此文件工具自动生成，不要修改
---@class cfg_wingstask_column
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

}

local cfg_wingstask =
{
	{id=101, group=1, taskTargetId=4000001, text="完成一次恶魔广场"},
	{id=102, group=1, taskTargetId=4000002, text="完成一次血色城堡"},
	{id=103, group=1, taskTargetId=4000003, text="5件装备强化+1"},
	{id=104, group=1, taskTargetId=4000004, text="击杀10只黄金怪"},
	{id=105, group=1, taskTargetId=4000005, text="穿戴4阶卓越防具2/2"},
	{id=106, group=1, taskTargetId=4000006, text="等级达到65"},
	{id=201, group=2, taskTargetId=4000007, text="击杀海魔希特拉3次"},
	{id=202, group=2, taskTargetId=4000008, text="穿戴4阶卓越防具5/5"},
	{id=203, group=2, taskTargetId=4000009, text="5件装备强化+6"},
	{id=204, group=2, taskTargetId=4000010, text="拍卖行上架任意装备3/3"},
	{id=205, group=2, taskTargetId=4000011, text="等级达到80"},
	{id=301, taskTargetId=4000012, text="击杀炽炎魔1次", rewardItem=local_rewardItem.rewardItem_2},
	{id=302, taskTargetId=4000013, text="加入战盟", rewardItem=local_rewardItem.rewardItem_2},
	{id=303, taskTargetId=4000014, text="进行2次装备追加", rewardItem=local_rewardItem.rewardItem_2},
	{id=304, taskTargetId=4000015, text="商城兑换2次祝福宝石", rewardItem=local_rewardItem.rewardItem_2},
	{id=305, taskTargetId=4000016, text="商城兑换2次灵魂宝石", rewardItem=local_rewardItem.rewardItem_2},
	{id=306, taskTargetId=4000017, text="完成5次勇气试炼", rewardItem=local_rewardItem.rewardItem_2},
	{id=307, taskTargetId=4000018, text="穿戴4阶卓越套装5/5", rewardItem=local_rewardItem.rewardItem_2},
	{id=308, taskTargetId=4000019, text="进行2次装备叠加", rewardItem=local_rewardItem.rewardItem_2},
	{id=309, taskTargetId=4000020, text="5件装备强化+9", rewardItem=local_rewardItem.rewardItem_2},
	{id=310, taskTargetId=4000021, text="等级达到100", rewardItem=local_rewardItem.rewardItem_2},
}

local defaults = {careerLimit={{0}}, group=3, rewardItem={50030002,1}, notes="祝福宝石"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_wingstask) do
	setmetatable(v, mt)
end

return cfg_wingstask