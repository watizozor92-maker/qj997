-- 此文件工具自动生成，不要修改
---@class cfg_DailyGiftPack_column
---与总表id保持一致
---@field id number @id column=1 A
---@field Packagetype number @组别 column=2 B
---@field conditionid string @条件id column=3 C
---@field Price number @价格 column=4 D
---@field Limited number @限购 column=5 E
---道具id#数量
---@field Rewards IntListList @奖励 column=6 F
---道具id#数量
---当Packagetype为1时生效
---填写则有不填则无
---@field Optionalreward IntListList @自选奖励 column=7 G
---不填则不显示
---@field rebate number @返利显示 column=8 H
---当Packagetype为1时生效
---一键购买时填空其他关联他的id
---@field purchase number @关联一键购买的id号 column=9 I
---@field sortId number @礼包排序 column=10 J

local local_Optionalreward = {
    Optionalreward_1={},

}

local cfg_DailyGiftPack =
{
	{id=1, Price=0, Limited=3, Rewards={{50030002,1},{10020001,1000}}, rebate=0, sortId=1},
	{id=2, Price=6, Limited=4, rebate=800, sortId=2},
	{id=3, Price=12, Limited=5, Rewards={{70800001,5},{50030002,10},{50030001,10},{10020001,10000}}, rebate=500, sortId=3},
	{id=4, Price=30, Limited=6, Rewards={{50010008,2},{50010009,2},{50030003,6},{10020001,30000}}, sortId=4},
	{id=5, Price=98, Limited=7, Rewards={{50030005,5},{50030003,10},{50030004,3},{10020001,60000}}, sortId=5},
	{id=6, Price=168, Limited=8, Rewards={{50040028,1000},{50030005,2},{50030004,5},{10020001,120000}}, sortId=6},
	{id=7, Price=228, Limited=9, Rewards={{50040097,50},{50030005,2},{50030004,5},{10020001,150000}}, sortId=7},
	{id=8, Price=328, Limited=10, Rewards={{50010010,200},{50030005,4},{50030004,10},{10020001,180000}}, sortId=8},
	{id=9, Price=598, Limited=11, Rewards={}, rebate=0, purchase=0, sortId=0},
}

local defaults = {Packagetype=1, conditionid="901#1", Rewards={{30030201,1},{50030003,2},{40030001,1},{10020001,6000}}, Optionalreward={}, rebate=300, purchase=9}
local mt = {__index = defaults}
for _, v in ipairs(cfg_DailyGiftPack) do
	setmetatable(v, mt)
end

return cfg_DailyGiftPack