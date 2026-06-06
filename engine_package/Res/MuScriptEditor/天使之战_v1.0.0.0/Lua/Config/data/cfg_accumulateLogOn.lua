-- 此文件工具自动生成，不要修改
---@class cfg_accumulateLogOn_column
---唯一id
---@field id number @id column=1 A
---获得奖励所需的累计天数
---@field accumulateDay number @累计天数 column=2 B
---格式：道具id#道具数量  
---@field reward IntList @奖励 column=3 C
local cfg_accumulateLogOn =
{
	{id=1, accumulateDay=1, reward={50030002,10}},
	{id=2, accumulateDay=2, reward={50030002,15}},
	{id=3, accumulateDay=3, reward={50030003,5}},
	{id=4, accumulateDay=4, reward={50030003,8}},
	{id=5, accumulateDay=5, reward={50040061,10}},
	{id=6, accumulateDay=6, reward={50030004,5}},
	{id=7, accumulateDay=7, reward={21500021,1}},
}
return cfg_accumulateLogOn