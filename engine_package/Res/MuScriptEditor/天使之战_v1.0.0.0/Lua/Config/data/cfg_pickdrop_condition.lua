-- 此文件工具自动生成，不要修改
---@class cfg_pickdrop_condition_column
---引援(cfg_item/拾取组pickgroup)
---@field id number @拾取组id column=1 A
---拾取组名
---@field groupName StringList @拾取组名UI column=2 B
---@field sort number @排序 column=3 C
---挂机拾取+自动拾取的范围
---@field range number @拾取范围 column=4 D
local cfg_pickdrop_condition =
{
	{id=1, groupName={"宝石","1"}, sort=1},
	{id=2, groupName={"白装","2"}, sort=4},
	{id=3, groupName={"技能书","3"}, sort=3},
	{id=4, groupName={"卓越装备","4"}, sort=5},
	{id=5, groupName={"金币","5"}, sort=2},
	{id=6, groupName={"套装","6"}, sort=6},
	{id=7, groupName={"材料","7"}, sort=7},
}

local defaults = {range=8}
local mt = {__index = defaults}
for _, v in ipairs(cfg_pickdrop_condition) do
	setmetatable(v, mt)
end

return cfg_pickdrop_condition