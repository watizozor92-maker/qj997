-- 此文件工具自动生成，不要修改
---@class cfg_equip_regenerationCost_column
---排列序号
---=强化组*100+等级
---@field id number @id column=1 A
---描写装备信息，方便查看
---@field description string @描述 column=2 B
---强化组
---@field group number @强化组 column=3 C
---强化等级
---@field level number @强化等级 column=4 D
---万分比
---@field rate number @强化成功率（服务端） column=5 E
---(前端被100整除)万分比
---@field rateClient number @强化成功率（客户端） column=6 F
---消耗道具：道具id#数量|道具id#数量
---@field cost IntListList @消耗道具 column=7 G

local local_cost = {
    cost_1={{50030009,1}},

}

local cfg_equip_regenerationCost =
{
	{id=101, level=1},
	{id=102, level=2},
	{id=103, level=3},
	{id=104, level=4},
	{id=105, level=5, rate=5000, rateClient=5000},
	{id=106, level=6, rate=5000, rateClient=5000},
	{id=201, description="防具", group=2, level=1},
	{id=202, description="防具", group=2, level=2},
	{id=203, description="防具", group=2, level=3},
	{id=204, description="防具", group=2, level=4},
	{id=205, description="防具", group=2, level=5, rate=5000, rateClient=5000},
	{id=206, description="防具", group=2, level=6, rate=5000, rateClient=5000},
}

local defaults = {description="武器", group=1, rate=10000, rateClient=10000, cost={{50030009,1}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_equip_regenerationCost) do
	setmetatable(v, mt)
end

return cfg_equip_regenerationCost