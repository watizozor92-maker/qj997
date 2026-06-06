-- 此文件工具自动生成，不要修改
---@class cfg_WeeklyGiftPack_column
---@field id number @id column=1 A
---@field Packagename string @名称 column=2 B
---@field Packagetype number @组别 column=3 C
---@field Price number @价格 column=4 D
---@field conditionid string @条件 column=5 E
---道具id#数量
---@field Rewards IntListList @奖励 column=6 F
---不填则不显示
---@field rebate number @返利显示 column=7 G
---@field sortId number @礼包排序 column=8 H
local cfg_WeeklyGiftPack =
{
	{id=21, Packagename="免费礼包", Price=0, Rewards={{50030003,3},{10020001,1000}}, rebate=0, sortId=1},
	{id=22, Packagename="首饰突破礼包", Price=30, rebate=800, sortId=2},
	{id=23, Packagename="变身突破礼包", Price=168, Rewards={{10040001,1200},{50010010,150},{10020001,68880}}, rebate=500, sortId=3},
	{id=24, Packagename="大天使材料礼包", Price=238, Rewards={{10040001,1500},{50040097,60},{10020001,88880}}, rebate=300, sortId=4},
	{id=25, Packagename="材料礼包", Price=328, Rewards={{10040001,2000},{50040028,1000},{10020001,128880}}, rebate=300, sortId=5},
}

local defaults = {Packagetype=1, conditionid="901#1", Rewards={{10040001,300},{40030002,10},{10020001,26880}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_WeeklyGiftPack) do
	setmetatable(v, mt)
end

return cfg_WeeklyGiftPack