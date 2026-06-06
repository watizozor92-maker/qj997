-- 此文件工具自动生成，不要修改
---@class cfg_wings_column
---@field id number @id column=1 A
---读取cfg_king_road_task/group
---@field groupID number @任务组 column=2 B
---任务组名称
---@field name string @名称 column=3 C
---完成任务组中所有任务获取改奖励
---道具ID#道具数量
---@field rewardItem IntList @奖励道具 column=4 D
local cfg_wings =
{
	{id=1, groupID=1, name="第一章", rewardItem={50030005,1}},
	{id=2, groupID=2, name="第二章", rewardItem={50030004,1}},
	{id=3, groupID=3, name="第三章", rewardItem={50030001,1}},
}
return cfg_wings