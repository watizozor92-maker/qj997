-- 此文件工具自动生成，不要修改
---@class MVPbaoxiang_column
---唯一id
---[[客户端不使用]]@field id number @id column=1 A
---1=统计概率，从所有道具中抽取1个（按权重）
---2=独立概率，每个道具单独判断概率
---*每张表只允许使用1个类型
---[[客户端不使用]]@field type number @掉落类型 column=2 B
---策划备注
---[[客户端不使用]]@field beizhu string @ column=3 C
---道具id
---@field item number @道具id column=4 D
---数量区间，从中随机数量
---x#y，左右闭区间
---@field num string @数量 column=5 E
---掉落类型为1时，此处为：掉落次数#权重
---掉落类型为2时，此处为：掉落次数#概率（万分比）
---掉落次数填本次掉落之前已经掉落的次数，例如首次掉落，之前没掉过，这里就填0
---[[客户端不使用]]@field probability string @概率 column=6 F
---限制职业
---只有对应职业才会掉落
---不填不做限制
---格式：所属职业#职业等级|所属职业#职业等级
---[[客户端不使用]]@field career string @职业 column=7 G
---限制等级
---只有角色在对应等级区间内才会掉
---x#y，左右闭区间
---999999标识无限大
---不填不做限制
---[[客户端不使用]]@field level string @等级 column=8 H
---宝箱开启时概率携带的技能id#等级#携带概率（万分比）
---@field skillbaoxiang IntList @装备携带【技能】概率 column=9 I
---宝箱开启时概率携带的权重#等级
---@field strengthenbaoxiang IntListList @装携带【强化】概率 column=10 J
---宝箱开启时概率携带的幸运的概率（万分比）
---@field luckbaoxiang number @装备携带【幸运】概率 column=11 K
---宝箱开启时概率携带的追加的权重#等级
---@field appendsbaoxiang IntListList @装备携带【追加】概率 column=12 L
---[[客户端不使用]]@field   @ column=13 M

local local_skillbaoxiang = {
    skillbaoxiang_1={},
    skillbaoxiang_2={1100003,1,10000},
    skillbaoxiang_3={1100002,1,10000},
    skillbaoxiang_4={1100004,1,10000},
    skillbaoxiang_5={1300002,1,10000},
    skillbaoxiang_6={1005003,1,10000},

}

local local_strengthenbaoxiang = {
    strengthenbaoxiang_1={},

}

local local_appendsbaoxiang = {
    appendsbaoxiang_1={},
    appendsbaoxiang_2={{9000,0},{900,1},{99,2},{1,3}},

}

local MVPbaoxiang =
{
	{item=1253000299, num="2#2", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000399, num="2#2", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000199, num="2#2", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000499, num="2#2", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000599, num="2#2", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000299, num="3#3", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000399, num="3#3", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000199, num="3#3", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000499, num="3#3", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000599, num="3#3", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000299, num="5#5", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000399, num="5#5", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000199, num="5#5", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000499, num="5#5", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1253000599, num="5#5", luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1254003899, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1254004099, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=1254006799, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=101536099, luckbaoxiang=0, appendsbaoxiang=local_appendsbaoxiang.appendsbaoxiang_1},
	{item=2041032199},
	{item=2061032199},
	{item=2081032199},
	{item=2071032199},
	{item=2091032199},
	{item=2042032199},
	{item=2062032199},
	{item=2082032199},
	{item=2072032199},
	{item=2092032199},
	{item=2043032199},
	{item=2063032199},
	{item=2083032199},
	{item=2073032199},
	{item=2093032199},
	{item=217699},
	{item=224299},
	{item=231799},
	{item=239299},
	{item=245899},
	{item=2031022199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2},
	{item=201099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2},
	{item=201199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4},
	{item=204299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3},
	{item=204399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3},
	{item=204799, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_3},
	{item=206599, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2},
	{item=206999, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_4},
	{item=207399, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_2},
	{item=208299, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=209099, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_5},
	{item=2012022199},
	{item=2012032199},
	{item=2022022199, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=215699, skillbaoxiang=local_skillbaoxiang.skillbaoxiang_6},
	{item=2022042199},
}

local defaults = {num="1#1", skillbaoxiang={}, strengthenbaoxiang={}, luckbaoxiang=1000, appendsbaoxiang={{9000,0},{900,1},{99,2},{1,3}}}
local mt = {__index = defaults}
for _, v in ipairs(MVPbaoxiang) do
	setmetatable(v, mt)
end

return MVPbaoxiang