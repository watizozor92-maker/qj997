-- 此文件工具自动生成，不要修改
---@class cfg_efficiency_level_column
---@field id number @唯一id column=1 A
---下一个等级id
---@field nextId number @下一阶段 column=2 B
---达到该等级时才能领取
---@field level number @等级 column=3 C
---职业id#道具id#数量|职业id#道具id#数量
---@field item IntListList @奖励 column=4 D

local local_item = {
    item_1={{1,10020001,1000},{2,10020001,1000},{3,10020001,1000}},
    item_2={{1,10020001,2000},{2,10020001,2000},{3,10020001,2000}},
    item_3={{1,10020001,3000},{2,10020001,3000},{3,10020001,3000}},
    item_4={{1,10020001,4000},{2,10020001,4000},{3,10020001,4000}},

}

local cfg_efficiency_level =
{
	{id=1, nextId=2, level=50},
	{id=2, nextId=3, level=70},
	{id=3, nextId=4, level=100},
	{id=4, nextId=5, level=150},
	{id=5, nextId=6, level=200, item=local_item.item_2},
	{id=6, nextId=7, level=250, item=local_item.item_2},
	{id=7, nextId=8, level=300, item=local_item.item_3},
	{id=8, nextId=9, level=350, item=local_item.item_3},
	{id=9, nextId=10, level=400, item=local_item.item_4},
	{id=10, nextId=11, level=450, item=local_item.item_4},
	{id=11, nextId=0, level=500, item={{1,10020001,5000},{2,10020001,5000},{3,10020001,5000}}},
}

local defaults = {item={{1,10020001,1000},{2,10020001,1000},{3,10020001,1000}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_efficiency_level) do
	setmetatable(v, mt)
end

return cfg_efficiency_level