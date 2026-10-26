-- 此文件工具自动生成，不要修改
---@class cfg_npcShop_column
---唯一id；
---第一位：商店编号（shopId字段）
---第二三位：编号
---@field id number @序号 column=1 A
---格式：道具id（cfg_item/id）
---@field itemId number @商店道具 column=2 B
---商品售卖数量
---@field number number @道具数量 column=3 C
---商店编号
---,用于确定NPC调用那个商店
---@field shopId number @商店编号 column=4 D
---NPC商店显示道具名称
---@field itemName string @道具名称 column=5 E
---等级上限#等级下限
---@field conditions string @上架条件 column=6 F
---外置字段，配空或0没有条件
---@field bugCondition intListListList @购买条件 column=7 G
---格式：需求道具类型#数量#是否关联#权重|需求道具类型#单价所需数量#是否关联#权重|需求道具类型#数量#是否关联#权重
---
---
---是否关联：0=不关联，1=关联
---为空时：此道具不可购买，商店内不上架此道具
---例：钻石#价格#是否关联
---权重：每次上架时根据权重随机出一个货币种类售卖
---3#2000#1
---[[客户端不使用]]@field price IntListList @上架价格 column=8 H
---1红药
---2蓝药
---@field group number @自动购买类型组 column=9 I

local local_bugCondition = {
    bugCondition_1={{{101,1}}},

}

