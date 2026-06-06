-- 此文件工具自动生成，不要修改
---@class cfg_Starterpack_column
---@field id number @id column=1 A
---@field Packagename string @名称 column=2 B
---[[客户端不使用]]@field Packagetype number @组别 column=3 C
---@field Price number @价格 column=4 D
---@field condition string @条件 column=5 E
---道具id#数量
---@field Rewards IntListList @奖励 column=6 F
---不填则不显示
---@field rebate number @返利显示 column=7 G
local cfg_Starterpack =
{
	{id=9001, Packagename="免费", Price=0, Rewards={{10040001,3}}, rebate=0},
	{id=9002, Packagename="经验药水", Price=18, Rewards={{10040001,6}}, rebate=900},
	{id=9003, Packagename="幸运宝石礼包", Price=128, Rewards={{10040001,9}}, rebate=600},
	{id=9004, Packagename="守护叠加礼包", Price=128, Rewards={{10040001,12}}, rebate=400},
	{id=9005, Packagename="大天使礼包", Price=328, Rewards={{10040001,15}}, rebate=340},
}

local defaults = {condition="900#1"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Starterpack) do
	setmetatable(v, mt)
end

return cfg_Starterpack