-- 此文件工具自动生成，不要修改
---@class cfg_synthesis_layer_column
---@field id number @编号 column=1 A
---@field name string @标题 column=2 B
---@field description string @介绍文字 column=3 C
---@field part string @面板路径 column=4 D
---关联synthesis表type字段id
---@field type IntList @关联合成表父类别id column=5 E
local cfg_synthesis_layer =
{
	{id=1, name="一般合成", description="装备强化、透明披风、恶魔广场通行证", type={1,3}},
	{id=2, name="玛雅合成", description="玛雅龙斧、玛雅雷杖、玛雅神弓", type={17}},
	{id=3, name="翅膀合成", description="翅膀合成、翅膀材料合成", type={4,5,6,7,8,9,10}},
	{id=4, name="大天使武器合成", description="大天使武器、卓越大天使武器、祝福大天使武器、大天使铁锤", type={13,14}},
	{id=5, name="果实合成", description="果实合成", type={15}},
	{id=6, name="再生合成", description="再生合成", type={16}},
	{id=7, name="披风合成", description="披风合成", type={25,26,27,28}},
	{id=8, name="耳环宝箱", description="耳环宝箱", type={29}},
	{id=9, name="耳环合成", description="耳环合成", type={30,31}},
	{id=10, name="天鹰合成", description="天鹰合成", type={32}},
	{id=11, name="黑王马合成", description="黑王马合成", type={33}},
	{id=12, name="坐骑合成", description="坐骑合成"},
	{id=13, name="战旗合成", description="战旗合成", type={36,37,38}},
}

local defaults = {part="", type={18,34,35,19,20,21,22,23,24}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_synthesis_layer) do
	setmetatable(v, mt)
end

return cfg_synthesis_layer