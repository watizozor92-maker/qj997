-- 此文件工具自动生成，不要修改
---@class cfg_MonthlyPack_column
---@field id number @id column=1 A
---@field Packagename string @名称 column=2 B
---1.单月卡
---2.双买
---@field monthlytype number @类型 column=3 C
---真实价格#打折前价格
---@field Price IntList @价格 column=4 D
---@field condition string @条件 column=5 E
---@field oneRewards IntListList @第一次领取奖励 column=6 F
---道具id#数量
---@field Rewards IntListList @奖励 column=7 G
---填相对路径
---@field Graphpath string @底版图路径 column=8 H
---@field sortId number @礼包排序 column=9 I

local local_oneRewards = {
    oneRewards_1={},

}

local cfg_MonthlyPack =
{
	{id=7001, Packagename="畅享月卡", monthlytype=1, Price={30,98}, condition="", oneRewards=local_oneRewards.oneRewards_1, Graphpath="img_monthlywihte", sortId=1},
	{id=7002, Packagename="尊享月卡", monthlytype=1, Price={98,198}, condition="", oneRewards=local_oneRewards.oneRewards_1, Rewards={{10020001,30000},{10050001,1188},{50030002,15},{50030003,6}}, Graphpath="img_monthlygold", sortId=2},
	{id=7003, Packagename="双买", monthlytype=2, Price={}, condition="", oneRewards=local_oneRewards.oneRewards_1, Rewards={}, Graphpath="", sortId=0},
}

local defaults = {Rewards={{10020001,5000},{10050001,368},{50030002,10},{50030003,3}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_MonthlyPack) do
	setmetatable(v, mt)
end

return cfg_MonthlyPack