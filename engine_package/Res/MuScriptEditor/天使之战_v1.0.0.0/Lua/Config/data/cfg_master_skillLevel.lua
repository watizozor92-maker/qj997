-- 此文件工具自动生成，不要修改
---@class cfg_master_skillLevel_column
---技能天赋等级
---@field id number @唯一id column=1 A
---@field exp number @升级需要经验值 column=2 B
---@field point number @升级提供天赋点 column=3 C
local cfg_master_skillLevel =
{
	{id=0},
	{id=1},
	{id=2},
	{id=3},
	{id=4},
	{id=5},
	{id=6},
	{id=7},
	{id=8},
	{id=9},
	{id=10, exp=2000},
	{id=11, exp=2000},
	{id=12, exp=2000},
	{id=13, exp=2000},
	{id=14, exp=2000},
	{id=15, exp=2000},
	{id=16, exp=2000},
	{id=17, exp=2000},
	{id=18, exp=0, point=0},
}

local defaults = {exp=1000, point=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_master_skillLevel) do
	setmetatable(v, mt)
end

return cfg_master_skillLevel