-- 此文件工具自动生成，不要修改
---@class cfg_equip_masterGroup_column
---部位id+0+类型
---@field id number @id column=1 A
---strPartId
---@field strPartId number @部位id column=2 B
---1强化
---2追加
---@field type number @类型 column=3 C
---调用组id
---@field group number @组 column=4 D
---用来配置前端显示的部位
---@field strpartShow string @部位显示 column=5 E
---[[客户端不使用]]@field   @ column=6 F
---[[客户端不使用]]@field   @ column=7 G
---[[客户端不使用]]@field   @ column=8 H
local cfg_equip_masterGroup =
{
	{id=101, strPartId=1},
	{id=201, strPartId=2},
	{id=301, strPartId=3},
	{id=401, strPartId=4},
	{id=501, strPartId=5},
	{id=601, strPartId=6},
	{id=701, strPartId=7},
	{id=801, strPartId=8},
	{id=901, strPartId=9},
	{id=1001, strPartId=10},
	{id=1101, strPartId=11},
	{id=1201, strPartId=12},
	{id=1301, strPartId=13},
	{id=1401, strPartId=14},
	{id=102, strPartId=1, type=2, group=2},
	{id=202, strPartId=2, type=2, group=2},
	{id=302, strPartId=3, type=2, group=2},
	{id=402, strPartId=4, type=2, group=2},
	{id=502, strPartId=5, type=2, group=2},
	{id=602, strPartId=6, type=2, group=2},
	{id=702, strPartId=7, type=2, group=2},
	{id=802, strPartId=8, type=2, group=2},
	{id=902, strPartId=9, type=2, group=2},
	{id=1002, strPartId=10, type=2, group=2},
	{id=1102, strPartId=11, type=2, group=2},
	{id=1202, strPartId=12, type=2, group=2},
	{id=1302, strPartId=13, type=2, group=2},
	{id=1402, strPartId=14, type=2, group=2},
}

local defaults = {type=1, group=1, strpartShow="武器  防具  首饰  翅膀"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_masterGroup) do
	setmetatable(v, mt)
end

return cfg_equip_masterGroup