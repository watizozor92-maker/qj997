-- 此文件工具自动生成，不要修改
---@class cfg_king_road_column
---@field id number @id column=1 A
---读取cfg_king_road_task/group
---@field groupID number @任务组 column=2 B
---任务组名称
---@field name string @名称 column=3 C
---icon显示
---@field icon string @图标 column=4 D
---任务组达到等级才能开启
---@field level number @开启等级 column=5 E
---完成任务组中所有任务获取改奖励
---道具ID#道具数量
---@field rewardItem IntList @奖励道具 column=6 F

local local_rewardItem = {
    rewardItem_1={50040092,20},

}

local cfg_king_road =
{
	{id=1, groupID=1, name="第一章", icon="UIRoadOfking_Text_1"},
	{id=2, groupID=2, name="第二章", icon="UIRoadOfking_Text_2"},
	{id=3, groupID=3, name="第三章", icon="UIRoadOfking_Text_3"},
	{id=4, groupID=4, name="第四章", icon="UIRoadOfking_Text_4"},
	{id=5, groupID=5, name="第五章", icon="UIRoadOfking_Text_5"},
	{id=6, groupID=6, name="第六章", icon="UIRoadOfking_Text_6", rewardItem={50040092,40}},
}

local defaults = {level=20, rewardItem={50040092,20}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_king_road) do
	setmetatable(v, mt)
end

return cfg_king_road