local cfg_npcShop =
{
	{id=101, itemId=30010001, itemName="大量苹果", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=102, itemName="小瓶治疗药水"},
	{id=103, itemId=30010003, itemName="中瓶治疗药水"},
	{id=104, itemId=30010004, itemName="大瓶治疗药水"},
	{id=105, itemId=30010005, itemName="超大治疗药水"},
	{id=106, itemId=30010012, itemName="小瓶魔力药水", group=2},
	{id=107, itemId=30010013, itemName="中瓶魔力药水", group=2},
	{id=108, itemId=30010014, itemName="大瓶魔力药水", group=2},
	{id=109, itemId=30010015, itemName="精华魔力药水", group=2},
	{id=110, itemId=30010006, itemName="小型精华治疗药水"},
	{id=111, itemId=30010007, itemName="中型精华治疗药水"},
	{id=112, itemId=30010008, itemName="大型精华治疗药水"},
	{id=113, itemId=30010009, itemName="超大精华治疗药水"},
	{id=114, itemName="大量小瓶治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=115, itemId=30010003, itemName="大量中瓶治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=116, itemId=30010004, itemName="大量大瓶治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=117, itemId=30010005, itemName="大量超大治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=118, itemId=30010006, itemName="大量小型精华治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=119, itemId=30010007, itemName="大量中型精华治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=120, itemId=30010008, itemName="大量大型精华治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=121, itemId=30010009, itemName="大量超大精华治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=122, itemId=30010012, itemName="大量小瓶魔力药水", conditions="checkLevel>=9500&&checkLevel<10001", group=2},
	{id=123, itemId=30010013, itemName="大量中瓶魔力药水", conditions="checkLevel>=9500&&checkLevel<10001", group=2},
	{id=124, itemId=30010014, itemName="大量大瓶魔力药水", conditions="checkLevel>=9500&&checkLevel<10001", group=2},
	{id=125, itemId=30010015, itemName="大量精华魔力药水", conditions="checkLevel>=9500&&checkLevel<10001", group=2},
	{id=126, itemId=30010001, shopId=5, itemName="苹果", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=127, itemId=30010001, shopId=5, itemName="大量苹果", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=128, shopId=5, itemName="小瓶治疗药水"},
	{id=129, itemId=30010003, shopId=5, itemName="中瓶治疗药水"},
	{id=130, itemId=30010004, shopId=5, itemName="大瓶治疗药水"},
	{id=131, itemId=30010005, shopId=5, itemName="超大治疗药水"},
	{id=132, itemId=30010012, shopId=5, itemName="小瓶魔力药水", group=2},
	{id=133, itemId=30010013, shopId=5, itemName="中瓶魔力药水", group=2},
	{id=134, itemId=30010014, shopId=5, itemName="大瓶魔力药水", group=2},
	{id=135, itemId=30010015, shopId=5, itemName="精华魔力药水", group=2},
	{id=136, itemId=30010006, shopId=5, itemName="小型精华治疗药水"},
	{id=137, itemId=30010007, shopId=5, itemName="中型精华治疗药水"},
	{id=138, itemId=30010008, shopId=5, itemName="大型精华治疗药水"},
	{id=139, itemId=30010009, shopId=5, itemName="超大精华治疗药水"},
	{id=140, shopId=5, itemName="大量小瓶治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=141, itemId=30010003, shopId=5, itemName="大量中瓶治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=142, itemId=30010004, shopId=5, itemName="大量大瓶治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=143, itemId=30010005, shopId=5, itemName="大量超大治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=144, itemId=30010006, shopId=5, itemName="大量小型精华治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=145, itemId=30010007, shopId=5, itemName="大量中型精华治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=146, itemId=30010008, shopId=5, itemName="大量大型精华治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=147, itemId=30010009, shopId=5, itemName="大量超大精华治疗药水", conditions="checkLevel>=9500&&checkLevel<10001"},
	{id=148, itemId=30010012, shopId=5, itemName="大量小瓶魔力药水", conditions="checkLevel>=9500&&checkLevel<10001", group=2},
	{id=149, itemId=30010013, shopId=5, itemName="大量中瓶魔力药水", conditions="checkLevel>=9500&&checkLevel<10001", group=2},
	{id=150, itemId=30010014, shopId=5, itemName="大量大瓶魔力药水", conditions="checkLevel>=9500&&checkLevel<10001", group=2},
	{id=151, itemId=30010015, shopId=5, itemName="大量精华魔力药水", conditions="checkLevel>=9500&&checkLevel<10001", group=2},
	{id=152, itemId=30510308, number=10000, itemName="代币", group=0},
	{id=153, itemId=23000099, number=1, itemName="绝版旗帜（非卖品）", group=0},
	{id=154, itemId=1253000199, number=999, itemName="玛雅之石", group=0},
	{id=155, itemId=1253000299, number=999, itemName="祝福宝石", group=0},
	{id=156, itemId=1253000399, number=999, itemName="灵魂宝石", group=0},
	{id=157, itemId=1253000499, number=999, itemName="生命宝石", group=0},
	{id=158, itemId=1253000599, number=999, itemName="创造宝石", group=0},
	{id=159, itemId=60030009, number=1, itemName="黑龙波术", group=0},
	{id=160, itemId=61007003, number=1, itemName="雷鸟术", group=0},
	{id=161, itemId=60035100, number=1, itemName="星云火链卷轴", group=0},
	{id=162, itemId=60035100, number=1, itemName="链雷咒羊皮纸", group=0},
	{id=163, itemId=60035083, number=1, itemName="烈袭 羊皮纸", group=0},
	{id=164, itemId=60030022, number=1, itemName="霹雳回旋斩之石", group=0},
	{id=165, itemId=61007001, number=1, itemName="幻龙术", group=0},
	{id=166, itemId=10210001, number=999, itemName="大天使积分", group=0},
	{id=167, itemId=100000007, number=1, itemName="金币", group=0},
	{id=168, itemId=1263508699, number=1, itemName="烈袭 羊皮纸", group=0},
	{id=169, itemId=1263509299, number=1, itemName="水幻兽 羊皮纸", group=0},
}

local defaults = {itemId=30010002, number=20, shopId=1, conditions="checkLevel>=0&&checkLevel<999", bugCondition={{{101,1}}}, group=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_npcShop) do
	setmetatable(v, mt)
end

return cfg_npcShop