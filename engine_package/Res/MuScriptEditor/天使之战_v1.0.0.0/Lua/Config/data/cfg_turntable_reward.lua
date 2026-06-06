-- 此文件工具自动生成，不要修改
---@class cfg_turntable_reward_column
---唯一id
---@field id number @id column=1 A
---其他抽卡系统调用卡池区分标识
---
---@field group number @奖池组 column=2 B
---策划看
---[[客户端不使用]]@field beizhu string @备注 column=3 C
---根职业ID（career表baseCareer字段）#道具ID#数量|根职业ID#道具ID#数量
---@field item IntListList @奖池道具 column=4 D
---抽取权重，同一个奖池内统计计算
---@field weight number @抽取权重 column=5 E
---可抽取次数
---可抽取到奖励的次数控制，填999999代表无上限，填0或不填代表奖励不进入奖池
---@field num number @可抽取次数 column=6 F
---道具是否进入奖池条件限制
---@field condition string @道具解锁条件 column=7 G
---前多少抽必定不出，不填无限制
---[[客户端不使用]]@field limit number @道具抽取次数限制 column=8 H
---每多少抽必出，若间隔区间内已经出了，则重新计数，100即为每第100抽出一次
---（必出的那一次不计入下一轮计数）
---@field guarantees number @保底循环 column=9 I
---奖励标签
---1=极品
---2=稀有
---不填为普通奖励
---类型1有全服播报，对应string表id601
---@field type number @奖励标签 column=10 J
---排列顺序
---从左上角第一个开始，顺时针排序
---@field order number @排列顺序 column=11 K

local local_item = {
    item_1={{1,50010010,20},{2,50010010,20},{3,50010010,20}},
    item_2={{1,50040074,10},{2,50040074,10},{3,50040074,10}},
    item_3={{1,50040057,10},{2,50040057,10},{3,50040057,10}},
    item_4={{1,50040059,6},{2,50040059,6},{3,50040059,6}},
    item_5={{1,60010002,10},{2,60010002,10},{3,60010002,10}},
    item_6={{1,50030002,5},{2,50030002,5},{3,50030002,5}},
    item_7={{1,50030003,5},{2,50030003,5},{3,50030003,5}},
    item_8={{1,50040061,6},{2,50040061,6},{3,50040061,6}},
    item_9={{1,50040075,2},{2,50040075,2},{3,50040075,2}},
    item_10={{1,50040077,2},{2,50040077,2},{3,50040077,2}},
    item_11={{1,50040076,2},{2,50040076,2},{3,50040076,2}},
    item_12={{1,50030005,1},{2,50030005,1},{3,50030005,1}},
    item_13={{1,30039702,1},{2,30039702,1},{3,30039702,1}},
    item_14={{1,50040097,40},{2,50040097,40},{3,50040097,40}},
    item_15={{1,50044101,1},{2,50044101,1},{3,50044101,1}},
    item_16={{1,50040097,50},{2,50040097,50},{3,50040097,50}},
    item_17={{1,50044102,1},{2,50044102,1},{3,50044102,1}},

}

