-- 此文件工具自动生成，不要修改
---@class cfg_timelLimitGift_all_column
---同组礼包会一同出现
---@field id number @礼包组id column=1 A
---礼包名称
---@field name string @礼包名称 column=2 B
---同组共用同一个持续时间，单位毫秒
---@field timeLimit number @持续时间 column=3 C
---1：使用condition
---2：100级后，强化一次，再次强化不满足条件时弹出
---3.：领取某限时礼包后弹出，3#礼包id
---4：购买该礼包后，指定礼包不会再出现，4#礼包id
---5:出现后顶替掉其他礼包，5#礼包id
---@field type number @类型 column=4 D
---参数
---@field param number @参数 column=5 E
---礼包出现条件
---@field condition string @出现条件 column=6 F
---界面tips语句内容
---@field tip string @tips column=7 G
local cfg_timelLimitGift_all =
{
	{id=1, name="强化礼包", timeLimit=7200000, type=2, param=0, condition="", tip="勇士的强化材料不足，这里为您带来了一些礼物~~"},
	{id=2, name="强化礼包", timeLimit=28800000, type=3, param=1, condition="", tip="勇士还需要更多材料吗，这里为您带来了一些礼物~~"},
	{id=3, name="超值回收", timeLimit=28800000, type=4, param=4, tip=""},
	{id=4, name="超值回收", timeLimit=86400000, type=5, param=3, condition="902#2&101#70", tip=""},
}

local defaults = {condition="902#1&101#70"}
local mt = {__index = defaults}
for _, v in ipairs(cfg_timelLimitGift_all) do
	setmetatable(v, mt)
end

return cfg_timelLimitGift_all