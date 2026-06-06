-- 此文件工具自动生成，不要修改
---@class cfg_master_proLevel_column
---职业天赋等级
---@field id number @唯一id column=1 A
---@field exp number @升级需要经验值 column=2 B
---@field point number @升级提供天赋点 column=3 C
local cfg_master_proLevel =
{
	{id=0, exp=1000},
	{id=1, exp=1000},
	{id=2, exp=1000},
	{id=3, exp=1000},
	{id=4, exp=1000},
	{id=5, exp=1000},
	{id=6, exp=1000},
	{id=7, exp=1000},
	{id=8, exp=1000},
	{id=9, exp=1000},
	{id=10},
	{id=11},
	{id=12},
	{id=13},
	{id=14},
	{id=15},
	{id=16},
	{id=17},
	{id=18},
	{id=19},
	{id=20},
	{id=21, exp=3000},
	{id=22, exp=0, point=0},
}

local defaults = {exp=2000, point=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_master_proLevel) do
	setmetatable(v, mt)
end

return cfg_master_proLevel