local cfg_turntable_reward =
{
	{id=1001, weight=2500},
	{id=1002, item=local_item.item_2, order=4},
	{id=1003, item=local_item.item_3, order=5},
	{id=1004, item=local_item.item_4, weight=3500, order=6},
	{id=1005, item=local_item.item_5, order=7},
	{id=1006, item=local_item.item_6, weight=5000, order=8},
	{id=1007, item=local_item.item_7, weight=5000, order=10},
	{id=1008, item=local_item.item_8, weight=3000, order=11},
	{id=1009, item=local_item.item_9, weight=2000, order=12},
	{id=1010, item=local_item.item_10, weight=2000, order=13},
	{id=1011, item=local_item.item_11, weight=2000, order=14},
	{id=1012, item=local_item.item_12, weight=1000, order=15},
	{id=1013, item=local_item.item_13, weight=600, num=10, guarantees=55, type=2, order=16},
	{id=1014, item={{1,50040041,1},{2,50040041,1},{3,50040041,1}}, weight=250, num=5, guarantees=120, type=2, order=9},
	{id=1015, item=local_item.item_14, weight=500, num=6, guarantees=75, type=2, order=2},
	{id=1016, item={{1,21600030,1},{2,21600030,1},{3,21600030,1}}, weight=100, num=1, guarantees=580, type=1, order=1},
	{id=2001, group=2, weight=2500},
	{id=2002, group=2, item=local_item.item_2, order=4},
	{id=2003, group=2, item=local_item.item_3, order=5},
	{id=2004, group=2, item=local_item.item_4, weight=3500, order=6},
	{id=2005, group=2, item=local_item.item_5, order=7},
	{id=2006, group=2, item=local_item.item_6, weight=5000, order=8},
	{id=2007, group=2, item=local_item.item_7, weight=5000, order=10},
	{id=2008, group=2, item=local_item.item_8, weight=3000, order=11},
	{id=2009, group=2, item=local_item.item_9, weight=2000, order=12},
	{id=2010, group=2, item=local_item.item_10, weight=2000, order=13},
	{id=2011, group=2, item=local_item.item_11, weight=2000, order=14},
	{id=2012, group=2, item=local_item.item_12, weight=1000, order=15},
	{id=2013, group=2, item=local_item.item_13, weight=600, num=10, guarantees=55, type=2, order=16},
	{id=2014, group=2, item={{1,50040015,1},{2,50040015,1},{3,50040015,1}}, weight=250, num=5, guarantees=120, type=2, order=9},
	{id=2015, group=2, item=local_item.item_14, weight=500, num=6, guarantees=75, type=2, order=2},
	{id=2016, group=2, item={{1,21600047,1},{2,21600047,1},{3,21600047,1}}, weight=100, num=1, guarantees=580, type=1, order=1},
	{id=3001, group=3, weight=2500},
	{id=3002, group=3, item=local_item.item_2, order=4},
	{id=3003, group=3, item=local_item.item_3, order=5},
	{id=3004, group=3, item=local_item.item_4, weight=3500, order=6},
	{id=3005, group=3, item=local_item.item_5, order=7},
	{id=3006, group=3, item=local_item.item_6, weight=5000, order=8},
	{id=3007, group=3, item=local_item.item_7, weight=5000, order=10},
	{id=3008, group=3, item=local_item.item_8, weight=3000, order=11},
	{id=3009, group=3, item=local_item.item_9, weight=2000, order=12},
	{id=3010, group=3, item=local_item.item_10, weight=2000, order=13},
	{id=3011, group=3, item=local_item.item_11, weight=2000, order=14},
	{id=3012, group=3, item=local_item.item_12, weight=1000, order=15},
	{id=3013, group=3, item=local_item.item_13, weight=600, num=10, guarantees=55, type=2, order=16},
	{id=3014, group=3, item=local_item.item_15, weight=250, num=5, guarantees=120, type=2, order=9},
	{id=3015, group=3, item=local_item.item_16, weight=500, num=6, guarantees=75, type=2, order=2},
	{id=3016, group=3, item={{1,21600051,1},{2,21600051,1},{3,21600051,1}}, weight=100, num=1, guarantees=580, type=1, order=1},
	{id=4001, group=4, weight=2500},
	{id=4002, group=4, item=local_item.item_2, order=4},
	{id=4003, group=4, item=local_item.item_3, order=5},
	{id=4004, group=4, item=local_item.item_4, weight=3500, order=6},
	{id=4005, group=4, item=local_item.item_5, order=7},
	{id=4006, group=4, item=local_item.item_6, weight=5000, order=8},
	{id=4007, group=4, item=local_item.item_7, weight=5000, order=10},
	{id=4008, group=4, item=local_item.item_8, weight=3000, order=11},
	{id=4009, group=4, item=local_item.item_9, weight=2000, order=12},
	{id=4010, group=4, item=local_item.item_10, weight=2000, order=13},
	{id=4011, group=4, item=local_item.item_11, weight=2000, order=14},
	{id=4012, group=4, item=local_item.item_12, weight=1000, order=15},
	{id=4013, group=4, item=local_item.item_13, weight=600, num=10, guarantees=55, type=2, order=16},
	{id=4014, group=4, item=local_item.item_15, weight=250, num=5, guarantees=120, type=2, order=9},
	{id=4015, group=4, item=local_item.item_16, weight=500, num=6, guarantees=75, type=2, order=2},
	{id=4016, group=4, item={{1,21600049,1},{2,21600049,1},{3,21600049,1}}, weight=100, num=1, guarantees=580, type=1, order=1},
	{id=5001, group=5, weight=2500},
	{id=5002, group=5, item=local_item.item_2, order=4},
	{id=5003, group=5, item=local_item.item_3, order=5},
	{id=5004, group=5, item=local_item.item_4, weight=3500, order=6},
	{id=5005, group=5, item=local_item.item_5, order=7},
	{id=5006, group=5, item=local_item.item_6, weight=5000, order=8},
	{id=5007, group=5, item=local_item.item_7, weight=5000, order=10},
	{id=5008, group=5, item=local_item.item_8, weight=3000, order=11},
	{id=5009, group=5, item=local_item.item_9, weight=2000, order=12},
	{id=5010, group=5, item=local_item.item_10, weight=2000, order=13},
	{id=5011, group=5, item=local_item.item_11, weight=2000, order=14},
	{id=5012, group=5, item=local_item.item_12, weight=1000, order=15},
	{id=5013, group=5, item=local_item.item_13, weight=600, num=10, guarantees=55, type=2, order=16},
	{id=5014, group=5, item=local_item.item_17, weight=250, num=5, guarantees=120, type=2, order=9},
	{id=5015, group=5, item=local_item.item_16, weight=500, num=6, guarantees=75, type=2, order=2},
	{id=5016, group=5, item={{1,21600053,1},{2,21600053,1},{3,21600053,1}}, weight=100, num=1, guarantees=580, type=1, order=1},
	{id=6001, group=6, weight=2500},
	{id=6002, group=6, item=local_item.item_2, order=4},
	{id=6003, group=6, item=local_item.item_3, order=5},
	{id=6004, group=6, item=local_item.item_4, weight=3500, order=6},
	{id=6005, group=6, item=local_item.item_5, order=7},
	{id=6006, group=6, item=local_item.item_6, weight=5000, order=8},
	{id=6007, group=6, item=local_item.item_7, weight=5000, order=10},
	{id=6008, group=6, item=local_item.item_8, weight=3000, order=11},
	{id=6009, group=6, item=local_item.item_9, weight=2000, order=12},
	{id=6010, group=6, item=local_item.item_10, weight=2000, order=13},
	{id=6011, group=6, item=local_item.item_11, weight=2000, order=14},
	{id=6012, group=6, item=local_item.item_12, weight=1000, order=15},
	{id=6013, group=6, item=local_item.item_13, weight=600, num=10, guarantees=55, type=2, order=16},
	{id=6014, group=6, item=local_item.item_17, weight=250, num=5, guarantees=120, type=2, order=9},
	{id=6015, group=6, item=local_item.item_16, weight=500, num=6, guarantees=75, type=2, order=2},
	{id=6016, group=6, item={{1,21600055,1},{2,21600055,1},{3,21600055,1}}, weight=100, num=1, guarantees=580, type=1, order=1},
}

local defaults = {group=1, item={{1,50010010,20},{2,50010010,20},{3,50010010,20}}, weight=4000, num=999999, condition="", guarantees=0, type=0, order=3}
local mt = {__index = defaults}
for _, v in ipairs(cfg_turntable_reward) do
	setmetatable(v, mt)
end

return cfg_turntable_reward