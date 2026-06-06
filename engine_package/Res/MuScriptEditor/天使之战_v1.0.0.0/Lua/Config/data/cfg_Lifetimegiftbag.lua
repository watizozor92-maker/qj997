-- 此文件工具自动生成，不要修改
---@class cfg_Lifetimegiftbag_column
---@field id number @id column=1 A
---@field Price number @价格 column=2 B
---@field condition string @条件 column=3 C
---@field Packagename string @名称 column=4 D
---道具id#数量
---@field Rewards IntListList @奖励 column=5 E
---不填则不显示
---@field rebate number @返利显示 column=6 F
---@field sortId number @礼包排序 column=7 G

local local_Rewards = {
    Rewards_1={{10010001,1000},{10040001,100},{10020001,100}},

}

local cfg_Lifetimegiftbag =
{
	{id=7001, Price=18, Packagename="技能觉醒礼包", rebate=900, sortId=1},
	{id=7002, Price=128, Packagename="连击进阶礼包", rebate=600, sortId=2},
	{id=7003, Price=128, Packagename="boss礼包", rebate=300, sortId=3},
}

local defaults = {condition="900#1", Rewards={{10010001,1000},{10040001,100},{10020001,100}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_Lifetimegiftbag) do
	setmetatable(v, mt)
end

return cfg_Lifetimegiftbag