-- 此文件工具自动生成，不要修改
---@class cfg_monsterHuntReward_column
---唯一id
---@field id number @唯一id column=1 A
---@field rank IntList @积分排名区间 column=2 B
---每个区间内，单个玩家的瓜分权重
---当前区间内的玩家的权重/每个区间的所有玩家的权重综合=瓜分百分比
---@field reward IntList @奖励获得权重 column=3 C
---每个区间内，单个玩家可获得的额外勋章数量
---不消耗奖池瓜分的。
---@field extra number @额外勋章数量 column=4 D
---每个区间内，单个玩家可获得的额外道具
---道具ID#数量
---UI需要显示，填空则不显示
---@field item IntListList @额外道具 column=5 E

local local_item = {
    item_1={{21500025,1}},
    item_2={},

}

local cfg_monsterHuntReward =
{
	{id=1, rank={1,1}, reward={4000}},
	{id=2, rank={2,2}, reward={3500}},
	{id=3, rank={3,3}, reward={3000}},
	{id=4, rank={4,10}, reward={2600}, item={{21500024,1}}},
	{id=5, rank={11,30}, reward={2400}, item=local_item.item_2},
	{id=6, rank={31,50}, reward={2200}, item=local_item.item_2},
	{id=7, rank={51,100}, reward={2000}, item=local_item.item_2},
	{id=8, rank={101,9999}, reward={0}, extra=29999, item=local_item.item_2},
}

local defaults = {extra=0, item={{21500025,1}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_monsterHuntReward) do
	setmetatable(v, mt)
end

return cfg_monsterHuntReward