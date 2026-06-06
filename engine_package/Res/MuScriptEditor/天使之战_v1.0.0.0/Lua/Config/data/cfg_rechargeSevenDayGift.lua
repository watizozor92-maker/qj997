-- 此文件工具自动生成，不要修改
---@class cfg_rechargeSevenDayGift_column
---唯一id
---@field id number @id column=1 A
---获得奖励所需的累计天数
---@field accumulateDay number @累计天数 column=2 B
---格式：道具id#道具数量  
---@field reward IntList @奖励 column=3 C
local cfg_rechargeSevenDayGift =
{
	{id=1, accumulateDay=1, reward={60010002,6}},
	{id=2, accumulateDay=2, reward={50040061,6}},
	{id=3, accumulateDay=3, reward={50040097,6}},
	{id=4, accumulateDay=4, reward={40030002,6}},
	{id=5, accumulateDay=5, reward={50010010,6}},
	{id=6, accumulateDay=6, reward={50030004,6}},
	{id=7, accumulateDay=7, reward={50030005,6}},
}
return cfg_rechargeSevenDayGift