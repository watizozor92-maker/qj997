-- 此文件工具自动生成，不要修改
---@class cfg_lines_column
---读mouthDown表gears字段
---@field id number @档位 column=1 A
---玩家的充值区间
---@field interval IntList @充值区间 column=2 B
---玩家每次提高额度的充值金额
---@field each number @充值金额 column=3 C
---玩家提高的额度上限
---@field quotaLimit number @额度上限 column=4 D
---不充值衰减的时间
---单位（天）
---@field decayTime number @衰减时间 column=5 E
---不充值衰减的额度
---@field decayGears number @衰减至档位 column=6 F
---发生衰减时，恢复额度所需达到的充值金额
---@field activationRecharge number @激活金额 column=7 G
local cfg_lines =
{
	{id=1, interval={1,1000}, each=1, quotaLimit=100, decayGears=1, activationRecharge=6},
	{id=2, interval={1001,2000}, each=1, quotaLimit=150, decayGears=1, activationRecharge=6},
	{id=3, interval={2001,3000}, each=1, quotaLimit=200, decayGears=2, activationRecharge=12},
	{id=4, interval={3001,4000}, each=2, quotaLimit=500, decayGears=3, activationRecharge=64},
	{id=5, interval={4001,5000}, each=5, quotaLimit=1500, decayTime=2, decayGears=4, activationRecharge=128},
}

local defaults = {decayTime=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_lines) do
	setmetatable(v, mt)
end

return cfg_lines