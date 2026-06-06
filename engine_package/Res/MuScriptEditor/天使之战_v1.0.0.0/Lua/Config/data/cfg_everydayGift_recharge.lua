-- 此文件工具自动生成，不要修改
---@class cfg_everydayGift_recharge_column
---唯一id
---@field id number @id column=1 A
---同一轮的目标充值金额需要保持相同
---@field round number @轮数 column=2 B
---同一轮内的排序，必须领取了排序在前的才能领取排序在后的
---@field sort number @排序 column=3 C
---天数文字
---@field task string @天数 column=4 D
---充值金额达到多少可以领取奖励，单位元
---@field needCost number @充值目标 column=5 E
---展示用珍惜奖励 职业#物品id#数量|职业#物品id#数量
---@field showItem IntListList @珍惜奖励 column=6 F
---职业#物品id#数量|职业#物品id#数量
---@field gift IntListList @返利道具 column=7 G
---mail表id
---[[客户端不使用]]@field mail number @邮件 column=8 H

local local_showItem = {
    showItem_1={},

}

local local_gift = {
    gift_1={{0,10040001,6480}},
    gift_2={{0,10040001,6480},{0,50040097,20}},
    gift_3={{0,10040001,100}},

}

local cfg_everydayGift_recharge =
{
	{id=1, sort=0, task="", needCost=0, gift={{0,10020001,1000}}},
	{id=2, sort=1, task="第1天", needCost=6, showItem=local_showItem.showItem_1, gift={{0,10040001,6480},{1,21010101,1},{2,21010102,1},{3,21010103,1}}},
	{id=3, sort=2, task="第2天", needCost=6, showItem=local_showItem.showItem_1, gift=local_gift.gift_1},
	{id=4, sort=3, task="第3天", needCost=6, showItem=local_showItem.showItem_1},
	{id=5, round=2, sort=0, task="", needCost=0, showItem={{1,21010201,1},{2,21010202,1},{3,21010202,1},{0,50040097,20},{0,10040001,64800},{0,50040041,10},{0,50040092,10},{0,40010007,10}}, gift=local_gift.gift_3},
	{id=6, round=2, sort=1, task="第1天", showItem=local_showItem.showItem_1, gift={{0,10040001,6480},{1,21010201,1},{2,21010202,1},{3,21010202,1}}},
	{id=7, round=2, sort=2, task="第2天", showItem=local_showItem.showItem_1, gift=local_gift.gift_1},
	{id=8, round=2, sort=3, task="第3天", showItem=local_showItem.showItem_1},
	{id=9, round=3, sort=0, task="", needCost=0, showItem={{1,21010301,1},{2,21010302,1},{3,21010302,1},{0,50040097,20},{0,10040001,64800},{0,50040041,10},{0,50040092,10},{0,40010007,10}}, gift=local_gift.gift_3},
	{id=10, round=3, sort=1, task="第1天", showItem=local_showItem.showItem_1, gift={{0,10040001,6480},{1,21010301,1},{2,21010302,1},{3,21010302,1}}},
	{id=11, round=3, sort=2, task="第2天", showItem=local_showItem.showItem_1, gift=local_gift.gift_1},
	{id=12, round=3, sort=3, task="第3天", showItem=local_showItem.showItem_1},
}

local defaults = {round=1, needCost=30, showItem={{1,21010101,1},{2,21010102,1},{3,21010103,1},{0,50040097,20},{0,10040001,64800},{0,50040041,10},{0,50040092,10},{0,40010007,10}}, gift={{0,10040001,6480},{0,50040097,20}}}
local mt = {__index = defaults}
for _, v in ipairs(cfg_everydayGift_recharge) do
	setmetatable(v, mt)
end

return cfg_everydayGift_recharge