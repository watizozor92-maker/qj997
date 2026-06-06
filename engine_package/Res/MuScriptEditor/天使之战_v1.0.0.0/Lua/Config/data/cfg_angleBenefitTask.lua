-- 此文件工具自动生成，不要修改
---@class cfg_angleBenefitTask_column
---任务id，第一位为任务类型，第二，三位为
---@field id number @id column=1 A
---1勇气试炼；2黄金怪（测试类型）
---@field type number @任务类型 column=2 B
---@field taskTitle string @任务标题 column=3 C
---任务详细内容
---@field taskDesc string @任务内容 column=4 D
---读取cfg_task_target 表id
---格式：任务目标id#任务目标id
---@field taskTargetId IntList @任务目标 column=5 E
---奖励道具组以及奖励道具组的数量
---格式：道具id#道具数量#修正id#绑定道具（0：非绑定，1：绑定）|道具id#道具数量#修正id#绑定道具
---修正id引援cfg_equip_correct表id，填0不生效
---@field rewardItem IntListList @奖励道具信息 column=6 F
---在同一type下的顺序
---@field taskRank number @任务排序 column=7 G

local local_rewardItem = {
    rewardItem_1={{10040001,100},{10210001,100}},

}

local cfg_angleBenefitTask =
{
	{id=101, type=1, taskTitle="试炼达人", taskDesc="勇气试炼通过第1层", taskTargetId={2001001}, taskRank=1},
	{id=102, type=1, taskTitle="试炼达人", taskDesc="勇气试炼通过第2层", taskTargetId={2001002}, taskRank=2},
	{id=103, type=1, taskTitle="试炼达人", taskDesc="勇气试炼通过第3层", taskTargetId={2001003}, taskRank=3},
	{id=104, type=1, taskTitle="试炼达人", taskDesc="勇气试炼通过第4层", taskTargetId={2001004}, taskRank=4},
	{id=105, type=1, taskTitle="试炼达人", taskDesc="勇气试炼通过第5层", taskTargetId={2001005}, taskRank=5},
	{id=201, taskDesc="黄金雪虫", taskTargetId={2000001}, taskRank=1},
	{id=202, taskDesc="黄金蓝魔怪", taskTargetId={2000002}, taskRank=2},
	{id=203, taskDesc="黄金寒冰魔", taskTargetId={2000003}, taskRank=3},
	{id=204, taskDesc="黄金地狱猎犬怪", taskTargetId={2000004}, taskRank=4},
	{id=205, taskDesc="黄金骷髅兵", taskTargetId={2000005}, taskRank=5},
	{id=206, taskDesc="黄金暗黑骑士", taskTargetId={2000006}, taskRank=6},
	{id=207, taskDesc="黄金鬼魂", taskTargetId={2000007}, taskRank=7},
	{id=208, taskDesc="黄金牛魔王", taskTargetId={2000008}, taskRank=8},
	{id=209, taskDesc="黄金死神戈登", taskTargetId={2000009}, taskRank=9},
}

local defaults = {type=2, taskTitle="怪物猎人", rewardItem={{10040001,100},{10210001,100}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_angleBenefitTask) do
	setmetatable(v, mt)
end

return cfg_angleBenefitTask