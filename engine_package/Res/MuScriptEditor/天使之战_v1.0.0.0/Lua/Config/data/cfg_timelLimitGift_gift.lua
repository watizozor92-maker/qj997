-- 此文件工具自动生成，不要修改
---@class cfg_timelLimitGift_gift_column
---唯一礼包id
---@field id number @id column=1 A
---timeLimitGift_all表id
---@field group number @礼包组 column=2 B
---礼包名称,策划备注
---[[客户端不使用]]@field name string @礼包名称 column=3 C
---同组礼包排序
---@field sort number @礼包排序 column=4 D
---购买了前置礼包才能购买此礼包
---@field preGift number @前置礼包 column=5 E
---礼包价格，不填为免费
---@field cost IntList @花费 column=6 F
---礼包给的奖励，格式：道具id#数量|道具id#数量
---@field gift IntListList @道具 column=7 G
---购买该礼包给同组持续时间增加多少时间，单位毫秒
---@field addTime number @购买增加持续时间 column=8 H
---奖励邮件id
---@field mail number @邮件id column=9 I

local local_cost = {
    cost_1={},

}

local local_gift = {
    gift_1={{30031041,1},{10020001,3000},{60010002,1},{60010001,5}},

}

local cfg_timelLimitGift_gift =
{
	{id=10101, cost={10040001,98}, gift={{50030002,3},{50030002,3},{50030003,1},{50030004,1}}},
	{id=10102, sort=2, preGift=10101, gift={{50030002,5},{50030002,5},{50030003,2},{50030004,1}}, mail=800001},
	{id=10103, sort=3, preGift=10102, cost={10040001,388}, gift={{50030002,10},{50030002,10},{50030003,5},{50030004,1}}},
	{id=10104, sort=4, preGift=10103, gift={{50030002,15},{50030002,15},{50030003,10},{50030004,1}}, mail=800001},
	{id=10201, group=2, cost={10040001,588}, gift={{50030002,15},{50030002,15},{50030003,10},{50030004,2}}},
	{id=10202, group=2, sort=2, preGift=10201, gift={{50030002,20},{50030002,20},{50030003,20},{50030004,3}}, mail=800001},
	{id=10203, group=2, sort=3, preGift=10202, cost={10040001,1188}, gift={{50030002,20},{50030002,20},{50030003,15},{50030004,4}}},
	{id=10204, group=2, sort=4, preGift=10203, gift={{50030002,40},{50030002,40},{50030003,30},{50030004,5}}, mail=800001},
	{id=10301, group=3, cost={10040001,30}},
	{id=10401, group=4, cost={10040001,50}},
}

local defaults = {group=1, sort=1, preGift=0, cost={}, gift={{30031041,1},{10020001,3000},{60010002,1},{60010001,5}}, addTime=0, mail=0}
local mt = {__index = defaults}
for _, v in ipairs(cfg_timelLimitGift_gift) do
	setmetatable(v, mt)
end

return cfg_timelLimitGift_gift