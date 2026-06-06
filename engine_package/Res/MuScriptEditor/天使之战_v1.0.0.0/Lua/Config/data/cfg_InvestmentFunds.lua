-- 此文件工具自动生成，不要修改
---@class cfg_InvestmentFunds_column
---@field id number @id column=1 A
---@field groupid number @组 column=2 B
---@field day number @天数 column=3 C
---@field conditionid number @条件 column=4 D
---[[客户端不使用]]@field Limited number @限购 column=5 E
---道具id#数量
---@field Rewards IntListList @奖励 column=6 F
---不填则不显示
---显示总的
---返利显示|道具id#数量|道具id|购买立得道具id#数量
---@field rebate IntListList @返利和钻石显示和道具图像显示 column=7 G
---必须天数保持一致
---@field Price number @总价格 column=8 H

local local_Rewards = {
    Rewards_1={{10050001,1920}},

}

local local_rebate = {
    rebate_1={{900},{10050001,12800},{61400003},{10050001,1280}},

}

local cfg_InvestmentFunds =
{
	{id=1, day=1, Rewards={{10040001,1280},{61400003,1}}, rebate={{900},{10040001,12800},{61400003},{10040001,1280}}},
	{id=2, day=2},
	{id=3, day=3},
	{id=4, day=4},
	{id=5, day=5},
	{id=6, day=6},
	{id=7, day=7},
}

local defaults = {groupid=1, conditionid=0, Rewards={{10050001,1920}}, rebate={{900},{10050001,12800},{61400003},{10050001,1280}}, Price=128}
local mt = {__index = defaults}
for _, v in ipairs(cfg_InvestmentFunds) do
	setmetatable(v, mt)
end

return cfg_InvestmentFunds