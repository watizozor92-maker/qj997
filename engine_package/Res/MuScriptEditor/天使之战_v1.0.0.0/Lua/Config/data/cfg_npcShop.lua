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
    bugCondition_2={{{101,50}}},
    bugCondition_3={{{101,100}}},
    bugCondition_4={{{101,200}}},
    bugCondition_5={{{101,250}}},
    bugCondition_6={{{101,70}}},
    bugCondition_7={{{101,150}}},
    bugCondition_8={},

}

local cfg_npcShop =
{
	{id=100, shopId=1, itemName="苹果"},
	{id=101, itemId=30010002, shopId=1, itemName="小瓶治疗药水", conditions="checkLevel>=0&&checkLevel<999"},
	{id=102, itemId=30010006, shopId=1, itemName="小型精华治疗药水", conditions="checkLevel>=0&&checkLevel<999"},
	{id=103, itemId=30010012, shopId=1, itemName="小瓶魔力药水", conditions="checkLevel>=0&&checkLevel<999", group=2},
	{id=104, itemId=30010015, shopId=1, itemName="精华魔力药水", conditions="checkLevel>=0&&checkLevel<999", group=2},
	{id=105, itemId=30010003, shopId=1, itemName="中瓶治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_2},
	{id=106, itemId=30010007, shopId=1, itemName="中型精华治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_2},
	{id=107, itemId=30010013, shopId=1, itemName="中瓶魔力药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_2, group=2},
	{id=108, itemId=30010004, shopId=1, itemName="大瓶治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_3},
	{id=109, itemId=30010008, shopId=1, itemName="大型精华治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_3},
	{id=110, itemId=30010014, shopId=1, itemName="大瓶魔力药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_3, group=2},
	{id=111, itemId=30010005, shopId=1, itemName="超大治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_4},
	{id=112, itemId=30010009, shopId=1, itemName="超大精华治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_4},
	{id=113, number=100, shopId=1, itemName="大量苹果"},
	{id=114, itemId=30010002, number=100, shopId=1, itemName="大量小瓶治疗药水"},
	{id=115, itemId=30010003, number=100, shopId=1, itemName="大量中瓶治疗药水", bugCondition=local_bugCondition.bugCondition_6},
	{id=116, itemId=30010004, number=100, shopId=1, itemName="大量大瓶治疗药水", bugCondition=local_bugCondition.bugCondition_7},
	{id=117, itemId=30010005, number=100, shopId=1, itemName="大量超大治疗药水", bugCondition=local_bugCondition.bugCondition_5},
	{id=118, itemId=30010006, number=100, shopId=1, itemName="大量小型精华治疗药水", bugCondition=local_bugCondition.bugCondition_5},
	{id=119, itemId=30010007, number=100, shopId=1, itemName="大量中型精华治疗药水", bugCondition=local_bugCondition.bugCondition_5},
	{id=120, itemId=30010008, number=100, shopId=1, itemName="大量大型精华治疗药水", bugCondition=local_bugCondition.bugCondition_5},
	{id=121, itemId=30010009, number=100, shopId=1, itemName="大量超大精华治疗药水", bugCondition=local_bugCondition.bugCondition_5},
	{id=122, itemId=30010012, number=100, shopId=1, itemName="大量小瓶魔力药水", group=2},
	{id=123, itemId=30010013, number=100, shopId=1, itemName="大量中瓶魔力药水", bugCondition=local_bugCondition.bugCondition_6, group=2},
	{id=124, itemId=30010014, number=100, shopId=1, itemName="大量大瓶魔力药水", bugCondition=local_bugCondition.bugCondition_7, group=2},
	{id=125, itemId=30010015, number=100, shopId=1, itemName="大量精华魔力药水", group=2},
	{id=126, itemId=20410111, number=1, shopId=2, itemName="皮盔", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=127, itemId=20610111, number=1, shopId=2, itemName="皮铠", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=128, itemId=20810111, number=1, shopId=2, itemName="皮护腿", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=129, itemId=20710111, number=1, shopId=2, itemName="皮护手", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=130, itemId=20910111, number=1, shopId=2, itemName="皮靴", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=131, itemId=20310111, number=1, shopId=2, itemName="短剑", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=132, itemId=60030032, number=1, shopId=2, itemName="暗杀者之石", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=133, itemId=60030022, number=1, shopId=2, itemName="霹雳回旋斩之石", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=134, itemId=60035068, number=1, shopId=2, itemName="钻云枪之石", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=135, itemId=60030004, number=1, shopId=3, itemName="火球术", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=136, itemId=60030011, number=1, shopId=3, itemName="真空波术", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=137, itemId=60030003, number=1, shopId=3, itemName="掌心雷术", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=138, itemId=60030006, number=1, shopId=3, itemName="瞬间移动术", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=139, itemId=60030002, number=1, shopId=3, itemName="陨石术", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=140, itemId=60030007, number=1, shopId=3, itemName="冰封术", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=141, itemId=60030005, number=1, shopId=3, itemName="火龙术", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=142, itemId=60030008, number=1, shopId=3, itemName="龙卷风术", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=143, itemId=60030030, number=1, shopId=4, itemName="哥布林召唤之石", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=144, itemId=60030031, number=1, shopId=4, itemName="石巨人召唤之石", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=145, itemId=60030032, number=1, shopId=4, itemName="暗杀者召唤之石", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=146, itemId=60030033, number=1, shopId=4, itemName="雪人王召唤之石", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=147, itemId=60030034, number=1, shopId=4, itemName="暗黑骑士召唤之石", conditions="", bugCondition=local_bugCondition.bugCondition_8, group=0},
	{id=148, itemId=3000104, number=1, itemName="战斗箭筒", conditions="checkLevel>=0&&checkLevel<999", group=0},
	{id=149, itemName="苹果"},
	{id=150, itemId=30010002, itemName="小瓶治疗药水", conditions="checkLevel>=0&&checkLevel<999"},
	{id=151, itemId=30010006, itemName="小型精华治疗药水", conditions="checkLevel>=0&&checkLevel<999"},
	{id=152, itemId=30010012, itemName="小瓶魔力药水", conditions="checkLevel>=0&&checkLevel<999", group=2},
	{id=153, itemId=30010015, itemName="精华魔力药水", conditions="checkLevel>=0&&checkLevel<999", group=2},
	{id=154, itemId=30010003, itemName="中瓶治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_2},
	{id=155, itemId=30010007, itemName="中型精华治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_2},
	{id=156, itemId=30010013, itemName="中瓶魔力药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_2, group=2},
	{id=157, itemId=30010004, itemName="大瓶治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_3},
	{id=158, itemId=30010008, itemName="大型精华治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_3},
	{id=159, itemId=30010014, itemName="大瓶魔力药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_3, group=2},
	{id=160, itemId=30010005, itemName="超大治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_4},
	{id=161, itemId=30010009, itemName="超大精华治疗药水", conditions="checkLevel>=0&&checkLevel<999", bugCondition=local_bugCondition.bugCondition_4},
	{id=162, number=100, itemName="大量苹果"},
	{id=163, itemId=30010002, number=100, itemName="大量小瓶治疗药水"},
	{id=164, itemId=30010003, number=100, itemName="大量中瓶治疗药水", bugCondition=local_bugCondition.bugCondition_6},
	{id=165, itemId=30010004, number=100, itemName="大量大瓶治疗药水", bugCondition=local_bugCondition.bugCondition_7},
	{id=166, itemId=30010005, number=100, itemName="大量超大治疗药水", bugCondition=local_bugCondition.bugCondition_5},
	{id=167, itemId=30010006, number=100, itemName="大量小型精华治疗药水", bugCondition=local_bugCondition.bugCondition_5},
	{id=168, itemId=30010007, number=100, itemName="大量中型精华治疗药水", bugCondition=local_bugCondition.bugCondition_5},
	{id=169, itemId=30010008, number=100, itemName="大量大型精华治疗药水", bugCondition=local_bugCondition.bugCondition_5},
	{id=170, itemId=30010009, number=100, itemName="大量超大精华治疗药水", bugCondition=local_bugCondition.bugCondition_5},
	{id=171, itemId=30010012, number=100, itemName="大量小瓶魔力药水", group=2},
	{id=172, itemId=30010013, number=100, itemName="大量中瓶魔力药水", bugCondition=local_bugCondition.bugCondition_6, group=2},
	{id=173, itemId=30010014, number=100, itemName="大量大瓶魔力药水", bugCondition=local_bugCondition.bugCondition_7, group=2},
	{id=174, itemId=30010015, number=100, itemName="大量精华魔力药水", group=2},
}

local defaults = {itemId=30010001, number=20, shopId=5, conditions="checkLevel>=9500&&checkLevel<10001", bugCondition={{{101,1}}}, group=1}
local mt = {__index = defaults}
for _, v in ipairs(cfg_npcShop) do
	setmetatable(v, mt)
end

return cfg_npcShop