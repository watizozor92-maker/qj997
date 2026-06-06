-- 此文件工具自动生成，不要修改
---@class cfg_Diamondgiftbag_column
---与总表id保持一致
---@field id number @id column=1 A
---@field Packagetype number @组别 column=2 B
---1.钻石#10040001
---2.绑钻#10050001
---@field Diamonditem number @消耗道具 column=3 C
---@field conditionid string @条件id column=4 D
---@field Price number @价格 column=5 E
---@field Limited number @限购 column=6 F
---道具id#数量
---@field Rewards IntListList @奖励 column=7 G
---道具id#数量
---当Packagetype为1时生效
---填写则有不填则无
---@field Optionalreward IntListList @自选奖励 column=8 H
---不填则不显示
---@field rebate number @返利显示 column=9 I
---当Packagetype为1时生效
---一键购买时填空其他关联他的id
---@field purchase number @关联一键购买的id号 column=10 J
---@field sortId number @礼包排序 column=11 K

local local_Optionalreward = {
    Optionalreward_1={},

}

local cfg_Diamondgiftbag =
{
	{id=1, Price=0, Limited=1401, Rewards={{50030002,1},{50030003,1}}, rebate=0, sortId=1},
	{id=2, Price=68, Limited=1402, rebate=800, sortId=2},
	{id=3, Price=128, Limited=1403, Rewards={{60010002,10},{40030014,1},{50030001,10},{50040057,10}}, rebate=500, sortId=3},
	{id=4, Price=388, Limited=1404, Rewards={{50040061,20},{50030005,1},{50030001,20},{50040074,20}}, sortId=4},
	{id=5, Price=988, Limited=1405, Rewards={{50040028,800},{40030014,3},{50030005,1},{40030015,50}}, sortId=5},
	{id=6, Price=1688, Limited=1406, Rewards={{50040097,35},{50040075,10},{50030005,2},{70800001,10}}, sortId=6},
	{id=7, Price=2988, Limited=1407, Rewards={{50010010,350},{50040077,10},{50030005,2},{70800001,20}}, sortId=7},
}

local defaults = {Packagetype=1, Diamonditem=2, conditionid="901#1", Rewards={{50030002,3},{50030003,3},{50030001,10},{10020001,3000}}, Optionalreward={}, rebate=300, purchase=8}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Diamondgiftbag) do
	setmetatable(v, mt)
end

return cfg_Diamondgiftbag